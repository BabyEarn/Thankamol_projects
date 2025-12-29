/* Copyright (C) 2025 2025-ITDS362-Group7
 * You may use, distribute and modify this code under the terms of the MIT license.
 */
package org.itds362.group7;

import net.objecthunter.exp4j.operator.Operator;
import net.objecthunter.exp4j.ExpressionBuilder;
import org.junit.Test;
import static org.junit.Assert.*;


public class Operator_Method_BCC_S08Test {

    // a @ b = a + 2*b
    private static final Operator AT_SAME_AS_MUL =
            new Operator("@", 2, true, Operator.PRECEDENCE_MULTIPLICATION) {
                @Override public double apply(double... args) { return args[0] + 2*args[1]; }
            };

    @Test
    public void base_withoutCustomOp() {
        double v = new ExpressionBuilder("1+2*3").build().evaluate();
        assertEquals(7.0, v, 1e-9);
    }

    @Test
    public void withCustomOp_samePrecAsMul() {
        double v = new ExpressionBuilder("1@2*3").operator(AT_SAME_AS_MUL).build().evaluate();
        // parse as 1 @ (2*3) = 1 + 2*(6) = 13
        assertEquals(13.0, v, 1e-9);
    }
}
