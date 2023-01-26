# CURTIS

This is named after curtis from [The Santa Clause (1994)](https://www.imdb.com/title/tt0111070/) but has literally
nothing to do with the movie. Bernard and Curtis are buddy-buddy elves that run the north pole.

Bernard is the boss boss, and curtis operates accordingly.

IYKYK.

`CURTIS` is a runtime for the [Playdate](https://play.date/) I use for research.


High level overview of the workflow to produce CURTIS:

1) Build probable deps for playdateOS
    - FreeRTOS
    - CMSIS
    - ST_Library (stm32f746xx)
    - LUA 5.4
        - (most good chance its based on [this](https://sudonull.com/post/25551-We-embed-the-Lua-interpreter-in-the-project-for-the-microcontroller-stm32) post)
    - Memfault

2) Generate signatures from all the built objects
3) Look for and label matches
4) Export headers from Binary Ninja for type information
5) Export addresses of functions into a template for our rust code
6) Generate bindings
7) ???
8) Profit (Write the runtime that connects to PlaydateOS)

Currently 1/8