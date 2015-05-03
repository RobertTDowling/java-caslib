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

import java.util.HashMap;
import java.util.Set;
import java.util.TreeSet;
import java.lang.Math;

public abstract class Factored extends Stackable {
	protected HashMap<String,Integer> pm; // powers
	protected HashMap<String,Stackable> fm; // factors
	final protected String [] font = {
		"⁰", "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹"};

	// boilerplate

	protected void addTo (Stackable p, int i) {
		Profile.tick ("Factored.addTo(p,i)");
		String k = p.toString();
		if (pm.containsKey (k))
			pm.put(k, i+pm.get(k));
		else {
			pm.put(k, i);
			fm.put(k, p);
		}
	}
	public double scalar () {
		double s = 1.0;
		for (String k: pm.keySet()) {
			for (int i=pm.get(k); i>0; i--) {
				s = s * fm.get(k).scalar();
			}
		}
		return s;
	}
	public boolean isScalar () {
		for (String s: pm.keySet()) {
			if (!fm.get(s).isScalar())
				return false;
		}
		return true;
	}
	public boolean isZero () {
		for (String s: pm.keySet()) {
			if (fm.get(s).isZero())
				return true;
		}
		return false;
	}
	public boolean isNotBad () {
		for (String s: pm.keySet()) {
			if (!fm.get(s).isNotBad())
				return false;
		}
		return true;
	}
	public Factored add (Factored b) { System.out.print ("!F1+"); return null; }
	public Factored sub (Factored b) { System.out.print ("!F1-"); return null; }
	public Factored mul (Factored b) { System.out.print ("!F1*"); return null; }
	public Factored div (Factored denom) { System.out.print ("!F1/"); return null; }
	public Factored [] divMod (Factored denom) { System.out.print ("!F1/%"); return null; }
	public Factored power (Factored exp) { System.out.print ("!F1^"); return null; }
	public Factored factor (SFactory t) { System.out.print ("!F1f"); return null; }

	public int get (Stackable p) {
		Profile.tick ("Factored.get");
		String k = p.toString();
		if (fm.containsKey (k)) {
			return pm.get(k);
		}
		return 0;
	}
	public Set<Stackable> keys () {
		return sortKeys ();
	}
	public TreeSet<Stackable> sortKeys () {
		Profile.tick ("Factored.sortKeys");
		TreeSet<Stackable> t = new TreeSet<Stackable>(new StackableComparer());
		for (String s: fm.keySet()) {
			t.add (fm.get(s));
		}
		return t;
	}
	public abstract String toString ();
	public abstract String name ();
	public void Debug () { 
		System.out.print (String.format("  %s='%s'\n", name(), toString()));
	}
}
