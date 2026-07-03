import psycopg2
conn = psycopg2.connect(host='db.example.com', user='demo_user', password='<PASSWORD>', dbname='demo_db')
cur = conn.cursor()
cur.execute("SELECT table_schema, table_name FROM information_schema.tables WHERE table_name LIKE '%usuario%';")
print("Usuario tables:", cur.fetchall())
cur.execute("SELECT table_schema, table_name FROM information_schema.tables WHERE table_name LIKE '%profesional%';")
print("Profesional tables:", cur.fetchall())
