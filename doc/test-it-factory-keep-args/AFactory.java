
class AFactory extends SFactory {
	public AFactory (S a, S b) { super (a,b); }
	public S makeFrom (S from) { return from.makeAFrom (); }
}
