import com.rtdti.cas.*;
import java.util.ArrayList;

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


class AllFactors {
	public static ArrayList<Polynomial> joey () {
		ArrayList<Polynomial> divisors = new ArrayList<Polynomial>();
		ArrayList<Integer> exp = new ArrayList<Integer>();
		ArrayList<Integer> trial = new ArrayList<Integer>();
		ArrayList<Polynomial> base = new ArrayList<Polynomial>();

		base.add (new Polynomial (new Scalar (2)));
		exp.add (new Integer(2));

		base.add (new Polynomial (new Scalar (3)));
		exp.add (new Integer(1));

		base.add (new Polynomial (new Variable ("x")));
		exp.add (new Integer(2));

		base.add (new Polynomial (new Variable ("y")));
		exp.add (new Integer(1));

		for (Integer i: exp) {
			trial.add (new Integer(0));
		}

		int divisorCount = exp.size();

		// Lexicographic order on jj
		Polynomial negone = new Polynomial (new Scalar (-1));
		int i = 0;
		while (i < divisorCount) {
			Polynomial p = new Polynomial (new Scalar(1));
			for (i=0; i<divisorCount; i++) {
				for (int j=0; j<trial.get(i); j++) {
					p = p.mul(base.get(i));
				}
			}

			divisors.add (p);
			// divisors.add (p.mul(negone));

			// Compute next trial
			for (i=0; i<divisorCount; i++) {
				trial.set(i, trial.get(i) + 1);
				if (trial.get(i) <= exp.get(i)) {
					break;
				}
				trial.set(i, 0);
			}
		}
		// System.out.print (String.format ("divisors = %s", divisors.toString()));
		return divisors;
	}
	public static ArrayList<Polynomial> fkin () {
		ArrayList<Polynomial> divisors = new ArrayList<Polynomial>();
		ArrayList<Integer> exp = new ArrayList<Integer>();
		ArrayList<Integer> trial = new ArrayList<Integer>();
		ArrayList<Polynomial> base = new ArrayList<Polynomial>();

		base.add (new Polynomial (new Scalar (2)));
		exp.add (new Integer(3));

		base.add (new Polynomial (new Scalar (3)));
		exp.add (new Integer(2));

		base.add (new Polynomial (new Variable ("x")));
		exp.add (new Integer(3));

		base.add (new Polynomial (new Variable ("y")));
		exp.add (new Integer(2));

		base.add (new Polynomial (new Variable ("z")));
		exp.add (new Integer(1));

		for (Integer i: exp) {
			trial.add (new Integer(0));
		}

		int divisorCount = exp.size();

		// Lexicographic order on jj
		Polynomial negone = new Polynomial (new Scalar (-1));
		int i = 0;
		while (i < divisorCount) {
			Polynomial p = new Polynomial (new Scalar(1));
			for (i=0; i<divisorCount; i++) {
				for (int j=0; j<trial.get(i); j++) {
					p = p.mul(base.get(i));
				}
			}

			divisors.add (p);
			// divisors.add (p.mul(negone));

			// Compute next trial
			for (i=0; i<divisorCount; i++) {
				trial.set(i, trial.get(i) + 1);
				if (trial.get(i) <= exp.get(i)) {
					break;
				}
				trial.set(i, 0);
			}
		}
		// System.out.print (String.format ("divisors = %s", divisors.toString()));
		return divisors;
	}
	public static ArrayList<Polynomial> ramone () {
		ArrayList<Polynomial> divisors = new ArrayList<Polynomial>();
		ArrayList<Integer> exp = new ArrayList<Integer>();
		ArrayList<Integer> trial = new ArrayList<Integer>();
		ArrayList<Polynomial> base = new ArrayList<Polynomial>();

		base.add (new Polynomial (new Scalar (2)));
		exp.add (new Integer(1));

		base.add (new Polynomial (new Variable ("x")));
		exp.add (new Integer(1));

		base.add (new Polynomial (new Variable ("y")));
		exp.add (new Integer(1));

		for (Integer i: exp) {
			trial.add (new Integer(0));
		}

		int divisorCount = exp.size();

		// Lexicographic order on jj
		Polynomial negone = new Polynomial (new Scalar (-1));
		int i = 0;
		while (i < divisorCount) {
			Polynomial p = new Polynomial (new Scalar(1));
			for (i=0; i<divisorCount; i++) {
				for (int j=0; j<trial.get(i); j++) {
					p = p.mul(base.get(i));
				}
			}

			divisors.add (p);
			// divisors.add (p.mul(negone));

			// Compute next trial
			for (i=0; i<divisorCount; i++) {
				trial.set(i, trial.get(i) + 1);
				if (trial.get(i) <= exp.get(i)) {
					break;
				}
				trial.set(i, 0);
			}
		}
		// System.out.print (String.format ("divisors = %s", divisors.toString()));
		return divisors;
	}
	public static void main(String[] args) {	
		if (System.console() != null)
			System.out.print (Stackable.version + "\n");
		new Profile ();
		ArrayList<Polynomial> a = joey ();
		ArrayList<Polynomial> b = ramone ();
		System.out.print (String.format ("We have %d in a\n", a.size()));
		
		Polynomial p, q, r;
		Stackable y;
		for (Polynomial f: a) {
			for (Polynomial g: a) {
				p = f.add(g);
				//				System.out.print (String.format ("%s\n", p.toString()));
				//				/*
				for (Polynomial h: b) {
					for (Polynomial i: b) {
						q = h.add(i);
						r = p.mul(q);
						y = r.factor();
					System.out.print (String.format ("%s=(%s)(%s)=%s\n", r.toString(), p.toString(), q.toString(), y.toString()));
						q = h.sub(i);
						// System.out.print (String.format ("%s\n", q.toString()));
						r = p.mul(q);
						y = r.factor();
					System.out.print (String.format ("%s=(%s)(%s)=%s\n", r.toString(), p.toString(), q.toString(), y.toString()));
					}
				}
				//				*/
				p = f.sub(g);
				//				System.out.print (String.format ("%s\n", p.toString()));
				//				/*
				for (Polynomial h: b) {
					for (Polynomial i: b) {
						q = h.add(i);
						// System.out.print (String.format ("%s\n", q.toString()));
						r = p.mul(q);
						y = r.factor();
					System.out.print (String.format ("%s=(%s)(%s)=%s\n", r.toString(), p.toString(), q.toString(), y.toString()));
						q = h.sub(i);
						// System.out.print (String.format ("%s\n", q.toString()));
						r = p.mul(q);
						y = r.factor();
					System.out.print (String.format ("%s=(%s)(%s)=%s\n", r.toString(), p.toString(), q.toString(), y.toString()));
					}
				}
				//				*/
			}
		}
	}
}
