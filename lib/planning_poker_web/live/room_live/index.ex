defmodule PlanningPokerWeb.RoomLive.Index do
  use PlanningPokerWeb, :live_view

  alias PlanningPoker.Tasks.Task

  @topic "room:planning"
  @estimation_topic "room:estimation"

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(PlanningPoker.PubSub, @estimation_topic)

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
  def handle_info({:estimate_task, task_id, points}, socket) do
    socket =
      socket
      |> assign(:estimations, [%{task_id: task_id, points: points} | socket.assigns.estimations])

    {:noreply, socket}
  end
end
