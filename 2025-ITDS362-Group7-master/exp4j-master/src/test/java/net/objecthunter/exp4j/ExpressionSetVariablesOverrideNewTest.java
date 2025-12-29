/* Copyright (C) 2025 Wongsakorn Adirekkittikun - All Rights Reserved
 * You may use, distribute and modify this code under the terms of the MIT license.
 */
package net.objecthunter.exp4j;
import java.util.*;
import org.junit.Test;
import static org.junit.Assert.*;
public class ExpressionSetVariablesOverrideNewTest {
    @Test
    public void setVariablesThenOverrideOne() {
        Map<String, Double> vars = new HashMap<>();
        vars.put("x", 2.0);
        vars.put("y", 10.0);
        Expression e = new ExpressionBuilder("x + y").variables("x","y").build();
        e.setVariables(vars);
        e.setVariable("y", 3.0); // override
        assertEquals(5.0, e.evaluate(), 1e-12);
    }
}
