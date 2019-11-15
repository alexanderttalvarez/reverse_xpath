defmodule ReverseXpath.Formats.Behaviour do
  @callback transform(Enum) :: [{String.t, String.t | nil}]
end
