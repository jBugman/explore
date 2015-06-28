(defproject process "0.1.0"
  :dependencies [[org.clojure/clojure "1.6.0"]]
  :main ^:skip-aot process.core
  :target-path "target/%s"
  :profiles {:uberjar {:aot :all}})
