defmodule Gw2Api.Request do
  def get(url) do
    apikey = Gw2Api.api_key()

    Finch.build(:get, url, [
      {"Authorization", "Bearer #{apikey}"}
    ])
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
