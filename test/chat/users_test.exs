defmodule Chat.UsersTest do
  use Chat.DataCase

  alias Chat.Users

  describe "users" do
    alias Chat.Users.User

    import Chat.UsersFixtures

    @invalid_attrs %{name: nil, password_hash: nil}
  end
end
