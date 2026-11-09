import datetime
import hashlib
import json
import os
from pathlib import Path
import re

version = os.environ['FLSMART_VERSION']
if not re.fullmatch(r'\d+\.\d+\.\d+', version):
    raise SystemExit('Release version must have three numeric components')
output = Path('dist')
apk = output / f'flsmart-{version}-android-arm64-v8a.apk'
sha = hashlib.file_digest(apk.open('rb'), 'sha256').hexdigest()
commit = (output / 'source-commit.txt').read_text().strip()
if commit != os.environ['GITHUB_SHA']:
    raise SystemExit('APK source commit differs from the workflow checkout')
body = Path(f'.github/releases/{version}.md').read_text()
for key, value in {
    'version': version,
    'commit': commit,
    'run_url': f"https://github.com/{os.environ['GITHUB_REPOSITORY']}/actions/runs/{os.environ['GITHUB_RUN_ID']}",
    'sha256': sha,
}.items():
    body = body.replace('{{' + key + '}}', value)
section = body.split('### 本次更新\n', 1)[1].split('\n### ', 1)[0]
entries = [
    {'id': f'{commit}:{index}', 'text': line[2:]}
    for index, line in enumerate(section.splitlines()) if line.startswith('- ')
]

changelog = {
    'schemaVersion': 2,
    'versions': [{
        'version': version, 'tag': version,
        'date': datetime.datetime.now(datetime.timezone.utc).date().isoformat(),
        'groups': [{'type': 'feat', 'entries': entries}],
    }],
}
body += '\n<!-- flclash:changelog:json\n' + json.dumps(changelog, ensure_ascii=False) + '\n-->\n'
(output / 'release.md').write_text(body)
