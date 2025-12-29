/* Copyright (C) 2025 2025-ITDS362-Group7
 * You may use, distribute and modify this code under the terms of the MIT license.
 */
package org.itds362.group7;

import net.objecthunter.exp4j.ExpressionBuilder;
import net.objecthunter.exp4j.operator.Operator;
import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class Operators_Method_PWC_S09Test {

    // สร้าง 2 custom operators ด้วยสัญลักษณ์ที่อนุญาต ('#' และ '§')
    private static final Operator OP_HASH = new Operator("#", 2, true, Operator.PRECEDENCE_ADDITION) {
        @Override
        public double apply(double... args) {
            // a # b = a - b
            return args[0] - args[1];
        }
    };

    private static final Operator OP_SECTION = new Operator("§", 2, true, Operator.PRECEDENCE_ADDITION) {
        @Override
        public double apply(double... args) {
            // a § b = a + b
            return args[0] + args[1];
        }
    };

    @Test
    public void bothCustomOps_interplay() {
        // 10 § 3 # 2  =>  (10 § 3) # 2  เพราะ precedence เท่ากัน + left-assoc
        // (10 + 3) # 2 = 13 # 2 = 13 - 2 = 11
        double v = new ExpressionBuilder("10§3#2")
                .operator(OP_HASH, OP_SECTION)
                .build()
                .evaluate();
        assertEquals(11.0, v, 1e-12);
    }

    @Test
    public void registrationOrder_notAffectParsing() {
        // สลับลำดับการ register ก็ต้องให้ผลเท่ากัน
        double v1 = new ExpressionBuilder("8#3§1")
                .operator(OP_HASH, OP_SECTION)
                .build()
                .evaluate(); // (8 - 3) + 1 = 6

        double v2 = new ExpressionBuilder("8#3§1")
                .operator(OP_SECTION, OP_HASH)
                .build()
                .evaluate();

        assertEquals(v1, v2, 1e-12);
        assertEquals(6.0, v1, 1e-12);
    }
}