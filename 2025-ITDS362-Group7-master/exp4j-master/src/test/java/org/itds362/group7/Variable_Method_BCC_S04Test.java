/* Copyright (C) 2025 2025-ITDS362-Group7
 * You may use, distribute and modify this code under the terms of the MIT license.
 */
package org.itds362.group7;


import net.objecthunter.exp4j.Expression;
import net.objecthunter.exp4j.ExpressionBuilder;
import org.junit.Test;
import static org.junit.Assert.*;


public class Variable_Method_BCC_S04Test {

    @Test
    public void base_noVar_ok() {
        double v = new ExpressionBuilder("1+2*3").build().evaluate();
        assertEquals(7.0, v, 1e-9);
    }

    @Test
    public void declareVar_thenSet_ok() {
        Expression e = new ExpressionBuilder("x+2").variable("x").build();
        assertEquals(5.0, e.setVariable("x", 3).evaluate(), 1e-9);
    }

    @Test
    public void declareVar_butNotSet_throws() {
        Expression e = new ExpressionBuilder("x+2").variable("x").build();
        try {
            e.evaluate();
            fail("Expected IllegalArgumentException");
        } catch (IllegalArgumentException expected) {
            // ok
        }
    }
}
