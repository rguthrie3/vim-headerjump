# vim-headerjump
Moving from source to header to unit test easily.

I have wanted to begin developing Vim plugins for a while, and this is my first attempt at something useful.
In C and C++ development, there is often a lot of bouncing around between a source file and its associated header and unit test.
Typically I would just have a tab with these 3 files open, but bouncing around takes more time than it needs to.  Switching around with Bufexplorer or CtrlP requires scanning for the right thing with your eyes and a lot of typing.
The explicit goal of this plugin is: given you are in a source file, a header file, or a unit test, you can move to any other of those files with a single command.

The plugin maintains a state of which 3 files these commands will jump to.
Example, say we are editing src/Calculator.cpp.  Then:
<leader>1 -> src/Calculator.cpp
<leader>2 -> inc/Calculator.h
<leader>3 -> test/CalculatorTest.cpp
Then we change buffers to src/Matrix.cpp, and the mappings now do
<leader>1 -> src/Matrix.cpp
<leader>2 -> inc/Matrix.h
<leader>3 -> test/Matrix.cpp

This plugin is currently not fully functional.  I would like for users to be able to supply simple rules to find this group of files based on the naming scheme used in their project, and to have the plugin take care of the rest.
I also only intend to explicitly support C++ and C.
