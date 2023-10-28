Rename all files so their filename is the creation date timestamp:

```shell
exiftool -d '%Y-%m-%d_%H%M%S.%%e' '-filename<CreateDate' .
```

Set the metadata timestamp to match the filename:
```shell
exiftool "-datetimeoriginal<filename" -overwrite_original ./
# or
exiftool "-alldates<filename" -overwrite_original ./
```

Clear all exif data:
```shell
exiftool -all= −overwrite_original ./
```
