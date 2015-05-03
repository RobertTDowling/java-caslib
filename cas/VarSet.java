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

// VarSet
//   vs is array of variables in sorted order
//   vm[Variable]= 1-based index in Evec: vm[firstVar]=1
//
//   int index (Variable v) =  1-based index in Evec
//   Variable var (index) = return Var at that 1-based index

public class VarSet {
	private final int order;
	private final ArrayList<Variable> vs; // Ordered
	private final VarMap vm;   // For finding index quickly
	public VarSet () {
		Profile.tick ("VarSet.ctor()");
		vs = new ArrayList<Variable> ();
		vm = new VarMap ();
		order = 0;
	}
	public VarSet (VarSet v) {
		Profile.tick ("VarSet.ctor(VarSet)");
		vs = new ArrayList<Variable> ();
		for (Variable i: v.vs)
			vs.add(i);
		vm = new VarMap (v.vm);
		order = v.order;
	}
	public VarSet (Variable v) {
		Profile.tick ("VarSet.ctor(var)");
		vs = new ArrayList<Variable> ();
		vm = new VarMap ();
		vs.add (v);
		vm.put (v, 1);
		order = 1;
	}
	public VarSet (String s) { // Deserialize "vx:y:z"
		vs = new ArrayList<Variable> ();
		vm = new VarMap ();
		String [] sp = s.substring(1).split (":");
		int i = 0;
		for (String t: sp) {
			Variable v = new Variable (t);
			vs.add (v);
			vm.put (v, ++i);
		}
		order = i;
	}
	// Transcribe back into ArrayList in sorted order
	private int transcribe (VarMap m) {
		int i = 0;
		for (Variable v: m.sortKeys()) {
			vs.add(v);
			vm.put(v, ++i);
		}
		return i;
	}
	public VarSet (VarMap m) {
		Profile.tick ("VarSet.ctor(VarMap)");
		// Transcribe back into ArrayList in sorted order
		vs = new ArrayList<Variable> ();
		vm = new VarMap ();
		order = transcribe (m);
	}
	public VarSet (Variable[] a) {
		Profile.tick ("VarSet.ctor([])");
		// Make unique
		VarMap m = new VarMap();
		for (Variable v: a)
			m.addTo (v);
		// Transcribe back into ArrayList in sorted order
		vs = new ArrayList<Variable> ();
		vm = new VarMap ();
		order = transcribe (m);
	}
	public VarSet (ArrayList<Variable> a) {
		Profile.tick ("VarSet.ctor(AL<V>)");
		// Make unique
		VarMap m = new VarMap();
		for (Variable v: a)
			m.addTo (v);
		// Transcribe back into ArrayList in sorted order
		vs = new ArrayList<Variable> ();
		vm = new VarMap ();
		order = transcribe (m);
	}
	public VarSet (EvecMap l) {
		Profile.tick ("VarSet.ctor(EvecMap)");
		VarMap m = new VarMap();
		for (Evec e: l.keys()) {
			VarMap n = e.unpack();
			for (Variable f: n.keys()) {
				m.addTo (f);
			}
		}
		// Transcribe back into ArrayList in sorted order
		vs = new ArrayList<Variable> ();
		vm = new VarMap ();
		order = transcribe (m);
	}
	public VarSet union (VarSet b) {
		Profile.tick ("VarSet.union");
		// Make unique
		VarMap m = new VarMap();
		for (Variable v: this.vs)
			m.addTo (v);
		for (Variable v: b.vs)
			m.addTo (v);
	 	return new VarSet (m);
	}
	public VarSet remove (Variable v) {
		// Make a new varset with variable v removed
		ArrayList<Variable> nvl = new ArrayList<Variable> (vs);
		int index = index (v);
		if (index < 1) {
			// Failed, so nothign to remove
			return this;
		}
		nvl.remove(index-1);
		return new VarSet (nvl);
	}
	public int order () { return order; }
	public int index (Variable v) {
		Profile.tick ("VarSet.index");
//		System.out.print (String.format ("VarSet index vm='%s' ", vm.toString()));
//		System.out.print (String.format ("v=%s: ix=%d\n", v.toString(), vm.get(v) ));
		return vm.get(v); }
	public Variable var (int index) { return vs.get(index-1); }
	public ArrayList<Variable> vars () { return vs; }

	// Convert Evec src into a new Evec with 'this' VarSet
	public Evec remap (Evec src) {
		Profile.tick ("VarSet.remap(Evec)");
		VarSet that = src.getVarSet ();
		VarMap m = src.unpack ();
		return new Evec (this, m);
	}
	public Term remap (Term tsrc) {
		Profile.tick ("VarSet.remap(Term)");
		Evec src = tsrc.evec();
		VarSet that = src.getVarSet ();
		VarMap m = src.unpack ();
		return new Term (tsrc.coef(), new Evec (this, m));
	}
	public boolean equals (VarSet other) {
		return vs.equals (other.vs);
	}
	public String toString () {
		String o = "";
		for (Variable v: vs)
			o += String.format(",%s[%d]", v.toString(), vm.get(v));
		return o.length() > 0 ? o.substring(1) : o;
	}

	public String serialize () {
		String o = "v";
		boolean first = true;
		for (Variable v: vs) {
			if (!first)
				o += ":";
			first = false;
			o += String.format("%s", v.toString());
		}
		return o;
	}
}
