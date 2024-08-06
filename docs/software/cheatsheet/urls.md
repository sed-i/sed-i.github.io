```mermaid
graph LR

scheme ---|://| username

subgraph netloc
username ---|:| password ---|@| hostname ---|:| port
end

port --- path["/path"]
```
