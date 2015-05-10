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

import java.util.ArrayList;
import java.util.TreeSet;
import java.util.Set;
import java.util.Iterator;

// Evec
//   Depends on variable set defined in VarSet vs
//   e[0] = total of all degrees of all variables
//   e[i] = degree (power) of i'th variable in vs. 1=first

public class Evec {
	private final int[] e;
	private final VarSet vs;
	public Evec (VarSet s, VarMap m) {
		Profile.tick ("Evec.ctor(VarSet, VarMap)");
		vs = s;
		e = new int[s.order()+1];
		e[0] = 0;
		for (Variable v: m.keys())
			e[0] += (e[s.index(v)] = m.get(v));
	}
	public Evec (VarSet s, int [] ev) {
		Profile.tick ("Evec.ctor(VarSet, int [])");
		vs = s;
		e = new int[ev.length];
		for (int i=0; i<ev.length; i++) {
			e[i] = ev[i];
		}
	}
	public Evec (Evec a) {
		Profile.tick ("Evec.ctor(Evec)");
		e = new int [a.e.length];
		for (int i=0; i<a.e.length; i++)
			e[i] = a.e[i];
		vs = a.vs;
	}
	public Evec (VarSet v, String s) { // Deserialize "e2:0:1"
		vs = v;
		e = new int[v.order()+1];
		String [] sp = s.substring(1).split (":");
		int i = 0;
		for (String t: sp) {
			int j = Integer.decode (t);
			e[i++] = j;
		}
	}
	public VarMap unpack () {
		Profile.tick ("Evec.unpack");
		VarMap m = new VarMap ();
		for (int i=1; i<e.length; i++) {
			if (e[i] > 0)
				m.put(vs.var(i), e[i]);
		}
		return m;
	}
	public int getPower (int index) {
		if (index > 0 && index < e.length)
			return e[index];
		return 0;
	}
	public int degree () {
		return e[0];
	}
	public boolean isScalar () {
		return degree() == 0;
	}
	// Return list of variables as factors.  If x^3 is there, return x,x,x
	public Variable [] factorInZ () {
		Variable [] f = new Variable [e[0]];
		int k=0;
		for (int i=1; i<e.length; i++) {
			for (int j=0; j<e[i]; j++) {
				f[k++] = vs.var(i);
			}
		}
		return f;
	}
	public Evec gcd (Evec y) {
		Evec x = this;
		int [] newe = new int [e.length];
		int degree = 0;
		for (int i=1; i<e.length; i++) {
			newe[i] = Math.min (x.e[i], y.e[i]);
			degree += newe[i];
		}
		newe[0] = degree;
		return new Evec (x.vs, newe);
	}
	public Evec mul (Evec other) {  // Used by Polynomial mul only
		Profile.tick ("Evec.mul");
		VarMap tm = this.unpack ();
		VarMap om = other.unpack ();
		// Collect all the maps
		VarMap work = new VarMap ();
		for (Variable x: tm.keys())
			work.addTo (x, tm.get(x));
		for (Variable x: om.keys())
			work.addTo (x, om.get(x));
		return new Evec (vs, work);
	}
	public VarSet getVarSet () { return vs; }
	public int [] getE () { return e; }
	public String toString () {
		String o = new String();
		boolean first = true;
		for (int i=0; i<e.length; i++) {
			if (!first)
				o += ":";
			first = false;
			o += String.format("%d", e[i]);
		}
		return o;
	}
	public String serialize () {
		return String.format ("e%s", toString());
	}
}
