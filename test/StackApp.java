import java.util.Scanner;
import java.util.Stack;
import com.rtdti.cas.*;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

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

class StackApp {
	private static MyStack stack;
	private static Stackable doBinOp (BinOp o, Stackable a, Stackable b) {
		SFactory t = o.binOpResultFactory (a,b);
		Stackable c = o.binOp (t);
		return c;
	}
	private static Stackable [] doBinOp2 (BinOp2 o, Stackable a, Stackable b) {
		SFactory t = o.binOp2ResultFactory (a,b);
		Stackable [] c = o.binOp2 (t);
		return c;
	}
	private static Stackable doUnOp (UnOp o, Stackable a) {
		SFactory t = o.unOpResultFactory (a);
		Stackable c = o.unOp (t);
		return c;
	}
	public static void main(String[] args) {	
		if (System.console() != null)
			System.out.print (Stackable.version + "\n");
		new Profile ();
		stack = new MyStack ();
		Scanner in = new Scanner(System.in);
		while (in.hasNext()) {
			if (in.hasNextDouble()) {
				double d = in.nextDouble();
				// System.out.print (String.format("double=%f\n", d));
				Scalar s = new Scalar (d);
				stack.push(s); // new Polynomial(s));
			} else {
				String line = in.next();
				// System.out.print(String.format("line='%s'\n", line));
				if (line.equals("+")) {
					BinOp o = new Add();
					Stackable b = stack.pop();
					Stackable a = stack.pop();
					stack.push(doBinOp (o, a, b));
				}
				else if (line.equals("-")) {
					BinOp o = new Sub();
					Stackable b = stack.pop();
					Stackable a = stack.pop();
					stack.push(doBinOp (o, a, b));
				}
				else if (line.equals("*")) {
					BinOp o = new Mul();
					Stackable b = stack.pop();
					Stackable a = stack.pop();
					stack.push(doBinOp (o, a, b));
				}
				else if (line.equals("/")) {
					BinOp2 o = new DivMod();
					Stackable b = stack.pop();
					Stackable a = stack.pop();
					Stackable [] c = doBinOp2 (o, a, b);
					stack.push(c[0]);
					stack.push(c[1]);
				}
				else if (line.equals("^")) {
					BinOp o = new Power();
					Stackable b = stack.pop();
					Stackable a = stack.pop();
					stack.push(doBinOp (o, a, b));
				}
				else if (line.equals("D")) {
					Stackable a = stack.pop();
				}
				else if (line.equals("E")) {
					Polynomial a = (Polynomial) stack.pop();
					Polynomial b = (Polynomial) stack.pop();
					Stackable [] c = b.expressIn (a);
					for (Stackable s: c) {
						stack.push (s);
					}
				}
				else if (line.equals("F")) {
					UnOp o = new Factor ();
				 	Stackable a = stack.pop();
					stack.push(doUnOp (o, a));
				}
				else if (line.equals("X")) {
					UnOp o = new Expand ();
				 	Stackable a = stack.pop();
					stack.push(doUnOp (o, a));
				}
				else if (line.equals("R")) {
				 	Stackable a = stack.pop();
					if (a.isScalar())
						a = new Scalar(a.scalar());
					stack.push(a);
				}
				else if (line.equals("$")) {
				 	Stackable a = stack.pop();
					stack.push(a);
					System.out.print (String.format ("Serialize=%s\n", a.serialize()));
				}
				else if (line.equals("%")) {
				 	Stackable a = stack.pop();
					Stackable b = Deserialize.deserialize (a.toString());
					// System.out.print (String.format ("Deser '%s' got %s\n", a.toString(), b.toString()));
					stack.push(b);
				}
				else if (line.equals("G")) {
				 	Stackable x = stack.pop();
				 	Polynomial pv = (Polynomial) stack.pop();
					Variable v = new Variable ("x");
				 	Polynomial f = (Polynomial) stack.pop();
				 	Stackable c = f.evalAt (v, x);
					stack.push (c);
				}
				else if (line.equals(".")) {
					Stackable a = stack.pop();
					System.out.print (String.format ("%s\n", a.toString()));
				}
				else if (line.equals("U")) {
					Stackable a = stack.pop();
					stack.push(a);
					Stackable b = a.copy ();
					stack.push(b);
				}
				else if (line.equals("S")) {
					Stackable b = stack.pop();
					Stackable a = stack.pop();
					stack.push(b);
					stack.push(a);
				}
				else if (line.equals(":gcd")) { Stackable b=stack.pop(); stack.push (doBinOp (new Gcd(), stack.pop(), b)); }
				else if (line.equals(":lcm")) { Stackable b=stack.pop(); stack.push (doBinOp (new Lcm(), stack.pop(), b)); }
				else if (line.equals(":and")) { Stackable b=stack.pop(); stack.push (doBinOp (new Add(), stack.pop(), b)); }
				else if (line.equals(":or")) { Stackable b=stack.pop(); stack.push (doBinOp (new Or(), stack.pop(), b)); }
				else if (line.equals(":xor")) { Stackable b=stack.pop(); stack.push (doBinOp (new Xor(), stack.pop(), b)); }
				else if (line.equals(":ee")) { Stackable b=stack.pop(); stack.push (doBinOp (new Ee(), stack.pop(), b)); }
				else if (line.equals(":")) { Stackable b=stack.pop(); stack.push (doBinOp (new Colon(), stack.pop(), b)); }
				else if (line.equals(":hm")) { Stackable b=stack.pop(); stack.push (doBinOp (new Hm(), stack.pop(), b)); }
				else if (line.equals(":md")) { Stackable b=stack.pop(); stack.push (doBinOp (new Md(), stack.pop(), b)); }

				else if (line.equals(":not")) { stack.push (doUnOp (new Not(), stack.pop())); }
				else if (line.equals(":addinv")) { stack.push (doUnOp (new Addinv(), stack.pop())); }
				else if (line.equals(":multinv")) { stack.push (doUnOp (new Multinv(), stack.pop())); }
				else if (line.equals(":ln")) { stack.push (doUnOp (new Ln(), stack.pop())); }
				else if (line.equals(":exp")) { stack.push (doUnOp (new Exp(), stack.pop())); }
				else if (line.equals(":log2")) { stack.push (doUnOp (new Log2(), stack.pop())); }
				else if (line.equals(":pow2")) { stack.push (doUnOp (new Pow2(), stack.pop())); }
				else if (line.equals(":floor")) { stack.push (doUnOp (new Floor(), stack.pop())); }
				else if (line.equals(":ceil")) { stack.push (doUnOp (new Ceil(), stack.pop())); }
				else if (line.equals(":round")) { stack.push (doUnOp (new Round(), stack.pop())); }
				else if (line.equals(":sin")) { stack.push (doUnOp (new Sin(), stack.pop())); }
				else if (line.equals(":cos")) { stack.push (doUnOp (new Cos(), stack.pop())); }
				else if (line.equals(":tan")) { stack.push (doUnOp (new Tan(), stack.pop())); }
				else if (line.equals(":asin")) { stack.push (doUnOp (new Arcsin(), stack.pop())); }
				else if (line.equals(":acos")) { stack.push (doUnOp (new Arccos(), stack.pop())); }
				else if (line.equals(":atan")) { stack.push (doUnOp (new Arctan(), stack.pop())); }
				else if (line.equals(":d2r")) { stack.push (doUnOp (new D2r(), stack.pop())); }
				else if (line.equals(":r2d")) { stack.push (doUnOp (new R2d(), stack.pop())); }
				else if (line.equals(":sqrt")) { stack.push (doUnOp (new Sqrt(), stack.pop())); }
				else if (line.equals(":squared")) { stack.push (doUnOp (new Squared(), stack.pop())); }
				else if (line.equals(":2*")) { stack.push (doUnOp (new Times2(), stack.pop())); }
				else if (line.equals(":2/")) { stack.push (doUnOp (new Divide2(), stack.pop())); }
				else if (line.equals("?")) {
					System.out.print ("+-*/^ Drop dUp Swap Factor :\n");
					System.out.print (":{gcd,lcm,and,or,xor,ee,hm,md} BinOps\n");
					System.out.print (":{not,addinv,multinv,ln,exp,log2,pow2,floor,ceil,round,sqrt,squared,2*,2/} UnOps\n");
					System.out.print (":{sin,cos,tan,asin,acos,atan,d2r,r2d} UnOps\n");
				}
				else {
					Variable x = new Variable (line);
					Stackable a = new Polynomial(x);
					stack.push(a);
				}
			}
			if (System.console() != null)
				stack.dumpStack ();
		}
		// Profile.stats ();
	}
}
