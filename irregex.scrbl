#lang scribble/manual

@author{Alex Shinn}

@title{IrRegular Expressions}

@defmodule[irregex]{
 This package contains Alex Shinn's "IrRegex". It's
 a regular expression matcher, including both a traditional
 character-based syntax and also an implementation of
 Olin Shivers' SRE parenthesized syntax.

 The code was written for standard Scheme, more specifically
 R[4567]RS code.

 I (John Clements) have performed a hasty port of this code to
 Racket. The required changes were extremely minimal, so
 it should be possible to stay up-to-date with upstream
 changes.

 What follows is the verbatim text of "irregex.doc",
 part of the original package.
}

@(require racket/runtime-path
          (only-in racket/file file->string))
@(define-runtime-path here ".")
@(verbatim (file->string (build-path here "irregex.doc")))