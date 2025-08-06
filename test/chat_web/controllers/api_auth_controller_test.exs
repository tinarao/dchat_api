defmodule ChatWeb.ApiAuthControllerTest do
  alias Chat.Sessions
  alias Chat.UsersFixtures
  use ChatWeb.ConnCase, async: true

  describe "POST /api/auth/signup" do
    test "request with invalid data should fail", %{conn: conn} do
      conn = post(conn, ~p"/api/auth/signup", %{name: "", password: "1"})
      assert conn.status == 400

      response = json_response(conn, 400)
      assert error = response["error"]
      assert error["password"] |> Enum.at(0) == "пароль слишком короткий"
      assert error["name"] |> Enum.at(0) == "поле не может быть пустым"
    end

    test "request with valid values should and create user", %{conn: conn} do
      data = %{
        name: "tinarao",
        password: "aboba_1488"
      }

      conn = post(conn, ~p"/api/auth/signup", data)
      assert conn.status == 201

      response = json_response(conn, 201)
      assert user = response["user"]
      assert user["id"] |> is_number()
      assert user["name"] == data.name

      # basically should not return any passwords
      refute user["password"]
      refute user["password_hash"]
    end

    test "should not register user with duplicate name", %{conn: conn} do
      data = %{
        name: "tinarao",
        password: "aboba_1488"
      }

      conn = post(conn, ~p"/api/auth/signup", data)
      assert conn.status == 201

      conn = post(conn, ~p"/api/auth/signup", data)
      assert conn.status == 400

      response = json_response(conn, 400)
      assert response["error"]
      assert response["error"] == "пользователь уже существует"
    end
  end

  describe "POST /api/auth/login" do
    test "request with unknown user should fail", %{conn: conn} do
      conn = post(conn, ~p"/api/auth/login", %{name: "unknown", password: "10"})
      assert conn.status == 400
    end

    test "request with valid data should work fine", %{conn: conn} do
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
