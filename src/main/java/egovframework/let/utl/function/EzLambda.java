package egovframework.let.utl.function;

import java.util.function.Consumer;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.function.Supplier;

/**
 * 함수형 프로그래밍을 돕는 유틸리티 클래스입니다.<br>
 * Java 8의 람다와 함수형 인터페이스를 편리하게 사용할 수 있도록 돕는 static 메소드를 제공합니다.<br>
 *
 * @author Jaewon Seo
 */
public final class EzLambda {

    /**
     * 예외를 던질 수 있는 Function을 래핑합니다.
     *
     * @param function 예외를 던질 수 있는 Function
     * @return 같은 입력을 받고 같은 결과를 반환하지만, 던져진 모든 예외를 WrappedException(Unchecked)으로 던지는 Function입니다.
     */
    public static <T, R, E extends Exception> Function<T, R> wrapThrowingFunction(ThrowsFunction<T, R, E> function) {
        return t -> {
            try {
                return function.apply(t);
            } catch (Exception e) {
                throw new WrappedException(e);
            }
        };
    }

    /**
     * 예외를 던질 수 있는 Predicate를 래핑합니다.
     *
     * @param predicate 예외를 던질 수 있는 Predicate
     * @return 같은 입력을 받지만, 던져진 모든 예외를 WrappedException(Unchecked)으로 던지는 Predicate입니다.
     */
    public static <T, E extends Exception> Predicate<T> wrapThrowingPredicate(ThrowsPredicate<T, E> predicate) {
        return t -> {
            try {
                return predicate.test(t);
            } catch (Exception e) {
                throw new WrappedException(e);
            }
        };
    }

    /**
     * 예외를 던질 수 있는 Consumer를 래핑합니다.
     *
     * @param consumer 예외를 던질 수 있는 Consumer
     * @return 같은 입력을 받지만, 던져진 모든 예외를 WrappedException(Unchecked)으로 던지는 Consumer입니다.
     */
    public static <T, E extends Exception> Consumer<T> wrapThrowingConsumer(ThrowsConsumer<T, E> consumer) {
        return t -> {
            try {
                consumer.accept(t);
            } catch (Exception e) {
                throw new WrappedException(e);
            }
        };
    }

    /**
     * 예외를 던질 수 있는 Supplier를 래핑합니다.
     *
     * @param supplier 예외를 던질 수 있는 Supplier
     * @return 같은 입력을 받지만, 던져진 모든 예외를 WrappedException(Unchecked)으로 던지는 Supplier입니다.
     */
    public static <T, E extends Exception> Supplier<T> wrapThrowingSupplier(ThrowsSupplier<T, E> supplier) {
        return () -> {
            try {
                return supplier.get();
            } catch (Exception e) {
                throw new WrappedException(e);
            }
        };
    }

    public static class WrappedException extends RuntimeException {
        public WrappedException(Throwable cause) {
            super(cause.toString(), cause, true, false);
        }
    }

}
