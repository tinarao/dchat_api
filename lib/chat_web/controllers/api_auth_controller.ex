defmodule ChatWeb.ApiAuthController do
  alias Chat.Tokens
  alias ChatWeb.Auth

  use ChatWeb, :controller

  def login(conn, %{"name" => name, "password" => password}) do
    device_id = conn.assigns.device_id

    case Chat.Auth.login(name, password, device_id) do
      {:ok, token} -> conn |> put_status(201) |> json(%{token: token})
      {:error, reason} -> conn |> put_status(400) |> json(%{error: reason})
    end
  end

  def signup(conn, %{"name" => name, "password" => password}) do
    case Chat.Auth.signup(name, password) do
      {:ok, user} ->
        conn |> put_status(201) |> json(%{user: user})

      {:error, reason} ->
        conn |> put_status(400) |> json(%{error: reason})
    end
  end

  def verify_session(conn, _params) do
    # skeleton, pretty much
    # todo IMPROVE
    with {:ok, token} <- Auth.extract_token(conn),
         {:ok, data} <- Tokens.decrypt(token) do
      IO.inspect(data)

      conn
      |> put_status(200)
      |> json(%{data: data})
    else
      _ ->
        conn
        |> put_status(401)
        |> json(%{
          error: "unauthorized"
        })
    end
  end
end
