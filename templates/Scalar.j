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

import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.text.DateFormat;
import java.util.ArrayList;

public class Scalar extends Stackable {

	// boilerplate

	public boolean isScalar () { return true; }
	public double scalar () { return d; }
	public Stackable copy () { return new Scalar (d); }
	public String name () { return "Scalar"; }

	private double d;

	static public long longFrom(double x) {
		return Math.round(Math.floor(x));
	}

	static public long longFromRounded(double x) {
		return Math.round(x);
	}
    
	static public long gcd (long a, long b) {
		a = Math.abs(a);
		b = Math.abs(b);
		while (a>0 && b>0) {
			if (a<b) { long t=a; a=b; b=t; }
			a-=b;
		}
		return b < 1 ? 1 : b;
	}
    
	static public long lcm (long a, long b) {
		return a*b/gcd(a,b);
	}
    
	public Scalar () { d = 0; }
	public Scalar (double a) { d = a; }
	public Scalar (Scalar a) { d = a.d; }
	public Scalar (PrimeFactored a) { d = a.scalar(); }
	public Scalar (FactoredPolynomial a) { d = a.scalar(); }
	public Scalar (Polynomial a) { d = a.scalar(); }
	public Scalar (DomainErr a) { d = 0; }
	public Scalar (String s) { // Deserialize
		d = 0;
		if (s.startsWith ("s")) {
			s = s.substring(1);
			long l = Long.decode (s);
			d = Double.longBitsToDouble(l);
		}
	}
	public Scalar add (Scalar b) { return new Scalar (d + b.d); }
	public Scalar sub (Scalar b) { return new Scalar (d - b.d); }
	public Scalar mul (Scalar b) { return new Scalar (d * b.d); }
	public Scalar div (Scalar b) { return new Scalar (d / b.d); }
	public Scalar power (Scalar b) { return new Scalar (Math.pow (d, b.d));	}
	public Scalar colon (Scalar b) { return new Scalar (d + b.d/60); }
	public Scalar hm (Scalar b) { return new Scalar ((60*60)*(d + b.d/60)); }
	public Scalar md (Scalar b) {
		Scalar a = this;
		Date d = new Date ();
		GregorianCalendar g = new GregorianCalendar ();
		g.setTime(d);
		int y = g.get(Calendar.YEAR);
		g = new GregorianCalendar (y, (int)a.d-1, (int)b.d);
		double r = g.getTime().getTime()/1000.0;  // Convert Java ms to s
		return new Scalar (r);
	}
	public Scalar and (Scalar b) { return new Scalar (longFrom(d) & longFrom(b.d)); }
	public Scalar or (Scalar b) { return new Scalar (longFrom(d) | longFrom(b.d)); }
	public Scalar xor (Scalar b) { return new Scalar (longFrom(d) ^ longFrom(b.d)); }
	public Scalar ee (Scalar b) { return new Scalar (d*Math.pow(10.0, b.d)); }
	public Scalar gcd (Scalar b) { return new Scalar (gcd(longFromRounded(d), longFromRounded(b.d))); }
	public Scalar lcm (Scalar b) { return new Scalar (lcm(longFromRounded(d), longFromRounded(b.d))); }
	public Scalar [] divMod (Scalar b) {
		double q = d / b.d;
		double r = 0;
		return new Scalar [] { new Scalar(q), new Scalar(r) }; }
	public Stackable factor () {
		Stackable [] r = factorInZ ();
		return new PrimeFactored (r);
	}
	public Scalar expand () { return new Scalar (d); }
	public Scalar log2 () { return new Scalar (Math.log(d)/Math.log(2.0)); }
	public Scalar pow2 () { return new Scalar (Math.pow(2.0,d)); }
	public Scalar not () { return new Scalar (~longFrom(d)); }
	public Scalar floor () { return new Scalar (Math.floor(d)); }
	public Scalar addinv () { return new Scalar (-d); }
	public Scalar multinv () { return new Scalar (1.0/d); }
	public Scalar exp () { return new Scalar (Math.exp(d)); }
	public Scalar ln () { return new Scalar (Math.log(d)); }
	public Scalar sin () { return new Scalar (Math.sin(d)); }
	public Scalar cos () { return new Scalar (Math.cos(d)); }
	public Scalar tan () { return new Scalar (Math.tan(d)); }
	public Scalar arcsin () { return new Scalar (Math.asin(d)); }
	public Scalar arccos () { return new Scalar (Math.acos(d)); }
	public Scalar arctan () { return new Scalar (Math.atan(d)); }
	public Scalar d2r () { return new Scalar (d/(180.0/Math.PI)); }
	public Scalar r2d () { return new Scalar (d*(180.0/Math.PI)); }
	public Scalar sqrt () { return new Scalar (Math.sqrt(d)); }
	public Scalar squared () { return new Scalar (d*d); }
	public Scalar ceil () { return new Scalar (Math.ceil(d)); }
	public Scalar ceillog2 () { return new Scalar (Math.ceil(Math.log(d)/Math.log(2.0))); }
	public Scalar ceilpow2 () { return new Scalar (Math.round(Math.pow(2.0, Math.ceil(d)))); }
	public Scalar times2 () { return new Scalar (d*2); }
	public Scalar divide2 () { return new Scalar (d/2); }
	public Scalar round () { return new Scalar (Math.round(d)); }

	public boolean isZero () { return d == 0; }
	public boolean isNeg () { return d < 0; }
	public boolean isNotBad () {
		return !(Double.isNaN(d) || Double.isInfinite(d));
	}
	public double get () { return d; }
	public String toString () {
		String o = Double.toString(d); // String.format("%+f", d);
    		if (o.endsWith(".0"))
    			o = o.substring(0, o.length()-2);
		return o; //  do better later
	}

	public Scalar [] factorInZ () {
		ArrayList<Scalar> rl = new ArrayList<Scalar>();
		long a = (long) d;
		// Handle exceptions
		if (a < 0) {
			rl.add (new Scalar(-1));
			a = -a;
		}
		if (a == 0 || a == 1) {
			rl.add (new Scalar(1));
		}
		// Factor
		long t = 2;  // trial divisor (long will make this have a greater range too)
		while (a > 1) {
			if ((a % t) == 0) {
				rl.add(new Scalar(t));
				a /= t;
			}
			else {
				if (t == 2)
					t ++;
				else
					t += 2;
				if (t > a) {
					rl.add(new Scalar(a));
					break;
				}
			}
		}
		Scalar [] ra = new Scalar[rl.size()];
		int i = 0;
		for (Scalar s: rl)
			ra[i++] = s;
		return ra;
	}

	public String serialize () {
		long l = Double.doubleToRawLongBits(d);
		String o = String.format ("s%d", l);
		return o;
	}
}
