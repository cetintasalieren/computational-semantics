;;
;;
;; Set utilities for COGS 543
;;
;; Umut Ozge -- tumuum@gmail.com
;;

; (defpackage :setutils 
;   (:use :common-lisp)
;   (:nicknames :su)
;   (:export :setp :random-pick :generate-tuples))
; 
; (in-package setutils)

(defconstant test '(1 2 3 4 5 6 7 8 9 10))

(defun setp (lst)
  "test for sethood"
  (or (null lst) 
      (and (not (member (car lst) (cdr lst))) 
           (setp (cdr lst)))))

(defun random-pick (set)
  "randomly pick an element from a set"
  (nth (random (length set)) set))

(defun pick-a-subset-r (set &optional (size (random (+ (length set) 1))))
  "recursive subset generator -- picks a random subset if size argument is missing"
  (if (zerop size)
    nil
    (let ((pick (random-pick set)))
      (cons pick (pick-a-subset-r (remove pick set) (- size 1))))))

(defun pick-a-subset-i (set &optional (size (random (+ (length set) 1))))
  "iterative subset generator -- picks a random subset if size argument is missing"
    (do ((accu nil (cons (random-pick set) accu)))
      ((eql (length accu) size) accu)
      (setf set (remove (car accu) set))))

(defun pick-a-subset (set &optional (size (random (+ (length set) 1))))
  "a funny function that randomly decides to use an iterative or a recursive function to pick a subset from a given set -- if size is missing, picks a random subset"
  (funcall (intern (concatenate 'string "PICK-A-SUBSET-" (random-pick '("I" "R")))) set size))


(defun cartesian-product (set-of-sets &optional (accu '(nil)))
  "computes the cartesian product of the sets in set-of-sets"
  (if (endp set-of-sets)
    accu
    (cartesian-product
      (cdr set-of-sets)
      (reduce 'union (mapcar
                      #'(lambda (x)
                          (mapcar
                            #'(lambda (y) (append x (list y)))
                            (car set-of-sets)))
                      accu)))))

(defun generate-tuples (baseset n)
  "generates a random set of n-tuples from baseset"
  (cond ((zerop n) nil)
        ((eql 1 n) (pick-a-subset baseset))
        (t
          (pick-a-subset
            (cartesian-product
              (make-list n :initial-element baseset))))))
