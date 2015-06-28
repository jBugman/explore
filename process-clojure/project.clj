(defproject process "0.1.0"
  :dependencies [
    [org.clojure/clojure "1.6.0"]
    [me.raynes/fs "1.4.6"]
    [cheshire "5.5.0"]
    [org.clojure/data.csv "0.1.2"]]
  :main ^:skip-aot process.core
  :target-path "target/%s"
  :profiles {:uberjar {:aot :all}})
