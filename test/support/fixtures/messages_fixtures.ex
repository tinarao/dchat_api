defmodule Chat.MessagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Chat.Messages` context.
  """

  @doc """
  Generate a message.
  """
  def message_fixture(attrs \\ %{}) do
    {:ok, message} =
      attrs
      |> Enum.into(%{
        cipher_text: "some cipher_text",
        secret_id: "some secret_id"
      })
      |> Chat.Messages.create_message()

    message
  end
end
