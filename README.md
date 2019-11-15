# ReverseXpath

This library allows to create a fake representation in a common format, according to a list of different XPATH.
For example, you could get a JSON or an XML representation.

## Installation

Add `reverse_xpath` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:reverse_xpath, git: "https://github.com/alexanderttalvarez/reverse_xpath.git", tag: "0.1.0"}
  ]
end
```

## Usage

You can generate a Map running:

```elixir
ReverseXpath.xpath_list_to_map([
  %{
    value: "Description 1",
    xpath: "//values/description/description_long/data/text()"
  },
  %{
    value: "Description 2",
    xpath: "//values/description/description_short/meta-data/text()"
  }
])
```

It's possible to get a JSON like this:

```elixir
ReverseXpath.Format.Json.transform([
  %{
    value: "Description 1",
    xpath: "//values/description/description_long/data/text()"
  },
  %{
    value: "Description 2",
    xpath: "//values/description/description_short/meta-data/text()"
  }
])
```

And an XML like this:

```elixir
ReverseXpath.Format.Xml.transform([
  %{
    value: "Description 1",
    xpath: "//values/description/description_long/data/text()"
  },
  %{
    value: "Description 2",
    xpath: "//values/description/description_short/meta-data/text()"
  }
])
```
