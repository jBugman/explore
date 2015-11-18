package me.bugman.process;

import static org.junit.Assert.*;
import org.junit.*;

public class ProcessTest {
    @Test public void works() {
        assertEquals(Process.process("Name", "../test_data/"), 0);
    }
}
