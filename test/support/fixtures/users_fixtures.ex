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
      |> Chat.Users.create_user()

    # |> Enum.into(%{
    #   name: attrs.username,
    #   password: attrs.password
    # })

    user
  end
end
