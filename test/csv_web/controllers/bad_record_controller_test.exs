defmodule CsvWeb.BadRecordControllerTest do
  use CsvWeb.ConnCase

  import Csv.BadRecordsFixtures

  @create_attrs %{date_created: ~N[2022-10-26 16:57:00], description: "some description", link: "some link", uid: "some uid"}
  @update_attrs %{date_created: ~N[2022-10-27 16:57:00], description: "some updated description", link: "some updated link", uid: "some updated uid"}
  @invalid_attrs %{date_created: nil, description: nil, link: nil, uid: nil}

  describe "index" do
    test "lists all bad_records", %{conn: conn} do
      conn = get(conn, Routes.bad_record_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Bad records"
    end
  end

  describe "new bad_record" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.bad_record_path(conn, :new))
      assert html_response(conn, 200) =~ "New Bad record"
    end
  end

  describe "create bad_record" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.bad_record_path(conn, :create), bad_record: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.bad_record_path(conn, :show, id)

      conn = get(conn, Routes.bad_record_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Bad record"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.bad_record_path(conn, :create), bad_record: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Bad record"
    end
  end

  describe "edit bad_record" do
    setup [:create_bad_record]

    test "renders form for editing chosen bad_record", %{conn: conn, bad_record: bad_record} do
      conn = get(conn, Routes.bad_record_path(conn, :edit, bad_record))
      assert html_response(conn, 200) =~ "Edit Bad record"
    end
  end

  describe "update bad_record" do
    setup [:create_bad_record]

    test "redirects when data is valid", %{conn: conn, bad_record: bad_record} do
      conn = put(conn, Routes.bad_record_path(conn, :update, bad_record), bad_record: @update_attrs)
      assert redirected_to(conn) == Routes.bad_record_path(conn, :show, bad_record)

      conn = get(conn, Routes.bad_record_path(conn, :show, bad_record))
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, bad_record: bad_record} do
      conn = put(conn, Routes.bad_record_path(conn, :update, bad_record), bad_record: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Bad record"
    end
  end

  describe "delete bad_record" do
    setup [:create_bad_record]

    test "deletes chosen bad_record", %{conn: conn, bad_record: bad_record} do
      conn = delete(conn, Routes.bad_record_path(conn, :delete, bad_record))
      assert redirected_to(conn) == Routes.bad_record_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.bad_record_path(conn, :show, bad_record))
      end
    end
  end

  defp create_bad_record(_) do
    bad_record = bad_record_fixture()
    %{bad_record: bad_record}
  end
end
