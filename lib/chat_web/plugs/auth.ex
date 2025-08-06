defmodule ChatWeb.Plugs.Protected do
  import Plug.Conn
  alias ChatWeb.Auth
  alias Chat.Tokens

  def init(opts), do: opts

  def call(conn, _opts) do
    # calculate device id
    # get session by token (cookie "sid")
    # verify user by this token
    # if no problem - :ok, else 401

    with {:ok, token} <- Auth.extract_token(conn),
         {:ok, _data} <- Tokens.decrypt(token) do
      # IO.inspect()
    else
      _ ->
        send_resp(conn, 401, "unauthorized")
    end
  end
end
