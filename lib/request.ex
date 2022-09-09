defmodule Gw2Api.Request do
  def get(url, apikey \\ :no_api_key) do
    headers =
      if apikey != :no_api_key do
        [
          {"Authorization", "Bearer #{apikey}"}
        ]
      else
        []
      end

    Finch.build(:get, url, headers)
    |> Finch.request(Gw2Finch)
    |> parse_response()
  end

  defp parse_response({:ok, %Finch.Response{status: 200, body: body}}) do
    {:ok, Jason.decode!(body, keys: :atoms)}
  end

  defp parse_response(_res) do
    {:error, :request_failed}
  end
end
