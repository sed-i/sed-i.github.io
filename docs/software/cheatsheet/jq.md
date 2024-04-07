# jq

[Playground](https://jqplay.org/)

## Merge list of dictionaries

```json
{
  "root":
  [
    {
      "name": "k1",
      "property": "v1"
    },
    {
      "name": "k2",
      "property": "v2"
    }
  ]
}
```

```
.root | map({(.name): (.property)}) | add
```
```json
{
  "k1": "v1",
  "k2": "v2"
}
```
