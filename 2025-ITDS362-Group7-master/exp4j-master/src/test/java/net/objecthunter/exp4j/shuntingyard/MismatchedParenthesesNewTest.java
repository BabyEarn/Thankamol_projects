/* Copyright (C) 2025 Wongsakorn Adirekkittikun - All Rights Reserved
 * You may use, distribute and modify this code under the terms of the MIT license.
 */
package net.objecthunter.exp4j.shuntingyard;
import net.objecthunter.exp4j.ExpressionBuilder;
import org.junit.Test;
public class MismatchedParenthesesNewTest {
    @Test(expected = IllegalArgumentException.class)
    public void mismatchedParenthesesShouldThrow() {
        new ExpressionBuilder("(1+2").build();
    }
}
