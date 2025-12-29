/* Copyright (C) 2025 2025-ITDS362-Group7
 * You may use, distribute and modify this code under the terms of the MIT license.
 */
package org.itds362.group7;

import net.objecthunter.exp4j.ExpressionBuilder;
import net.objecthunter.exp4j.operator.Operator;
import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class Operator_Method_BCC_S08Test {

    // ใช้สัญลักษณ์ที่อนุญาต: '#'
    // ตั้ง precedence ให้ "เท่ากับการคูณ" และ left-associative
    private static final Operator HASH = new Operator("#", 2, true, Operator.PRECEDENCE_MULTIPLICATION) {
        @Override
        public double apply(double... args) {
            // กำหนดพฤติกรรมง่าย ๆ : a # b = a + b
            return args[0] + args[1];
        }
    };

    @Test
    public void withCustomOp_samePrecAsMul() {
        // เนื่องจาก precedence เท่ากันและเป็น left-associative:
        // 2 # 3 * 4 => (2 # 3) * 4 = (5) * 4 = 20
        double v = new ExpressionBuilder("2#3*4")
                .operator(HASH)
                .build()
                .evaluate();
        assertEquals(20.0, v, 1e-12);
    }
}