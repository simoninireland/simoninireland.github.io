<html><body><p>Monads are one of the hottest topics in functional programming, and arguably simplify the construction of a whole class of systems. Which makes it surprising that they're so opaque and hard to understand to people who's main experience is in imperative or object-oriented languages.

<!--more-->

There are a lot of explanations of, and tutorials on, monads, but most of them seem to take one of two perspectives: either start with a concrete example, usually in I/O handling, and work back, or start from the abstract mathematical formulation and work forwards. This sounds reasonable, but apparently neither works well in practice -- at least, judging from the comments one receives from  intelligent and able programmers who happen not to have an extensive functional programming or abstract mathematical background. Such a core concept shouldn't be hard to explain, though, so I thought I'd try a different tack: monads from the perspective of language design.

In Pascal, C or Java, statements are separated (or terminated) by semicolons. This is usually regarded as a piece of syntax, but let's look at it slightly differently. Think of the semicolon as an operator that takes two program fragments and combines them together to form a bigger fragment. For example:

<code>
int x = 4;
int y = x * 3;
printf("%d", y);
</code>

We have three program fragments. The semicolon operator at the end of the first line takes the fragment on its left-hand side and combines it with the fragment on its right-hand side. Essentially the semicolon defines how the RHS is affected by the code on the LHS: in this case the RHS code is evaluated in an environment that includes a binding of variable x, effectively resolving what is otherwise a free variable. Similarly, the semicolon at the end of the second line causes the third line to be evaluated in an environment that include y. The meaning of the semicolon is hard-wired into the language (C, in this case) and defines how code fragments are sequenced and their effects propagated.

Now from this perspective, <strong>a monad is a programmable semicolon</strong>. A monad allows the application programmer, rather than the language designer, to determine how a sequence of code is put together, and how one fragment affects those that come later.

Let's revert to Haskell. In a slightly simplified form, a monad is a type class with the  following signature:

<code>
class Monad m where
   return :: a -&gt; m a
   (&gt;&gt;=)  :: m a -&gt; (a -&gt; m b) -&gt; m b
</code>

So a monad is a constructed type wrapping-up some underlying element  type that defines two functions, <tt>return</tt> and <tt>(&gt;&gt;=)</tt>. The first  function injects an element of the element type into the monadic type.  The second takes an element of the monadic type and a function that maps  an element that monad's element type to some other monadic type, and  returns an element of this second monadic type.

The simplest example of a monad is Haskell's <tt>Maybe</tt> type, which represents either a value of some underlying element type  or the absence of a value:

<code>
data Maybe a = Just a
            | Nothing
</code>

<tt>Maybe</tt> is an instance of <tt>Monad</tt>, simply by virtue of defining the two  functions that the type class needs:

<code>
instance Monad Maybe where
   return a = Just a
   Just a  &gt;&gt;= f = f a
   Nothing &gt;&gt;= _ = Nothing
</code>

<tt>return</tt> injects an element of <tt>a</tt> into an element of <tt>Maybe a</tt>.  <tt>(&gt;&gt;=)</tt> takes an element of <tt>Maybe a</tt> and a function from <tt>a</tt> to <tt>Maybe  b</tt>. If the element of <tt>Maybe a</tt> it's passed is of the form <tt>Just a</tt>, it  applies the function to the element value <tt>a</tt>. If, however, the element is <tt>Nothing</tt>, it returns <tt>Nothing</tt> without evaluating the function.

It's hard to see what this type has to do with sequencing, but bear with me. Haskell provides a <tt>do</tt> construction which gives rise to code like the following:

<code>
do v &lt;- if b == 0 then Nothing
                  else Just (a / b)
   return 26 / v
</code>

Intuitively this looks like a sequence of code fragments, so we might infer that the conditional executes first and binds a value to <tt>v</tt>, and then the next line computes with that value -- which is in fact what happens, but with a twist. The <em>way</em> in which the fragments relate is <em>not</em> pre-defined by Haskell. Instead, the relationship between the fragments is determined by <em>the values of which monad the fragments manipulate</em> (usually expressed as <em>which monad the code executes in</em>). The <tt>do</tt> block is just syntactic sugar for a stylised use of the two monad functions. The example above expands to:

<code>
(if b == 0 then Nothing else Just (a / b)) &gt;&gt;= (\v -&gt; return (26 / v))
</code>

So the <tt>do</tt> block is syntax that expands into user-defined code, depending on the monad that the expressions within it use. In this case, we execute the first expression and then compose it with the function on the right-hand side of the <tt>(&gt;&gt;=)</tt> operator. The definition says that, if the left-hand side value is <tt>Just a</tt>, the result is that we call the RHS passing the element value; if the LHS is <tt>Nothing</tt>, we return <tt>Nothing</tt> immediately. The result is that, if <em>any</em> code fragment in the computation returns <tt>Nothing</tt>, then the <em>entire computation</em> returns <tt>Nothing</tt>, since all subsequent compositions will immediately short-circuit: the <tt>Maybe</tt> type acts like a simple exception that escapes from the computation immediately <tt>Nothing</tt> is encountered. So the monad structure introduces what's normally regarded as a control construct, <em>entirely within the language</em>. It's fairly easy to see that we could provide "real" exceptions by hanging an error code off the failure value. It's also fairly easy to see that the monad sequences the code fragments and aborts when one of the "fails". In C we can think of the same function being provided by the semicolon "operator", but with the crucial difference that it is the <em>language</em>, and not the <em>programmer</em>,<em> </em>that decides what happens, one and for all. Monads reify the control of sequencing into the language.

To see how this can be made more general, let's think about another monad: the list type constructor. Again, to make lists into monads we need to define <tt>return</tt> and <tt>(&gt;&gt;=)</tt> with appropriate types. The obvious injection is to turn a singleton into a list:

<code>
instance Monad [] where
   return a = [a]
</code>

The definition of <tt>(&gt;&gt;=)</tt> is slightly more interesting: which function of type <tt>[a] -&gt; (a -&gt; [b]) -&gt; [b]</tt> is appropriate? One could choose to select an element of the <tt>[a]</tt> list at random and apply the function to it, giving a list <tt>[b]</tt> -- a sort of non-deterministic application of a function to a set of possible arguments. (Actually this might be interesting in the context of <a href="/2010/03/five-big-questions/">programming with uncertainty</a>, but that's another topic.) Another definition -- and the one that Haskell actually chooses -- is to apply the function to all the elements of <tt>[a]</tt>, taking each a to a list <tt>[b]</tt>, and then concatenating the resulting lists together to form one big list:

<code>
   l &gt;&gt;= f = concat (map f l)
</code>

What happens to the code fragments in a do block now? The monad threads them together using the two basic functions. So if we have code such as:

<code>
do x &lt;- [1..10]
   y &lt;- [20..30]
   return (x, y)
</code>

What happens? The first and second fragments clearly define lists, but what about the third, which seems to define a pair? To see what happens, we need to consider <em>all</em> the fragments together. Remember, each fragment is combined with the next by applying <tt>concat (map f l)</tt>. If we expand this out, we get:

<code>
concat (map (\x -&gt; concat (map (\y -&gt; return (x, y)) [20..30])) [1..10])
</code>

So to summarise, Haskell provides a do block syntax that expands to a nested sequence of monadic function calls. The actual functions used depend on the monadic type in the do block, so the programmer can define how the code fragments relate to one another. Common monads include some simple types, but also I/O operations and state bindings, allowing Haskell to perform operations that are typically regarded as imperative without losing its laziness. The Haskell tutorial <a href="http://www.haskell.org/tutorial/io.html">explains the I/O syntax</a>.

What can we say about monads from the perspective of language design? Essentially they reify sequencing, in a functional style. They only work as seamlessly as they do because of Haskell's flexible type system (allowing the definition of new monads), and also because of the <tt>do</tt> syntax: without the syntactic sugar, most monadic code is incomprehensible. The real power is that they allow some very complex functionality to be abstracted into functions and re-used. Consider the <tt>Maybe</tt> code we used earlier: without the "escape" provided by the <tt>Maybe</tt> monad, we'd have to guard each statement with a conditional to make sure there wasn't a <tt>Nothing</tt> returned at any point. This quickly gets tiresome and error-prone: the monad encapsulates and enforces the desired behaviour. When you realise that one can also compose monads using monad transformers, layering monadic behaviours on top of each other (albeit with some contortions to keep the type system happy), it becomes clear that this is a very powerful capability.

I think one can also easily identify a few drawbacks, though. One that immediately springs to mind is that monads reify <em>one</em> construction, of the many that one might choose. A more general meta-language, like the use of meta-objects protocols or aspects, or structured language and compiler extensions, would allow even more flexibility. A second -- perhaps with wider impact -- is that one has to be intimately familiar with the monad being used before one has the <em>slightest idea</em> what a piece of code will do. The list example above is not obviously a list comprehension, until one recognises the "idiom" of the list monad. Thirdly, the choice of monadic function definitions isn't often canonical, so there can be a certain arbitrariness to the behaviour. It'd be interesting to consider generalisations of monads and language constructs to address these issues, but for the meantime one can use them to abstract a whole range of functionality in an interesting way. Good luck!</p></body></html>