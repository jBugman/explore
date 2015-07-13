name := "process-scala"

version := "1.0"

scalaVersion := "2.11.6"

libraryDependencies ++= Seq(
  "org.json4s" %% "json4s-native" % "3.2.10",
  "com.github.tototoshi" %% "scala-csv" % "1.2.1",

  "org.scalatest" % "scalatest_2.11" % "2.2.4" % "test"
)

mainClass       in assembly := Some("Process")
assemblyJarName in assembly := "process.jar"
