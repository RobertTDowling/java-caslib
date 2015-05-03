
class A implements S {
	private int value;	
	public A (int x) { value = x; }
	public S addTo (S x) { return x.addA (this); }
	public S mulTo (S x) { return x.mulA (this); }
	public A addA (A y) { return new A(value+y.value); }
	public A mulA (A y) { return new A(value*y.value); }
	public B addB (B y) { return null; }
	public B mulB (B y) { return null; }
	public S makeAFrom () { return new A(value); }
	public S makeBFrom () { return new B(value); }
	public SFactory addResultFactory(S y) { return y.addResultFactoryWithA(); }
	public SFactory mulResultFactory(S y) { return y.mulResultFactoryWithA(); }
	public SFactory addResultFactoryWithA() { return new AFactory (); }
	public SFactory addResultFactoryWithB() { return new BFactory (); }
	public SFactory mulResultFactoryWithA() { return new AFactory (); }
	public SFactory mulResultFactoryWithB() { return new BFactory (); }
	public String toString () { return Integer.toString(value); }
}
