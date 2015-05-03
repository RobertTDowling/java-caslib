class Test {
	public static void main(String[] args) {
		runTest (new SAdd(), new A(1), new A(2));
		runTest (new SAdd(), new A(1), new B(2.5));
		runTest (new SAdd(), new B(1.5), new A(2));
		runTest (new SAdd(), new B(1.5), new B(2.5));
		runTest (new SMul(), new A(1), new A(2));
		runTest (new SMul(), new A(1), new B(2.5));
		runTest (new SMul(), new B(1.5), new A(2));
		runTest (new SMul(), new B(1.5), new B(2.5));
	}
	private static void runTest (SOp o, S a, S b) {
		SFactory t = o.binOpResultFactory (a, b);
		S aa = t.makeFrom(a);
		S bb = t.makeFrom(b);
		S c = o.binOp(aa, bb);
		System.out.print (String.format ("a=%s aa=%s\n",
						 a.toString(), aa.toString()));
		System.out.print (String.format ("b=%s bb=%s\n",
						 b.toString(), bb.toString()));
		System.out.print (String.format ("c=%s\n",
						 c.toString()));
	}
}

