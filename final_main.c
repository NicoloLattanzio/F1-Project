#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <libpq-fe.h>

#define PG_HOST "127.0.0.1"
#define PG_USER "user0"
#define PG_PORT 5432
#define PG_PSW "intmainale_04"
#define PG_DBNAME "F1-scuderia"

void prepare_all_statements(PGconn *conn);
int is_valid_date_format(const char *date);
void checkresult(PGresult *res, const PGconn *conn);
void printresult(PGresult *res);
const char* insert_data();
const char* insert_cf();
const char* insert_engine_producer();
const char* insert_age(int previous_age);
const char* insert_financial_year();


int main(int argc, char **argv) {
    char conninfo[256];
    sprintf(conninfo, "user=%s password=%s dbname=%s hostaddr=%s port=%d", 
            PG_USER, PG_PSW, PG_DBNAME, PG_HOST, PG_PORT);
    
    PGconn *conn = PQconnectdb(conninfo);

    if (PQstatus(conn) != CONNECTION_OK) {
        printf("Connection error: %s\n", PQerrorMessage(conn));
        PQfinish(conn);
        return 1;
    }

    printf("Connection established\n");
    prepare_all_statements(conn);

    int choice;
    PGresult *res = NULL;
    
    do {
        printf("\nMenu:\n");
        printf("1. Team members hired after a date\n");
        printf("2. Fastest lap per GP for a driver\n");
        printf("3. Cars per driver and engine type\n");
        printf("4. Average compensation by role for age range\n");
        printf("5. Suppliers for sectors within budget\n");
        printf("0. Exit\n");
        printf("Enter choice: ");
        scanf("%d", &choice);

        int n_params;
        const char **params;
        switch(choice){
            case 1:
                n_params = 1;
                params = malloc(n_params*sizeof(char*));
                params[0] = insert_data();
                res = PQexecPrepared(conn, "tm_hiring", n_params, params, NULL, NULL, 0);
                free(params);
                break;
            case 2:
                n_params = 1;
                params = malloc(n_params*sizeof(char*));
                params[0] = insert_cf();
                res = PQexecPrepared(conn, "fastest_lap", n_params, params, NULL, NULL, 0);
                free(params);
                break;
            case 3:
                n_params = 1;
                params = malloc(n_params*sizeof(char*));
                params[0] = insert_engine_producer();
                res = PQexecPrepared(conn, "cars_per_driver", n_params, params, NULL, NULL, 0);
                free(params);
                break;
            case 4:
                n_params = 2;
                params = malloc(n_params*sizeof(char*));
                params[0] = insert_age(0);
                params[1] = insert_age(atoi(params[0]));
                res = PQexecPrepared(conn, "avg_comp", n_params, params, NULL, NULL, 0);
                free(params);
                break;
            case 5:
                n_params = 1;
                params = malloc(n_params*sizeof(char*));
                params[0] = insert_financial_year();
                res = PQexecPrepared(conn, "suppliers_budget", n_params, params, NULL, NULL, 0);
                free(params);
                break;
            case 0:
                printf("Exiting...\n");
                break;
            default:
                printf("Invalid choice!\n");
                res = NULL;
        }
        if (res && choice != 0)
            printresult(res);
        
    }while(choice != 0);

    PQfinish(conn);
    return 0;
}

void prepare_all_statements(PGconn *conn){
    struct {
        const char *name;
        const char *query;
        int nparams;
    } statements[] = {
        {
            "tm_hiring",
            "SELECT tm.nome, tm.cognome, tm.data_nascita, tm.ruolo "
            "FROM team_member tm "
            "JOIN contratto c ON tm.cf = c.cf_team "
            "WHERE c.inizio >= $1::date",
            1
        },
        {
            "fastest_lap",
            "SELECT c.nome, g.data, g.numero_giro, g.tempo "
            "FROM giro g "
            "JOIN pilota p ON p.cf = g.pilota "
            "JOIN circuito c ON c.id_circuito = g.circuito "
            "WHERE g.pilota = $1::char(16) "
            "AND g.tempo <= ALL( "
            "SELECT g1.tempo "
            "FROM giro g1 "
            "WHERE g1.circuito = g.circuito "
            "AND g1.data = g.data "
            "AND g1.pilota = g.pilota "
            ")",
            1
        },
        {
            "cars_per_driver",
            "SELECT p.nome, p.cognome, m.alimentazione, COUNT(v.id_vettura) as nr_vetture "
            "FROM pilota p "
            "JOIN vettura v ON v.cf = p.cf "
            "JOIN motore m ON m.id_motore = v.id_motore "
            "WHERE m.produttore = $1::varchar(50) "
            "GROUP BY p.cf, m.alimentazione",
            1
        },
        {
            "avg_comp", 
            "SELECT tm.ruolo, AVG(c.compenso) as compenso_medio "
            "FROM team_member tm "
            "JOIN contratto c ON c.cf_team = tm.cf "
            "WHERE EXTRACT(YEAR FROM AGE(CURRENT_DATE, tm.data_nascita))::integer >= $1::integer "
            "AND EXTRACT(YEAR FROM AGE(CURRENT_DATE, tm.data_nascita))::integer <= $2::integer "
            "GROUP BY tm.ruolo "
            "ORDER BY AVG(c.compenso) DESC",
            2
        },
        {
            "suppliers_budget",
            "SELECT s.nome, s.budget, f.nome "
            "FROM settore s "
            "JOIN utilizzo u ON u.settore = s.nome "
            "JOIN strumento str ON str.id_strumento = u.strumento "
            "JOIN fornitura fnt ON fnt.strumento = str.id_strumento "
            "JOIN fornitore f ON fnt.fornitore = f.nome "
            "WHERE EXTRACT(YEAR FROM fnt.data)::integer = $1::integer "
            "GROUP BY s.nome, s.budget, f.nome "
            "HAVING SUM(fnt.prezzo) <= s.budget "
            "ORDER BY s.budget DESC",
            1
        }
    };

    for (int i = 0; i < sizeof(statements)/sizeof(statements[0]); i++) {
        PGresult *res = PQprepare(conn, statements[i].name, statements[i].query, statements[i].nparams, NULL);
        if (PQresultStatus(res) != PGRES_COMMAND_OK) {
            fprintf(stderr, "Prepare failed for %s: %s\n", statements[i].name, PQerrorMessage(conn));
            PQclear(res);
        }
        PQclear(res);
    }   
}

int is_valid_date_format(const char *date) {
    if (strlen(date) != 10) return 0;
    if (date[4] != '-' || date[7] != '-') return 0;
    for (int i = 0; i < 10; i++) {
        if (i != 4 && i != 7 && !isdigit(date[i])) return 0;
    }
    return 1;
}

void printresult(PGresult *res) {
    int rows = PQntuples(res);
    int cols = PQnfields(res);

    for (int j = 0; j < cols; j++) {
        printf("%-35s", PQfname(res, j));
    }
    printf("\n");

    for (int j = 0; j < cols; j++) {
        printf("-----------------------------------");
    }
    printf("\n");

    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            printf("%-35s", PQgetvalue(res, i, j));
        }
        printf("\n");
    }
    PQclear(res);
}

const char *insert_data() {
    char *date = malloc(10);
    if (date == NULL) {
        fprintf(stderr, "Memory allocation failed\n");
        exit(1);
    }
    printf("Enter date (YYYY-MM-DD): ");
    scanf("%10s", date);
    while (!is_valid_date_format(date)) {
        printf("Invalid format. Enter date (YYYY-MM-DD): ");
        scanf("%10s", date);
    }
    return date;
}

const char* insert_cf() {
    char *cf = malloc(16);
    if (cf == NULL) {
        fprintf(stderr, "Memory allocation failed\n");
        exit(1);
    }
    printf("Enter driver CF (16 chars): ");
    scanf("%16s", cf);

    return cf;
}

const char* insert_engine_producer() {
    char* producer = malloc(50);
    if (producer == NULL) {
        fprintf(stderr, "Memory allocation failed\n");
        exit(1);
    }

    printf("Enter engine producer: ");
    scanf("%s", producer);

    return producer;
}

const char* insert_age(int previous_age) {

    int age;
    printf("Enter age: ");
    scanf("%d", &age);
    while(age < previous_age){
        printf("Age too small, enter new age: ");
        scanf("%d", &age);
    }

    char* str_age = malloc(12);
    snprintf(str_age, sizeof(str_age), "%d", age);

    return str_age;
}

const char* insert_financial_year() {
    int year;
    printf("Enter financial year: ");
    scanf("%d", &year);

    while(year < 1946){
        printf("Too early, enter new financial year: ");
        scanf("%d", &year);
    }
    char* str_year = malloc(12);
    snprintf(str_year, sizeof(str_year), "%d", year);

    return str_year;
}
