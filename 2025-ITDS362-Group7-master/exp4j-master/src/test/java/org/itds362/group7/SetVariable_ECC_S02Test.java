/* Copyright (C) 2025 2025-ITDS362-Group7
 * You may use, distribute and modify this code under the terms of the MIT license.
 */
package org.itds362.group7;


import net.objecthunter.exp4j.Expression;
import net.objecthunter.exp4j.ExpressionBuilder;
import org.junit.Test;
import static org.junit.Assert.*;


public class SetVariable_ECC_S02Test {

    @Test
    public void set_thenEvaluate_changesValue() {
        Expression e = new ExpressionBuilder("x+1").variable("x").build();
        assertEquals(3.0, e.setVariable("x", 2).evaluate(), 1e-9);
        assertEquals(6.0, e.setVariable("x", 5).evaluate(), 1e-9);
    }

    @Test
    public void missingVariable_thenEvaluate_throws() {
        Expression e = new ExpressionBuilder("x+1").variable("x").build();
        try {
            e.evaluate();
            fail("Expected IllegalArgumentException");
        } catch (IllegalArgumentException expected) {
            // ok
        }
    }
}
