
class BFactory implements SFactory {
	public S makeFrom (S from) { return from.makeBFrom (); }
}
