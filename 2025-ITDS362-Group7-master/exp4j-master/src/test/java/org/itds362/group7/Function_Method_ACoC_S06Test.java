/* Copyright (C) 2025 2025-ITDS362-Group7
 * You may use, distribute and modify this code under the terms of the MIT license.
 */
package org.itds362.group7;

import net.objecthunter.exp4j.function.Function;
import net.objecthunter.exp4j.ExpressionBuilder;
import org.junit.Test;
import static org.junit.Assert.*;


public class Function_Method_ACoC_S06Test {

    private static final Function inc = new Function("inc", 1) {
        @Override public double apply(double... args) { return args[0] + 1; }
    };

    @Test
    public void unary_customFunction_const() {
        double v = new ExpressionBuilder("inc(2)").function(inc).build().evaluate();
        assertEquals(3.0, v, 1e-9);
    }

    @Test
    public void unary_customFunction_var() {
        double v = new ExpressionBuilder("inc(x)").variable("x").function(inc).build()
                     .setVariable("x", 5).evaluate();
        assertEquals(6.0, v, 1e-9);
    }

    @Test
    public void nested_customFunction() {
        double v = new ExpressionBuilder("inc(inc(2))").function(inc).build().evaluate();
        assertEquals(4.0, v, 1e-9);
    }
}
