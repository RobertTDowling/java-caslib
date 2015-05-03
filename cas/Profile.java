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
import java.util.TreeSet;

public class Profile {
	static private HashMap<String,Integer> h;
	public Profile () {
		h = new HashMap<String,Integer> ();
	}
	static public void tick (String k) {
        if (h == null)
            return;
		if (h.containsKey (k))
			h.put(k, 1+h.get(k));
		else
			h.put(k, 1);
	}
	static public TreeSet<String> sortKeys () {
		TreeSet<String> t = new TreeSet<String>(new ProfileComparer(h));
		for (String s: h.keySet()) {
			t.add (s);
		}
		return t;
	}
	static public void stats () {
		for (String s: sortKeys()) {
			System.out.print (String.format ("%8d %s\n",
							 h.get(s), s));
		}
	}
}
