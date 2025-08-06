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
    # |> validate_length(:password,
    #   min: 8,
    #   max: 128,
    #   message: "пароль должен иметь длину от 8 до 128 символов"
    # )
    |> unique_constraint(:name)
  end

  def register_changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :password])
    |> validate_required([:name, :password])
    |> validate_length(:password, min: 8)
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
