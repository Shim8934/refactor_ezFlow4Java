package egovframework.let.utl.function;

import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.util.function.Consumer;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.function.Supplier;

import static org.assertj.core.api.Assertions.*;

public class EzLambdaTest {

    @Test
    void testWrapThrowingFunction() {
        Function<Integer, Integer> throwingFunction = EzLambda.wrapThrowingFunction(value -> {
            if (value == 0) {
                throw new IOException("Value must not be 0");
            }
            return value * 2;
        });

        // Function works normally
        assertThat(throwingFunction.apply(2)).isEqualTo(4);

        // Function throws exception
        assertThatThrownBy(() -> throwingFunction.apply(0)).isInstanceOf(EzLambda.WrappedException.class);
    }

    @Test
    void testWrapThrowingPredicate() {
        Predicate<Integer> throwingPredicate = EzLambda.wrapThrowingPredicate(value -> {
            if (value <= 0) {
                throw new IOException("Value must be greater than 0");
            }
            return value > 10;
        });

        // Predicate works normally
        assertThat(throwingPredicate.test(20)).isTrue();

        // Predicate throws exception
        assertThatThrownBy(() -> throwingPredicate.test(0)).isInstanceOf(EzLambda.WrappedException.class);
    }

    @Test
    void testWrapThrowingConsumer() {
        Consumer<Integer> throwingConsumer = EzLambda.wrapThrowingConsumer(value -> {
            if (value == 0) {
                throw new IOException("Value must not be 0");
            }
        });

        // Consumer works normally
        assertThatCode(() -> throwingConsumer.accept(2)).doesNotThrowAnyException();

        // Consumer throws exception
        assertThatThrownBy(() -> throwingConsumer.accept(0)).isInstanceOf(EzLambda.WrappedException.class);
    }

    @Test
    void testWrapThrowingSupplier() {
        Supplier<Integer> throwingSupplier = EzLambda.wrapThrowingSupplier(() -> {
            throw new IOException("Error in supplying value");
        });

        // Supplier throws exception
        assertThatThrownBy(throwingSupplier::get).isInstanceOf(EzLambda.WrappedException.class);
    }

}
