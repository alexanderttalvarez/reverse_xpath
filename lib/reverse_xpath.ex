defmodule ReverseXpath do
  @moduledoc """
  Library for transforming a list of xpath in a file.
  """

  @doc """
  Requires a list of maps. The map should include :value and :xpath as parameters.

  ## Examples

      iex> ReverseXpath.xpath_list_to_map([
      ...>  %{value: "Name 1", xpath: "//values/name/element/data/text()"},
      ...>  %{
      ...>    value: "Description 1",
      ...>    xpath: "//values/description/element/description_short/data/text()"
      ...>  },
      ...>  %{
      ...>    value: "Description 2",
      ...>    xpath: "//values/description/element/description_long/data/text()"
      ...>  },
      ...>  %{
      ...>    value: "Description 3",
      ...>    xpath: "//values/description/element/description_short/meta-data/text()"
      ...>  }
      ...> ])
      %{
        "values" => %{
          "name" => [%{"data" => "Name 1"}],
          "description" => [
            %{
              "description_short" => %{
                "data" => "Description 1",
                "meta-data" => "Description 3"
              },
              "description_long" => %{
                "data" => "Description 2"
              }
            }
          ]
        }
      }

  """
  def xpath_list_to_map(xpath) when is_list(xpath) do
    Enum.reduce(xpath, %{}, fn x, acc ->
      deep_merge(acc, xpath_to_map(x))
    end)
  end


  @doc """
  Requires a single map. The map should include :value and :xpath as parameters.

  ## Examples

      iex> ReverseXpath.xpath_to_map(
      ...>  %{value: "Name 1", xpath: "//values/name/element/data/text()"}
      ...> )
      %{
        "values" => %{"name" => [%{"data" => "Name 1"}]}
      }

  """
  def xpath_to_map(xpath) when is_map(xpath),
    do: xpath_to_map(xpath[:xpath], xpath[:value])

  def xpath_to_map(xpath, value) do
    tracks = xpath
    |> String.replace_leading("//", "")
    |> String.split("/")

    xpath_to_map(xpath, value, tracks)
  end
  def xpath_to_map(xpath, value, tracks) do
    case Enum.count(tracks) do
      0 -> %{}
      1 -> value
      _ ->
        case (tracks |> List.first) do
          "element" -> [ xpath_to_map(xpath, value, tracks |> List.delete_at(0)) ]
          fv -> Map.put(%{}, fv, xpath_to_map(xpath, value, tracks |> List.delete_at(0)))
        end
    end
  end


  def deep_merge(left, right), do: Map.merge(left, right, &deep_resolve/3)
  # Key exists in both maps, and both values are maps as well.
  # These can be merged recursively.
  defp deep_resolve(_key, left = %{}, right = %{}) do
    deep_merge(left, right)
  end
  # Both values are maps, so we merge them and we deep merge the maps contained inside
  defp deep_resolve(_key, left, right) when is_list(left) and is_list(right) do
    [Enum.concat(left, right)
    |> Enum.reduce(%{}, fn m, acc ->
      deep_merge(acc, m)
    end)]
  end
  # Key exists in both maps, but at least one of the values is
  # NOT a map. We fall back to standard merge behavior, preferring
  # the value on the right.
  defp deep_resolve(_key, _left, right), do: right

end
