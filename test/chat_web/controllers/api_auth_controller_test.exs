defmodule ChatWeb.ApiAuthControllerTest do
  alias Chat.Sessions
  alias Chat.UsersFixtures
  use ChatWeb.ConnCase, async: true

  describe "POST /api/auth/login" do
    test "request with unknown user should fail", %{conn: conn} do
      conn = post(conn, ~p"/api/auth/login", %{name: "unknown", password: "10"})
      assert conn.status === 400
    end

    test "request with valid data should pass, create session and return token", %{conn: conn} do
      changeset = %{
        name: "tinarao",
        password: "123456_789"
      }

      UsersFixtures.user_fixture(changeset)
      conn = post(conn, ~p"/api/auth/login", changeset)

      assert conn.status == 201
      response = json_response(conn, 201)
      assert Map.has_key?(response, "token")
      token = response["token"]

      # validate session
      assert Sessions.session_exists?(token)
      assert {:ok, session} = Sessions.get_session(token)
      assert session["user_name"] == changeset.name
    end
  end

  describe "GET /api/auth/verify" do
    test "request without token should fail", %{conn: conn} do
      conn
      |> put_req_header("authorization", "Bearer")

      conn = get(conn, ~p"/api/auth/verify")

      assert conn.status === 401
    end

    test "request with invalid token value should fail", %{conn: conn} do
      conn
      |> put_req_header("authorization", "Bearer undefined")

      conn = get(conn, ~p"/api/auth/verify")

      assert conn.status === 401
    end
  end
end
