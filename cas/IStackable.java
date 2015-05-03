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

public interface IStackable {

	public Stackable addTo (Stackable x);
	public Stackable subTo (Stackable x);
	public Stackable mulTo (Stackable x);
	public Stackable divTo (Stackable x);
	public Stackable modTo (Stackable x);
	public Stackable powerTo (Stackable x);
	public Stackable colonTo (Stackable x);
	public Stackable hmTo (Stackable x);
	public Stackable mdTo (Stackable x);
	public Stackable andTo (Stackable x);
	public Stackable orTo (Stackable x);
	public Stackable xorTo (Stackable x);
	public Stackable eeTo (Stackable x);
	public Stackable gcdTo (Stackable x);
	public Stackable lcmTo (Stackable x);

	public Stackable [] divModTo (Stackable x);

	public Stackable log2 ();
	public Stackable pow2 ();
	public Stackable not ();
	public Stackable floor ();
	public Stackable addinv ();
	public Stackable multinv ();
	public Stackable exp ();
	public Stackable ln ();
	public Stackable sin ();
	public Stackable cos ();
	public Stackable tan ();
	public Stackable arcsin ();
	public Stackable arccos ();
	public Stackable arctan ();
	public Stackable d2r ();
	public Stackable r2d ();
	public Stackable sqrt ();
	public Stackable squared ();
	public Stackable ceil ();
	public Stackable ceillog2 ();
	public Stackable ceilpow2 ();
	public Stackable times2 ();
	public Stackable divide2 ();
	public Stackable round ();
	public Stackable factor ();

	public Stackable makeScalarFrom ();
	public Stackable makePrimeFactoredFrom ();
	public Stackable makePolynomialFrom ();
	public Stackable makeFactoredPolynomialFrom ();

	public boolean isScalar ();
	public boolean isZero ();
	public boolean isNotBad ();
	public double scalar ();
	public Stackable copy ();
	public String toString ();
	public String name();

	public String serialize ();
}
