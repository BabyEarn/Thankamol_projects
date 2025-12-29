/* Copyright (C) 2025 Wongsakorn Adirekkittikun - All Rights Reserved
 * You may use, distribute and modify this code under the terms of the MIT license.
 */
package net.objecthunter.exp4j;
import org.junit.Test;
import static org.junit.Assert.*;
public class LeadingDotNumberTokenizerNewTest {
    @Test
    public void leadingDotNumberShouldParse() {
        double v = new ExpressionBuilder(".5 + 1").build().evaluate();
        assertEquals(1.5, v, 1e-12);
    }
}
