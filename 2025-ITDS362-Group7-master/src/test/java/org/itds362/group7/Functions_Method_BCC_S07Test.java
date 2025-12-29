/* Copyright (C) 2025 2025-ITDS362-Group7
 * You may use, distribute and modify this code under the terms of the MIT license.
 */
package org.itds362.group7;

import net.objecthunter.exp4j.function.Function;
import net.objecthunter.exp4j.ExpressionBuilder;
import org.junit.Test;
import static org.junit.Assert.*;


public class Functions_Method_BCC_S07Test {

    private static final Function sum2 = new Function("sum2", 2) {
        @Override public double apply(double... a) { return a[0] + a[1]; }
    };
    private static final Function sq = new Function("sq", 1) {
        @Override public double apply(double... a) { return a[0] * a[0]; }
    };

    @Test
    public void base_singleFunction() {
        double v = new ExpressionBuilder("sq(3)").functions(sq).build().evaluate();
        assertEquals(9.0, v, 1e-9);
    }

    @Test
    public void addSecondFunction_pairUse() {
        double v = new ExpressionBuilder("sq(sum2(2,3))").functions(sq, sum2).build().evaluate();
        assertEquals(25.0, v, 1e-9);
    }

    @Test
    public void orderOfRegistration_notAffectResult() {
        double a = new ExpressionBuilder("sq(sum2(2,3))").functions(sq, sum2).build().evaluate();
        double b = new ExpressionBuilder("sq(sum2(2,3))").functions(sum2, sq).build().evaluate();
        assertEquals(a, b, 1e-9);
    }
}
