defmodule PlanningPokerWeb.RoomLive.Show do
  use PlanningPokerWeb, :live_view

  @topic "room:planning"
  @estimation_topic "room:estimation"

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(PlanningPoker.PubSub, @topic)
    end

    {:ok, assign(socket, :current_task, nil)}
  end

  @impl true
  def handle_info({:current_task, task}, socket) do
    {:noreply, assign(socket, :current_task, task)}
  end

  @impl true
  def handle_event("estimate-task", %{"points" => points}, socket) do
    Phoenix.PubSub.broadcast(
      PlanningPoker.PubSub,
      @estimation_topic,
      {:estimate_task, socket.assigns.current_task.id, points}
    )

    {:noreply, socket}
  end
end
