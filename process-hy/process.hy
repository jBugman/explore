#!/usr/bin/env hy
(import [collections [defaultdict]]
        [csv [writer :as csv-writer]]
        [json [load :as json-load]]
        [os]
        [os.path [join :as path-join]]
        [sys [argv exit]])

(defn parse-json-file [file]
  (with [[f (open file :encoding "utf-8")]] (json-load f)))

(defn inc-counter [dict key] (assoc dict key (inc (get dict key))))

(defn process [field folder]
  (let [[frequencies (defaultdict (fn [] 0))]
        [files (list-comp f [f (.listdir os folder)] (.endswith f ".json"))]
        [jsons (list-comp (parse-json-file (path-join folder f)) [f files])]]
    (for [data jsons]
      (if (not (in field data))
        (exit "Field is missing")
        (let [[value (get data field)]] (cond
            [(not (string? value)) (exit "Field is not a string")]
            [(not (empty? value)) (inc-counter frequencies value)]
        ))))
    (let [[sorted-freq (sorted (.items frequencies) :key (fn [kv] (second kv)) :reverse True)]]
      (with [[f (open "output.csv" "w" :encoding "utf-8")]]
        (let [[writer (csv-writer f)]] (for [item sorted-freq] (.writerow writer item)))))))

(defmain []
  (if (< (len argv) 3)
    (print "Args are: <field name> <folder>")
    (process (get argv 1) (get argv 2))))

; ; Benchmark
; (defmain []
;   (for [i (range 100)]
;     (process "Name" "../test_data/")))
