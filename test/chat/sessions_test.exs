defmodule Chat.SessionsTest do
  use Chat.DataCase
  alias Chat.Sessions

  @user_id 1
  @user_name "petr"
  @device_id "zhiguli"

  describe "sessions" do
    test "create_session creates a session" do
      user_data = %{
        user_name: @user_name,
        device_id: @device_id
      }

      assert :ok = Sessions.create_session(@user_id, user_data)
      assert Sessions.session_exists?(@user_id)
    end

    test "get_session returns session data" do
      user_data = %{
        user_name: @user_name,
        device_id: @device_id
      }

      Sessions.create_session(@user_id, user_data)

      case Sessions.get_session(@user_id) do
        {:ok, session_data} ->
          assert session_data["device_id"] == user_data.device_id
          assert session_data["user_name"] == user_data.user_name
          assert session_data["created_at"]
          assert session_data["last_activity"]
        {:error, reason} ->
          flunk("Failed to get session: #{reason}")
      end
    end

    test "delete_session removes session" do
      user_data = %{
        user_name: @user_name,
        device_id: @device_id
      }

      Sessions.create_session(@user_id, user_data)
      assert Sessions.session_exists?(@user_id)

      Sessions.delete_session(@user_id)
      refute Sessions.session_exists?(@user_id)
    end

    test "session_exists? returns false for non-existent session" do
      refute Sessions.session_exists?(999)
    end
  end
end
