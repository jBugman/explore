require Logger
require Poison
require CSV

defmodule Process.CLI do

  def main(args) do
    case args do
      [field, folder] -> process(field, folder)
      _ -> Logger.error "Args are: <field name> <folder>"
    end
  end

  # # Benchmark
  # def main(_) do main_rec(100) end
  # def main_rec(0) do :done end
  # def main_rec(n) do process("Name", "../test_data/") end

  def process(field, folder) do
    values = for file <- glob(folder, ".json"),
        contents = File.read!(file),
        json = Poison.decode!(contents, as: %{}) do
      case json[field] do
        nil -> raise "Field is missing"
        x when not is_binary(x) -> raise "Field is not a string"
        text -> text
      end
    end

    frequencies = values
      |> Enum.filter(&(&1 != ""))
      |> Enum.reduce(%{}, fn(x, acc) -> Map.update(acc, x, 1, &(&1 + 1)) end)

    sorted_list = Map.to_list(frequencies)
      |> Enum.sort(&(elem(&1, 1) > elem(&2, 1)))
      |> Enum.map(&(Tuple.to_list(&1)))

    {:ok, outfile} = File.open("output.csv", [:write, :utf8])
    try do
      sorted_list |> CSV.encode |> Enum.each(&IO.write(outfile, &1))
    after
      File.close(outfile)
    end

    :ok
  end

  defp glob(folder, mask) do
    {:ok, regex} = Regex.compile(".*?" <> Regex.escape(mask))
    for filename <- File.ls!(folder),
        filename =~ regex,
        filepath = Path.join(folder, filename) do
      filepath
    end
  end
end
