defmodule GersangDbWeb.Utils.ViewHelpers do
  def format_tags(tags) do
    cond do
      is_nil(tags) or tags == [] ->
        "N/A"
      true ->
        Enum.join(tags, ", ")
    end
  end
end
