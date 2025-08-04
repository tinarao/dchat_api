defmodule Chat.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Jason.Encoder,
    only: [:id, :cipher_text, :secret_id, :sender, :inserted_at, :updated_at]
  }

  schema "messages" do
    field :cipher_text, :binary
    field :secret_id, :string
    belongs_to :room, Chat.Rooms.Room
    belongs_to :sender, Chat.Users.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:cipher_text, :secret_id, :room_id, :sender_id])
    |> validate_required([:cipher_text, :secret_id, :room_id, :sender_id])
  end
end
