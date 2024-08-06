# `strace`

## What's strace?
- Trace calls to system calls, signals
- Debug programs for which no source is available
- Simple profiling

## Profiling
```bash
strace -wc ./a.out  # wall time
```

## Use strace "in the wild"
### systemd
Prepend the command: `ExecStart=/usr/bin/strace /path/to/bin`

### Replace the binary[^1]
```bash
mv /usr/bin/something /usr/bin/something.real
```
```bash
cat <<EOF > /usr/bin/something
#!/usr/bin/env bash

strace "@!" 2>&1 | tee /tmp/something.log.$$
EOF
```
```bash
chmod +x /usr/bin/something
```

[^1]: h/t [@rbarry82](https://github.com/rbarry82)

