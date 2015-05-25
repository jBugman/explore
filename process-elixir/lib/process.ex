require Logger
require Poison

defmodule Process.CLI do
  def main(args) do
    case args do
      [field, folder] -> (
        values = for file <- glob(folder, ".json"),
            contents = File.read!(file),
            json = Poison.decode!(contents, as: %{}) do
          case json[field] do
            nil -> Logger.error "Field is missing"
            x when not is_binary(x) -> Logger.error "Field is not a string"
            text -> text
          end
        end
        filtered = for x <- values, x != "" do x end
        frequencies = Enum.reduce filtered, %{}, fn(x, acc) ->
          Map.update(acc, x, 1, &(&1 + 1))
        end

        IO.inspect frequencies
      )
      _ -> Logger.error "Args are: <field name> <folder>"
    end
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
