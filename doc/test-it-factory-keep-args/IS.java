
interface IS {
	public S addTo (S x);
	public S mulTo (S x);
	public S makeAFrom ();
	public S makeBFrom ();
	public SFactory addResultFactory(S y);
	public SFactory mulResultFactory(S y);
	public SFactory addResultFactoryWithA(S x);
	public SFactory addResultFactoryWithB(S x);
	public SFactory mulResultFactoryWithA(S x);
	public SFactory mulResultFactoryWithB(S x);
	public String toString ();
}
