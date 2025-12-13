#!/bin/sh
set -e

TEMPLATE_PATH="/config/buildarr.yml.tpl"
OUTPUT_PATH="/config/buildarr.yml"

if [ ! -f "$TEMPLATE_PATH" ]; then
  echo "Template file not found at $TEMPLATE_PATH" >&2
  exit 1
fi

echo "Rendering Buildarr config from template..."

if command -v python3 >/dev/null 2>&1; then
  PYTHON_BIN=python3
else
  PYTHON_BIN=python
fi

"$PYTHON_BIN" - << 'EOF'
import os
from pathlib import Path

template_path = Path("/config/buildarr.yml.tpl")
output_path = Path("/config/buildarr.yml")

template = template_path.read_text()
rendered = os.path.expandvars(template)

output_path.write_text(rendered)
EOF

echo "Rendered Buildarr config to $OUTPUT_PATH"
echo "Running buildarr apply..."

exec buildarr apply


