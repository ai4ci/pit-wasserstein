#!/bin/bash
# check processes
for p in $(ls /proc | grep -E '^[0-9]+$'); do
      ls -l "/proc/$p/fd" 2>/dev/null | grep -q '/dev/dri/' &&
          echo "pid $p: $(tr '\0' ' ' < "/proc/$p/cmdline" | cut -c1-90)"
done
