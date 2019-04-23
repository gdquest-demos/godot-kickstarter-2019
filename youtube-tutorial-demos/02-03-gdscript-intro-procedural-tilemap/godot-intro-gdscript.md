# 1. What is computer programming?

We all have an intuitive idea, to program something is to give instructions. So then, computer programming is speaking & writing the language of computers to make them do what we want.

This is what you'll be creating by the end of this introductory series: **{{GODOT_TILEMAP_GENERATOR_PROJECT shown}}**. It's much easier to learn and understand by going through a practical example.

Throughout the computing history people have invented hundreds of programming languages and it's interesting and also important to note some key differences between them. Broadly speaking there are a few ways in which we can categorize programming languages:

- by level o abstraction
  - low-level (close to machine code - bits, 0s & 1s)
  - high-level (close to spoken english - usually)
- by mode of running the code
  - compiled: first the code we humans understand is translated into target machine instructions - usually called compilation. The program can then be executed
  - interpreted: the code gets interpreted in real time. Writing code for interpreters is usually called scripting
- by language features: imperative, object oriented, functional, reactive etc.
- by type system (it may very well be a "lanugage features" but this distinction is so important it gets its own category)
  - statically typed: types for data containers (variables, constant values) and function return values have to be specified in order for the computer to understand your code
  - dynamically typed: types aren't built into the programming language although lately there's been increase demand and interest to add optional types to the languages falling in this cateogry

These are not mutually exclussive categories. For example, GDScript, the language we'll look at today understood by Godot is a high-level, interpreted, imperative, object oriented, and dynamically typed with optional type hints. It's modeled to resemble Python, but created exclusively for scripting in the Godot Game Engine.

Don't worry if you don't understand everything right now, we'll go through the **{{GODOT_TILEMAP_GENERATOR_PROJECT shown}}** source code later and it will make this clear.

# 2. Building blocks of a computer program.

These are general ideas used in all programming language types, although we'll be looking at GDScript in particular here (**note** give examples):

- variables are for storing all kinds of data types
- constants likewise, although once a value is assigned to a constant, it can't be changed, that's the difference between them and variables
- instructions to operate on data (actual operators: +, -, for loop, if statements etc.)
- functions store instruction sequences for operating on data. Functions are reusable pieces of code that can optionally receive input parameters and optionally return values
- in object oriented programming, language such as GDScript has features built into them to that facilitate the creation of objects. Objects are collesctions of state (variables, constants) and optinoally behavior (functions) and they're built through a process called instantiation: first a definition of an object is given through a `class` declaration after which concrete objects (instances) can be created with it

# 3. What is API?
In tools/frameworks/systems/libraries built by people to ease the creation process of programs, we'll encounter a very often used term: API. API stands for Application Programming Interface and is a set of ready-made functions available to use by us, the programmers, to speed up the creation process. These systems come with a lot of helper tools and other ready-made data types although API generally refers to the function portion put to our disposal.

So when somone tells you "check the X API" you'll know what to do next. Search the documentation of X to learn what ready-made functionality it has prepared for you.

**note**: perhaps show and discuss a bit about a `Node`'s functionality (API): `_ready`, `_input`, `_process` etc. and how it ties in with the rest of the system.

# 4. Anatomy of GDScript source code file.

*There's no point in me going through breaking down the file, most info would be a slimmed-down version of the GDScript docs + our coding style guide, with what instructions go where*

There there's a few things that are important in my opinion:
  - mention that all files are by design, classes that can be used to make objects with
  - they don't need to necessarily extend a built-in type (`extends` is optional)
  - you can define inner classes

# 5. Put everything together.
- **{{GODOT_TILEMAP_GENERATOR_PROJECT gets shown}}** as an example, pointing out the different things we discussed like variables, functions, instructions, data types, what's API what's not
- point out again that it is a class that gets used when the game runs and its function is storage of state (other data) + behavior (functions)
- explain the map generation process

# 6. Exercise: try it yourself.
Now you know how to create a simple tile map with a perimeter of a given tile type (`Obstacle`) and an inner area made up of `Dirt` & `Grass` tiles. Ofter after creating a system such as this one, a frequent question comes up: how can we improve it?

In our example, the tiles lack variation. We've prepared for you a different project that includes variation in how the tiles look. Think about what it means to include variation in a tile type, for example the `Dirt` tile type. What instructions would we need to give the computer given we have a set of tiles of a particular type, in this case `Dirt`, that we can retreive through an integer value index: `tile_map.set_cell(coordonate_x, coordinate_y, index_tile_type)`. Hint: we already have access to a random number generator.

Note that in our previous implementation, when running the game and cliking right mouse button or enter/space we regenerate the inner area of the map only. This is no problem because tiles lack variatoin so there's no need to regenerate the perimeter as well. Now that we have tile type variation, what do we need to change in order to regenerate the outer perimeter as well?

We provde our solution to this exercise. Because this is an introductory GDScript tutorial we chose an easy implementation, but it comes with a cost: the method we used is not easily extensible. We chose to "hard-code" the tile index values in the `pick_cell` function. This is generally bad practice because if we were to update the tile set picture, we'd have to manually re-assign the indices based on the tile types. It's beyond the scope of this tutorial to offer an advanced solution, but it's good to keep in mind that we generally prefer ways to calculate these values at run-time instead of hard-coding them like this.

**note**: mention that there's potential problems if it were a real game. If the grass tiles would be real obstacles for the player, with this algorithm, depending on the `obstacle_probability` we might run the risk to create unsolvable maze types. This example is just to get familiar with GDScript and avoids advanced topics by design.
