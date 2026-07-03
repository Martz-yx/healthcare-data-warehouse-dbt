set DBT_PG_HOST=db.example.com
set DBT_PG_PORT=5432
set DBT_PG_DBNAME=demo_db
set DBT_PG_USER=demo_user
set DBT_PG_PASSWORD=<PASSWORD>
set DBT_ALLOW_EXPERIMENTAL_ADAPTERS=true
cd "."
dbt run --target dev
