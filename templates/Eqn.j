// -*- mode: java; -*-
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

import java.util.ArrayList;

public class Eqn extends Stackable {

	public boolean isScalar () { return lhs.isScalar(); }
	public double scalar () { return lhs.scalar (); }
	public Stackable copy () { return new Eqn (this); }
	public String name () { return "Eqn"; }

	private Stackable lhs, rhs;

	public Eqn () { lhs = rhs = new Scalar (0); }
	public Eqn (double a) { lhs = rhs = new Scalar (a); }
	public Eqn (Scalar a) { lhs = rhs = new Scalar (a); }
	public Eqn (Eqn a) { // FIXME: need to copy
		lhs=a.lhs; rhs=a.rhs;
	}
	public Eqn (PrimeFactored a) { lhs = rhs = new PrimeFactored (a); }
	public Eqn (FactoredPolynomial a) { lhs = rhs = new FactoredPolynomial (a); }
	public Eqn (Polynomial a) { lhs = rhs = new Polynomial (a); }
	public Eqn (DomainErr a) { lhs = rhs = new DomainErr (a); }
	public Eqn (String s) { // Deserialize
		if (s.startsWith ("E")) {
			String [] s2 = s.substring(1).split ("=");
			lhs = Deserialize.deserialize (s2[0]);
			rhs = Deserialize.deserialize (s2[1]);
		}
	}
	// This does not make a copy!
	public Eqn (Stackable l, Stackable r) {
		lhs = l;
		rhs = r;
	}
	private Eqn doBinOp (Eqn b, BinOp o) {
		Eqn a = this;
		SFactory t = o.binOpResultFactory (lhs, b.lhs);
		Stackable l = o.binOp (t);
		SFactory u = o.binOpResultFactory (rhs, b.rhs);
		Stackable r = o.binOp (u);
		return new Eqn (l, r);
	}
	public Eqn add (Eqn b) { return doBinOp (b, new Add ()); }
	public Eqn sub (Eqn b) { return doBinOp (b, new Sub ()); }
	public Eqn mul (Eqn b) { return doBinOp (b, new Mul ()); }
	public Eqn div (Eqn b) { return doBinOp (b, new Div ()); }
	public Eqn mod (Eqn b) { return doBinOp (b, new Mod ()); }
	public Eqn power (Eqn b) { return doBinOp (b, new Power ()); }
	public Eqn [ ] divMod (Eqn b) { 
		BinOp2 o = new DivMod ();
		SFactory t = o.binOp2ResultFactory (lhs, b.lhs);
		Stackable [] l = o.binOp2 (t);
		SFactory u = o.binOp2ResultFactory (rhs, b.rhs);
		Stackable [] r = o.binOp2 (t);
		return new Eqn [] { new Eqn (l[0], r[0]),
					  new Eqn (l[1], r[1]) };
	}
	public Stackable expand () { return new Polynomial (this); }
	/*
	public Stackable factor () { return null; // FIXME }
	public Eqn sqrt () { return new Eqn (Math.sqrt(d)); }
	public Eqn squared () { return new Eqn (d*d); }
	public Eqn times2 () { return new Eqn (d*2); }
	public Eqn divide2 () { return new Eqn (d/2); }
	*/

	public Stackable getLhs () { return lhs; }
	public Stackable getRhs () { return rhs; }
	public boolean isZero () { return lhs.isZero(); }
	// public boolean isNeg () { return lhs.isNeg(); }
	public boolean isNotBad () { return lhs.isNotBad(); }
	public String toString () {
		return lhs.toString() + "=" + rhs.toString(); 
	}
	public String serialize () {
		String o = String.format ("E%s=%s",
					  lhs.serialize (),
					  rhs.serialize ());
		return o;
	}

	// boilerplate

}
