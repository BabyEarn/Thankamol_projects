/* Copyright (C) 2025 2025-ITDS362-Group7
 * You may use, distribute and modify this code under the terms of the MIT license.
 */
package org.itds362.group7;

import net.objecthunter.exp4j.ExpressionBuilder;
import org.junit.Test;
import static org.junit.Assert.*;


public class Evaluate_ECC_S01Test {

    @Test
    public void simple_noVars_intLike() {
        double v = new ExpressionBuilder("1+2*3").build().evaluate();
        assertEquals(7.0, v, 1e-9);
    }

    @Test
    public void paren_noVars_intLike() {
        double v = new ExpressionBuilder("(1+2)*3").build().evaluate();
        assertEquals(9.0, v, 1e-9);
    }

    @Test
    public void simple_oneVar_double() {
        double v = new ExpressionBuilder("x+2.5").variable("x").build()
                     .setVariable("x", 1.5).evaluate();
        assertEquals(4.0, v, 1e-9);
    }

    @Test
    public void division_semantics_infAndNaN() {
        assertTrue(Double.isInfinite(new ExpressionBuilder("1/0").build().evaluate()));
        assertTrue(Double.isNaN(new ExpressionBuilder("0/0").build().evaluate()));
    }
}
