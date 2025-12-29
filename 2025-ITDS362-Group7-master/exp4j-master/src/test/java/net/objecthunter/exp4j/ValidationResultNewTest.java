/* Copyright (C) 2025 Wongsakorn Adirekkittikun - All Rights Reserved
 * You may use, distribute and modify this code under the terms of the MIT license.
 */
package net.objecthunter.exp4j;
import org.junit.Test;
import static org.junit.Assert.*;
public class ValidationResultNewTest {
    @Test
    public void missingVariableShouldInvalidate() {
        // ต้องประกาศทั้งสองตัวแปร ไม่งั้น build จะ error
        Expression exp = new ExpressionBuilder("x + y")
                .variables("x", "y")
                .build()
                .setVariable("x", 1);
        ValidationResult result = exp.validate(true);
        assertFalse(result.isValid());
    }

    @Test
    public void successConstantExpression() {
        Expression exp = new ExpressionBuilder("2+3*4").build();
        ValidationResult vr = exp.validate(true);
        assertTrue(vr.isValid());
        // SUCCESS.getErrors() เป็น null ตาม design
        assertNull(vr.getErrors());
    }

}
