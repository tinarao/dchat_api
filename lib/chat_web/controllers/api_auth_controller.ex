defmodule ChatWeb.ApiAuthController do
  alias Chat.Users
  alias Chat.Sessions
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

  def login(conn, _params) do
    conn |> put_status(400) |> json(%{error: "данные отсутствуют или некорректны"})
  end

  def signup(conn, %{"name" => name, "password" => password}) do
    case Chat.Auth.signup(name, password) do
      {:ok, user} ->
        conn |> put_status(201) |> json(%{user: user})

      {:error, reason} ->
        conn |> put_status(400) |> json(%{error: reason})
    end
  end

  def signup(conn, _params) do
    conn |> put_status(400) |> json(%{error: "данные отсутствуют или некорректны"})
  end

  def verify_session(conn, _params) do
    try do
      with {:ok, token} <- Auth.extract_token(conn),
           {:ok, data} <- Tokens.decrypt(token),
           {:ok, session} <- Sessions.get_session(token),
           user <- Users.get_user_by_name(session["user_name"]) do
        current_device_id = conn.assigns.device_id

        if user.id != data["user_id"] do
          raise "Некорректные данные сессии"
        end

        if user.name != session["user_name"] do
          raise "Некорректные данные сессии"
        end

        if current_device_id != data["device_id"] or data["device_id"] != session["device_id"] do
          raise "Некорректные данные сессии"
        end

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
    rescue
      # check this thing
      # todo tests
      e -> conn |> put_status(403) |> json(%{error: e})
    end
  end
end
