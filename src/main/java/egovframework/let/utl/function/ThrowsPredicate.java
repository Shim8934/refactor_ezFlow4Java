package egovframework.let.utl.function;

@FunctionalInterface
public interface ThrowsPredicate<T, E extends Exception> {

    boolean test(T t) throws E;

}
