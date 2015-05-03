
class NegUnOp implements UnOp {
	public NegUnOp () { }
	public S unOp (S x) { return x.neg(); }
	public SFactory unOpResultFactory (S x) {
		return x.negResultFactory ();
	}
}
