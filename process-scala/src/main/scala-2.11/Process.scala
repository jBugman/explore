import java.io.{File, IOException}

import com.github.tototoshi.csv.CSVWriter
import org.json4s.JsonAST._
import org.json4s.native.JsonMethods._

import scala.collection.mutable
import scala.io.Source

object Process {

  def main(args: Array[String]): Unit = for (_ <- 1 to 100) { process("Name", "../test_data/") }

  def process(field: String, folder: String): String = {
    val frequencies = mutable.Map.empty[String, Int]

    val files = new File(folder).listFiles().filter(x => x.isFile && x.getName.endsWith(".json"))
    files foreach { file =>
      val contents = Source.fromFile(file).mkString
      val json = parse(contents)
      json \ field match {
        case JString("") =>
        case JString(value) => frequencies(value) = frequencies.getOrElse(value, 0) + 1
        case JNothing => throw new IOException("Field is missing")
        case _ => throw new IOException("Field is not a string")
      }
    }
    val sorted = frequencies.toList.sortWith(_._2 > _._2)

    val outfile = new File("output.csv")
    val writer = CSVWriter.open(outfile)
    writer.writeAll(sorted.map(x => Seq(x._1, x._2.toString)))
    writer.close()

    "ok"
  }
}
