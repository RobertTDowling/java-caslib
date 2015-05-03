
class AddBinOp implements BinOp {
	public AddBinOp () { }
	public S binOp (S x, S y) { return y.addTo (x); }
	public SFactory binOpResultFactory (S x, S y) {
		return x.addResultFactory (y);
	}
}
