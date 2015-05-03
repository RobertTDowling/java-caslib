
class SAdd implements SOp {
	public SAdd () { }
	public S binOp (S x, S y) { return x.add (y); }
	public SFactory binOpResultFactory (S x, S y) {
		return x.addResultFactory (y);
	}
}
