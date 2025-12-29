/* Copyright (C) 2025 2025-ITDS362-Group7
 * You may use, distribute and modify this code under the terms of the MIT license.
 */
package org.itds362.group7;

import net.objecthunter.exp4j.operator.Operator;
import net.objecthunter.exp4j.ExpressionBuilder;
import org.junit.Test;
import static org.junit.Assert.*;


public class Operators_Method_PWC_S09Test {

    // a # b = a - 2*b  (lower than +)
    private static final Operator HASH_LOW =
            new Operator("#", 2, true, Operator.PRECEDENCE_ADDITION - 1) {
                @Override public double apply(double... args) { return args[0] - 2*args[1]; }
            };
    // a @ b = a + 2*b  (same as *)
    private static final Operator AT_MUL =
            new Operator("@", 2, true, Operator.PRECEDENCE_MULTIPLICATION) {
                @Override public double apply(double... args) { return args[0] + 2*args[1]; }
            };

    @Test
    public void bothCustomOps_interplay() {
        double v = new ExpressionBuilder("1#2@3")
                .operator(HASH_LOW, AT_MUL).build().evaluate();
        // @ first -> 2@3 = 2 + 6 = 8; then 1#8 = 1 - 16 = -15
        assertEquals(-15.0, v, 1e-9);
    }

    @Test
    public void registrationOrder_notAffectParsing() {
        double a = new ExpressionBuilder("1#2@3").operator(HASH_LOW, AT_MUL).build().evaluate();
        double b = new ExpressionBuilder("1#2@3").operator(AT_MUL, HASH_LOW).build().evaluate();
        assertEquals(a, b, 1e-9);
    }
}
