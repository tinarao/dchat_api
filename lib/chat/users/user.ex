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
    field :password, :string, virtual: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :password_hash])
    |> validate_required([:name, :password_hash])
    |> unique_constraint(:name)
  end

  def register_changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :password])
    |> validate_required([:name, :password])
    |> validate_length(:password, min: 8, message: "password is too short")
    |> validate_length(:name, min: 4, message: "name is too short")
    |> validate_length(:name, max: 128, message: "name is too long")
    |> unique_constraint(:name)
    |> put_password_hash()
  end

  def put_password_hash(changeset) do
    case get_change(changeset, :password) do
      nil -> changeset
      password -> put_change(changeset, :password_hash, Argon2.hash_pwd_salt(password))
    end
  end
end
