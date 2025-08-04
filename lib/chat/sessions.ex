defmodule Chat.Sessions do
  @session_ttl 3600 # hour

  def create_session(user_id, user_data) do
    session_data = %{
      user_name: user_data.user_name,
      device_id: user_data.device_id,
      created_at: DateTime.utc_now() |> DateTime.to_iso8601(),
      last_activity: DateTime.utc_now() |> DateTime.to_iso8601()
    }

    Chat.Redis.set_session(user_id, session_data, @session_ttl)
  end

  def get_session(user_id) do
    case Chat.Redis.get_session(user_id) do
      nil -> {:error, :session_not_found}
      session_data -> {:ok, session_data}
    end
  end

  def session_exists?(user_id) do
    Chat.Redis.session_exists?(user_id)
  end

  def update_activity(user_id) do
    case get_session(user_id) do
      {:ok, session_data} ->
        updated_data = Map.put(session_data, :last_activity, DateTime.utc_now() |> DateTime.to_iso8601())
        Chat.Redis.set_session(user_id, updated_data, @session_ttl)
      {:error, _} ->
        {:error, :session_not_found}
    end
  end

  def delete_session(user_id) do
    Chat.Redis.delete_session(user_id)
  end

  def get_user_id(user_id) do
    case get_session(user_id) do
      {:ok, session_data} -> {:ok, session_data.user_id}
      {:error, reason} -> {:error, reason}
    end
  end

  def get_user_data(user_id) do
    case get_session(user_id) do
      {:ok, session_data} -> {:ok, session_data.user_data}
      {:error, reason} -> {:error, reason}
    end
  end
end
