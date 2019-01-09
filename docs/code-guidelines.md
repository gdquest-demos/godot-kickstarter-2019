# Coding Guidelines

This document describes GDScript coding style and best practices to organize code base to keep sane when developing mid-to-large projects.

The ideas exposed below take inspiration from good practices from different paradigms and languages, especially from Python and functional programming, as well as the official GDScript documentation.

In order of importance:

1. [GDScript Style Guide](http://docs.godotengine.org/en/latest/getting_started/scripting/gdscript/gdscript_styleguide.html)
1. [Static typing in GDScript](http://docs.godotengine.org/en/latest/getting_started/scripting/gdscript/static_typing.html)
1. [Boundaries - A talk by Gary Bernhardt from SCNA 2012](https://www.destroyallsoftware.com/talks/boundaries) & [Functional Core, Imperative Shell](https://www.destroyallsoftware.com/screencasts/catalog/functional-core-imperative-shell)
1. [The Clean Architecture in Python](https://www.youtube.com/watch?v=DJtef410XaM)
1. [Onion Architecture Without the Tears - Brendan Richards](https://www.youtube.com/watch?v=R2pW09tMCnE&t=1095s)
1. [Domain Driven Design Through Onion Architecture](https://www.youtube.com/watch?v=pL9XeNjy_z4)

There isn’t a straightforward way of transposing these ideas into an object-oriented setting such as when working with Godot since it has its way of handling interactions.

To create modular and composable systems, we have to manage boundaries: the places where different game systems interact with one another. Especially the interaction of the game systems with the user.

## Code Writing Style

This section shows our programming style by example.

<!-- TODO: Add a short but complete, real-world example -->

```gdscript
extends Node

"""
A brief description of the class's role and functionality

A longer description, if needed, possibly of multiple paragraphs. Properties and method names should be in backticks like so: `_process`, `x` etc.

Notes
-----
Specific things that don't fit the class's description above.

Keep lines under 100 characters long
"""
```

Include `class_name` only if necessary: if you need to check for this type in other classes, or to be able to create the node in the create node dialogue.

```gdscript
class_name MyNode
```

Signals go first and don't use parentheses unless they pass function parameters. Use the past tense to name signals. Append `_started` or `_finished` if the signal corresponds to the beginning or the end of an action.

```gdscript
signal moved
signal talk_started(parameter_name)
signal talk_finished
```

Place `onready` variables after signals, because we mostly use them to keep track of child nodes this class accesses. Having them at the top of the file makes it easier to keep track of dependencies.

```
onready var timer : = $Timer
onready var ysort : = $YSort
```

After that, place exported variables, then constants, then enums. The enums' names should be in `CamelCase` while the values themselves should be in `ALL_CAPS_SNAKE_CASE`

```gdscript
export(int) var number

const MAX_TRIALS : = 3
const TARGET_POSITION : = Vector2(2, 56)

enum TileTypes { EMPTY=-1, WALL, DOOR }
```

Follow enums with member variables. Their names should use `snake_case`a. Define setters and getters when properties alter their behavior instead of using methods to access them. They should start with an `_` to indicate these are private methods, and use the names `_set_variable_name`,  `_get_variable_name`

```
var animation_length : = 1.5
var tile_size : = 40
var side_length : = 5 setget _set_side_length, _get_side_length # where setters/getters start with `_`
```

Define private and virtual methods, starting with a leading `_`.

```
func _init() -> void:
  pass

func _process(delta: float) -> void:
  pass
```

Then define public methods. Include type hints for variables and the return type.

You can use a brief docstring, if need be, to describe what the function does and what it returns. To describe the return value in the docstring, start the sentence with `Returns`. Use the present tense and direct voice. See Godot's [documentation writing guidelines](http://docs.godotengine.org/en/latest/community/contributing/docs_writing_guidelines.html) for more information.

```
func can_move(cell_coordinates : Vector2) -> bool:
  return grid[cell_coordinates] != TileTypes.WALL
```

Use `return` only at the beginning and end of functions. If `return` is at the beginning, you can use it as a defense mechanism in an `if` statement.

**Don't** return in the middle of the method. It makes it harder to track returned values. Here's an example of a **clean** and readable method:

```gdscript
func start_quest(id : String) -> Quest:
  """
  Finds the quest corresponding to the `id` in the database and calls its start method.
  Returns the Quest object so other nodes can connect to its signals.
  """
  var quest : Quest = get_quest_from_database(id)
  if not quest:
    return null
  quest.start()
  return quest
```

Another example of **good** return statements:

<!-- TODO: replace with a concrete example -->

```gdscript
func good_return_func(health : int, param : float) -> Vector3:
  if health < 0:
    return Vector3()

  var some_out_value : = # initialize
  if param_is_good(param):
    some_out_value = calculate_out(param)
  else:
    some_out_value = # some calculation possibly depending on other factors

  return some_out_value
```

<!-- TODO: proof from here -->

### On the use of `null`

`None`, `null`, `NULL`, etc. references could be the biggest mistake in the history of computing, coming from the man that invented it himself: [Null References: The Billion Dollar Mistake](https://www.infoq.com/presentations/Null-References-The-Billion-Dollar-Mistake-Tony-Hoare).

For programming languages that depend on `null` such as GDScript it's impossible to get rid of `null` usage completely because a lot of its functionality relies on built-in functions that work/return `null` values. But why would we care about it? In simple terms, `null` is a value that behaves like any other value in any context which means that the compiler can't warn us about mistakes caused by `null` at compile time. Which in turn means that `null` exceptions will only be visible at runtime. This is bad and it should be avoided like the plague.

In general there are sensible option for initializing variables of certaing types without the need for `null`. For example, if a function returns a positive `int` number, then upon failure to calculate the desired return value, the function could return `-1` instead of `null` to signify the error.

So the key takeaway is: **use `null` only if you're forced to**. Instead think about alternative ways of implementing the same functionality using regular types.

### [Typed GDScript](http://docs.godotengine.org/en/latest/getting_started/scripting/gdscript/static_typing.html)

In this project we'll be using [Typed GDScript](http://docs.godotengine.org/en/latest/getting_started/scripting/gdscript/static_typing.html). At the time of this writing static GDScript typing doesn't provide any perofrmance boosts or any other compiler features just yet, but we'll be using as a training exercise to get used to it, because things like JIT (Just In Time) compilation and other nice improvements are on the Godot roadmap.

What typed GDScript provides right now is better code completion, and better warnings in the Godot text editor so even now it's quite a good improvement over dynamically typed GDScript.

Be sure to check [Static typing in GDScript](http://docs.godotengine.org/en/latest/getting_started/scripting/gdscript/static_typing.html) to get an idea of how static typing works.

Although Godot can infer the type for you if you write something like `var x := some_function_returning_Vector2()`, instead of `var x : Vector2 = some_function_returning_Vector2()`, in the codebase we're working with we'll enforce types whenever we define variables `var x : SomeType = ...` for tow main reasons: to get acustomed to working with types and for documentation. It makes the code easier to follow if you can immediately see what the variable types are. After all, reading a code base is far more common than writing it so readability is really important.

_note_ that at the moment both Typed and Dynamic GDScript can be used in the same source code file, but we'll strive to use [Typed GDScript](http://docs.godotengine.org/en/latest/getting_started/scripting/gdscript/static_typing.html) as much as possible.
