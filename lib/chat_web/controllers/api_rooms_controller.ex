defmodule ChatWeb.ApiRoomsController do
  alias Chat.Rooms
  use ChatWeb, :controller

  def show(conn, %{"id" => id}) do
    case Rooms.get_room(id) do
      nil -> conn |> put_status(404) |> json(%{error: "not found"})
      room -> conn |> put_status(200) |> json(%{room: room})
    end
  end

  def list(conn, _) do
    conn |> put_status(200) |> json(%{rooms: Rooms.list_rooms()})
  end
end
