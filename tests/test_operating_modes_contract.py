import json
from pathlib import Path
import subprocess
import unittest

ROOT=Path(__file__).resolve().parents[1]
class ModeTests(unittest.TestCase):
    def test_canonical_contract(self):
        path=ROOT/'config/ava/operating-modes.v1.json'
        self.assertTrue(path.is_file(),'missing canonical mode contract')
        d=json.loads(path.read_text())
        self.assertEqual(d['default'],'BUILD')
        self.assertFalse(d['modes']['SOLO']['external_delegation'])
        self.assertTrue(d['modes']['PARTY']['coding'])
        self.assertTrue(d['modes']['PARTY']['isolated_writer'])
        self.assertTrue(d['modes']['COUNCIL']['single_quest'])
        self.assertTrue(all(v is False for v in d['authority'].values()))
    def test_default_build_and_unknown(self):
        door=ROOT/'scripts/ava'
        self.assertTrue(door.is_file(),'missing thin mode router')
        a=subprocess.run(['bash',str(door)],text=True,capture_output=True)
        b=subprocess.run(['bash',str(door),'build'],text=True,capture_output=True)
        self.assertEqual(a.returncode,0,a.stderr)
        self.assertEqual(a.stdout,b.stdout)
        self.assertIn('BUILD',a.stdout)
        bad=subprocess.run(['bash',str(door),'bogus'],text=True,capture_output=True)
        self.assertNotEqual(bad.returncode,0)
        for mode in ['solo','party','council','modes','help']:
            r=subprocess.run(['bash',str(door),mode],text=True,capture_output=True)
            self.assertEqual(r.returncode,0,r.stderr)

if __name__=='__main__': unittest.main()
