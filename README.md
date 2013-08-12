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
