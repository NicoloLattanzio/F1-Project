#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "dependencies/include/libpq-fe.h"

//connection credentials
#define PG_HOST "127.0.0.1"
#define PG_USER "user0"
#define PG_PORT 5432
#define PG_PSW "intmainale_04"
#define PG_DBNAME "F1-scuderia"

int isValidDateFormat(const char *date) {
    if (strlen(date) != 10) return 0;

    if (date[4] != '-' || date[7] != '-') return 0;

    for (int i = 0; i < 10; i++)
        if (i != 4 && i != 7 && !isdigit(date[i])) return 0;
    
    return 1;
}

void checkresult(PGresult *res, const PGconn *conn){
        if(PQresultStatus(res) != PGRES_TUPLES_OK){
            printf("Inconsistent results %s\n", PQerrorMessage(conn));
            PQclear(res);
            exit(1);
        }
}
void prepare_statement(PGconn *conn, const char *stmt_name, const char *query, int n_params) {
    PGresult *res = PQprepare(conn, stmt_name, query, n_params, NULL);
    if (PQresultStatus(res) != PGRES_COMMAND_OK) {
        printf("Prepare failed for statement '%s': %s\n", stmt_name, PQerrorMessage(conn));
        PQclear(res);
        PQfinish(conn);
        exit(1);
    }
    PQclear(res);
}

PGresult* query_TM_contract_hiring(PGresult *res, PGconn *conn) {
    const char *query = "SELECT tm.nome, tm.cognome, tm.data_nascita, tm.ruolo "
                        "FROM team_member tm "
                        "JOIN contratto c ON tm.cf = c.cf_team "
                        "WHERE c.inizio > $1::date;";

    // Prepare the statement using the helper function
    prepare_statement(conn, "query", query, 1);
    
    // Get the date parameter
    char date[11];
    printf("Inserire la data dalla quale si vuole sapere quali persone sono state assunte e in che ruolo: (YYYY-MM-DD)\n");
    scanf("%10s", date);
    while(!isValidDateFormat(date)) {
        printf("Formato data non valido. Inserire nel formato YYYY-MM-DD: ");
        scanf("%10s", date);
    }

    const char* param = date;

    // Execute the prepared statement
    res = PQexecPrepared(conn, "query", 1, &param, NULL, 0, 0);
    
    return res;     
}
void printresult(PGresult *res){
    int n_tuples = PQntuples(res);
    int n_fields = PQnfields(res);

    for(int i=0; i<n_tuples; i++){
        for(int j=0; j<n_fields; j++){
            printf("%s\t\t", PQgetvalue(res,i,j));
        }
        printf("\n");
    }
    PQclear(res);
}
int main(int argc , char ** argv){
    char conninfo[256];
    sprintf(conninfo, "user =%s password =%s dbname =%s hostaddr =%s port =%d", PG_USER, PG_PSW, PG_DBNAME, PG_HOST, PG_PORT);
    
    PGconn *conn;
    conn = PQconnectdb(conninfo);

    //verify connection status
    if(PQstatus(conn) != CONNECTION_OK){
        printf("Connection error: %s\n", PQerrorMessage(conn));
        PQfinish(conn);
        exit(1);
    }
    else{
        printf("Connection established\n");
        PGresult *res;

        /*
        char *query = "select \"ID\" from \"Piloti\" where \"Nome\"=$1::varchar";
        char name[20];
        scanf("%s", name);
        const char *param = name;

        res = PQprepare(conn, "query1", query, 1, NULL);
        res = PQexecPrepared(conn, "query1", 1, &param, NULL, 0, 0);*/

        //fgets(query, sizeof(query), stdin);
        //res = PQexec(conn, query);

        res = query_TM_contract_hiring(res, conn);

        printresult(res);
        
        PQfinish(conn);
    }
}
