defmodule ReverseXpath.Format.Xml do
  @behaviour ReverseXpath.Formats.Behaviour

  def transform(xpath) when is_list(xpath) do
    ReverseXpath.xpath_list_to_map(xpath)
    |> Poison.encode!
    |> JsonToXml.convert!
  end

end
