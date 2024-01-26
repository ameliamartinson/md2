#set page(
  paper: "a4",
  header: [
    #set text(10pt)
    RFC 1319 #h(8.15em) MD2 Message-Digest Algorithm     #h(8.15em)       April 1992
    ]
  )
#set text(
  size: 12pt,
  font: "Liberation Mono"
  )

#grid(
  columns: (1fr, 1fr),
  align(left)[
    Network Working Group \
    Request for Comments: 1319 \
    Updates: RFC 1115\
    ],
  align(right)[
    B. Kaliski \
    RSA Laboratories \
    April 1992
    ]
  )


  #align(center, text(17pt)[*The MD2 Message-Digest Algorithm*])

  == Status of this Memo

#show par: set block(above: 1.4em, below: 1.8em)
#set par(
  justify: false,
)
This memo provides information for the Internet community. It does not specify an Internet standard. Distribution of this memo is unlimited.

== Acknowledgements
 The description of MD2 is based on material prepared by John Linn and Ron Rivest.  Their permission to incorporate that material is greatly appreciated.

 == Table of Contents
 + Executive Summary
 + Terminology and Notation
 + MD2 Algorithm description
 + Summary
 #set enum(numbering: n => "")
 + References
 + APPENDIX A - Reference Implementation
 + Security Considerations
 + Author's Address

 #set heading(numbering: "1.")
 = Executive Summary

This document describes the MD2 message-digest algorithm. The
   algorithm takes as input a message of arbitrary length and produces
   as output a 128-bit "fingerprint" or "message digest" of the input.
   It is conjectured that it is computationally infeasible to produce
   two messages having the same message digest, or to produce any
   message having a given pre-specified target message digest. The MD2
   algorithm is intended for digital signature applications, where a
   large file must be "compressed" in a secure manner before being
   signed with a private (secret) key under a public-key cryptosystem
   such as RSA.

    License to use MD2 is granted for non-commerical Internet Privacy-
   Enhanced Mail [1-3].

 This document is an update to the August 1989 RFC 1115 [3], which
   also gives a reference implementation of MD2. The main differences are that a textual dscription of MD2 is included, and that the reference implementation of MD2 is more portable.

    For OSI-based applications, MD2's object identifier is

   md2 OBJECT IDENTIFIER ::=
   iso(1) member-body(2) US(840) rsadsi(113549) digestAlgorithm(2) 2}

   In the X.509 type AlgorithmIdentifier [4], the parameters for MD2
   should have type NULL.

   = Terminology and Notation

   In this document, a "byte" is an eight-bit quantity.

   Let x_i denote "x sub i". If the subscript is an expression, we
   surround it in braces, as in x\_{i+1}. Similarly, we use ^ for
   superscripts (exponentiation), so that x^i denotes x to the i-th
   power.

   Let X xor Y denote the bit-wise XOR of X and Y.

   = MD2 Algorithm Description
   
We begin by supposing that we have a b-byte message as input, and
   that we wish to find its message digest. Here b is an arbitrary
   non-negative integer; b may be zero, and it may be arbitrarily large.
   We imagine the bytes of the message written down as follows:

#align(center)[m\_0 m\_1 $dots$ m\_{b-1}]

   The following five steps are performed to compute the message digest
   of the message.

== Step 1. Append Padding Bytes

The message is "padded" (extended) so that its length (in bytes) is
   congruent to 0, modulo 16. That is, the message is extended so that
   it is a multiple of 16 bytes long. Padding is always performed, even
   if the length of the message is already congruent to 0, modulo 16.

    Padding is performed as follows: "i" bytes of value "i" are appended
   to the message so that the length in bytes of the padded message
   becomes congruent to 0, modulo 16. At least one byte and at most 
   16 bytes are appended.

   At this point the resulting message (after padding with bytes) has a
   length that is an exact multiple of 16 bytes. Let M[0 ... N-1] denote
the bytes of the resulting message, where N is a multiple of 16.

== Step 2. Append Checksum

A 16-byte checksum of the message is appended to the result of the
   previous step.

   This step uses a 256-byte "random" permutation constructed from the
   digits of pi. Let S[i] denote the i-th element of this table. The
   table is given in the appendix.

   Do the following:

#show raw: it => {
  set text(12pt)
  it
  }
  ```
  /* Clear checksum. */
  For i = 0 to 15 do:
     Set C[i] to 0.
  end /* of loop on i */
  
  Set L to 0.
  
  /* Process each 16-byte block. */
  For i = 0 to N/16-1 do
  
     /* Checksum block i. */
     For j = 0 to 15 do
        Set c to M[i*16+j].
        Set C[j] to C[j] xor S[c xor L].
        Set L to C[j].
     end /* of loop on j */
  end /* of loop on i *

  ```

  The 16-byte checksum C[0 ... 15] is appended to the message.
Let M[0..N'-1] be the message with padding and checksum appended,
   where N' = N + 16.

== Step 3. Initialize MD Buffer

A 48-byte buffer X is used to compute the message digest. The buffer
   is initialized to zero.

== Step 4. Process Message in 16-Byte Blocks

Do the following:

#show raw: it => {
  set text(12pt)
  it
  }
```
      /* Process each 16-byte block. */
      For i = 0 to N'/16-1 do

         /* Copy block i into X. */
         For j = 0 to 15 do
            Set X[16+j] to M[i*16+j].
            Set X[32+j] to (X[16+j] xor X[j]).
          end /* of loop on j */

         Set t to 0.

         /* Do 18 rounds. */
         For j = 0 to 17 do

            /* Round j. */
            For k = 0 to 47 do
               Set t and X[k] to (X[k] xor S[t]).
            end /* of loop on k */

            Set t to (t+j) modulo 256.
         end /* of loop on j */

      end /* of loop on i */
```

== Step 5. Output 

   The message digest produced as output is X[0 ... 15]. That is, we
   begin with X[0], and end with X[15].

   This completes the description of MD2. A reference implementation in
   C is given in the appendix.

= Summary
   The MD2 message-digest algorithm is simple to implement, and provides
   a "fingerprint" or message digest of a message of arbitrary length.
   It is conjectured that the difficulty of coming up with two messages
   having the same message digest is on the order of 2^64 operations,
   and that the difficulty of coming up with any message having a given
   message digest is on the order of 2^128 operations. The MD2 algorithm
   has been carefully scrutinized for weaknesses. It is, however, a
   relatively new algorithm and further security analysis is of course
     justified, as is the case with any new proposal of this sort.

#bibliography("bib.yml",full: true, title: "References")

#set heading(
  numbering: none
  )

= Appendix A - Reference Implementation

This appendix contains the following files taken from RSAREF: A
   Cryptographic Toolkit for Privacy-Enhanced Mail:

   #h(2em) global.h -- global header file

    #h(2em) md2.h -- header file for MD2

    #h(2em) md2c.c -- source code for MD2

For more information on RSAREF, send email to #link("<rsaref@rsa.com>")

The appendix also includes the following file:

#h(2em)  mddriver.c -- test driver for MD2, MD4 and MD5

The driver compiles for MD5 by default but can compile for MD2 or MD4 if
the symbol MD is defined on the C compiler command line as 2 or 4.

#counter(heading).update(0)
#set heading(numbering: n => [A.#n] )

= global.h 

#let globalh = read("ref-impl/global.h")
#show raw.where(block: false): box.with(
  fill: luma(240),
  inset: (x: 3pt, y: 0pt),
  outset: (y: 3pt),
  radius: 2pt,
)
#raw(globalh, lang: "c")

= md2.h

#let md2h = read("ref-impl/md2.h")
#raw(md2h, lang: "c")

= md2c.c
#let md2c = read("ref-impl/md2c.c")
#raw(md2c, lang: "c")

= mddriver.c 
#let mddriver = read("ref-impl/mddriver.c")
#raw(mddriver, lang: "c")

= Test Suite

The MD2 test suite (driver option "-x") should print the following results:

```c 
MD2 test suite:
MD2("") = 8350e5a3e24c153df2275c9f80692773
MD2("a") = 32ec01ec4a6dac72c0ab96fb34c0b5d1
MD2("abc") = da853b0d3f88d99b30283a69e6ded6bb
MD2("message digest") = ab4f496bfb2a530b219ff33031fe06b0
MD2("abcdefghijklmnopqrstuvwxyz") = 4e8ddff3650292ab5a4108c3aa47940b
MD2("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789") =
da33def2a42df13975352846c30338cd
MD2("123456789012345678901234567890123456789012345678901234567890123456
78901234567890") = d5976f79d83d3a0dc9806c3c66f3efd8
```

#set heading(numbering: none)

== Security Considerations
The level of security discussed in this memo is considered to be
   sufficient for implementing very high security hybrid digital
   signature schemes based on MD2 and a public-key cryptosystem.

