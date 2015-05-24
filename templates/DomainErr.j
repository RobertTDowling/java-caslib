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

public class DomainErr extends Stackable {
	public final String msg;

	// boilerplate

	public boolean isScalar () { return true; }
	public double scalar () { return 0; }
	public Stackable copy () { return new DomainErr (msg); }
	public String name () { return "DomainErr"; }

	public DomainErr () { msg="unknown"; }
	public DomainErr (String s) { msg=s; }
	public DomainErr (double a) { msg="fromDouble"; }
	public DomainErr (DomainErr a) { msg="unknown-DomainErr"; }
	public DomainErr (Scalar a) { msg="fromScalar"; }
	public DomainErr (PrimeFactored a) { msg="fromPF"; }
	public DomainErr (FactoredPolynomial a) { msg="fromFP"; }
	public DomainErr (Polynomial a) { msg="fromPoly"; }
	public DomainErr (Eqn a) { msg="fromEqn"; }
	public DomainErr add (DomainErr b) { return new DomainErr ("add"); }
	public DomainErr sub (DomainErr b) { return new DomainErr ("sub"); }
	public DomainErr mul (DomainErr b) { return new DomainErr ("mul"); }
	public DomainErr div (DomainErr b) { return new DomainErr ("div"); }
	public DomainErr [] divMod (DomainErr b) { return new DomainErr [] { new DomainErr ("divmod"), new DomainErr ("divmod")}; }
	public DomainErr power (DomainErr b) { return new DomainErr ("power"); }
	public DomainErr factor () { return new DomainErr ("factor"); }
	public DomainErr neg () { return new DomainErr ("neg"); }
	public boolean isZero () { return false; }
	public boolean isNeg () { return false; }
	public boolean isNotBad () { return true; }
	public double get () { return 0; }
	public String toString () { return "DomainErr("+msg+")"; }

	public String serialize () {
		return "d()";
	}

	public Stackable deserialize(String s) {
		return null;
	}

}
