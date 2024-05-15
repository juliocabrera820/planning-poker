defmodule PlanningPokerWeb.RoomLive.Index do
  use PlanningPokerWeb, :live_view

  alias PlanningPoker.Tasks.Task

  @topic "room:planning"
  @estimation_topic "room:estimation"
  @user_joined_topic "room:user_joined"

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(PlanningPoker.PubSub, @estimation_topic)
    Phoenix.PubSub.subscribe(PlanningPoker.PubSub, @user_joined_topic)

    socket =
      socket
      |> assign(:tasks, Task.list_tasks())
      |> assign(:users, [])
      |> assign(:current_task, nil)
      |> assign(:estimations, [])

    {:ok, socket}
  end

  @impl true
  def handle_event("start-estimation", %{"task-id" => task_id}, socket) do
    task = Task.get_task(task_id)
    Phoenix.PubSub.broadcast(PlanningPoker.PubSub, @topic, {:current_task, task})
    {:noreply, socket}
  end

  @impl true
  def handle_info({:estimate_task, username, points}, socket) do
    socket =
      socket
      |> assign(:estimations, [%{username: username, points: points} | socket.assigns.estimations])

    {:noreply, socket}
  end

  @impl true
  def handle_info({:user_joined, username}, socket) do
    socket =
      socket
      |> assign(:users, [username | socket.assigns.users])

    {:noreply, socket}
  end
end
