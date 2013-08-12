(import 
 [hy.models.list [HyList]]
 [hy.models.symbol [HySymbol]]
 )

(defun maptests [tests]
  (HyList
   (map
    (lambda [test]
      (quasiquote
       [(unquote (get test "name"))
	(fn [self]
	  (unquote (get test "expr"))
	  )]
       )
      )
    tests
    )
   )
  )

(defun nametests [tests]
  (HyList
   (map
    (lambda [test]
      (quasiquote
       (
	(unquote (get test "name"))
	)
       )
      )
    tests
    )
   )
  )

(defun buildmodule [tests loader]
  (HyList
   (+
    tests
    [loader]
    )
   )
  )

(defmacro defsuite [name &rest test-exprs]
  (let [[tests (map (lambda [test] (eval test)) test-exprs)]]
    (quasiquote
     (defclass (unquote name) [unittest.TestCase]
       (unquote (maptests tests))
       )
     )
    )
  )

(defmacro defsetup [expr]
  (quasiquote
   {"name" (quote setUp)
	   "expr" (quote (unquote expr))
	   }
   )
  )

(defmacro defteardown [expr]
  (quasiquote
   {"name" (quote tearDown)
	   "expr" (quote (unquote expr))
	   }
   )
  )

(defmacro deftest [name expr]
  (quasiquote
   {
    "name" (quote (unquote name))
	   "expr" (quote (unquote expr))
	   })
  )

(defmacro hytest-main []
  (quote
   (do
    (defclass LocalModule [object]
      [[--init--
	(fn [self dir locals globals]
	  (setattr self "_dir" dir)
	  (setattr self "_locals" locals)
	  (setattr self "_globals" globals)
	  )]

       [--dir--
	(fn [self]
	  (getattr self "_dir")
	  )]

       [--getattr--
	(fn [self attr]
	  (.get (getattr self "_locals") attr 
		(.get (getattr self "_globals") attr None)
		)
	  )]
       ])
    (unittest.main (LocalModule (dir) (locals) (globals)))
    )
   )
  )
