import psycopg2

def connection():
    conn = psycopg2.connect(database = "flask_db", user = "flask_user", password = "flask-password", host = "localhost", port = 5432)
    #print("Connection successful")
    cur = conn.cursor()
    return cur, conn



