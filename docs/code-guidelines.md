# Coding Guidelines

This document describes GDScript coding style and best practices for organizing code base in order to keep sane when developing mid-to-large projects. This is influenced by a series of good-practice guides found in the wild taken especially from Python-related & functional programming presentations and talks as well as the official GDScript documentation (in order of importance):

1. [GDScript Style Guide](http://docs.godotengine.org/en/latest/getting_started/scripting/gdscript/gdscript_styleguide.html)
1. [Static typing in GDScript](http://docs.godotengine.org/en/latest/getting_started/scripting/gdscript/static_typing.html)
1. [Boundaries - A talk by Gary Bernhardt from SCNA 2012](https://www.destroyallsoftware.com/talks/boundaries) & [Functional Core, Imperative Shell](https://www.destroyallsoftware.com/screencasts/catalog/functional-core-imperative-shell)
1. [The Clean Architecture in Python](https://www.youtube.com/watch?v=DJtef410XaM)
1. [Onion Architecture Without the Tears - Brendan Richards](https://www.youtube.com/watch?v=R2pW09tMCnE&t=1095s)
1. [Domain Driven Design Through Onion Architecture](https://www.youtube.com/watch?v=pL9XeNjy_z4)

This means that we there isn’t a very easy and clear way of transposing these ideas into an object orented setting such as when working with Godot, since it has its own way of handling interactions. The solution for creating modular and composable systems is managing boundaries, especially at the interaction of the system with the user/player. And this guideline tries to give an overview of useful ideas to manage this task.

## Code Writing Style

This section will exemplify how to write code through an annotated example:

```gdscript
extends Node
"""
Brief description of class functionality.

Followed by longer description comprised of possibly multiple paragraphs
where properties/methods specified in this docstring are enclosed in back
ticks like so: `_process`, `x` etc. If there's specifics that aren't easily
expressed in the main paragraphs a note section can be used.

Notes
-----
Where here we'll have some notes on specific things that aren't meant to go
in the main paragraphs above.

Keep the line length lower than 100 characters
"""

# include class names only if necessary
class_name NewNode

# signals go first and don't use parentheses unless necessary
signal moved # use past tense to signify finished action
signal talk_started(param1) # and append `_started` and `_finished`
signal talk_finished # if the signal is for beginning/ending of action

# immediately followed by `onready` variables
# because these are mostly used when accessing
# other nodes so it's easy to keep track of
# dependencies
onready timer := $Timer
onready other_node := $OtherNode

# and then exports
export(int) var number

# next const values
const X := 3
const Y := Vector2(2, 56)

# next enums, which if named are written in CamelCase
# while the values themselves are ALL_CAPS_SNAKE_CASE
enum Named {TYPE_1, TYPE_2, ANOTHER_TYPE}

# followed by local variables and define setters/getters
# when properties should depend or alter their behavior
# instead of using functions to access them
var snake_case_for_variables := 4.5
var tile_size = 40
var y := 5 setget _set_y, _get_y # where setters/getters start with `_`

# next define private/virtual functions
func _init() -> void:
  # do some initialization here
  pass

func _process(delta: float) -> void:
  # do some processing here
  pass

# finally define regular functions
func to_world(v: Vector2) -> Vector2:
  """
  A brief docstring of what the function does and its return value specified
  via the :returns: tag. For example this conversion function :returns:
  a Vector2 transformed to world coordinates.
  """
  var idx := # calculate indices
  var new_v := # do some calculation with `idx`
  return new_v

# the following are a couple of ideas on structuring function logic
# so it's easy to understand
func dont_user_return_in_middle_blocks(do_it: bool) -> Vector3:
  """
  Use `return` only at the beginning and end of functions. At the beginning we
  use it normally as a guard of some sorts in an `if` statement, while at the
  end we regularly use it to return the result.

  Don't use `return` in the middle of `if` statements in the main function
  body. It only creates confusion.
  """
  var some_v := # initialization
  if condition(some_v):
    var calculation := # some calculation that returns Vector3 for example
    return calculation # this is a bad return
  return Vector3()

# this is a good organized function
func good_return_func(health: int, param: float) -> Vector3:
  # good return (guard)
  if health < 0:
    return Vector3()

  var some_out_value := # initialize
  # do some work that potentially branches
  if param_is_good(param):
    some_out_value = calculate_out(param)
  else:
    some_out_value = # some calculation possibly depending on other factors

  # good return (at the end)
  return some_out_value
```

### On the use of `null`

`None`, `null`, `NULL`, etc. references could be the biggest mistake in the history of computing, coming from the man that invented it himself: [Null References: The Billion Dollar Mistake](https://www.infoq.com/presentations/Null-References-The-Billion-Dollar-Mistake-Tony-Hoare).

For programming languages that depend on `null` such as GDScript it's impossible to get rid of `null` usage completely because a lot of its functionality relies on built-in functions that work/return `null` values. But why would we care about it? In simple terms, `null` is a value that behaves like any other value in any context which means that the compiler can't warn us about mistakes caused by `null` at compile time. Which in turn means that `null` exceptions will only be visible at runtime. This is bad and it should be avoided like the plague.

In general there are sensible option for initializing variables of certaing types without the need for `null`. For example, if a function returns a positive `int` number, then upon failure to calculate the desired return value, the function could return `-1` instead of `null` to signify the error.

So the key takeaway is: **use `null` only if you're forced to**. Instead think about alternative ways of implementing the same functionality using regular types.

### [Typed GDScript](http://docs.godotengine.org/en/latest/getting_started/scripting/gdscript/static_typing.html)

In this project we'll be using [Typed GDScript](http://docs.godotengine.org/en/latest/getting_started/scripting/gdscript/static_typing.html). At the time of this writing static GDScript typing doesn't provide any perofrmance boosts or any other compiler features just yet, but we'll be using as a training exercise to get used to it, because things like JIT (Just In Time) compilation and other nice improvements are on the Godot roadmap.

What typed GDScript provides right now is better code completion, and better warnings in the Godot text editor so even now it's quite a good improvement over dynamically typed GDScript.

Be sure to check [Static typing in GDScript](http://docs.godotengine.org/en/latest/getting_started/scripting/gdscript/static_typing.html) to get an idea of how static typing works.

There's one main guideline to go by: **if the compiler can infer the type for you let it**.

Normally we define typed variables like this:

```gdscript
var x : Vector2 = some_function_returning_Vector2(param1, param2)
```

but if `some_function_returning_Vector2` is also annotated with a return type:

```gdscript
func some_function_returning_Vector2(param1: int, param2: int) -> Vector2:
  # do some work
  return Vector2()
```

then Godot can infer the type for us so we can define the variable like so:

```
var x := some_function_returning_Vector2(param1, param2)
```

omitting the type after the colon. _note_ that we still use the collon in the assingment as in `:=`, it isn't a simple `=`. This instructs Godot to try and figure out the type, while using the simple `=` would revert to dynamic GDScript.

_note_ that at the moment both Typed and Dynamic GDScript can be used in the same source code file, but we'll strive to use [Typed GDScript](http://docs.godotengine.org/en/latest/getting_started/scripting/gdscript/static_typing.html) as much as possible.
