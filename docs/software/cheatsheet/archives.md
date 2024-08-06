# Archives

## `cat` file in an archive[^1]

```bash
unzip -p archive.zip file1.txt
```

[^1](https://superuser.com/a/462796/317188)

## tar

```bash
# List
tar -tvf archive.tar.gz

# Create
tar -czf archive.tar.gz /path/to/folder

# Extract
tar xf archive.tar.gz -C /path/to/target
```
