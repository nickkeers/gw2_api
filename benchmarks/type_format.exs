sample_data = Stream.cycle([
  %{
    base_rgb: [128, 26, 26],
    categories: ["Blue", "Vibrant", "Rare"],
    cloth: %{
      brightness: 22,
      contrast: 1.25,
      hue: 196,
      lightness: 1.32813,
      rgb: [54, 130, 160],
      saturation: 0.742188
    },
    fur: %{
      brightness: 22,
      contrast: 1.25,
      hue: 196,
      lightness: 1.32813,
      rgb: [54, 130, 160],
      saturation: 0.742188
    },
    id: 10,
    item: 20370,
    leather: %{
      brightness: 22,
      contrast: 1.25,
      hue: 196,
      lightness: 1.32813,
      rgb: [61, 129, 156],
      saturation: 0.664063
    },
    metal: %{
      brightness: 22,
      contrast: 1.28906,
      hue: 196,
      lightness: 1.32813,
      rgb: [65, 123, 146],
      saturation: 0.546875
    },
    name: "Sky"
  }
])
|> Enum.take(1000)

alias Gw2Api.Colors.Color
alias Gw2Api.Type

Benchee.run(
  %{
    "single map" => fn -> Enum.map(sample_data,
      fn color ->
        Color
        |> struct(color)
        |> Type.convert()
      end)
    end,
#     "double map" => fn ->
#       sample_data
#       |> Enum.map(&struct(Color, &1))
#       |> Enum.map(&Type.convert/1)
#     end,
    "what da fak" => fn ->
      sample_data
      |> Enum.map(&(struct(Color, &1) |> Type.convert()))
    end
  },
  time: 10,
  memory_time: 2
)
