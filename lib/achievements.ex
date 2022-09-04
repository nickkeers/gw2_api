defmodule Gw2Api.Achievements do
  alias Gw2Api.Request

  defmodule AccountAchievement do
    @moduledoc """
    A struct represent a GW2 achievement according to the V2 API
    """
    use TypedStruct

    @typedoc "An achievement from the /account/achievements endpoint"
    typedstruct do
      field(:id, non_neg_integer(), enforce: true)
      field(:bits, [integer()])
      field(:current, non_neg_integer())
      field(:max, non_neg_integer())
      field(:done, boolean(), enforce: true)
      field(:repeated, non_neg_integer())
      field(:unlocked, boolean())
    end
  end

  defmodule Achievement do
    use TypedStruct

    typedstruct do
      field(:id, non_neg_integer(), enforce: true)
      field(:icon, String.t())
      field(:name, String.t(), enforce: true)
      field(:description, String.t(), enforce: true)
      field(:requirement, String.t(), enforce: true)
      field(:locked_text, String.t(), enforce: true)
      field(:type, Default | ItemSet)

      field(:flags, [
        Pvp
        | CategoryDisplay
        | MoveToTop
        | IgnoreNearlyComplete
        | Repeatable
        | Hidden
        | RequiresUnlock
        | RepairOnLogin
        | Daily
        | Weekly
        | Monthly
        | Permanent
      ])

      field(:tiers, [%{count: non_neg_integer(), points: non_neg_integer()}])
      field(:prerequisites, [non_neg_integer()])

      field(:rewards, [
        %{
          type: Coins,
          count: non_neg_integer()
        }
        | %{type: Item, id: non_neg_integer(), count: non_neg_integer()}
        | %{type: Mastery, region: String.t()}
        | %{type: Title, id: non_neg_integer()}
      ])

      field(:bits, [non_neg_integer()])

      field(:point_cap, non_neg_integer())
    end
  end

  def get() do
    Request.get("https://api.guildwars2.com/v2/account/achievements")
    |> case do
      {:ok, achievements} ->
        {:ok,
         Enum.map(achievements, fn item ->
           struct(AccountAchievement, item)
         end)}

      err ->
        err
    end
  end

  defp format_reward(reward) do
    %{reward | type: String.to_atom(reward["type"])}
  end

  def get(id) do
    Request.get("https://api.guildwars2.com/v2/achievements?ids=#{id}")
    |> case do
      {:ok, achievements} ->
        {:ok,
         Enum.map(achievements, fn item ->
           achievement = struct(Achievement, item)

           %Achievement{
             achievement
             | flags: Enum.map(achievement.flags, &String.to_atom/1),
               rewards: Enum.map(achievement.rewards, &format_reward/1)
           }
         end)}

      err ->
        err
    end
  end
end
