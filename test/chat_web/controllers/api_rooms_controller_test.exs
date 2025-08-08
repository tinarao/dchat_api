defmodule ChatWeb.ApiRoomsControllerTest do
  alias Chat.UsersFixtures
  use ChatWeb.ConnCase, async: true

  @mock_user %{
    name: "name",
    password: "aboba_aboba"
  }

  @second_mock_user %{
    name: "second_name",
    password: "second_aboba_aboba"
  }

  defp authorized_conn(conn) do
      _user = UsersFixtures.user_fixture(@mock_user)
      login_conn = post(conn, ~p"/api/auth/login", @mock_user)
      assert login_conn.status == 201
      response = json_response(login_conn, 201)
      token = response["token"]

      conn
      |> put_req_header("authorization", "Bearer " <> token)
  end

  describe "GET /api/rooms/show/:id" do
    test "should return 404 if room with provided id is not exist", %{conn: conn} do
      auth_conn = authorized_conn(conn)
      conn = get(auth_conn, ~p"/api/rooms/show/999")
      assert conn.status == 404
    end
  end

  describe "POST /api/rooms" do
    test "should successfully create room with room_members", %{conn: conn} do
      contact = UsersFixtures.user_fixture(@second_mock_user)
      auth_conn = authorized_conn(conn)

      conn = post(auth_conn, ~p"/api/rooms/", %{withName: contact.name, isPrivate: true})
      assert conn.status == 201
    end
  end
end
