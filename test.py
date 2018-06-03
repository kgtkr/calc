import os
import os.path
import json
import subprocess

testCases = json.load(open("test.json"))


for lang in [x for x in os.listdir(".") if os.path.exists(f"{x}/test.json")]:
    langJson = json.load(open(f"{lang}/test.json"))
    print(f"#{lang}")
    subprocess.run(langJson["build"], cwd=lang, stdout=subprocess.PIPE)
    for case in testCases:
        out = subprocess.run(
            [case[0] if x == "$ARGS" else x for x in langJson["run"]], cwd=lang,  check=True, stdout=subprocess.PIPE).stdout.strip().decode("UTF-8")
        if out != case[1]:
            print(
                f"Error:\n\tinput:{case[0]}\n\texpect:{case[1]}\n\toutput:{out}")
