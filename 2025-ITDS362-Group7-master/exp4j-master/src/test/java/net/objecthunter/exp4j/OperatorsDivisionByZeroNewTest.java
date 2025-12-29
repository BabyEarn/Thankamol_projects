/* Copyright (C) 2025 Wongsakorn Adirekkittikun - All Rights Reserved
 * You may use, distribute and modify this code under the terms of the MIT license.
 */
package net.objecthunter.exp4j;
import org.junit.Test;
public class OperatorsDivisionByZeroNewTest {
    @Test(expected = ArithmeticException.class)
    public void divisionByZeroShouldThrow() {
        new ExpressionBuilder("1/0").build().evaluate();
    }
}
