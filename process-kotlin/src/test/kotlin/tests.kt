package process

import kotlin.test.assertEquals
import org.junit.Test as test

class Tests {
    @test fun shouldWork() {
        assertEquals(OK, process("Name", "../test_data/"))
    }
}