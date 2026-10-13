"""Generate missing mobile hosts without overwriting interview code or tests."""
from pathlib import Path
import shutil
import subprocess
import tempfile

project = Path(__file__).resolve().parents[1]
if not shutil.which('flutter'):
    raise SystemExit('Install Flutter and add flutter to PATH first.')
with tempfile.TemporaryDirectory(prefix='inbox-hosts-') as temp:
    generated = Path(temp) / 'host'
    subprocess.run(['flutter', 'create', '--project-name', 'inbox_interview',
                    '--platforms=android,ios', '--no-pub', str(generated)], check=True)
    for platform in ('android', 'ios'):
        target = project / platform
        if not target.exists():
            shutil.copytree(generated / platform, target)
            print('Created', platform)
        else:
            print('Preserved existing', platform)
subprocess.run(['flutter', 'pub', 'get'], cwd=project, check=True)
