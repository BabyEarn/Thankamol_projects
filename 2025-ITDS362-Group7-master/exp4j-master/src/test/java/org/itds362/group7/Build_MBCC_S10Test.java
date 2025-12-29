/* Copyright (C) 2025 2025-ITDS362-Group7
 * You may use, distribute and modify this code under the terms of the MIT license.
 */
package org.itds362.group7;

import net.objecthunter.exp4j.Expression;
import net.objecthunter.exp4j.ExpressionBuilder;
import org.junit.Test;
import static org.junit.Assert.*;


public class Build_MBCC_S10Test {

    @Test
    public void validExpression_buildSucceeds() {
        try {
            new ExpressionBuilder("(1+2)*(3+4)").build();
        } catch (Exception ex) {
            fail("Should build without exceptions, but got: " + ex);
        }
    }

    @Test
    public void unknownFunction_onBuildOrEval_throws() {
        try {
            Expression expr = new ExpressionBuilder("foo(2)").build(); // some versions throw here
            // if build didn't throw, evaluate should
            expr.evaluate();
            fail("Expected IllegalArgumentException");
        } catch (IllegalArgumentException expected) {
            // ok
        }
    }

    @Test
    public void malformedExpression_doublePlus_illegalArgument() {
        try {
            new ExpressionBuilder("(1+2").build();
            fail("Expected IllegalArgumentException");
        } catch (IllegalArgumentException expected) {
            // ok
        }
    }
}
