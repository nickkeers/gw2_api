defmodule Gw2Api.Account do
  @moduledoc """
  Contains information about a player's account
  """
  alias Gw2Api.Request
  use TypedStruct

  @typedoc """
  Module for the the account response
  """
  typedstruct do
    field(:id, String.t(), enforce: true)
    field :age, non_neg_integer()
    field(:name, String.t(), enforce: true)
    field :world, non_neg_integer()
    field :guilds, [String.t()]
    field :guild_leader, [String.t()]
    field :created, String.t()

    field :access, [
      :None
      | :PlayForFree
      | :GuildWars2
      | :HeartOfThorns
      | :PathOfFire
      | :EndOfDragons
    ]

    field(:commander, boolean(), default: false)
    field :fractal_level, non_neg_integer()
    field :daily_ap, non_neg_integer()
    field :monthly_ap, non_neg_integer()
    field :wvw_rank, non_neg_integer()
    field :last_modified, String.t()
    field :build_storage_slots, non_neg_integer()
  end

  @spec convert(map) :: __MODULE__.t()
  def convert(account) do
    account = struct(__MODULE__, account)

    %__MODULE__{
      account
      | access: Enum.map(account.access, &String.to_atom/1)
    }
  end

  @doc """
  Get the account with the given API key
  """
  @spec get(String.t()) :: {:error, :request_failed} | Gw2Api.Account.t()
  def get(apikey) do
    Request.get("https://api.guildwars2.com/v2/account?v=2022-01-01T00:00:00Z", apikey)
    |> case do
      {:ok, account} ->
        convert(account)

      {:error, :request_failed} ->
        {:error, :request_failed}
    end
  end
end
