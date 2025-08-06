defmodule Chat.Auth do
  alias Chat.Tokens
  alias Chat.Users

  def login(name, password, user_agent, remote_ip) do
    with %Users.User{} = user <- Users.get_user_by_name(name),
         true <- Users.verify_password(user, password),
         device_id <- generate_device_id(user_agent, remote_ip),
         token <-
           Tokens.encrypt(%{
             user_id: user.id,
             device_id: device_id
           }) do
      {:ok, token |> to_string()}
    else
      nil ->
        {:error, "пользователь не найден"}

      {:error, reason} ->
        IO.inspect(reason, label: "Chat.Auth.Login at 19")
        {:error, "некорректные авторизационные данные"}
    end
  end

  def generate_device_id(user_agent, remote_ip) do
    data =
      %{
        user_agent: user_agent,
        ip_address: remote_ip
      }
      |> Jason.encode!()

    :crypto.hash(:sha256, data)
    |> Base.encode64()
  end
end
