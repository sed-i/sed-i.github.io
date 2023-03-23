# Python multiprocessing

Here are some patterns for various multiprocessing use cases.

References:
- https://docs.python.org/3/library/multiprocessing.html


## Split array and process chunks independently

```python
from multiprocessing import Pool
from time import sleep
from typing import Callable, List

import numpy as np


def split_and_merge(
    data: np.ndarray,
    num_processes: int,
    function: Callable[[np.ndarray], float],
) -> float:

    def merge(chunks: List[float]) -> float:
        return sum(chunks)

    with Pool(num_processes) as pool:
        return merge(pool.map(function, np.array_split(data, num_processes)))


if __name__ == '__main__':
    def f(arr: np.ndarray) -> float:
        sleep(2)
        return float(sum(arr))

    # Calculate the sum of 0..999 using 5 processes
    arr = np.array(range(1000))
    assert split_and_merge(arr, 5, f) == sum(range(1000)), "Uh oh"
```

