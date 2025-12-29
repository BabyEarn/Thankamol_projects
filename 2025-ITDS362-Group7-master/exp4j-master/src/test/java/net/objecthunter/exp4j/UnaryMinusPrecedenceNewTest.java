/* Copyright (C) 2025 Wongsakorn Adirekkittikun - All Rights Reserved
 * You may use, distribute and modify this code under the terms of the MIT license.
 */
package net.objecthunter.exp4j;
import org.junit.Test;
import static org.junit.Assert.*;
public class UnaryMinusPrecedenceNewTest {
    @Test
    public void minusHasLowerPrecedenceThanPower() {
        double v1 = new ExpressionBuilder("-3^2").build().evaluate();
        double v2 = new ExpressionBuilder("(-3)^2").build().evaluate();
        assertEquals(-9.0, v1, 1e-12);
        assertEquals(9.0, v2, 1e-12);
    }
}
