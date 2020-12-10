<!--
.. title: Backporting Python type annotations
.. slug: backporting-python-types
.. date: 2020-12-09 10:45:43 UTC
.. tags: python, programming, epyc, epydemic
.. category: development
.. link: 
.. description: 
.. type: text
-->

I recently added type annotations to my
[``epyc``](/development/epyc/) and
[``epydemic``](/development/epydemic/) libraries. Making these work
while not sacrificing interoperability a wide range of Python versions
is quite delicate.

<!-- TEASER_END -->

Python is inherently a dynamically-typed language. The parameters to
methods and functions are checked as they are called, leading to
``TypeError`` and ``ValueError`` exceptions if they're used
incorrectly. Dignifying this by calling it ["duck
typing"](https://opensource.com/article/20/5/duck-typing-python)
doesn't alter the fundamental weakness -- from the perspective of a
programming language person -- that this opens-up in the heart of a
codebase. Unit testing isn't a proper substitute for static checks.

Parts of the Python community have recently embraced this view too,
leading to the
[``typing``](https://docs.python.org/3/library/typing.html) module
available from Python 3.5. This allows (but doesn't require)
programmers to add type annotations to code that can then be checked
by external typecheckers. There are a range, including
[``mypy``](http://mypy-lang.org/) and
[``pylance``](https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-pylance)
(which is built into Microsoft's VS Code).

As with any emerging feature in any language, the problem then becomes
one of backwards compatibility. I wanted to retain compatibility with
previous versions of Python prior to my current Python 3.8 -- ideally
all the way back to Python 3.5. That turned out to be a version too
far, but getting support for Python 3.6 and later proved possible.

Basic type annotations as they are intended
-------------------------------------------

We should of course start with the features we want. Type annotations
can be attached to method declarations and object attributes:

```python
class A:
	name : str = 'my name'
	
	def __init__(self, v : str =None):
		self.value = v
		
	def value(self) -> str:
		return self.v
```

Hopefully self-explanatory, and note that it doesn't need any special
imports. If we were to extend things a little, for example to use
lists or dicts, then we need some more machinery:

```python
from typing import List, Dict, Any

class B:
	names : List[str] = []
	values : List[Any] = []
	
	def addPair(self, n: str, v : Any) -> Any:
		names.append(n)
		values.append(v)
		return v
		
	def asDict(self) -> Dict[str, Any]:
		d = dict()
		for i in range(len(names)):
			d[names[i]] = values[i]
		return d
```

Note that ``List[]`` and ``Dict[]`` are *type constructors* taking
their element types in square brackets. A typechecker can now work out
before execution that, for example ``(b.asDict())[1]`` is
type-incorrect.

Self types
----------

How about a method that returns an instance of ``self`` (or similar)?
The obvious approach is:

```python
class C:
	def meAgain(self) -> C:
		return self
```

Surprisingly this will fail, as ``C`` isn't in scope in its own
definition. This is such a natural thing, though, that it's going to
be supported in future versions and, from Python 3.8, is available as
an import from the ``__future__`` module:

```python
from __future__ import annotations

class C:
	def meAgain(self) -> C:    # now typechecks
		return self
```

(Remember that ``__future__`` imports have to appear as the first code
line of a source file.)

Backporting type annotations
----------------------------

This all works fine in Python 3.8, so if that's all you care about you
can stop here. However, a lot of Python scripts want (or need) to
continue to work with earlier versions, preferably without the
disaster-waiting-to-happen of maintaining parallel codebases. So can
we use ``typing`` for earlier versions?

Type annotations first appeared in Python 3.5, but the ideas have been
evolving. If all you use are "normal" types such as builtins, class
names, ``List[]`` and so on, then everything works fine. But I
discovered that there are three exceptions.

**1. ``Final[]`` (and other) types**

Suppose you have an attribute that you want to be constant. The
``Final[]`` type constructor lets you denote this:

```python
from typing import List, Final

class D
	VERSION : Final[str] = '1.2.1'
```

``Final[]`` wasn't added to ``typing`` until Python 3.8, though, so
running this code on Python 3.7 (for example) will fail. However,
there's another module, ``typing_extensions``, that backports many new
features which can be imported if needed:

```python
import sys
if sys.version_info >= (3, 8):
	from typing import List, Final
else:
	from typing import List
	from typing_extensions import Final

class D
	VERSION : Final[str] = '1.2.1'
```

(The
[documentation](https://github.com/python/typing/blob/master/typing_extensions/README.rst)
for ``typing_extensions`` specifies the types it provides. They're all
very specialised apart from ``Final[]``.)  One the one hand this kind
of conditional importing is messy and inelegant; on the other hand, it
makes something possible that otherwise isn't.

Of course you need to have ``typing_extensions`` available to be
imported. This means that it has to be included in the
``requirements.txt`` and/or the ``setup.py`` files for the
module. This requires using version annotations in those files. For
``requirements.txt`` we can "guard" the import with the Python
versions for which it applied:

```python
typing_extensions; python_version <= '3.7'
```

For ``setup.py`` we similarly include it as an "extra" requirement,
guarded by the version:

```python
from setuptools import setup

with open('README.rst') as f:
    longDescription = f.read()

setup(name = 'my_module',
      version = ...,
      packages = ...,
      package_data = { 'my_module': [ 'py.typed' ] },
      zip_safe = False,
      install_requires = [ ... ],
      extra_requires = { ':python_version < 3.8': [ 'typing_extensions' ] },
)
```

(All the ``...``s are whatever you'd normally have in your setup
script.)

Notice the ``package_data`` attribute. This points to a file called
``py.typed`` which sits in the source tree and does ... absolutely
nothing, *except* indicate that the module has type annotations that
can then be used by *other* modules that import it.

**2. Self types**

Methods that return instances of their own class need a ``__future__``
import that's only available from Python 3.8 onwards: used with
earlier versions, it will be rejected. Fortunately there's a
workaround, which is that type annotations can be strings rather than
more general objects. So to annotate self types portably, replace the
``__fiture__`` import and use of the class name with a use of the
*string name* of the class name:

```python
# Too far into the future...
#from __future__ import annotations

class C:
	def meAgain(self) -> 'C':
		return self
```

I find this very messy -- but again, if you want portability, it's a
way round the problem that hopefully only appears in a few places
within the code.


**3. Variable annotations**

Type annotations were introduced in Python 3.5, but annotations for
*variables* only came in with Python 3.6. So code of this form will
fail with a syntax error when run on Python 3.5:

```python
class E:
	v : str = 'my value'
```

And as far as I can tell there's nothing to be done about this: the
syntax simply isn't available. If you desperately need Python 3.5 then
you need to not annotate variables; otherwise, your backport stops
with Python 3.6. In my case I chose the latter option, as I had a lot
of constant strings that needed to be annotated. Your constraints
might lead to a different choice.

Conclusion
----------

Feelings vary on the usefulness and Pythonic qualities of Python type
annotations. For me, they help eliminate logic errors and improve the
effectiveness of testing. The typecheckers do an impressive job of
type inference too, which reduces the need for excessive annotations:
I almost never use them for variables within methods, for example,
just for method signatures and attributes. The backporting isn't
perfect but at least it's possible, and it extends the usefulness of
codebases without overly complicating things. I find that quite
a Pythonic idea.





