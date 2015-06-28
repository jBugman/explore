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

(defn process [field folder]
  (def files (glob (io/file folder) "*.json"))
  (def contents (map #(json/parse-string (slurp %)) files))
  (def values (map
    (fn [data]
      (def value (get data field))
      (case value
        nil (exit "Field is missing")
        (if (string? value) value (exit "Field is not a string"))))
    contents))
  (def stats (sort-by val > (frequencies (remove empty? values))))
  (csv "output.csv" stats))

(defn -main [& args]
  (if (= 2 (count args))
    (process (first args) (second args))
    (println "Args are: <field name> <folder>")))
