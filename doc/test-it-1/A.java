
class A implements S {
	private int value;	
	public A (int x) { value = x; }
	public S makeAFrom () { return new A(value); }
	public S makeBFrom () { return new B(value); }
	private A add (A y) { return new A(value+y.value); }
	private A mul (A y) { return new A(value*y.value); }
	public S add (S y) { return (S) add ((A) y); }
	public S mul (S y) { return (S) mul ((A) y); }
	public SFactory addResultFactory(S y) { return y.addResultFactoryWithA(); }
	public SFactory mulResultFactory(S y) { return y.mulResultFactoryWithA(); }
	public SFactory addResultFactoryWithA() { return new AFactory (); }
	public SFactory addResultFactoryWithB() { return new BFactory (); }
	public SFactory mulResultFactoryWithA() { return new AFactory (); }
	public SFactory mulResultFactoryWithB() { return new BFactory (); }
	public String toString () { return Integer.toString(value); }
}
