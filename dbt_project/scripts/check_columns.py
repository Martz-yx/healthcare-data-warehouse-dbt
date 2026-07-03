import psycopg2
conn = psycopg2.connect(host='db.example.com', user='demo_user', password='<PASSWORD>', dbname='demo_db')
cur = conn.cursor()
cur.execute("SELECT column_name FROM information_schema.columns WHERE table_name='profesional';")
print("Profesional columns:", cur.fetchall())
