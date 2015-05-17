package com.rtdti.cas;
/*****************************************************************************
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

public abstract class Stackable {

	public final static String version = "java-caslib 1.12a 5/2015";

	public abstract Stackable addTo (Stackable x);
	public abstract Stackable subTo (Stackable x);
	public abstract Stackable mulTo (Stackable x);
	public abstract Stackable divTo (Stackable x);
	public abstract Stackable modTo (Stackable x);
	public abstract Stackable powerTo (Stackable x);
	public abstract Stackable colonTo (Stackable x);
	public abstract Stackable hmTo (Stackable x);
	public abstract Stackable mdTo (Stackable x);
	public abstract Stackable andTo (Stackable x);
	public abstract Stackable orTo (Stackable x);
	public abstract Stackable xorTo (Stackable x);
	public abstract Stackable eeTo (Stackable x);
	public abstract Stackable gcdTo (Stackable x);
	public abstract Stackable lcmTo (Stackable x);

	public abstract Stackable [] divModTo (Stackable x);

	public abstract Stackable makeScalarFrom ();
	public abstract Stackable makePrimeFactoredFrom ();
	public abstract Stackable makePolynomialFrom ();
	public abstract Stackable makeFactoredPolynomialFrom ();

	public abstract boolean isScalar ();
	public abstract boolean isZero ();
	public abstract boolean isNotBad ();
	public abstract double scalar ();
	public abstract Stackable copy ();
	public abstract String toString ();
	public abstract String name();

	public abstract String serialize ();

	public Stackable [] factorInZ() { return new Stackable [] { new DomainErr ("factorInZ")}; }

	// boilerplate
}

