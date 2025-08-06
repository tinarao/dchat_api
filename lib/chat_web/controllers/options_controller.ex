defmodule ChatWeb.OptionsController do
  use ChatWeb, :controller

  def options(conn, _opts) do
    conn |> send_resp(200, "")
  end
end
