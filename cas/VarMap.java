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

// VarMap
//    Maps Variables to Integers, through their strings.
//    Keeps String->Var lookup and String->Int lookup tables

public class VarMap {
	private HashMap<String,Integer> pm;
	private HashMap<String,Variable> vm;
	public VarMap () {
		Profile.tick ("VarMap.ctor()");
		pm = new HashMap<String,Integer> ();
		vm = new HashMap<String,Variable> ();
	}
	public VarMap (VarMap m) {
		Profile.tick ("VarMap.ctor(VarMap)");
		pm = new HashMap<String,Integer> ();
		vm = new HashMap<String,Variable> ();
		for (String s: m.pm.keySet()) {
			pm.put (s, m.pm.get(s));
			vm.put (s, m.vm.get(s));
		}
	}
	public void addTo (Variable v) {
		Profile.tick ("VarMap.addTo");
		addTo (v, 1);
	}
	public void addTo (Variable v, int p) {
		Profile.tick ("VarMap.addTo");
		String k = v.toString();
		if (pm.containsKey (k))
			pm.put(k, p+pm.get(k));
		else {
			pm.put(k, p);
			vm.put(k, v);
		}
	}
	public void put (Variable v, int i) {
		Profile.tick ("VarMap.put");
		String k = v.toString();
		pm.put (k, i);
		vm.put (k, v);
	}
	public int get (Variable v) {
		Profile.tick ("VarMap.get");
		String k = v.toString();
//		System.out.print (String.format("VarMap get Search v=%s\n", v.toString()));
//		dumpo ();
		if (pm.containsKey (k)) {
//			System.out.print (String.format("  success v=%s\n", v.toString()));
			return pm.get(k);
		}
//		System.out.print (String.format("   failure v=%s\n", v.toString()));
		return 0;
	}
	public void remove (Variable v) {
		Profile.tick ("VarMap.remove");
		String k = v.toString();
		if (pm.containsKey (k)) {
			pm.remove (k);
			vm.remove (k);
		}
	}
	public Set<Variable> keys () {
		return sortKeys ();
	}
	public TreeSet<Variable> sortKeys () {
		Profile.tick ("VarMap.sortKeys");
		TreeSet<Variable> t = new TreeSet<Variable>(new VarComparer());
		for (String s: pm.keySet()) {
//			System.out.print (String.format("VarMap sortkeys: s=%s p=%d v=%s\n", s, pm.get(s), vm.get(s)));
			t.add (vm.get(s));
		}
//		System.out.print (String.format("VarMap sortkeys's is done\n"));
		return t;
	}
	public String toString () {
		String o = "";
		for (Variable v: sortKeys())
			o += String.format(",%s^%d", v.toString(), get(v));;
		return o.length() > 0 ? o.substring(1) : o;
	}
	private void dumpo () {
		System.out.print (String.format("VarMap Dumpo pm{"));
		Set<String> s = pm.keySet();
		for (String t: s) {
			System.out.print (String.format("...%s", t));
		}
		System.out.print (String.format("} vm{"));
		s = vm.keySet();
		for (String t: s) {
			System.out.print (String.format("...%s", t));
		}
		System.out.print (String.format("}\n", s));
	}
}

