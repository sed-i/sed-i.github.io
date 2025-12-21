---
title: "Nushell tutorial"
date: 2025-12-20T00:00:00-00:00
categories:
- tutorial
tags:
- nushell
---

It's December, which means [advent of code](https://adventofcode.com/2025/) is out.
Let's take this opportunity to learn some [nushell](https://www.nushell.sh)!

## Day 1, part 1

> The safe has a dial with only an arrow on it; around the dial are the numbers `0` through `99` in order.
> The attached document (your puzzle input) contains a sequence of _rotations_, one per line, which tell you how to open the safe. A rotation starts with an `L` or `R` which indicates whether the rotation should be to the _left_ (toward lower numbers) or to the _right_ (toward higher numbers). Then, the rotation has a _distance_ value which indicates how many clicks the dial should be rotated in that direction.
> The actual password is _the number of times the dial is left pointing at `0` after any rotation in the sequence_.

### Load data into a nu `table` using `from csv`

First, let's load the data into a table. For now, I will use literal stand-in data instead of `open`ing the full input file.

```shell
> echo "R15\nL20\n"
R15
L20

> echo "R15\nL20\n" | from csv --noheaders
╭───┬─────────╮
│ # │ column0 │
├───┼─────────┤
│ 0 │ R15     │
│ 1 │ L20     │
╰───┴─────────╯

> echo "R15\nL20\n" | from csv --noheaders | rename "rot"
╭───┬─────╮
│ # │ rot │
├───┼─────┤
│ 0 │ R15 │
│ 1 │ L20 │
╰───┴─────╯
```

### Add calculated columns using `insert`

"L" and "R" represent "-" and "+". Let's break it up:

```shell
> echo "R15\nL20\n" | from csv --noheaders | rename "rot" | insert "dir" {|row| $row.rot | str substring 0..0} | insert "amount" {|row| $row.rot | str substring 1..}
╭───┬─────┬─────┬────────╮
│ # │ rot │ dir │ amount │
├───┼─────┼─────┼────────┤
│ 0 │ R15 │ R   │ 15     │
│ 1 │ L20 │ L   │ 20     │
╰───┴─────┴─────┴────────╯
```

Let's convert the last two column into a signed value:

```shell
> echo "R15\nL20\n" | from csv --noheaders | rename "rot" | insert "dir" {|row| $row.rot | str substring 0..0} | insert "amount" {|row| $row.rot | str substring 1..} | insert "value" {|row| $row.dir | if $in == 'L' {-1} else {1} | $in * $row.amount}
Error: nu::shell::type_mismatch

  × Type mismatch during operation.
```

Ok so "amount" is a string. Let's convert it:

```shell
> echo "R15\nL20\n" | from csv --noheaders | rename "rot" | insert "dir" {|row| $row.rot | str substring 0..0} | insert "amount" {|row| $row.rot | str substring 1..} | insert "value" {|row| $row.dir | if $in == 'L' {-1} else {1} | $in * ($row.amount | into int)}
╭───┬─────┬─────┬────────┬───────╮
│ # │ rot │ dir │ amount │ value │
├───┼─────┼─────┼────────┼───────┤
│ 0 │ R15 │ R   │ 15     │    15 │
│ 1 │ L20 │ L   │ 20     │   -20 │
╰───┴─────┴─────┴────────┴───────╯
```

Or, instead of keeping strings, let's store "amount" as an int to begin with.

```shell
> echo "R15\nL20\n" | from csv --noheaders | rename "rot" | insert "dir" {|row| $row.rot | str substring 0..0} | insert "amount" {|row| $row.rot | str substring 1.. | into int} | insert "value" {|row| $row.dir | if $in == 'L' {-1} else {1} | $in * $row.amount }
╭───┬─────┬─────┬────────┬───────╮
│ # │ rot │ dir │ amount │ value │
├───┼─────┼─────┼────────┼───────┤
│ 0 │ R15 │ R   │     15 │    15 │
│ 1 │ L20 │ L   │     20 │   -20 │
╰───┴─────┴─────┴────────┴───────╯
```

### Use the multiline editor to better visualize the pipeline

This line is already too long, let's break it up (option + return on a mac to insert a line break):

```shell
> echo "R15\nL20\n"
| from csv --noheaders | rename "rot" 
| insert "dir" {|row| $row.rot | str substring 0..0} 
| insert "amount" {|row| $row.rot | str substring 1.. | into int} 
| insert "value" {|row| $row.dir | if $in == 'L' {-1} else {1} | $in * $row.amount }
╭───┬─────┬─────┬────────┬───────╮
│ # │ rot │ dir │ amount │ value │
├───┼─────┼─────┼────────┼───────┤
│ 0 │ R15 │ R   │     15 │    15 │
│ 1 │ L20 │ L   │     20 │   -20 │
╰───┴─────┴─────┴────────┴───────╯
```

### Keep only the desired columns using `select`

So far this was just data prep. Let's keep only that last column.

```shell
> echo "R15\nL20\n"
| from csv --noheaders | rename "rot" 
| insert "dir" {|row| $row.rot | str substring 0..0} 
| insert "amount" {|row| $row.rot | str substring 1.. | into int} 
| insert "value" {|row| $row.dir | if $in == 'L' {-1} else {1} | $in * $row.amount }
| select value
╭───┬───────╮
│ # │ value │
├───┼───────┤
│ 0 │    15 │
│ 1 │   -20 │
╰───┴───────╯
```

### Shorten the pipeline using `str startswith`
Turns out there's `str startswith`, which can shorten the expression,
```shell
> echo "R15\nL20\n" 
| from csv --noheaders | rename "rot" 
| insert "oneshot" {|row| $row.rot | (if ($in | str starts-with 'L') {-1} else {1}) * ($in | str substring 1.. | into int) }
| select oneshot
╭───┬─────────╮
│ # │ oneshot │
├───┼─────────┤
│ 0 │      15 │
│ 1 │     -20 │
╰───┴─────────╯
```

### Shorten the pipeline using `each`
Instead of `insert`ing columns we'd end up dropping, I might as well _transform_ the input into what I need
```shell
> echo "R15\nL20\n"
| from csv --noheaders | rename "rot" 
| each {|row| $row.rot | (if ($in | str starts-with 'L') {-1} else {1}) * ($in | str substring 1.. | into int) }
╭───┬─────╮
│ 0 │  15 │
│ 1 │ -20 │
╰───┴─────╯
```

An even shorter expression when we use `str replace`.

```shell
> echo "R15\nL20\n"
| from csv --noheaders | rename "rot" 
| each {|row| $row.rot | str replace 'L' '-'  | str replace 'R' '' | into int}
╭───┬─────╮
│ 0 │ 15  │
│ 1 │ -20 │
╰───┴─────╯
```

### Use `describe` to check data type
Huh, no headers this time, not even the default `column0`. So it's not a table anymore?

```shell
> echo "R15\nL20\n"
| from csv --noheaders | rename "rot" 
| each {|row| $row.rot | str replace 'L' '-'  | str replace 'R' '' | into int}
| describe
list<int> (stream)
```

Ok, a list of `int`s, makes sense.

### Read data into list instead of table

In fact, we don't need the intermediate table at all, and reading directly into a list is even shorter:

```shell
> echo "R15\nL20\n" | split words
╭───┬─────╮
│ 0 │ R15 │
│ 1 │ L20 │
╰───┴─────╯
```

Turns out the `lines` command is even a better fit than `split words`,

```
> echo "R15\nL20\n" | lines
╭───┬─────╮
│ 0 │ R15 │
│ 1 │ L20 │
╰───┴─────╯
```


```
> echo "R15\nL20\n" 
| lines
| each {|it| $it | str replace 'L' '-'  | str replace 'R' '' | into int}
╭───┬─────╮
│ 0 │  15 │
│ 1 │ -20 │
╰───┴─────╯
```

Performance wise, this had a 4x improvement:

```shell
> let d = open day1.input

> 1..100 
| each {
    (timeit { $d | split words }) / (timeit { $d | lines })
  }
| math avg
4.407299909583932
```

### Store in a variable using `let`
Now that the table is ready to use, let's store it in a variable so we don't need to repeat all the lines above again and again.

```shell
> let lst = echo "R15\nL20\n" 
| lines
| each {|it| $it | str replace 'L' '-'  | str replace 'R' '' | into int}

> $lst
╭───┬─────╮
│ 0 │  15 │
│ 1 │ -20 │
╰───┴─────╯
```

### Define custom commands for reusable code

```shell
> def load_day1 [] {
  echo "R15\nL20\n" 
  | lines
  | each {|it| $it | str replace 'L' '-'  | str replace 'R' '' | into int}
}

> load_day1
╭───┬─────╮
│ 0 │  15 │
│ 1 │ -20 │
╰───┴─────╯

> let lst = load_day1
```

### Create a sum series using `reduce`
To solve the day1 part1 challenge, I'd be looking for the number of times the sum series has a value that is divisible by 100.
First we need the sum series, which we can create using `reduce`.
From the problem statement, the initial value is 50. So, adapting the [example in the docs](https://www.nushell.sh/commands/docs/reduce.html#examples):

```shell
> [ 1 2 3 4 ] | reduce --fold [50] {|it, acc| $acc | append (($acc | last) + $it)}
╭───┬────╮
│ 0 │ 50 │
│ 1 │ 51 │
│ 2 │ 53 │
│ 3 │ 56 │
│ 4 │ 60 │
╰───┴────╯
```

Here, every iteration `$acc` contains a list, which we incrementally grow, using `append`.
The concept is solid, so let's apply to our case:

```shell
> load_day1 
| reduce --fold [50] {
    |it, acc| $acc | append (($acc | last) + $it)
  }
╭───┬────╮
│ 0 │ 50 │
│ 1 │ 65 │
│ 2 │ 45 │
╰───┴────╯
```

### Filter list items with... ~~`filter`~~ `where`

The solution is the number of values the are divisible by 100. Let's count only those:
```shell
> [0, 99, 100, 101, -100, -99] | filter {|it| $it mod 100 == 0}
╭───┬──────╮
│ 0 │    0 │
│ 1 │  100 │
│ 2 │ -100 │
╰───┴──────╯

> [0, 99, 100, 101, -100, -99] | filter {|it| $it mod 100 == 0} | length
3
```

However, a recent enough nushell would emit a warning:
```
filter was deprecated in 0.105.0 and will be removed in a future release.
help: `where` command can be used instead, as it can now read the predicate closure from a variable
```

Heeding to that advice,
```shell
> [0, 99, 100, 101, -100, -99] | where $it mod 100 == 0 | length
3
```

### Load file contents using `open`
That's it, everything is ready to use real data.
In the function definition, I'd need to change the `echo` with `open`:

```shell
> def load_day1 [] {
  open "day1.input" 
  | lines
  | each {|it| $it | str replace 'L' '-'  | str replace 'R' '' | into int}
}

> load_day1 
| reduce --fold [50] {
    |it, acc| $acc | append (($acc | last) + $it)
  }
| where $it mod 100 == 0 | length
984
```

## `reduce` can `update` a record
Now that I think of it, the sum series isn't *necessary* and the closure in the `reduce`  can accumulate, without needing the `length`.

```shell
> load_day1
| reduce --fold {s: 50, n: 0} {
    |it, acc| $acc 
      | update s ($acc.s + $it) 
      | update n ($acc.n + ($acc.s mod 100 == 0 | into int))
  }
| get n
984
```

Or, instead of using `update`, it is also possible to reconstruct the record every reduce step:

```shell
> load_day1
| reduce --fold {s: 50, n: 0} {
    |it, acc| {
      s: ($acc.s + $it),
      n: ($acc.n + (($acc.s + $it) mod 100 == 0 | into int))
    }
  }
| get n
984
```

## Day 1, part 2

> ... you're actually supposed to count the number of times _any click_ causes the dial to point at `0`, regardless of whether it happens during a rotation or at the end of one.
> Be careful: if the dial were pointing at `50`, a single rotation like `R1000` would cause the dial to point at `0` ten times before returning back to `50`!

Here's a silly inefficient solution, but makes use of mutable variables, ranges and nested loops:

```shell
> mut n = 0; mut s = 50
> for v in (load_day1) {
    if $v == 0 {
      $n += 1
      continue
    }
    
    let rng = if $v > 0 {1..$v} else {-1..$v}
    for _ in $rng {
        $s += if $v > 0 {1} else {-1}
        $s = $s mod 100
        if $s == 0 { $n += 1 }
    }
  }

> $n
5657
```