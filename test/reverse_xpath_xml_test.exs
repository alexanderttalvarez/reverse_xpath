defmodule ReverseXpathTest.Format.Xml do
  use ExUnit.Case
  doctest ReverseXpath

  describe "Reverse xpath Xml tests" do

    test "Maps without internal lists" do
      xml = ReverseXpath.Format.Xml.transform([
        %{
          value: "Description 1",
          xpath: "//values/description/description_long/data/text()"
        },
        %{
          value: "Description 2",
          xpath: "//values/description/description_short/meta-data/text()"
        }
      ])

      assert xml == "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<root>\n\t<values>\n\t\t<description>\n\t\t\t<description_long>\n\t\t\t\t<data>Description 1</data>\n\t\t\t</description_long>\n\t\t\t<description_short>\n\t\t\t\t<meta-data>Description 2</meta-data>\n\t\t\t</description_short>\n\t\t</description>\n\t</values>\n</root>"
    end

    test "Maps with internal lists, but lists with plain values" do
      xml = ReverseXpath.Format.Xml.transform([
        %{
          value: "Description 1",
          xpath: "//values/description/description_long/element/text()"
        },
        %{
          value: "Description 2",
          xpath: "//values/description/description_short/element/text()"
        }
      ])

      assert xml == "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<root>\n\t<values>\n\t\t<description>\n\t\t\t<description_long>\n\t\t\t\t<element>Description 1</element>\n\t\t\t</description_long>\n\t\t\t<description_short>\n\t\t\t\t<element>Description 2</element>\n\t\t\t</description_short>\n\t\t</description>\n\t</values>\n</root>"
    end

  end


end
