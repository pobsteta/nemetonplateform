#!/bin/bash
# usage : resultat.sh NNN [flux]  — résumé du dernier flux d'une mission (coût, sortie structurée, dernier texte)
. "$(dirname "$0")/commun.sh"
f=$CACHE/m$1/${2:-flux}.jsonl
python3 - "$f" <<'P'
import json,sys
L=open(sys.argv[1]).read().splitlines(); d=json.loads(L[-1])
print(d.get('type'),d.get('subtype'),'coût',d.get('total_cost_usd'),'session',d.get('session_id'))
print(json.dumps(d.get('structured_output'),ensure_ascii=False,indent=1)[:4000])
for l in L[::-1]:
    x=json.loads(l)
    if x.get('type')=='assistant':
        t=[c['text'] for c in x['message']['content'] if c.get('type')=='text']
        if t: print('---\n'+t[0][:2500]); break
P
