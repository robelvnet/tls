;; Chapter 8

;; atom?
;; checks if element is atom
(defun atom? (x)
  (not (listp x))
)

;; equan?
;; check if two atom s are equal
(defun equan? (x y)
  (cond
    ((and (numberp x) (numberp y)) (= x y))
    ((or (numberp x) (numberp y)) nil)
    (t
      (eq x y))
  )
)

;; eqlist?
;; checks if two lists are equal
(defun eqlist? (l1 l2)
  (cond
    ((and (null l1) (null l2)) t)
    ((or (null l1) (null l2)) nil)
    ((and (atom? (car l1)) (null l2))
      nil)
    ((and (atom? (car l1)) (atom? (car l2)))
      (and (equan? (car l1) (car l2))
           (eqlist? (cdr l1) (cdr l2))
      )
    )
    ((atom? (car l1)) nil)
    ((null l2) nil)
    ((atom? (car l2)) nil)
    (t
      (and (eqlist? (car l1) (car l2))
           (eqlist? (cdr l1) (cdr l2))
      )
    )
  )
)

;; equal?
;; checks if two S-Expressions are equal
(defun equal? (s1 s2)
  (cond
    ((and (atom? s1) (atom? s2))
      (eq s1 s2))
    ((or (atom? s1) (atom? s2)) nil)
    (t
      (eqlist? s1 s2))
  )
)

;; rember-f
;; removes member by a passed function
(defun rember-f (test?)
  (function
    (lambda (a l)
      (cond
        ((null l) '())
        ((funcall test? a (car l)) (cdr l))
        (t
          (cons (car l) (funcall (rember-f test?) a (cdr l))))
      )
    )
  )
)

;; eq?-c
;; curry eq?
(defun eq?-c (a)
  (function
    (lambda (x)
      (eq a x)
    )
  )
)

;; eq?-salad
(setq eq?-salad (eq?-c 'salad))

;; insertL-f
;; inserts elem to the left by a passed function
(defun insertL-f (test?)
  (function
    (lambda (new old l)
      (cond
        ((null l) '())
        ((funcall test? old (car l))
          (cons new (cons old (cdr l))))
        (t
          (cons (car l) (funcall (insertL-f test?) new old (cdr l))))
      )
    )
  )
)

;; insertR-f
;; inserts elem to the right by a passed function
(defun insertR-f (test?)
  (function
    (lambda (new old l)
      (cond
        ((null l) '())
        ((funcall test? old (car l))
          (cons old (cons new (cdr l))))
        (t
          (cons (car l) (funcall (insertR-f test?) new old (cdr l))))
      )
    )
  )
)

;; seqL
(defun seqL (new old l)
  (cons new (cons old l))
)

;; seqR
(defun seqR (new old l)
  (cons old (cons new l))
)

;; insert-g
(defun insert-g (seq)
  (function
    (lambda (new old l)
      (cond
        ((null l) '())
        ((eq old (car l))
          (funcall seq new old (cdr l)))
        (t
          (cons (car l) (funcall (insert-g seq) new old (cdr l))))
      )
    )
  )
)

;; seqS
(defun seqS (new old l)
  (cons new l)
)

;; subst
(setq subst (insert-g 'seqS))

;; seqrem
(defun seqrem (new old l)
  l
)

;; yyy
(defun yyy (a l)
  (funcall (insert-g 'seqrem) nil a l)
)

;; atom-to-function
(defun atom-to-function (x)
  (cond
    ((eq x '+) (function +))
    ((eq x '*) (function *))
  )
)

;; value
(defun value (nexp)
  (cond
    ((atom? nexp) nexp)
    (t
      (funcall (atom-to-function (car (cdr nexp)))
        (value (car nexp))
        (value (car (cdr (cdr nexp))))
      )
    )
  )
)

;; multirember-f
(defun multirember-f (test?)
  (function
    (lambda (a lat)
      (cond
        ((null lat) '())
        ((funcall test? a (car lat))
          (funcall (multirember-f test?) a (cdr lat)))
        (t
          (cons (car lat) (funcall (multirember-f test?) a (cdr lat))))
      )
    )
  )
)

;; multirember-eq
(setq multirember-eq (multirember-f 'eq))

;; eq-tuna
(setq eq-tuna (eq?-c 'tuna))

;; multiremberT
(defun multiremberT (test? lat)
  (cond
    ((null lat) '())
    ((funcall test? (car lat))
      (multiremberT test? (cdr lat)))
    (t
      (cons (car lat) (multiremberT test? (cdr lat))))
  )
)

;; a-friend
(defun a-friend (x y)
  (null y)
)

;; new-friend
(defun new-friend (newlat seen)
  (a-friend newlat (cons 'tuna seen))
)

;; last-friend
(defun last-friend (x y)
  (length x)
)

;; multiremberCo
(defun multiremberCo (a lat col)
  (cond
    ((null lat)
      (funcall col '() '()))
    ((eq a (car lat))
      (multiremberCo a (cdr lat) (lambda (newlat seen) (funcall col newlat (cons (car lat) seen)))))
    (t
      (multiremberCo a (cdr lat) (lambda (newlat seen) (funcall col (cons (car lat) newlat) seen))))
  )
)

;; multiinsertLR
(defun multiinsertLR (new oldL oldR lat)
  (cond
    ((null lat) '())
    ((eq oldL (car lat))
      (cons new (cons oldL (multiinsertLR new oldL oldR (cdr lat)))))
    ((eq oldR (car lat))
      (cons oldR (cons new (multiinsertLR new oldL oldR (cdr lat)))))
    (t
      (cons (car lat) (multiinsertLR new oldL oldR (cdr lat))))
  )
)
