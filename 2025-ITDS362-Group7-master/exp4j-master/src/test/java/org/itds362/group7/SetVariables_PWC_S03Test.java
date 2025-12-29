/* Copyright (C) 2025 2025-ITDS362-Group7
 * You may use, distribute and modify this code under the terms of the MIT license.
 */
package org.itds362.group7;


import net.objecthunter.exp4j.Expression;
import java.util.Map;
import net.objecthunter.exp4j.ExpressionBuilder;
import org.junit.Test;
import static org.junit.Assert.*;


public class SetVariables_PWC_S03Test {

    @Test
    public void allProvided_twoVars() {
        Expression e = new ExpressionBuilder("x*y + x").variables("x","y").build();
        double v = e.setVariables(Map.of("x", 2.0, "y", 3.0)).evaluate();
        assertEquals(8.0, v, 1e-9);
    }

    @Test
    public void missingOneVar_throws() {
        Expression e = new ExpressionBuilder("x+y").variables("x","y").build();
        try {
            e.setVariables(Map.of("x", 1.0)).evaluate();
            fail("Expected IllegalArgumentException");
        } catch (IllegalArgumentException expected) {
            // ok
        }
    }

    @Test
    public void zeroAndNegativeValues() {
        Expression e = new ExpressionBuilder("x-y").variables("x","y").build();
        double v = e.setVariables(Map.of("x", 0.0, "y", -2.0)).evaluate();
        assertEquals(2.0, v, 1e-9);
    }
}
