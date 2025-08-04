defmodule Chat.Tokens.Test do
  use Chat.DataCase

  @user_id 1
  @device_id "pringles_original_YEEEEEEESSS"

  @payload %{
    user_id: @user_id,
    device_id: @device_id
  }

  describe "tokens" do
    test "ecnrypt functions generates a binary token" do
      token = Chat.Tokens.encrypt(@payload)
      assert token |> is_binary()
    end

    test "decrypt can work on tokens generated via encrypt/1" do
      token = Chat.Tokens.encrypt(@payload)
      result = Chat.Tokens.decrypt(token)

      assert {:ok, decr} = result
      assert decr["user_id"] == @payload.user_id
      assert decr["device_id"] == @payload.device_id
    end
  end
end
