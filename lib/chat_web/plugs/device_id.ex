defmodule ChatWeb.Plugs.DeviceID do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    remote_ip = ChatWeb.Auth.extract_ip(conn)
    user_agent = ChatWeb.Auth.extract_user_agent(conn)
    device_id = Chat.Auth.generate_device_id(user_agent, remote_ip)

    assign(conn, :device_id, device_id)
  end
end
