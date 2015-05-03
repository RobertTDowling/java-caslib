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

import java.util.HashMap;
import java.util.Set;
import java.util.TreeSet;
import java.lang.Math;

public class FactoredPolynomial extends Factored {

	// boilerplate


	public Stackable copy () { return new FactoredPolynomial (this); }
//////////////////////////////////////////////////////////////////////////////
	public FactoredPolynomial () {
		Profile.tick("FactoredPolynomial.ctor()");
		pm = new HashMap<String,Integer> (); // powers
		fm = new HashMap<String,Stackable> (); // factors
	}
	public FactoredPolynomial (DomainErr e) {
		Profile.tick("FactoredPolynomial.ctor()");
		pm = new HashMap<String,Integer> (); // powers
		fm = new HashMap<String,Stackable> (); // factors
	}
	public FactoredPolynomial (FactoredPolynomial f) {
		Profile.tick ("FactoredPolynomial.ctor(FactoredPolynomial)");
		pm = new HashMap<String,Integer> ();
		fm = new HashMap<String,Stackable> ();
		for (String s: f.pm.keySet()) {
			pm.put (s, f.pm.get(s));
			fm.put (s, f.fm.get(s));
		}
	}
	public FactoredPolynomial (Scalar s) {
		Profile.tick("FactoredPolynomial.ctor(Scalar)");
		pm = new HashMap<String,Integer> ();
		fm = new HashMap<String,Stackable> ();
		Stackable p = new Polynomial (s);
		// Factor it in Z
		Stackable [] pp = p.factorInZ ();
		// Populate
		for (Stackable ppp: pp) {
			addTo (ppp, 1);
		}
	}
	public FactoredPolynomial (Variable v) {
		Profile.tick("FactoredPolynomial.ctor(Var)");
		pm = new HashMap<String,Integer> ();
		fm = new HashMap<String,Stackable> ();
		Stackable p = new Polynomial (v);
		addTo (p, 1);
	}
	public FactoredPolynomial (Polynomial p) {
		Profile.tick("FactoredPolynomial.ctor(Polynomial)");
		pm = new HashMap<String,Integer> ();
		fm = new HashMap<String,Stackable> ();
		addTo (p, 1);
	}
	public FactoredPolynomial (Stackable [] a) {
		Profile.tick("FactoredPolynomial.ctor(Stackable [])");
		pm = new HashMap<String,Integer> ();
		fm = new HashMap<String,Stackable> ();
		for (Stackable s: a) {
			PolynomialFactory f = new PolynomialFactory (s, null);
			Stackable p = f.makeFrom (s);
			addTo (p, 1);
		}
	}
	public FactoredPolynomial (PrimeFactored f) {
		Profile.tick ("FactoredPolynomial.ctor(PrimeFactored)");
		pm = new HashMap<String,Integer> ();
		fm = new HashMap<String,Stackable> ();
		for (String s: f.pm.keySet()) {
			pm.put (s, f.pm.get(s));
			fm.put (s, f.fm.get(s));
		}
	}
	public FactoredPolynomial (String s) { // Deserialize
		pm = new HashMap<String,Integer> (); // powers
		fm = new HashMap<String,Stackable> (); // factors
		if (s.startsWith ("f")) {
			String [] sp = s.substring(1).split ("\\*");
			for (String t: sp) {
				String [] ssp = t.split(";");
				int i = Integer.decode (ssp[0].substring(1));
				Polynomial p = new Polynomial (ssp[1]);
				addTo (p, i);
			}
		}
	}
	// public FactoredPolynomial add (FactoredPolynomial b);
	// public FactoredPolynomial sub (FactoredPolynomial b);
	public FactoredPolynomial mul (FactoredPolynomial b) {
		Profile.tick("FactoredPolynomial.mul");
		FactoredPolynomial a = new FactoredPolynomial (b);
		for (String s: pm.keySet()) {
			a.addTo (fm.get(s), pm.get(s));
		}
		return a;
	}
	public FactoredPolynomial div (FactoredPolynomial denom) {
		FactoredPolynomial [] dr = divMod (denom);
		return dr[0];
	}
	public FactoredPolynomial [] divMod (FactoredPolynomial denom) {
		Profile.tick("FactoredPolynomial.div");
		FactoredPolynomial rem = new FactoredPolynomial (this);
		FactoredPolynomial quot = new FactoredPolynomial (this);
		for (String s: pm.keySet()) {
			quot.addTo (fm.get(s), -pm.get(s));
		}
		return new FactoredPolynomial[]{quot, rem};
	}
	public FactoredPolynomial power (FactoredPolynomial exp) {
		if (exp.isScalar()) {
			BinOp o = new Mul();
			int i = (int) (long) exp.scalar ();
			FactoredPolynomial c = new FactoredPolynomial (new Scalar (1));
			while (i-- > 0) {
				c = c.mul(this);
			}
			return c;
		}
		return null;
	}
	public FactoredPolynomial factor (SFactory t) {
		Stackable [] r = t.args[0].factorInZ ();
		return new FactoredPolynomial (r);
	}
	public Polynomial expand () { return new Polynomial (this); }
	public String toString () {
		String o = "";
		for (String s: pm.keySet()) {
			String e = "";
			int p = pm.get(s);
			if (p > 1) {
				String j = String.format ("%d", p);
				for (char c: j.toCharArray()) {
					e += font[c-'0'];
				}
			}
			o += "(" + fm.get(s).toString() + ")" + e;
		}
		return o;
	}
	public String name () { return "FactoredPolynomial"; }

	public String serialize () {
		// protected HashMap<String,Integer> pm; // powers
		// protected HashMap<String,Stackable> fm; // factors
		String o = "f";
		boolean first=true;
		for (String k: pm.keySet()) {
			int i = pm.get(k);
			Stackable s = fm.get(k);
			if (!first)
				o += "*";
			o += String.format ("i%d;%s", i, s.serialize());
			first = false;
		}
		return o;
	}
}
