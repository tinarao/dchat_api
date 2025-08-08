defmodule ChatWeb.ApiRoomsController do
  alias Chat.RoomMembers
  alias Chat.Users
  alias Chat.Rooms
  use ChatWeb, :controller

  def show(conn, %{"id" => id}) do
    case Rooms.get_room(id) do
      nil -> conn |> put_status(404) |> json(%{error: "not found"})
      room -> conn |> put_status(200) |> json(%{room: room})
    end
  end

  def get_rooms_i_created(conn, _params) do
    user = conn.assigns.current_user

    conn
    |> put_status(200)
    |> json(%{
      rooms: Rooms.get_by_user_id(user.id)
    })
  end

  def list(conn, _) do
    conn |> put_status(200) |> json(%{rooms: Rooms.list_rooms()})
  end

  def create(conn, %{"withName" => with_name, "isPrivate" => is_private}) do
    user = conn.assigns.current_user

    with false <- user.name == with_name,
         %Users.User{} = contact <- Users.get_user_by_name(with_name),
         {:ok, room} <-
           Rooms.create_room(%{
             creator_id: user.id,
             is_private: is_private,
             name: "#{user.name} / #{contact.name}"
           }),
         {:ok, [member1, member2]} <- RoomMembers.on_room_create(room.id, user.id, contact.id) do
      conn
      |> put_status(201)
      |> json(%{
        room: room,
        members: [member1, member2]
      })
    else
      nil ->
        conn |> put_status(401) |> json(%{error: "пользователь " <> with_name <> " не найден"})

      true ->
        conn |> put_status(400) |> json(%{error: "нельзя создать комнату с самим собой"})

      {:error, reason} ->
        conn
        |> put_status(400)
        |> json(%{error: "не удалось создать комнату", description: reason})
    end
  end
end
