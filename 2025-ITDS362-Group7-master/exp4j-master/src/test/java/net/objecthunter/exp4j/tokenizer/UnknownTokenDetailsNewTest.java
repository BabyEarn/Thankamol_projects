/* Copyright (C) 2025 Wongsakorn Adirekkittikun - All Rights Reserved
 * You may use, distribute and modify this code under the terms of the MIT license.
 */
package net.objecthunter.exp4j.tokenizer;
import net.objecthunter.exp4j.ExpressionBuilder;
import org.junit.Test;
import static org.junit.Assert.*;
public class UnknownTokenDetailsNewTest {
    @Test
    public void unknownFunctionDetailsAreExposed() {
        try {
            new ExpressionBuilder("foo(1)").build();
            fail("Expected IllegalArgumentException");
        } catch (IllegalArgumentException ex) {
            if (ex instanceof UnknownFunctionOrVariableException) {
                UnknownFunctionOrVariableException u = (UnknownFunctionOrVariableException) ex;
                assertEquals("foo", u.getToken());
                assertTrue(u.getPosition() >= 0);
                assertTrue(u.getExpression().contains("foo(1)"));
            } else {
                fail("Unexpected exception type: " + ex.getClass());
            }
        }
    }
}
