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

public class PrimeFactored extends Factored {

	// boilerplate

	public Stackable copy () { return new PrimeFactored (this); }
//////////////////////////////////////////////////////////////////////////////
	public PrimeFactored () {
		Profile.tick("PrimeFactored.ctor()");
		pm = new HashMap<String,Integer> (); // powers
		fm = new HashMap<String,Stackable> (); // factors
	}
	public PrimeFactored (PrimeFactored f) {
		Profile.tick ("PrimeFactored.ctor(PrimeFactored)");
		pm = new HashMap<String,Integer> ();
		fm = new HashMap<String,Stackable> ();
		for (String s: f.pm.keySet()) {
			pm.put (s, f.pm.get(s));
			fm.put (s, f.fm.get(s));
		}
	}
	public PrimeFactored (Scalar s) {
		Profile.tick("PrimeFactored.ctor(Scalar)");
		pm = new HashMap<String,Integer> ();
		fm = new HashMap<String,Stackable> ();
		Scalar p = new Scalar (s);
		// Factor it in Z
		Scalar [] pp = p.factorInZ ();
		// Populate
		for (Scalar ppp: pp) {
			addTo (ppp, 1);
		}
	}
	public PrimeFactored (Variable v) {
		Profile.tick("PrimeFactored.ctor(Var)");
		System.out.print ("Can't make PrimeFactored from Variable\n");
	}
	public PrimeFactored (Polynomial p) {
		Profile.tick("PrimeFactored.ctor(Polynomial)");
		System.out.print ("Can't make PrimeFactored from Polynomial\n");
	}
	public PrimeFactored (FactoredPolynomial f) {
		Profile.tick ("PrimeFactored.ctor(FactoredPolynomial)");
		pm = new HashMap<String,Integer> ();
		fm = new HashMap<String,Stackable> ();
		Scalar p = new Scalar (f);
		// Factor it in Z
		Scalar [] pp = p.factorInZ ();
		// Populate
		for (Scalar ppp: pp) {
			addTo (ppp, 1);
		}
	}
	public PrimeFactored (Stackable [] a) {
		Profile.tick("PrimeFactored.ctor(Stackable [])");
		pm = new HashMap<String,Integer> ();
		fm = new HashMap<String,Stackable> ();
		for (Stackable s: a) {
			ScalarFactory f = new ScalarFactory (s, null);
			Stackable ss = f.makeFrom (s);
			addTo (ss, 1);
		}
	}
	public PrimeFactored (DomainErr e) {
		Profile.tick("PrimeFactored.ctor()");
		pm = new HashMap<String,Integer> (); // powers
		fm = new HashMap<String,Stackable> (); // factors
	}		
	public PrimeFactored (String s) { // Deserialize
		pm = new HashMap<String,Integer> (); // powers
		fm = new HashMap<String,Stackable> (); // factors
		if (s.startsWith ("z")) {
			String [] sp = s.substring(1).split ("\\*");
			for (String t: sp) {
				String [] ssp = t.split(",");
				int i = Integer.decode (ssp[0].substring(1));
				Scalar ss = new Scalar (ssp[1]);
				addTo (ss, i);
			}
		}
	}
	// public PrimeFactored add (PrimeFactored b);
	// public PrimeFactored sub (PrimeFactored b);
	public PrimeFactored mul (PrimeFactored b) {
		Profile.tick("PrimeFactored.mul");
		PrimeFactored a = new PrimeFactored (b);
		for (String s: pm.keySet()) {
			a.addTo (fm.get(s), pm.get(s));
		}
		return a;
	}
	public PrimeFactored div (PrimeFactored denom) {
		PrimeFactored [] dr = divMod (denom);
		return dr[0];
	}
	public PrimeFactored [] divMod (PrimeFactored denom) {
		Profile.tick("PrimeFactored.div");
		PrimeFactored rem = new PrimeFactored (this);
		PrimeFactored quot = new PrimeFactored (this);
		for (String s: pm.keySet()) {
			quot.addTo (fm.get(s), -pm.get(s));
		}
		return new PrimeFactored[]{quot, rem};
	}
	public PrimeFactored power (PrimeFactored exp) {
		if (exp.isScalar()) {
			BinOp o = new Mul();
			int i = (int) (long) exp.scalar ();
			PrimeFactored c = new PrimeFactored (new Scalar (1));
			while (i-- > 0) {
				c = c.mul(this);
			}
			return c;
		}
		return null;
	}
	public PrimeFactored factor (SFactory t) {
		Stackable [] r = t.args[0].factorInZ ();
		return new PrimeFactored (r);
	}
	public Stackable expand () { return new Scalar (this); }
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
	public String name () { return "PrimeFactored"; }

	public String serialize () {
		// protected HashMap<String,Integer> pm; // powers
		// protected HashMap<String,Stackable> fm; // factors
		String o = "z";
		boolean first=true;
		for (String k: pm.keySet()) {
			int i = pm.get(k);
			Stackable s = fm.get(k);
			if (!first)
				o += "*";
			o += String.format ("i%d,%s", i, s.serialize());
			first = false;
		}
		return o;
	}
}
