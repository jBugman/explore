(ns process.core-test
  (:require [clojure.test :refer :all]
            [process.core :refer :all]))

(deftest works
  (testing "'process' works with sensible arguments"
    (is (nil? (process "Name" "../test_data/")))))
