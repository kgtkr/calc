import os
import os.path
import json
import subprocess
import sys

testCases = json.load(open("test.json"))


for lang in [x for x in os.listdir(".") if os.path.exists(f"{x}/Dockerfile")]:
    if len(sys.argv) == 1 or sys.argv[1] == lang:
        image_name = "calc_"+lang
        print(f"#{lang}")
        subprocess.run(["docker", "build", "-t", image_name, "."],
                       cwd=lang, stdout=subprocess.PIPE)
        for case in testCases:
            out = subprocess.run(
                ["docker", "run", "-it", "-t", image_name, "./run", case[0]], cwd=lang,  check=True, stdout=subprocess.PIPE).stdout.strip().decode("UTF-8")
            if out != case[1]:
                print(
                    f"Error:\n\tinput:{case[0]}\n\texpect:{case[1]}\n\toutput:{out}")
