/* Copyright (C) 2025 2025-ITDS362-Group7
 * You may use, distribute and modify this code under the terms of the MIT license.
 */
package org.itds362.group7;

import java.util.Map;
import net.objecthunter.exp4j.ExpressionBuilder;
import org.junit.Test;
import static org.junit.Assert.*;


public class Variables_Method_ACoC_S05Test {

    @Test
    public void multipleVars_allSet_ok() {
        Expression e = new ExpressionBuilder("a*b + c").variables("a","b","c").build();
        double v = e.setVariables(Map.of("a", 2.0, "b", 4.0, "c", 1.0)).evaluate();
        assertEquals(9.0, v, 1e-9);
    }

    @Test
    public void multipleVars_oneMissing_throws() {
        Expression e = new ExpressionBuilder("a+b+c").variables("a","b","c").build();
        try {
            e.setVariables(Map.of("a", 1.0, "b", 2.0)).evaluate();
            fail("Expected IllegalArgumentException");
        } catch (IllegalArgumentException expected) {
            // ok
        }
    }

    @Test
    public void underscoreVarName_ok() {
        Expression e = new ExpressionBuilder("_x + 1").variable("_x").build();
        assertEquals(6.0, e.setVariable("_x", 5).evaluate(), 1e-9);
    }
}
