defmodule Gw2Api.Achievements.Daily do
  @moduledoc """
  This resource returns the current set of daily achievements.

  [GW2 API Docs](https://wiki.guildwars2.com/wiki/API:2/achievements/daily)
  """
  alias Gw2Api.Request

  defmodule DailyAchievement do
    @moduledoc """
    A struct representing a GW2 daily achievement according to the V2 API
    """

    use TypedStruct

    @typedoc "An achievement from the /achievements/daily endpoint"
    typedstruct do
      field(:id, non_neg_integer(), enforce: true)
      field(:level, %{min: non_neg_integer(), max: non_neg_integer()})

      field(:required_access, [
        GuildWars2
        | HeartOfThorns
        | PathOfFire
      ])
    end

    @spec convert(maybe_improper_list | {atom, maybe_improper_list() | map} | map) ::
            {:ok, __MODULE__.t()}
    def convert(achievements) when is_list(achievements) or is_map(achievements) do
      {:ok,
       Enum.map(achievements, &convert/1)
       |> Enum.into(%{})}
    end

    def convert({key, item}) do
      achievements =
        item
        |> Enum.map(fn item ->
          achievement = struct(__MODULE__, item)

          %__MODULE__{
            achievement
            | required_access: format_required_access(achievement.required_access)
          }
        end)

      {key, achievements}
    end

    defp format_required_access(x) when is_list(x), do: Enum.map(x, &format_required_access/1)
    defp format_required_access(nil), do: []

    defp format_required_access(%{condition: condition, product: product}),
      do: %{condition: String.to_atom(condition), product: String.to_atom(product)}
  end

  @doc """
  Retrieves the list of daily achievements in the format specified in the API docs.
  """
  def get do
    Request.get("https://api.guildwars2.com/v2/achievements/daily?v=2019-05-16T00:00:00.000Z")
    |> case do
      {:ok, achievements} ->
        DailyAchievement.convert(achievements)
    end
  end

  @doc """
  Retrieves the list of tomorrow's daily achievements in the format specified in the API docs.
  """
  def tomorrow do
    Request.get(
      "https://api.guildwars2.com/v2/achievements/daily/tomorrow?v=2019-05-16T00:00:00.000Z"
    )
    |> case do
      {:ok, achievements} ->
        DailyAchievement.convert(achievements)
    end
  end
end
