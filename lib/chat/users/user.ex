defmodule Chat.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Jason.Encoder,
    only: [:id, :name, :inserted_at, :updated_at]
  }

  schema "users" do
    field :name, :string
    field :password_hash, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :password_hash])
    |> validate_required([:name, :password_hash])
    |> validate_length(:password,
      min: 8,
      max: 128,
      message: "пароль должен иметь длину от 8 до 128 символов"
    )
    |> unique_constraint(:name)
  end
end
