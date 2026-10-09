"""Deterministic mode policy. Descriptive identities never authorize dispatch."""
import json
from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]


def contract():
    d=json.loads((ROOT/'config/ava/operating-modes.v1.json').read_text())
    if (d.get('schema')!='avalhla.operating-modes.v1' or d.get('default')!='BUILD'
            or set(d.get('modes',{}))!={'BUILD','SOLO','PARTY','COUNCIL'}
            or d.get('aliases')!={'ava':'build'}
            or d.get('authority')!={k:False for k in ('model','provider','persona','aspect','role','skill','ability','party')}
            or d.get('relation')!='AvvA'):
        raise ValueError('invalid operating contract')
    required={
        'BUILD': {'external_delegation':False},
        'SOLO': {'external_delegation':False,'local_safety_review_devilash':True},
        'PARTY': {'external_delegation':True,'coding':True,'isolated_writer':True},
        'COUNCIL': {'external_delegation':True,'single_quest':True,'coding':False,'voting_authority':False},
    }
    for mode,fields in required.items():
        if any(d['modes'][mode].get(k) is not v for k,v in fields.items()):
            raise ValueError('mode boundary drift')
    return d


def external_allowed(mode):
    d=contract()
    if mode not in d['modes']:
        raise ValueError('unknown mode')
    return d['modes'][mode]['external_delegation']


def main(args):
    d=contract()
    key=args[0].lower() if args else 'build'
    if key in ('help','modes'):
        print('ava [build|solo|party|council|modes|help]')
        print('BUILD: improve Avalhla. SOLO: local capabilities. PARTY: isolated workers. COUNCIL: one QUEST.')
        return
    mode=key.upper()
    if mode not in d['modes'] or len(args)>1:
        raise ValueError('unknown or unsupported mode arguments; use ava help')
    print(f'MODE={mode}')
    print('OBJECTIVE=improve Avalhla' if mode=='BUILD' else f'EXTERNAL_DELEGATION={str(external_allowed(mode)).lower()}')
    print('Supporting doors: ava-cobuilder, ava-resume, ava-safety, ava-review, ava-verify')
    print('Dawa chooses.')


if __name__=='__main__':
    import sys
    try:
        main(sys.argv[1:])
    except (ValueError,KeyError,OSError) as exc:
        print(f'ava: {exc}',file=sys.stderr)
        sys.exit(2)
