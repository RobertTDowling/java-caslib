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
import java.util.Set;

public class Polynomial extends Stackable {
	private VarSet vs;
	private ArrayList<Term> ts;

	// boilerplate

	public Stackable copy () { return new Polynomial (this); }
//////////////////////////////////////////////////////////////////////////////
	public Polynomial () {
		Profile.tick("Polynomial.ctor()");
		vs = new VarSet();
		ts = new ArrayList<Term> ();
	}
	public Polynomial (DomainErr e) {
		Profile.tick("Polynomial.ctor()");
		vs = new VarSet();
		ts = new ArrayList<Term> ();
	}
	public Polynomial (Scalar s) {
		Profile.tick("Polynomial.ctor(Scalar)");
		vs = new VarSet();
		VarMap m = new VarMap();
		Evec e = new Evec(vs, m);
		Term t = new Term(s, e);
		ts = new ArrayList<Term> ();
		ts.add (t);
	}
	public Polynomial (Variable v) {
		Profile.tick("Polynomial.ctor(Var)");
		vs = new VarSet(v);
		VarMap m = new VarMap();
		m.addTo (v);
		Evec e = new Evec(vs, m);
		Scalar s = new Scalar(1);
		Term t = new Term(s, e);
		ts = new ArrayList<Term> ();
		ts.add (t);
	}
	public Polynomial (VarSet v, Term t) {
		Profile.tick("Polynomial.ctor(VarSet,Term)");
		vs = v;
		ts = new ArrayList<Term> ();
		ts.add (t);
	}
	public Polynomial (Polynomial a) {
		Profile.tick("Polynomial.ctor(Poly)");
		vs = a.vs;
		ts = new ArrayList<Term> ();
		for (Term t: a.ts)
			ts.add(new Term(t));
		// ts = (ArrayList<Term>) a.ts.clone(); // This is unclean operation.  Why?
	}
	public Polynomial (Factored f) {
		Profile.tick("Polynomial.ctor(Factored)");
		Polynomial r = new Polynomial (new Scalar (1));
		BinOp o = new Mul ();
		SFactory u = new PolynomialFactory (null, null);
		for (Stackable p: f.keys()) {
			Polynomial pp = (Polynomial) u.makeFrom(p);
			for (int i=f.get(p); i>0; i--) {
				r = r.mul(pp);
			}
		}
		vs = r.vs;
		ts = new ArrayList<Term> ();
		for (Term t: r.ts)
			ts.add(new Term(t));
	}
	public Polynomial (String s) { // Deserialize
		vs = new VarSet();
		ts = new ArrayList<Term> ();
		String [] s2 = s.substring(1).split ("\\+");
		boolean first = true; 
		for (String t: s2) {
			if (first) {
				// Pick off VarSet
				// System.out.print (String.format (" vs='%s'\n", t));
				vs = new VarSet (t); // Use deserialze in VarSet
				first = false;
			} else {
				// Rest is Scalar,Evec pairs
				String [] s3 = t.split(",");
				// System.out.print (String.format (" t='%s' %s / %s\n", t, s3[0], s3[1]));
				Scalar sc = new Scalar (s3[0]);
				Evec e = new Evec (vs, s3[1]);
				Term term = new Term (sc, e);
				addTo (term);
			}
		}
	}
	public void addTo (Term t) {
	       ts.add(t);
	}
	public int degree () {
		if (ts.size()>0)
			return ts.get(0).degree();
		return 0;
	}
	public double scalar () {
		for (Term t: ts) {
			Evec te = t.evec();
			if (te.toString().equals ("0"))
				return t.coef().get();
		}
		return 0;
	}
	public boolean isScalar () {
		for (Term t: ts) {
			Evec te = t.evec();
			if (!te.toString().equals ("0"))
				return false;
		}
		return true;
	}
	public boolean isZero () { return isScalar() && scalar() == 0; }
	public boolean isNotBad () {
		for (Term t: ts) {
			if (!t.coef().isNotBad())
				return false;
		}
		return true;
	}
	public Polynomial add (Polynomial b) {
		Profile.tick("Polynomial.add");
		Polynomial a = this;
		// Compute union varset
		VarSet vu = a.vs.union (b.vs);
		// Collect all terms in VarMap
		EvecMap m = new EvecMap();
		for (Term t: a.ts) {
			Evec te = t.evec();
			Scalar tc = t.coef();
			Evec me = vu.remap (te);
			m.addTo (tc, me);
		}
		for (Term t: b.ts) {
			Evec te = t.evec();
			Scalar tc = t.coef();
			Evec me = vu.remap (te);
			m.addTo (tc, me);
		}
		return cleanup (vu, m);
	}
	public Polynomial sub (Polynomial b) {
		Profile.tick("Polynomial.sub");
		Polynomial a = this;
		// Compute union varset
		VarSet vu = a.vs.union (b.vs);
		// Collect all terms in VarMap
		EvecMap m = new EvecMap();
		for (Term t: a.ts) {
			Evec te = t.evec();
			Scalar tc = t.coef();
			Evec me = vu.remap (te);
			m.addTo (tc, me);
		}
		for (Term t: b.ts) {
			Evec te = t.evec();
			Scalar tc = t.coef();
			Evec me = vu.remap (te);
			m.addTo (tc.addinv(), me);
		}
		return cleanup (vu, m);
	}
	public Polynomial mul (Polynomial b) {
		Profile.tick("Polynomial.mul");
		Polynomial a = this;
		// Compute union varset
		VarSet vu = a.vs.union (b.vs);
		// Collect all terms in VarMap
		EvecMap m = new EvecMap();
		for (Term t: a.ts) {
			Evec te = t.evec();
			Scalar tc = t.coef();
			Evec tu = vu.remap (te);
			for (Term u: b.ts) {
				Evec ue = u.evec();
				Scalar uc = u.coef();
				Evec uu = vu.remap (ue);
				m.addTo (tc.mul(uc), tu.mul(uu));
			}
		}
		return cleanup (vu, m);
	}
	public Polynomial div (Polynomial denom) {
		Polynomial [] dr = divMod (denom);
		return dr[0];
	}
	public Polynomial [] divMod (Polynomial denom) {
		Profile.tick("Polynomial.div");
		Polynomial num = this;
		Polynomial rem;
		Polynomial quot;

		if (denom.isScalar()) {
			// System.out.print (String.format ("scalar division %s/%s\n", num.toString(), denom.toString()));
			rem = new Polynomial(new Scalar(0));
			quot = num.mul(new Polynomial(new Scalar(1 / denom.scalar())));
		} else {
			// System.out.print (String.format ("full division %s/%s\n", num.toString(), denom.toString()));
			rem = new Polynomial(num);
			quot = new Polynomial(new Scalar(0));
			// f/g, find m in f, m = q*lm(g).  m can be any monomial in f.
			// reduce(f,g) = f - c(m)/lc(g)*q*g.

			// Compute union varset
			VarSet vu = num.vs.union(denom.vs);

			// Get leading term in denom, re at in union varset
			Term dlt = vu.remap(denom.ts.get(0));
			// System.out.print (String.format ("Try vu=%s dlt=%s\n",vu.toString(), dlt.toString()));

			// Loop
			boolean all = true;
			int count = 10000;
			while (all && count-- > 0) {
				all = false;
				for (Term rt : rem.ts) {
					// System.out.print (String.format ("Try rt=%s\n",rt.toString()));
					Term qt = vu.remap(rt).div(vu, dlt);
					if (qt != null) {
						all = true;
						// ArrayList<Term> p = new ArrayList<Term>();
						Polynomial a = new Polynomial(vu, qt);
						Polynomial s = denom.mul(a);
						if (!s.isNotBad()) {
							count = 0;
							break;
						}
						Polynomial rr = rem.sub(s);
						// System.out.print (String.format ("  qt=%s a=%s s=%s rr=%s quot=%s",
						// qt.toString(), a.toString(), s.toString(), rr.toString(), quot.toString()));
						rem = rr;
						quot = quot.add(a);
						// System.out.print (String.format ("  final quot=%s", quot.toString()));
						break;
					}
					// System.out.print ("\n");
				}
			}
			if (count <= 0) { // failure
				quot = new Polynomial (new Variable ("x"));
				rem = new Polynomial (new Variable ("y"));
			}
		}
		return new Polynomial[]{quot, rem};
	}
	public Polynomial power (Polynomial exp) {
		if (exp.isScalar()) {
			BinOp o = new Mul();
			int i = (int) (long) exp.scalar ();
			Polynomial c = new Polynomial (new Scalar (1));
			while (i-- > 0) {
				c = c.mul(this);
			}
			return c;
		}
		System.out.print ("Can't compute Polynomial^Polynomial\n");
		return null;
	}
	public Polynomial cleanup (VarSet vs, EvecMap m) {
		Profile.tick("Polynomial.cleanup");
		// Remove 0 terms
		for (Evec e: m.keys())
			if (m.get(e).isZero())
				m.remove(e);
		// Remap again in  any terms went away
		VarSet nvu = new VarSet(m);
		if (!nvu.equals(vs)) {
			// Need to remap
			EvecMap m1 = new EvecMap();
			for (Evec e: m.keys())
				m1.addTo (m.get(e), nvu.remap(e));
			m = m1;
			vs = nvu;
		}

		// Turn back in to terms
		Polynomial c = new Polynomial ();
		c.vs = vs;
		for (Evec e: m.sortKeys())
			c.ts.add (new Term(m.get(e), e));
		return c;
	}
	public String toString () {
		String o = "";
		for (Term t: ts)
			o += t.toString();
		if (o.startsWith ("+"))
			return o.substring(1);
		return o.equals ("") ? "0" : o;
	}
	public String name () { return "Polynomial"; }
	public void Debug () {
		System.out.print (String.format("vs='%s'\n", vs.toString()));
		for (Term t: ts)
			System.out.print (String.format("  t='%s'\n", t.toDebug()));
	}
	public Stackable factor () {
		Stackable [] r = factorInZ ();
		return new FactoredPolynomial (r);
	}
	public Polynomial expand () { return new Polynomial (this); }
	// Public one
	public Polynomial [] factorInZ () {
		// Early out if degree 1 or less
		if (degree() < 2)
			return new Polynomial [] { this };
		// Use the theorem that says that any factor of
		// ax^n+...+z will be in the form (bx+y) where b is a factor
		// of a and y is a factor of z.
		//
		// So can we apply this theorem yet?  Or must we simplify
		// what we got?

		// Pick a variable to factor in.  Pick the first
		Variable v = vs.var(1);
		int degLastTerm = ts.get(ts.size()-1).degree();

		// Is this polynomial either in 2 vars or in 1 var with a
		// a scalar term?  If so, we can make a (x-k) type attempt.
		if (vs.order() == 1 && degLastTerm == 0 ||
		    vs.order() == 2 && degLastTerm != 0) {
			// Yes, we can try to find a x-k type of factor

			// System.out.print (String.format ("v=%s\n", v.toString()));
			// Factor...
			ArrayList<Polynomial> l = new ArrayList<Polynomial>();
			factorInZ (v, l);
			// Construct array from arraylist
			Polynomial [] a = new Polynomial[l.size()];
			for (int i=0; i<l.size(); i++)
				a[i] = l.get(i);
			return a;
		} else {
			// We need to simplify
			System.out.print ("We need to remove variable " + v.toString() + " to do this...\n");
			System.out.print (String.format ("vs.order=%d last term=%s degree=%d\n",
							 vs.order(), ts.get(ts.size()-1).toString(),
							 degLastTerm));
			
			Polynomial [] pInVar1 = expressIn (v);
			// Subfactor last (lowest power in v) term
			Polynomial last = pInVar1[0];
			System.out.print ("  ... last=" +last.toString()+ "\n");
			Polynomial [] lastFactored = last.factorInZ ();
			
			// Oy!  These factors serve as "k" in x-k type expressions
			return lastFactored; // FIXME: this is not real answer
		}
	}
	
	// Worker, not public
	private void factorInZ (Variable v, ArrayList<Polynomial> l) {
		Polynomial f = this;
		ArrayList<Polynomial> r = new ArrayList<Polynomial>();

		// Get leading and last coefficient
		double dleading = ts.get(0).coef().get();
		double dlast = ts.get(ts.size()-1).coef().get();
		// System.out.print (String.format ("leading=%f last=%f\n", dleading, dlast));
		// Factor each in Z
		long leading = (long) dleading;
		long last = (long) dlast;

		ArrayList<Long> fleading = zFactorsOf(leading);
		ArrayList<Long> flast = zFactorsOf(last);

		// Get leading and last variable
		VarMap mleading = ts.get(0).evec().unpack();
		VarMap mlast = ts.get(ts.size()-1).evec().unpack();
		Set<Variable> sleading = mleading.keys();
		Set<Variable> slast = mlast.keys();
		if (slast.isEmpty())
			slast = sleading;

		// System.out.print (String.format ("leading=%s %s\n", fleading.toString(), sleading.toString()));
		// System.out.print (String.format ("last=%s %s\n", flast.toString(), slast.toString()));

		for (Long a: fleading) {
		    for (Variable x: sleading) {
			for (Long b: flast) {
		            for (Variable y: slast) {
				    // System.out.print (String.format ("a=%s x=%s b=%s y=%s\n", a.toString(), x.toString(), b.toString(), y.toString()));
				// Polynomial p = new Polynomial (v);
				Polynomial pl = new Polynomial (x);
				Polynomial pr;
				if (y.toString().equals(x.toString()))
					pr = new Polynomial (new Scalar(1.0));
				else
					pr = new Polynomial (y);
				// p=p.mul(new Polynomial(new Scalar(a)));
				pl=pl.mul(new Polynomial(new Scalar(a)));
				pr=pr.mul(new Polynomial(new Scalar(b)));
				// p=p.add(new Polynomial(new Scalar(b)));
				Polynomial p=pl.add(pr);
				Polynomial [] c = f.divMod (p);
				// System.out.print (String.format ("Try %s q=%s r=%s\n", p.toString(), c[0].toString(), c[1].toString()));
				if (c[1].isZero()) {
					// Found one (p); Add to list
					// System.out.print (String.format ("(%s)", p.toString()));
					l.add (p);
					// Is quotient degree 1?
					if (c[0].degree() < 2) {
						// Save quotient too, then we're done
						// System.out.print (String.format ("(%s)", c[0].toString()));
						l.add (c[0]);
						return;
					}
					// recurse on quotient (c[0])
					c[0].factorInZ(v, l);
					return;
				}
			}
		    }}
		}
		// Failed to factor, tack on what is left
		l.add (this);
		return;
	}
	// Find integer factors of an integer
	private ArrayList<Long> zFactorsOf (long a) {
		ArrayList<Long> r = new ArrayList<Long>();
		a=Math.abs(a);
		if (a == 0 || a == 1) {
			r.add (1L);
			r.add (-1L);
			return r;
		}
		// Factor
		for (long t=1L; t<=a; t++) {
			if ((a % t) == 0) {
				r.add (t);
				r.add (-t);
			}
		}
		return r;
	}
	// Change a polynomial u,v,w.,,, into a polynomial in v with coef
	// of polynomials in u,w,...
	public Stackable expressIn (Polynomial pi) {
		// Peel off the variable V from pi
		Variable v = pi.vs.var(1);
		int index = vs.index (v);
		if (index < 1) {
			// Failed,so whole polynomial is answer
			return this;
		}
		return this; // Not done
	}
	public Polynomial [ ] expressIn (Variable v) {
		// Find the highest power of that variable
		// System.out.print (String.format ("expressIn pi=%s this=%s, v=%s ix=%d\n", pi.toString(), this.toString(), v.toString(), index));
		int index = vs.index (v);
		if (index < 1) {
			// Failed,so whole polynomial is answer
			return new Polynomial [] { this };
		}
		int maxPower = 0;
		for (Term t: ts) {
			Evec te = t.evec();
			int p = te.getPower(index);
			if (p > maxPower)
				maxPower = p;
		}
		// System.out.print (String.format ("  MaxPower of %s is %d ix=%d\n",
		//      v.toString(), maxPower, index));

		// Create a Varset that does not have V in it
		VarSet nvs = vs.remove (v);
		// System.out.print (String.format ("  New VS=%s\n", nvs.toString()));

		// Accumulate into maxPower+1 seperate EvecMaps
		EvecMap [] em = new EvecMap [maxPower+1];
		for (int i=0; i<=maxPower; i++) {
			em[i] = new EvecMap ();
		}
		for (Term t: ts) {
			// Get Evec from Term
			Evec te = t.evec();
			// Get power of V, and make new Evec w/o it
			VarMap nvm = te.unpack();
			int p = nvm.get(v);
			nvm.remove(v);
			Evec ne = new Evec (nvs, nvm);
			em[p].addTo (t.coef(), ne);
		}
		// Turn into maxPower+1 polynomials
		Polynomial [] np = new Polynomial [maxPower+1];
		for (int i=maxPower; i>=0; i--) {
			// System.out.print (String.format ("  %s^%d: %s\n", v.toString(), i, em[i].toString()));
			np[i] = new Polynomial();
			np[i].vs = nvs;
			for (Evec e:em[i].sortKeys())
				np[i].ts.add (new Term(em[i].get(e), e));
			System.out.print (String.format ("(%s)%s^%d", np[i].toString(), v.toString(), i));
			if (i>0) System.out.print("+");
		}
		System.out.print("\n");
		// Finally, create new Sum object...uh, I don't have this yet!
		return np;
	}

	public String serialize () {
		String o = String.format ("p%s", vs.serialize());
		for (Term t: ts) {
			Evec te = t.evec();
			Scalar sc = t.coef();
			o += String.format ("+%s,%s", sc.serialize(),
					    te.serialize());
		}
		return o;
	}
}
