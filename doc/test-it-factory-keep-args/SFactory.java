
abstract class SFactory {
	public final S [] args;
	public SFactory (S a, S b) { args = new S [] { a, b }; }
	abstract public S makeFrom (S from);
}
