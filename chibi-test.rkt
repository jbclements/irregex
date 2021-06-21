#lang racket


;; This is a simple bridge to provide what appear to be
;; chibi-test-like bindings that connect to rackunit
;; bindings

;; docs for chibi test at
;; http://synthcode.com/scheme/chibi/lib/chibi/test.html

;; porting notes: it appears to me that chibi scheme's "test-assert"
;; form checks that the given value is "not-false" (rather than checking
;; that it's #t. I can't be sure of this without building and trying
;; it out.


(provide test-begin test-end
         test
         test-assert
         test-error
         test-group
         ru:check-true ru:check-exn
         ru:check-equal?
         ru:run-tests
         ru:test-suite)

(require (prefix-in ru: rackunit)
         (prefix-in ru: (only-in rackunit/text-ui run-tests)))

(define (test-begin) 'ignored)
(define (test-end) 'ignored)
;; preserve syntax locations...
(define-syntax (test-assert stx)
  (syntax-case stx ()
    [(_ arg) (datum->syntax #'here
                            (list #'ru:check-not-false
                                  #'arg)
                            #'stx)]
    [(_ name arg) (datum->syntax #'here
                                 (list #'ru:test-not-false
                                       #'name
                                       #'arg)
                                 #'stx)]))
(define-syntax (test-error stx)
  (syntax-case stx ()
    [(_ arg)
     (datum->syntax #'here (list #'ru:check-exn
                                 #'exn:fail?
                                 (list 'lambda '() #'arg))
                    #'stx)]
    [(_ name arg)
     (datum->syntax #'here (list #'ru:test-exn
                                 #'name
                                 #'exn:fail?
                                 (list 'lambda '() #'arg))
                    #'stx)]))


;; looks like expected is first for this test form?
(define-syntax (test stx)
  (syntax-case stx ()
    [(_ expected actual)
     (datum->syntax #'here (list #'ru:check-equal?
                                 #'actual
                                 #'expected)
                    #'stx)]
    [(_ name expected actual)
     (datum->syntax #'here (list #'ru:test-equal?
                                 #'name
                                 #'actual
                                 #'expected)
                    #'stx)]))

;; looks like test-group is reasonably similar to ru:test-case
;; (but note that a nested test case will override this name)
(define-syntax (test-group stx)
  (syntax-case stx ()
    [(_ name bodies ...)
     (datum->syntax #'here (cons #'ru:test-case
                                 (cons #'name
                                       #'(bodies ...)))
                    #'stx)]))