
interface S {
	public S add (S y);
	public S mul (S y);
	public S makeAFrom ();
	public S makeBFrom ();
	public SFactory addResultFactory(S y);
	public SFactory mulResultFactory(S y);
	public SFactory addResultFactoryWithA();
	public SFactory addResultFactoryWithB();
	public SFactory mulResultFactoryWithA();
	public SFactory mulResultFactoryWithB();
	public String toString ();
}
