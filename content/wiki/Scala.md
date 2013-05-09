---
updated_at: <2013-05-08 15:23:18>
created_at: <2011-12-03 03:40:47>
title: Scala
tags: scala, java, programming
toc: true
---

## Class

### Constructor

Primary constructor

```scala
class Rational(n: Int, d: Int) {
  // primary constructor
  // code otherthan `def` are in the primary constructor
}
```

Override constructor

```scala
class Rational(n: Int, d: Int) {
  def this(i: Int) = this(i, 1)
}
```

Argument validation

```scala
class Rational(n: Int, d: Int) {
  require(d != 0)
}
```

### Operator

-   Binary operator is method defined using special characters. `a + b => a.+(b)`

-   Pre-unary operator: `!~+-`, `!a => a.unary_!()`

-   `a(0) => a.apply(0)`, `a(0) = 1 => a.update(0, 1)`

### Implicit Conversion

```scala
implicit def intToRational(x: Int) = new Rational(x)
```

## Function

-   Partially applied function: `println _`. `_` is optional if function is
    required in the context.

-   Each placeholder is a new unbound variable: `_ + _` is the same with `(x, y) => x + y`.

-   If there is only one variable in function literal parameter list, and type
    is omit, the parenthesis is optional: =nums.foreach(x => println(x))

-   Partially applied curried function: `curriedSum(1)_`

-   If a function tasks only one argument, the argument can be surrounded by braces.
    
    ```scala
    println { "Hello, World" }
    ```

-   Loan pattern with curried function parameter.
    
    ```scala
    def withPrinterWriter(file: File)(op: PrinterWriter => Unit) {
      val writer = new PrintWriter(file)
      try {
        op(writer)
      } finally {
        writer.close()
      }
    }
    
    withPrinterWriter(file) {
      writer => wirter.println(new java.util.Date)
    }
    ```

-   By-name parameter: removes `()` from the parameter list
    
    ```scala
    def byNameAssert(predicate: => Boolean) =
      if (assertionsEnabled && !predicate)
        throw new AssertionError
    
    byNameAssert(4 > 3)
    ```

## Inheritance

-   Field can override no parameter method.

-   Prefix primary constructor parameter with `val` or `var` will declare them
    as fields.

## Traits

-   `abstract override` defines a method that the trait can only be mixed into
    a class having a concrete implementation.

-   Mixed in methods are called from right to left.

## Packages & Import

-   Packages can be nested.

-   Package name can be import.

-   Object fields can be import.

-   Import anywhere

-   Import rename: `import java.{sql => S}`

-   Import exclusion: `import java.util.{Map => _, _}`

-   package object: `package object {}` in package.scala

-   Forward both type and object:
    
    ```scala
    object Predef {
      type Map[A, +B] = collection.immutable.Map[A, B]
      val Map = collection.immutable.Map
    }
    ```

## Case Classes and Pattern Matching

### Case Classes

```scala
abstract class Expr
case class Var(name: String) extends Expr
case class Number(num: Double) extends Expr
case class UnOp(operator: String, arg: Expr) extends Expr
case class BinOp(operator: String, left: Expr, right: Expr) extends Expr
```

-   Case classes define factory method: `Var("foo")`

-   Primary constructor parameters implicitly get a `val` prefix, so they are
    also the fields.

-   Compiler also adds `toString`, `hashCode` and `equals`.

-   Copy method is defined to duplicate the object with optional changed using
    named parameter: `op.copy(operator = "-")`.

-   They support pattern matching

### Patterns

-   Wildcard pattern: `_` matches anything, and value is not captured.

-   Constant pattern: `1` <code>"foo"</code> matches using `==`

-   Variable pattern: matches anything, and bind to the matching value.

-   Capitalized variable `Pi`, quoted `` `var` ``, `this.var`, `obj.var` are considered
    as constant pattern.

-   Constructor pattern: cass classes constructor by replacing each parameter
    with pattern.

-   List pattern: `List(0, _, _)`, `_*` to match variables of any length.

-   Tuple pattern `(a, b, _)`

-   Type pattern: `m: Map[_, _]` does type tests and casts. Because generic
    type erasure, `m: Map[Int, Int]` also matches any `Map`. However `Array[Int]` works.

-   Variable binding: `e @ List(0, _*)` binds the expression to `e` after `@`

-   Pattern guard: pattern are matched linearly, to ensure two variable
    pattern are the same: <code>case List(x, y) if x == y</code>

-   `sealed abstract class Expr` only allow sub-classes in the same file.

-   `(e: @unchecked) match {}` to inhibit warnings.

Pattern anywhere:

-   `val (a, b) = (1, 2)`

-   Pattern matching parameters when used as function literal.
    
    ```scala
    react{
      case(name: String, actor: Actor) => {
        actor !getip(name)
        act()
      }
    
      case msg => {
        println("Unhandledmessage: " + msg)
        act()
      }
    }
    ```

-   Sequence of `case` gives a partial function. Declare the function as
        `PartialFunction[A, B]`, which has a method `isDefinedAt`.

-   `for ((a, b) -> args)`

### Extractors

Extractor implements `unapply`

```scala
object Email = {
  def unapply(str: String): Option[(String, String)] = {
    ...
  }
}

x match {
  case Email(user, domain) =>
}

// Scala calls Email.unapply(x)
```

## List

List is **covariant**. If `S` is subclass of `T`, `List[S]` is also subclass of
`List[T]`. Empty list type is `List[Nothing]`.

## Type Parameterization

Type constructor:

```scala
trait Queue[T] {
}
```

`Queue` is not a type but a trait.

Covariant type parameter.

```scala
trait Queue[+T]
```

Thus `Queue[String]` is subclass of `Queue[AnyRef]`.

`Array` is nonvariant, but can be cast using `asInstanceOf[Array[Object]]`.

## Actors and Concurrency

Extend `Actor` and implement `act()`

```scala
import scala.actors._

object SillyActor extends Actor {
  def act() {
    ...
  }
}

SillyActor.start()
```

Create using method `scala.actors.Actor.actor`

```scala
val actor = scala.actors.Actor.actor {
  ...
}
```

## XML Literal

Scala can contain XML without quoting or escaping

```scala
val book = <book><name>Programming in Scala</name></book>
```

Interpolate Scala code in XML using ={}=. The attributes interpolation should
not be quoted.

```scala
val author = "Martin"
val name = "Programming in Scala"
val book = <book author={author}><name>{name}</name></book>
```

XML can be nested

```scala
val books = List("Programming in Scala", "Play for Scala")
val booksXML = <books>
  {for (book < books) yield <book>{book}</book>}
</books>
```
