hytest
======

Simplify unit testing with Hy

## Getting Started ##

A basic example, adapted from the unittest Documentation:

```lisp
(import [random] 
	[unittest])

(require hytest)

(defsuite TestSequenceFunctions
  (deftest test-choice
    (.assertTrue 
     self
     (in (random.choice (range 10)) (range 10))
     )
    )

  (deftest test-sample-checks-bounds
    (.assertRaises self ValueError random.sample (range 10) 20)
    )

  (deftest test-sample-in-sequence
    (foreach [member (random.sample (range 10) 5)]
      (.assertTrue
       self
       (in member (range 10))
       )
      )
    )
  )

(if (= --name-- "__main__")
  (hytest-main)
  )
```

`defsuite` is actually a macro for defining a subclass of TestCase,
and `deftest` a test function, so within each test, you can refer to
`self` to invoke the assertions which are members of
`unittest.TestCase`.

## Setup and Teardown ##

You can technically define `setUp` and `tearDown` methods, using
`defsetup` and `defteardown`, like so:

```lisp
(defsuite TestSomething
  (defsetup
	(print "setting up")
	)

  (defteardown
    (print "tearing down")
	)
  )
```

These functions also have access to `self`, but aren't very useful
when testing side-effect free code. A better pattern might be a way to
define input data passed to all the test functions, but I haven't
quite figured out exactly how I'd want to do that.

## Main Function ##

As you can see in the original example, there is a macro named
`hytest-main` which you can use to invoke `unittest.main` on the
current module. Currently this macro takes no arguments, so you cannot
provide additional arguments to `unittest.main`.

The macro is necessary because, as of hy 0.9.10, the mechanism by
which `unittest` discovers test cases in the current module
(`__import__('__main__')`) is broken (the returned module has no
members.

## Nose Plugin ##

A nosetest plugin is also provided, to make it easier to run large
test suites across multiple files. 

You can enable the plugin by passing the `--with-hynose` option to
nose, or setting `NOSE_WITH_HYNOSE` to true. It will run all files
named `test_*.hy`.

### Future Work ###

1) The standard options for defining test filename matches should be
honored.
