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

public class Term {
	private Scalar coef;
	private Evec evec;
	final private String [] font = {
		"⁰", "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹"};
	public Term (Scalar coef, Evec evec) {
		Profile.tick ("Term.ctor()");
		this.coef = coef;
		this.evec = evec;
	}
	public Term (Term t) {
		Profile.tick ("Term.ctor(Term)");
		coef = new Scalar (t.coef);
		evec = new Evec (t.evec);
	}
	public Scalar coef () { return coef; }
	public Evec evec () { return evec; }
	public int degree () { return evec.degree(); }
	public Term gcd (Term y) {
		Term x = this;
		Scalar c = x.coef.gcd(y.coef);
		Evec e = x.evec.gcd(y.evec);
		Term r = new Term (c, e);
		// System.out.print (String.format ("Term: x=%s y=%s gcd=%s\n", x.toString(), y.toString(), r.toString()));
		return r;
	}
	public Term mul (VarSet v, Term other) {
		Profile.tick ("Term.mul");
		VarMap tm = this.evec.unpack ();
		VarMap om = other.evec.unpack ();
		Scalar tc = this.coef;
		Scalar oc = other.coef;
		// Collect all the maps
		VarMap work = new VarMap ();
		for (Variable x: tm.keys())
			work.addTo (x, tm.get(x));
		for (Variable x: om.keys())
			work.addTo (x, om.get(x));
		return new Term (tc.mul(oc), new Evec (v, work));
	}
	public Term div (VarSet v, Term other) {
		Profile.tick ("Term.div");
		VarMap tm = this.evec.unpack ();
		VarMap om = other.evec.unpack ();
		Scalar tc = this.coef;
		Scalar oc = other.coef;
		// Collect all the maps
		VarMap work = new VarMap ();
		for (Variable x: tm.keys())
			work.addTo (x, tm.get(x));
		for (Variable x: om.keys())
			work.addTo (x, -om.get(x));
		// Check for failure
		for (Variable x: work.keys())
			if (work.get(x) < 0) return null;
		return new Term (tc.div(oc), new Evec (v, work));
	}
	public String toString () {
		String o = coef.isNeg() ? "" : "+";
		o += coef.toString();
		if (evec.isScalar())
			return o;
		if (coef.get() == -1) o = "-";
		if (coef.get() == 1) o = "+";
		VarMap m = evec.unpack ();
		for (Variable v: m.sortKeys ()) {
			int p = m.get(v);
			if (p==1)
				o += v.toString();
			else {
				String e = "";
				String j = String.format ("%d", p);
				for (char c: j.toCharArray()) {
					e += font[c-'0'];
				}
				o += String.format("%s%s", v.toString(), e);
			}
		}
		return o;
	}
	public String toDebug () {
		return String.format ("Coef:%s Evec:%s", coef.toString(), evec.toString());
	}
}
