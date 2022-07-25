# pg_hint_planを有効化
psql -d learning_db -U postgres -c "CREATE EXTENSION pg_hint_plan"