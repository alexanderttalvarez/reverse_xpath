defmodule ReverseXpathTest do
  use ExUnit.Case
  doctest ReverseXpath

  describe "Reverse xpath tests" do

    test "Maps without internal lists" do
      merge = ReverseXpath.xpath_list_to_map([
        %{
          value: "Description 1",
          xpath: "//values/description/description_long/data/text()"
        },
        %{
          value: "Description 2",
          xpath: "//values/description/description_short/meta-data/text()"
        }
      ])

      assert merge == %{
        "values" => %{
          "description" => %{
            "description_short" => %{
              "meta-data" => "Description 2"
            },
            "description_long" => %{
              "data" => "Description 1"
            }
          }
        }
      }
    end

    test "Maps with internal lists, but lists with plain values" do
      merge = ReverseXpath.xpath_list_to_map([
        %{
          value: "Description 1",
          xpath: "//values/description/description_long/element/text()"
        },
        %{
          value: "Description 2",
          xpath: "//values/description/description_short/element/text()"
        }
      ])

      assert merge == %{
        "values" => %{
          "description" => %{
            "description_long" => ["Description 1"],
            "description_short" => ["Description 2"]
          }
        }
      }
    end

    test "Maps with different structure" do
      merge = ReverseXpath.xpath_list_to_map([
        %{
          value: "Description 1",
          xpath: "//values/description/element/description_long/text()"
        },
        %{
          value: "Description 2",
          xpath: "//values/description/description_short/element/text()"
        }
      ])

      assert merge == %{
        "values" => %{
          "description" => %{
            "description_short" => ["Description 2"]
          }
        }
      }
    end

  end

end
