defmodule ChatWeb.ApiAuthController do
  alias Chat.Tokens
  alias ChatWeb.Auth

  use ChatWeb, :controller

  def login(conn, %{"name" => name, "password" => password}) do
    remote_ip = Auth.extract_ip(conn)
    user_agent = Auth.extract_user_agent(conn)

    case Chat.Auth.login(name, password, user_agent, remote_ip) do
      {:ok, token} ->
        conn |> put_status(201) |> json(%{token: token})

      {:error, reason} ->
        conn |> put_status(400) |> json(%{error: reason})
    end
  end

  def verify_session(conn, _params) do
    with {:ok, token} <- Auth.extract_token(conn),
         {:ok, data} <- Tokens.decrypt(token) do
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
