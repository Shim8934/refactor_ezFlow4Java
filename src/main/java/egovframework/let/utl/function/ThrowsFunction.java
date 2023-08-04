package egovframework.let.utl.function;

@FunctionalInterface
public interface ThrowsFunction<T, R, E extends Exception> {

    R apply(T t) throws E;

}
