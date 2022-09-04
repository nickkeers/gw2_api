defmodule Gw2Api do
  @moduledoc """
  Documentation for `Gw2Api`.
  """

  use Application

  def api_key() do
    Application.get_env(Gw2Api, :api_key, "")
  end


  def start(_type, _args) do
    Supervisor.start_link([
      {Finch, name: Gw2Finch}
    ], strategy: :one_for_one)
  end
end
