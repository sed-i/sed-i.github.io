# ps

| Command                              | Use-case               |
|--------------------------------------|------------------------|
| `ps -e -T`                           | Show thread names      |
| `ps -e -o class,rtprio,pri,nice,cmd` | Show nice and priority |
| `renice -n <NI> -p <PID>`            | Renice                 |
| `chrt`                               | Change RT scheduling   |
| `pstree <PID>`                       | Process tree           |
