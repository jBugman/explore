(ns process.core
  (:gen-class))
(require '[me.raynes.fs :refer [glob]]
         '[clojure.java.io :as io]
         '[cheshire.core :as json]
         '[clojure.data.csv :as csv])

(defn exit [message] (throw (Exception. message)))

(defn csv [filename data]
  (with-open [f (io/writer filename)]
    (csv/write-csv f data)))

(defn check-field [value]
  (cond #(%1 %2) value
    nil? (exit "Field is missing")
    (complement string?) (exit "Field is not a string")
    :else value))

(defn parse-json-file [file] (-> file slurp json/parse-string))

(defn process [field folder]
  (->>  (glob (io/file folder) "*.json")
        (map (comp check-field #(get % field) parse-json-file))
        (remove empty?)
        frequencies
        (sort-by val >)
        (csv "output.csv")))

(defn -main [& args]
  (if (= 2 (count args))
    (process (first args) (second args))
    (println "Args are: <field name> <folder>")))
