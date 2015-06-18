ProcessTest := UnitTest clone do(
	assertTrue(process("Name1", "../test_data"))
)
TestSuite run
