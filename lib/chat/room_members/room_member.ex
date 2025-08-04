defmodule Chat.RoomMembers.RoomMember do
  use Ecto.Schema
  import Ecto.Changeset

  schema "room_members" do
    belongs_to :room, Chat.Rooms.Room
    belongs_to :user, Chat.Users.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(room_member, attrs) do
    room_member
    |> cast(attrs, [:room_id, :user_id])
    |> validate_required([:room_id, :user_id])
  end
end
