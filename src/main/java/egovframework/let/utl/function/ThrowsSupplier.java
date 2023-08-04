package egovframework.let.utl.function;

@FunctionalInterface
public interface ThrowsSupplier<T, E extends Exception> {

    T get() throws E;

}
