import sys, json

if __name__ == "__main__":
    try:
        with open('wotd.json', 'r') as f:
            wotd = json.loads(f.read())[0]
            print(f"""
            Word:  {wotd['word_of_the_day']}\n
            Type:  {wotd['word_type']}\n
            Def:   {wotd['definition']}
            Pro:  |{wotd['pronounciation']}\n
            """, file=sys.stdout)
    except Exception as e:
        print(e, file=sys.stderr)

