# Text manipulations

## Replace pattern in all files
```bash
find /path/to/search -type f -exec sed -i 's/old_text/new_text/g' {} +
```
