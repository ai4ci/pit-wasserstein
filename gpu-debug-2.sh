 #!/bin/bash
  echo "=== 1. Chromium processes (note each --type=) ==="
  ps -eo pid,args 2>/dev/null | grep -i '[r]studio' | cut -c1-150

  echo; echo "=== 2. Which processes hold /dev/dri ==="
  found=0
  for p in $(ls /proc 2>/dev/null | grep -E '^[0-9]+$'); do
      if ls -l "/proc/$p/fd" 2>/dev/null | grep -q '/dev/dri/'; then
          nodes=$(ls -l "/proc/$p/fd" 2>/dev/null | grep -o '/dev/dri/[a-zA-Z0-9]*' | sort -u | tr '\n' ' ')
          echo "  pid $p [$nodes] $(tr '\0' ' ' < "/proc/$p/cmdline" 2>/dev/null | cut -c1-80)"
          found=$((found+1))
      fi
  done
  [ "$found" -eq 0 ] && echo "  none"

  echo; echo "=== 3. Can the render node actually be opened? ==="
  ls -l /dev/dri/ 2>&1 | head -5
  echo "  id -G: $(id -G)"
  echo "  writable: $( [ -w /dev/dri/renderD128 ] && echo yes || echo NO )"
