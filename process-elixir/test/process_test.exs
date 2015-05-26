defmodule ProcessTest do
  use ExUnit.Case

  test "the truth" do
    assert :ok = Process.CLI.process("Name", "../test_data")
  end
end
