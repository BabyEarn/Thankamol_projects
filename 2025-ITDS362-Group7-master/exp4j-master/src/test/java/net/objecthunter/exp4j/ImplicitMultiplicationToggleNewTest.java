/* Copyright (C) 2025 Wongsakorn Adirekkittikun - All Rights Reserved
 * You may use, distribute and modify this code under the terms of the MIT license.
 */
package net.objecthunter.exp4j;
import org.junit.Test;
import static org.junit.Assert.*;
public class ImplicitMultiplicationToggleNewTest {
    @Test(expected = IllegalArgumentException.class)
    public void implicitMultiplicationDisabledShouldFail() {
        new ExpressionBuilder("2x")
                .implicitMultiplication(false)
                .variable("x")
                .build()
                .setVariable("x", 5)
                .evaluate(); // <-- เพิ่ม evaluate() ให้มันโยนตอนรันจริง
    }

}
