
class A extends S {
	private int value;	
	public A (int x) { value = x; }
	public S addTo (S x) { return x.add (this); }
	public S mulTo (S x) { return x.mul (this); }
	public A add (A y) { return new A(value+y.value); }
	public A mul (A y) { return new A(value*y.value); }
	public S makeAFrom () { return new A(value); }
	public S makeBFrom () { return new B(value); }
	public SFactory addResultFactory(S y) { return y.addResultFactoryWithA(this); }
	public SFactory mulResultFactory(S y) { return y.mulResultFactoryWithA(this); }
	public SFactory addResultFactoryWithA(S x) { return new AFactory (x, this); }
	public SFactory addResultFactoryWithB(S x) { return new BFactory (x, this); }
	public SFactory mulResultFactoryWithA(S x) { return new AFactory (x, this); }
	public SFactory mulResultFactoryWithB(S x) { return new BFactory (x, this); }
	public String toString () { return Integer.toString(value); }
}
