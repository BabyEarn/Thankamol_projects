/* Copyright (C) 2025 Wongsakorn Adirekkittikun - All Rights Reserved
 * You may use, distribute and modify this code under the terms of the MIT license.
 */
package net.objecthunter.exp4j;
import net.objecthunter.exp4j.function.Function;
import net.objecthunter.exp4j.function.Functions;
import org.junit.Test;
import static org.junit.Assert.*;
public class FunctionsBuiltinLookupNewTest {
    @Test
    public void builtinFunctionExists() {
        Function sin = Functions.getBuiltinFunction("sin");
        assertNotNull(sin);
        assertEquals("sin", sin.getName());
    }
    @Test
    public void unknownFunctionReturnsNull() {
        assertNull(Functions.getBuiltinFunction("sinn"));
    }
}
