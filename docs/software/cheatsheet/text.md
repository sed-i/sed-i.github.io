# Text manipulations

## Remove all lines matching a pattern
```bash
sed -i '/the_pattern/d' file.name
```

## Replace pattern in all files
```bash
find /path/to/search -type f -exec sed -i 's/old_text/new_text/g' {} +
```

## Columnar trim
Trim the first 5 characters of every line:
```bash
cut -c6- file.name
```
