defmodule Chat.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Chat.Users` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        name: "some name",
        password_hash: "some password_hash"
      })
      |> Chat.Users.create_user()

    user
  end
end
