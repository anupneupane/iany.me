---
title: Coffeescript
created_at: <2012-02-04 19:41:13>
updated_at: <2012-02-04 19:41:57>
tags: [javascript, web]
---

## Tricks ##

- `do`, pass local variables as paramter and run the function immediatly.

      for i in [1..10]
        do (i) ->
          doSomething -> alert i

- `class`

      class Foo
        # local variable
        localVar = 1
        
        # properties of object Foo
        @classVar: 1
        @classFun: ->

        constructor: ->
          # properties of the new Foo instance
          @foo = 10

        # properties of Foo.prototype
        instanceVar: 1
        instanceFun: ->
        
      Foo::xx # =>> Foo.prototype.xx
