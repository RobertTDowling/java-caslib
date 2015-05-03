
class B implements S {
	private double value;	
	public B (double x) { value = x; }
	public S makeAFrom () { return new A((int)value); }
	public S makeBFrom () { return new B(value); }
	private B add (B y) { return new B(value+y.value); }
	private B mul (B y) { return new B(value*y.value); }
	public S add (S y) { return (S) add ((B) y); }
	public S mul (S y) { return (S) mul ((B) y); }
	public SFactory addResultFactory(S y) { return y.addResultFactoryWithB(); }
	public SFactory mulResultFactory(S y) { return y.mulResultFactoryWithB(); }
	public SFactory addResultFactoryWithA() { return new BFactory (); }
	public SFactory addResultFactoryWithB() { return new BFactory (); }
	public SFactory mulResultFactoryWithA() { return new BFactory (); }
	public SFactory mulResultFactoryWithB() { return new BFactory (); }
	public String toString () { return Double.toString(value); }
}
