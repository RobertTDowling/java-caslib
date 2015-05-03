class Test {
	public static void main(String[] args) {
		runTest (new AddBinOp(), new A(1), new A(2));
		runTest (new AddBinOp(), new A(1), new B(2.5));
		runTest (new AddBinOp(), new B(1.5), new A(2));
		runTest (new AddBinOp(), new B(1.5), new B(2.5));
		runTest (new MulBinOp(), new A(1), new A(2));
		runTest (new MulBinOp(), new A(1), new B(2.5));
		runTest (new MulBinOp(), new B(1.5), new A(2));
		runTest (new MulBinOp(), new B(1.5), new B(2.5));
	}
	private static void runTest (BinOp o, S a, S b) {
		SFactory t = o.binOpResultFactory (a, b);
		S aa = t.makeFrom(a);
		S bb = t.makeFrom(b);
		S c = o.binOp(aa, bb);
		System.out.print (String.format ("t.args[0]=%s t.args[1]=%s\n",
						 t.args[0].toString(),
						 t.args[1].toString()));
		System.out.print (String.format ("a=%s aa=%s\n",
						 a.toString(), aa.toString()));
		System.out.print (String.format ("b=%s bb=%s\n",
						 b.toString(), bb.toString()));
		System.out.print (String.format ("c=%s\n",
						 c.toString()));
	}
}

