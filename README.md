CoffeeScript Notebook
=====================

Quick experiment: How hard can it be to make interactive CoffeeScript with a notebook interface 
similar to [Mathematica](http://www.wolfram.com/mathematica/) or [IPython notebook](ipython.org/notebook.html)?
This runs completely inside the browser and has almost no functionality beyond adding and evaluating CoffeeScript.

See the IPython pull request https://github.com/ipython/ipython/pull/5130 for something similar that runs on top of 
IPython notebook.

![CoffeeScript Notebook screenshot](/doc/CoffeeScriptNotebook.png)

Installation
------------

Install required node packages

    npm install
    
Run the server

    grunt serve
    
Open the example notebook on http://127.0.0.1:9000/scratch.html


Limitations
-----------

- notebooks cannot be saved / loaded
- cells cannot be deleted, moved etc

The IPython fork https://github.com/ipython/ipython/pull/5130 has all the good things for working with notebooks (saving, loading, converting to HTML etc).
