import psycopg2
conn = psycopg2.connect(host='db.example.com', user='demo_user', password='<PASSWORD>', dbname='demo_db')
cur = conn.cursor()
cur.execute("SELECT table_name FROM information_schema.columns WHERE column_name='cedula';")
print("Tables with cedula:", cur.fetchall())
cur.execute("SELECT table_name FROM information_schema.columns WHERE column_name='nickname';")
print("Tables with nickname:", cur.fetchall())
