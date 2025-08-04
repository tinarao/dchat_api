defmodule Chat.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :cipher_text, :binary
      add :secret_id, :string
      add :room_id, references(:rooms, on_delete: :nothing)
      add :sender_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:messages, [:room_id])
    create index(:messages, [:sender_id])
  end
end
