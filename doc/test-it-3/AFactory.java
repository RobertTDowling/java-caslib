
class AFactory implements SFactory {
	public S makeFrom (S from) { return from.makeAFrom (); }
}
