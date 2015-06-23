import org.scalatest._

class ProcessSpec extends FlatSpec with Matchers {

  "Process" should "work with correct arguments" in {
    Process.process("Name", "../test_data/") should be ("ok")
  }
}
