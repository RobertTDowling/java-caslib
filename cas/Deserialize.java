package com.rtdti.cas;
/*****************************************************************************"
Copyright (c) 2015, Robert T Dowling
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*****************************************************************************/

/* Notes on parsing serialized output
 * First character represents type:
 *    s - Scalar
 *    z - PrimeFactored 
 *    p - Polynomial
 *    f - FactoredPolynomial
 *    f - FactoredPolynomial
 *    E - Eqn
 *    d - DomainErr
 *    some hidden sub-types, used by Polynomial
 *        e = Evec
 *        v = VarSet
 *
 * Some bodies contain multiple parts, so they have "split" delimiters:
 *
 *    * - PrimeFactored, separating factors
 *    , - PrimeFactored, separating powers from primes
 *
 *    + - Polynomial, separating terms, and also first item is VarSet
 *    , - Polynomial, separating coef from varset
 *
 *    * - FactoredPolynomial, separating polynomial factors
 *    ; - FactoredPolynomial, separating powers from polynomials
 *
 *    = - Eqn, separating LHS and RHS
 *
 *    : - VarSet, separating the variable names
 *    : - Evec, separating the powers of the variables
 */

public class Deserialize {
	static public Stackable deserialize (String s) {
		if (s.startsWith ("s"))
			return new Scalar (s);
		else if (s.startsWith ("z"))
			return new PrimeFactored (s);
		else if (s.startsWith ("p"))
			return new Polynomial (s);
		else if (s.startsWith ("f"))
			return new FactoredPolynomial (s);
		else if (s.startsWith ("E"))
			return new Eqn (s);
		else
			return new DomainErr ("Deserialize:"+s);
	}
}
