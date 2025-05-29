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

// Function prototypes
int isValidDateFormat(const char *date);
void checkresult(PGresult *res, const PGconn *conn);
void printresult(PGresult *res);
PGresult* query_TM_contract_hiring(PGconn *conn);
PGresult* query_fastest_lap_per_gp(PGconn *conn);
PGresult* query_cars_per_driver_engine(PGconn *conn);
PGresult* query_avg_compensation(PGconn *conn);
PGresult* query_suppliers_within_budget(PGconn *conn);

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

        switch(choice) {
            case 1:
                res = query_TM_contract_hiring(conn);
                break;
            case 2:
                res = query_fastest_lap_per_gp(conn);
                break;
            case 3:
                res = query_cars_per_driver_engine(conn);
                break;
            case 4:
                res = query_avg_compensation(conn);
                break;
            case 5:
                res = query_suppliers_within_budget(conn);
                break;
            case 0:
                printf("Exiting...\n");
                break;
            default:
                printf("Invalid choice!\n");
                res = NULL;
        }

        if (res && choice != 0) {
            printresult(res);
            PQclear(res);
        }
    } while (choice != 0);

    PQfinish(conn);
    return 0;
}

int isValidDateFormat(const char *date) {
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

    // Print headers
    for (int j = 0; j < cols; j++) {
        printf("%-20s", PQfname(res, j));
    }
    printf("\n");

    // Print separator
    for (int j = 0; j < cols; j++) {
        printf("--------------------");
    }
    printf("\n");

    // Print data
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            printf("%-20s", PQgetvalue(res, i, j));
        }
        printf("\n");
    }
}

PGresult* query_TM_contract_hiring(PGconn *conn) {
    const char *query = 
        "SELECT tm.nome, tm.cognome, tm.data_nascita, tm.ruolo "
        "FROM team_member tm "
        "JOIN contratto c ON tm.cf = c.cf_team "
        "WHERE c.inizio >= $1::date";

    char date[11];
    printf("Enter date (YYYY-MM-DD): ");
    scanf("%10s", date);
    while (!isValidDateFormat(date)) {
        printf("Invalid format. Enter date (YYYY-MM-DD): ");
        scanf("%10s", date);
    }

    PGresult *res = PQprepare(conn, "tm_hiring", query, 1, NULL);
    if (PQresultStatus(res) != PGRES_COMMAND_OK) {
        printf("Prepare failed: %s\n", PQerrorMessage(conn));
        PQclear(res);
        return NULL;
    }
    PQclear(res);

    const char *params[1] = {date};
    res = PQexecPrepared(conn, "tm_hiring", 1, params, NULL, NULL, 0);
    return res;
}

PGresult* query_fastest_lap_per_gp(PGconn *conn) {
    const char *query = 
        "SELECT g.id_circuito, g.data, g.numero_giro, g.tempo "
        "FROM giro g "
        "WHERE g.pilota = $1::char(16) "
        "AND g.tempo <= ALL ("
        "    SELECT g1.tempo "
        "    FROM giro g1 "
        "    WHERE g1.id_circuito = g.id_circuito "
        "    AND g1.data = g.data "
        "    AND g1.pilota = g.pilota"
        ")";

    char cf[17];
    printf("Enter driver CF (16 chars): ");
    scanf("%16s", cf);

    PGresult *res = PQprepare(conn, "fastest_lap", query, 1, NULL);
    if (PQresultStatus(res) != PGRES_COMMAND_OK) {
        printf("Prepare failed: %s\n", PQerrorMessage(conn));
        PQclear(res);
        return NULL;
    }
    PQclear(res);

    const char *params[1] = {cf};
    res = PQexecPrepared(conn, "fastest_lap", 1, params, NULL, NULL, 0);
    return res;
}

PGresult* query_cars_per_driver_engine(PGconn *conn) {
    const char *query = 
        "SELECT p.nome, p.cognome, m.alimentazione, COUNT(v.id_vettura) as nr_vetture "
        "FROM pilota p "
        "JOIN vettura v ON v.cf = p.cf "
        "JOIN motore m ON m.id_motore = v.id_motore "
        "WHERE m.produttore = $1::varchar(50) "
        "GROUP BY p.cf, m.alimentazione";

    char producer[51];
    printf("Enter engine producer: ");
    scanf(" %50[^\n]", producer);  // Read up to 50 characters including spaces

    PGresult *res = PQprepare(conn, "cars_per_driver", query, 1, NULL);
    if (PQresultStatus(res) != PGRES_COMMAND_OK) {
        printf("Prepare failed: %s\n", PQerrorMessage(conn));
        PQclear(res);
        return NULL;
    }
    PQclear(res);

    const char *params[1] = {producer};
    res = PQexecPrepared(conn, "cars_per_driver", 1, params, NULL, NULL, 0);
    return res;
}

PGresult* query_avg_compensation(PGconn *conn) {
    const char *query = 
        "SELECT tm.ruolo, AVG(c.compenso) as compenso_medio "
        "FROM team_member tm "
        "JOIN contratto c ON c.cf_team = tm.cf "
        "WHERE EXTRACT(YEAR FROM AGE(CURRENT_DATE, tm.data_nascita)) BETWEEN $1 AND $2 "
        "GROUP BY tm.ruolo "
        "ORDER BY AVG(c.compenso) DESC";

    int min_age, max_age;
    printf("Enter min age: ");
    scanf("%d", &min_age);
    printf("Enter max age: ");
    scanf("%d", &max_age);

    // Convert integers to strings for parameters
    char min_str[12], max_str[12];
    snprintf(min_str, sizeof(min_str), "%d", min_age);
    snprintf(max_str, sizeof(max_str), "%d", max_age);

    PGresult *res = PQprepare(conn, "avg_comp", query, 2, NULL);
    if (PQresultStatus(res) != PGRES_COMMAND_OK) {
        printf("Prepare failed: %s\n", PQerrorMessage(conn));
        PQclear(res);
        return NULL;
    }
    PQclear(res);

    const char *params[2] = {min_str, max_str};
    res = PQexecPrepared(conn, "avg_comp", 2, params, NULL, NULL, 0);
    return res;
}

PGresult* query_suppliers_within_budget(PGconn *conn) {
    const char *query = 
        "WITH settori_rispettanti AS ( "
        "    SELECT s.nome "
        "    FROM settore s "
        "    JOIN utilizzo u ON u.settore = s.nome "
        "    JOIN strumento str ON str.id_strumento = u.strumento "
        "    JOIN fornitura fnt ON fnt.strumento = str.id_strumento "
        "    WHERE EXTRACT(YEAR FROM fnt.data) = $1::integer "
        "    GROUP BY s.nome, s.budget "
        "    HAVING SUM(fnt.prezzo_fnt) <= s.budget "
        ") "
        "SELECT DISTINCT s.nome, s.budget, f.nome "
        "FROM settore s "
        "JOIN utilizzo u ON u.settore = s.nome "
        "JOIN strumento str ON str.id_strumento = u.strumento "
        "JOIN fornitura fnt ON fnt.strumento = str.id_strumento "
        "JOIN fornitore f ON fnt.fornitore = f.nome "
        "WHERE EXTRACT(YEAR FROM fnt.data) = $1::integer "
        "AND s.nome IN (SELECT nome FROM settori_rispettanti) "
        "ORDER BY s.budget DESC";

    int year;
    printf("Enter financial year: ");
    scanf("%d", &year);

    char year_str[12];
    snprintf(year_str, sizeof(year_str), "%d", year);

    PGresult *res = PQprepare(conn, "suppliers_budget", query, 1, NULL);
    if (PQresultStatus(res) != PGRES_COMMAND_OK) {
        printf("Prepare failed: %s\n", PQerrorMessage(conn));
        PQclear(res);
        return NULL;
    }
    PQclear(res);

    const char *params[1] = {year_str};
    res = PQexecPrepared(conn, "suppliers_budget", 1, params, NULL, NULL, 0);
    return res;
}