defmodule LiveChatWeb.ConnectLiveTest do
  use LiveChatWeb.ConnCase
  import Phoenix.LiveViewTest

  describe "static mount" do
    test "shows the form", %{conn: conn} do
      conn = get(conn, "/")
      assert html = html_response(conn, 200)

      assert html =~ "Enter an email"
      assert html =~ "Enter a name"
    end
  end

  describe "connected mount" do
    test "shows the form", %{conn: conn} do
      {:ok, view, html} = live(conn, "/")

      IO.inspect(view)

      assert html =~ "Enter an email"
      assert html =~ "Enter a name"
    end
  end

  describe "form submission" do
    test "requires all fields to be filled", %{conn: conn} do
      {:ok, view, html} = live(conn, "/")

      form = %{"user" => %{"name" => "", "email" => ""}}

      html = render_submit(view, "join", form)

      result = Floki.find(html, ".text-field-error[data-field=name]")
      assert length(result) == 1
      assert Floki.text(result) =~ "can't be blank"

      result = Floki.find(html, ".text-field-error[data-field=email]")
      assert length(result) == 1
      assert Floki.text(result) =~ "can't be blank"
    end

    test "valid submissions render the name", %{conn: conn} do
      {:ok, view, html} = live(conn, "/")

      form = %{"user" => %{"name" => "Edgar", "email" => "edgar@edgar"}}

      html = render_submit(view, "join", form)

      assert Floki.find(html, ".text-field-error") == []
      assert render(view) =~ "Welcome, Edgar!"
    end
  end
end
