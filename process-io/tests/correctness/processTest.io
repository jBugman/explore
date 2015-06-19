ProcessTest := UnitTest clone do(
	assertTrue(process("Name", "../test_data"))
)
TestSuite run
