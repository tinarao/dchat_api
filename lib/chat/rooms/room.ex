defmodule Chat.Rooms.Room do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Jason.Encoder,
    only: [:id, :name, :is_private, :creator, :inserted_at, :updated_at]
  }

  schema "rooms" do
    field :name, :string
    field :is_private, :boolean, default: false
    belongs_to :creator, Chat.Users.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:name, :is_private, :creator_id])
    |> validate_required([:name, :is_private, :creator_id])
  end
end
