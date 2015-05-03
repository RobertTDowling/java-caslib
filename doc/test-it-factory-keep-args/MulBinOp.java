
class MulBinOp implements BinOp {
	public MulBinOp () { }
	public S binOp (S x, S y) { return y.mulTo (x); }
	public SFactory binOpResultFactory (S x, S y) {
		return x.mulResultFactory (y);
	}
}
