
class BFactory extends SFactory {
	public BFactory (S a, S b) { super (a, b); }
	public S makeFrom (S from) { return from.makeBFrom (); }
}
