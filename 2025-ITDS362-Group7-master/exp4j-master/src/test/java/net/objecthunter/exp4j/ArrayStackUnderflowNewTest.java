/* Copyright (C) 2025 Wongsakorn Adirekkittikun - All Rights Reserved
 * You may use, distribute and modify this code under the terms of the MIT license.
 */
package net.objecthunter.exp4j;
import org.junit.Test;
import java.util.EmptyStackException;
import static org.junit.Assert.*;
public class ArrayStackUnderflowNewTest {
    @Test(expected = EmptyStackException.class)
    public void popOnEmptyShouldThrow() {
        ArrayStack s = new ArrayStack();
        s.pop();
    }
    @Test
    public void pushPopSize() {
        ArrayStack s = new ArrayStack();
        assertTrue(s.isEmpty());
        s.push(1.0);
        s.push(2.0);
        assertEquals(2, s.size());
        assertEquals(2.0, s.pop(), 1e-12);
        assertEquals(1, s.size());
    }
}
