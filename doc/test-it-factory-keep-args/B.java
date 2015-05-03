
class B extends S {
	private double value;	
	public B (double x) { value = x; }
	public S addTo (S x) { return x.add (this); }
	public S mulTo (S x) { return x.mul (this); }
	public B add (B y) { return new B(value+y.value); }
	public B mul (B y) { return new B(value*y.value); }
	public S makeAFrom () { return new A((int)value); }
	public S makeBFrom () { return new B(value); }
	public SFactory addResultFactory(S y) { return y.addResultFactoryWithB(this); }
	public SFactory mulResultFactory(S y) { return y.mulResultFactoryWithB(this); }
	public SFactory addResultFactoryWithA(S x) { return new BFactory (x, this); }
	public SFactory addResultFactoryWithB(S x) { return new BFactory (x, this); }
	public SFactory mulResultFactoryWithA(S x) { return new BFactory (x, this); }
	public SFactory mulResultFactoryWithB(S x) { return new BFactory (x, this); }
	public String toString () { return Double.toString(value); }
}
