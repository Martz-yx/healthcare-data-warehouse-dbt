import psycopg2

try:
    conn = psycopg2.connect(
        host="db.example.com",
        port="5432",
        dbname="demo_db",
        user="demo_user",
        password="<PASSWORD>"
    )
    cur = conn.cursor()
    cur.execute("SELECT table_name FROM information_schema.tables WHERE table_schema='dbt_analytics'")
    tables = cur.fetchall()
    print(f"Found {len(tables)} tables/views in dbt_analytics:")
    for t in tables:
        print(t[0])
except Exception as e:
    print("Error:", e)
