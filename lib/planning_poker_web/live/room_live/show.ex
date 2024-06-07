defmodule PlanningPokerWeb.RoomLive.Show do
  use PlanningPokerWeb, :live_view

  @topic "room:planning"
  @estimation_topic "room:estimation"
  @user_joined_topic "room:user_joined"
  @points [1, 2, 3, 5, 8, 13, "?"]

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(PlanningPoker.PubSub, @topic)
    end

    socket =
      socket
      |> assign(:points, @points)
      |> assign(:current_task, nil)
      |> assign(:username, nil)
      |> assign(:current_index, nil)

    {:ok, socket}
  end

  @impl true
  def handle_info({:current_task, task}, socket) do
    {:noreply, assign(socket, :current_task, task)}
  end

  @impl true
  def handle_event("estimate-task", %{"points" => points, "index" => index}, socket) do
    Phoenix.PubSub.broadcast(
      PlanningPoker.PubSub,
      @estimation_topic,
      {:estimate_task, socket.assigns.username, points}
    )

    socket = socket |> assign(:current_index, String.to_integer(index))
    {:noreply, socket}
  end

  @impl true
  def handle_event("submit-username", %{"username" => username}, socket) do
    socket =
      socket
      |> assign(:username, username)

    Phoenix.PubSub.broadcast(PlanningPoker.PubSub, @user_joined_topic, {:user_joined, username})

    {:noreply, socket}
  end
end
