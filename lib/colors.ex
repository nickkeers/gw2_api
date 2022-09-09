defmodule Gw2Api.Colors do
  alias Gw2Api.Request

  defmodule Color do
    use TypedStruct

    @typedoc """
    The Color response from
    """
    typedstruct do
      field :id, non_neg_integer()
      field :name, String.t()
      field :base_rgb, [non_neg_integer()]
      field :cloth, Map.t()
      field :leather, Map.t()
      field :metal, Map.t()
      field :fur, Map.t()
      field :item, non_neg_integer()

      @type hue :: :Gray | :Brown | :Red | :Orange | :Yellow | :Green | :Blue | :Purple
      @type material :: :Vibrant | :Leather | :Metal
      @type rarity :: :Starter | :Common | :Uncommon | :Rare | :Exclusive

      field(:categories, [hue | material | rarity])
    end
  end

  defimpl Gw2Api.Type, for: Color do
    @spec convert(any()) :: Gw2Api.Colors.Color.t()
    def convert(color) do
      %Color{
        color
        | categories: Enum.map(color.categories, &String.to_atom/1)
      }
    end
  end

  def list do
    Request.get("https://api.guildwars2.com/api/v2/colors")
  end

  def get(id) do
    Request.get("https://api.guildwars2.com/v2/colors?ids=#{id}")
    |> case do
      {:ok, colors} ->
        {:ok,
         colors
         |> dbg()
         |> Enum.map(&struct(Color, &1))
         |> Enum.map(&Gw2Api.Type.convert/1)}

      err ->
        err
    end
  end
end
