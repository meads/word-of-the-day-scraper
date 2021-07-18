#!/usr/bin/env python3

import os, sys, json

def main():
    script = sys.argv[0]
    project_root = os.path.dirname(script)
    try:
        with open(f"{project_root}/wotd.json", 'r') as f:
            wotd = json.loads(f.read())[0]
            print(f"""\n
Word:  {wotd['word_of_the_day']}\n
Type:  {wotd['word_type']}\n
Def:   {wotd['definition']}\n\n
Pro:  |{wotd['pronounciation']}\n
            """, file=sys.stdout)
    except Exception as e:
        print(e, file=sys.stderr)

if __name__ == "__main__":
    main()

