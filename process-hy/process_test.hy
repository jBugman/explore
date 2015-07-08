(import [unittest [TestCase main :as test-main]]
        [process [process]])

(defclass TestProcess [TestCase]
  [[test_works (fn [self]
    (.assertIsNone self (process "Name" "../test_data/")))]])

(defmain [&rest args] (test-main))
