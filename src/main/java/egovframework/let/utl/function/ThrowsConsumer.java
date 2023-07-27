package egovframework.let.utl.function;

@FunctionalInterface
public interface ThrowsConsumer<T, E extends Exception> {

    void accept(T t) throws E;

}
