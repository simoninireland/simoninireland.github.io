cl-bitfields: Packed bitfield operations for Common Lisp
========================================================

.. raw:: html

   <a href="https://www.gnu.org/licenses/gpl-3.0.en.html">
   <img src="https://www.gnu.org/graphics/gplv3-88x31.png"/>
   </a>

Machine code and assembly language typically consist of bytes and
words with structure. A machine code opcode will have several fields
defining the instruction, how it gets its operands, and so forth; in
languages like Lisp, pointers are often similarly structured to make
dispatching and garbage collection easier. Languages like C recognise
this and have language structures -- "`bitfields
<https://en.wikipedia.org/wiki/Bit_field>`_" -- that let a program in
a high-level language access structures defined at the sub-byte level.

Common Lisp doesn't have "packed" structures conveniently like this,
so ``cl-bitfields`` provides them. It defines a collection of macros
for specifying bitfields and unpacking them into variables that can
then be worked on by normal Lisp code before being optionally packed
back. It's more flexible than C bitfields in that a single value may
be populated from non-contiguous bits, and may have variable width
determined at run-time.


In use
------

For example, a function accessing a machine code instruction might
unpack a packed value something like this:

.. code-block:: lisp

   (with-bitfields (1 1 0 x x y y x) opcode
      (princ x))

where ``x`` gets three (non-contiguous) bits and ``y`` gets two
(contiguous) bits, in the expected order, from ``opcode``: the
least-significant bit of the bitfield is on the right. ``x`` and
``y`` are in scope in the body of the ``with-bitfields`` macro. The
syntax is similar to that of the normal ``destructuring-bind`` macro,
but matching variables to bits within a single packed value.

You can also specify the bit widths directly:

.. code-block:: lisp

   (with-bitfields (1 1 0 (x 3) (y 2)) opcode
      (princ x))

where ``x`` takes three contiguous bits and ``y`` two. The widths can
be variable, determined at runtime, or even computed:

.. code-block:: lisp

  (let ((v 3))
     (with-bitfields (1 1 0 (x v) y y) opcode
       (princ x)))

The restructuring operation takes variables and packs them into
bitfield values:

.. code-block:: lisp

   (let ((x #2r10110)
	 (y #2r10))
      (make-bitfields (x x y y x x x 1)))

or a value can be stored directly to a place:

.. code-block:: lisp

   (let ((x #2r110)
	 (y #2r11))
      (setf-bitfields v (x x x y y)))

and if desired unpacking and packing can be combined to decompose a
bitfield, manipulate it, and write it back:

.. code-block:: lisp

   (let ((v #2r1011101))
      (with-bitfields-f (x x x 1 1 y y) v
	 (setf x #2r000)
	 (setf y #2r00))

      ;; v now has the values implied by the setf calls above
      v)

This library arose as part of a larger project that's currently on
hold, as well as being an exercise for me to learn how to design more
complicated macros. The idea is to make the code look as far as
possible like the standard presentations of opcodes, pointers, and
other such packed structures, while making them accessible to Lisp in
a natural way. The macros are complicated enough to optimise the code
generated for the simple cases where bitfield widths are constants
known at compile-time, and only generate run-time calculations when
needed.


Resources
---------

- `Github repo <https://github.com/simoninireland/cl-bitfields>`_
