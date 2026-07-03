import psycopg2
conn = psycopg2.connect(host='db.example.com', user='demo_user', password='<PASSWORD>', dbname='demo_db')
cur = conn.cursor()
cur.execute("SELECT schemaname, matviewname FROM pg_matviews WHERE matviewname LIKE '%usuario%';")
print("MatViews:", cur.fetchall())
cur.execute("SELECT schemaname, matviewname FROM pg_matviews WHERE matviewname LIKE '%profesional%';")
print("MatViews Profesional:", cur.fetchall())
