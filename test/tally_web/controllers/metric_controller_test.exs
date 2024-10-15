defmodule TallyWeb.MetricControllerTest do
  use TallyWeb.ConnCase

  import Tally.TrackerFixtures

  alias Tally.Tracker.Metric

  @create_attrs %{
    name: "some name",
    description: "some description"
  }
  @update_attrs %{
    name: "some updated name",
    description: "some updated description"
  }
  @invalid_attrs %{name: nil, description: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all metrics", %{conn: conn} do
      conn = get(conn, ~p"/api/metrics")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create metric" do
    test "renders metric when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/metrics", metric: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/metrics/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some description",
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/metrics", metric: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update metric" do
    setup [:create_metric]

    test "renders metric when data is valid", %{
      conn: conn,
      metric: %Metric{id: id} = metric
    } do
      conn = put(conn, ~p"/api/metrics/#{metric}", metric: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/metrics/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some updated description",
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, metric: metric} do
      conn = put(conn, ~p"/api/metrics/#{metric}", metric: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete metric" do
    setup [:create_metric]

    test "deletes chosen metric", %{conn: conn, metric: metric} do
      conn = delete(conn, ~p"/api/metrics/#{metric}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/metrics/#{metric}")
      end
    end
  end

  defp create_metric(_) do
    metric = metric_fixture()
    %{metric: metric}
  end
end
