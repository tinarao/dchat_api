defmodule Chat.RoomsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Chat.Rooms` context.
  """

  @doc """
  Generate a room.
  """
  def room_fixture(attrs \\ %{}) do
    {:ok, room} =
      attrs
      |> Enum.into(%{
        is_private: true,
        name: "some name"
      })
      |> Chat.Rooms.create_room()

    room
  end
end
