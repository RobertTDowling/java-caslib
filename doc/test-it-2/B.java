
class B implements S {
	private double value;	
	public B (double x) { value = x; }
	public S addTo (S x) { return x.addB (this); }
	public S mulTo (S x) { return x.mulB (this); }
	public A addA (A y) { return null; }
	public A mulA (A y) { return null; }
	public B addB (B y) { return new B(value+y.value); }
	public B mulB (B y) { return new B(value*y.value); }
	public S makeAFrom () { return new A((int)value); }
	public S makeBFrom () { return new B(value); }
	public SFactory addResultFactory(S y) { return y.addResultFactoryWithB(); }
	public SFactory mulResultFactory(S y) { return y.mulResultFactoryWithB(); }
	public SFactory addResultFactoryWithA() { return new BFactory (); }
	public SFactory addResultFactoryWithB() { return new BFactory (); }
	public SFactory mulResultFactoryWithA() { return new BFactory (); }
	public SFactory mulResultFactoryWithB() { return new BFactory (); }
	public String toString () { return Double.toString(value); }
}
