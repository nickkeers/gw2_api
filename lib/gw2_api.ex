defmodule Gw2Api do
  @moduledoc """
  Documentation for `Gw2Api`.
  """

  use Application

  def api_key() do
    Application.get_env(Gw2Api, :api_key, "41261896-9769-1D4B-A746-8188C0DF9C54B3000CED-F788-45AF-817D-A992062A7614")
  end


  def start(_type, _args) do
    Supervisor.start_link([
      {Finch, name: Gw2Finch}
    ], strategy: :one_for_one)
  end
end
