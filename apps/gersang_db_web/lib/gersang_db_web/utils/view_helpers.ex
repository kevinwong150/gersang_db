defmodule GersangDbWeb.Utils.ViewHelpers do
  def format_tags(tags) do
    cond do
      is_nil(tags) or tags == [] ->
        "N/A"
      true ->
        Enum.join(tags, ", ")
    end
  end

  # Helper function to format numbers with commas
  def format_number_with_commas(number) when is_integer(number) do
    number
    |> Integer.to_string()
    |> String.reverse()
    |> String.replace(~r/(\d{3})(?=\d)/, "\\1,")
    |> String.reverse()
  end

  def format_number_with_commas(nil), do: "N/A"
  def format_number_with_commas(_), do: "N/A"

  # Helper function to format abbreviated numbers for large values
  def format_abbreviated_number(number) when number >= 1_000_000_000 do
    abbreviated = number / 1_000_000_000
    formatted = :erlang.float_to_binary(abbreviated, decimals: 3)
    trimmed = String.replace(formatted, ~r/\.?0+$/, "")
    trimmed <> "B"
  end

  def format_abbreviated_number(number) when number >= 1_000_000 do
    abbreviated = number / 1_000_000
    formatted = :erlang.float_to_binary(abbreviated, decimals: 3)
    trimmed = String.replace(formatted, ~r/\.?0+$/, "")
    trimmed <> "M"
  end

  def format_abbreviated_number(_number), do: nil
end
