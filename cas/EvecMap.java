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

public class EvecMap {
	private HashMap<String,Scalar> sm;
	private HashMap<String,Evec> em;
	public EvecMap () {
		Profile.tick ("EvecMap.ctor()");
		sm = new HashMap<String,Scalar> ();
		em = new HashMap<String,Evec> ();
	}
	public void addTo (Scalar s, Evec e) {
		Profile.tick ("EvecMap.addTo");
		String k = e.toString();
		if (sm.containsKey (k))
			sm.put(k, s.add(sm.get(k)));
		else {
			sm.put(k, s);
			em.put(k, e);
		}
	}
	public void put (Scalar s, Evec e) {
		Profile.tick ("EvecMap.put");
		String k = e.toString();
		sm.put (k, s);
		em.put (k, e);
	}
	public Scalar get (Evec e) {
		Profile.tick ("EvecMap.get");
		String k = e.toString();
		if (sm.containsKey (k)) {
			return sm.get(k);
		}
		return new Scalar (0);
	}
	public Set<Evec> keys () {
		return sortKeys ();
	}
	public TreeSet<Evec> sortKeys () {
		Profile.tick ("EvecMap.sortKeys");
		TreeSet<Evec> t = new TreeSet<Evec>(new EvecComparer());
		for (String s: sm.keySet()) {
			t.add (em.get(s));
		}
		return t;
	}
	public void remove (Evec e) {
		String k = e.toString();
		if (sm.containsKey (k)) {
			sm.remove(k);
		}
	}
	public String toString () {
		String o = "";
		for (Evec e: sortKeys())
			o += String.format("+(%s*%s)", get(e), e.toString());
		return o.length() > 0 ? o.substring(1) : o;
	}
}
