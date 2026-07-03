import os

directory = r"../models"

for root, dirs, files in os.walk(directory):
    for file in files:
        if file.endswith(".sql") and file != "stg_establecimiento.sql":
            path = os.path.join(root, file)
            with open(path, "r", encoding="utf-8") as f:
                content = f.read()
            new_content = content.replace("e.nombre_establecimiento", "e.nombre").replace("est.nombre_establecimiento", "est.nombre")
            if new_content != content:
                with open(path, "w", encoding="utf-8") as f:
                    f.write(new_content)
                print(f"Fixed {path}")
