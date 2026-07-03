import os
import sys
import time
import subprocess
from datetime import datetime, timedelta

def run_dbt():
    print(f"[{datetime.now()}] --- STARTING DBT RUN ---")
    sys.stdout.flush()
    # Runs dbt run using the environment variables set on the container
    res = subprocess.run(["dbt", "run"], cwd="/usr/app/dbt_project")
    print(f"[{datetime.now()}] dbt run finished with exit code: {res.returncode}")
    sys.stdout.flush()

if __name__ == "__main__":
    print(f"[{datetime.now()}] DBT Scheduler started.")
    sys.stdout.flush()
    
    # Run once on startup to sync the database
    run_dbt()
    
    while True:
        # Calculate time until tomorrow at 01:00 AM
        now = datetime.now()
        target = now.replace(hour=1, minute=0, second=0, microsecond=0)
        if target <= now:
            target += timedelta(days=1)
        
        sleep_seconds = (target - now).total_seconds()
        print(f"[{datetime.now()}] Next scheduled run at {target}. Sleeping for {sleep_seconds:.1f} seconds...")
        sys.stdout.flush()
        
        time.sleep(sleep_seconds)
        run_dbt()
