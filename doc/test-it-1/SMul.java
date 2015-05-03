
class SMul implements SOp {
	public SMul () { }
	public S binOp (S x, S y) { return x.mul (y); }
	public SFactory binOpResultFactory (S x, S y) {
		return x.mulResultFactory (y);
	}
}
