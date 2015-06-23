import unittest

import process


class TestProcess(unittest.TestCase):
    def test_works(self):
        self.assertIsNone(process.process('Name', '../test_data/'))


if __name__ == '__main__':
    unittest.main()
