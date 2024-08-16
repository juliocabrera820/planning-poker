defmodule PlanningPokerWeb.RoomLive.Show do
  use PlanningPokerWeb, :live_view

  alias PlanningPoker.Tasks.Task
  alias PlanningPokerWeb.RoomServer
  alias PlanningPoker.UserPlugin

  @topic "room:planning"
  @estimation_topic "room:estimation"
  @user_joined_topic "room:user_joined"
  @cards_state_topic "room:cards_state"
  @points [1, 2, 3, 5, 8, 13, "?"]


  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(PlanningPoker.PubSub, @topic)
      Phoenix.PubSub.subscribe(PlanningPoker.PubSub, @estimation_topic)
      Phoenix.PubSub.subscribe(PlanningPoker.PubSub, @user_joined_topic)
      Phoenix.PubSub.subscribe(PlanningPoker.PubSub, @cards_state_topic)
    end

    socket =
      socket
      |> assign(:points, @points)
      |> assign(:current_task, RoomServer.get_current_task())
      |> assign(:username, nil)
      |> assign(:current_index, nil)
      |> assign(:tasks, Task.list_tasks())
      |> assign(:users, RoomServer.get_users())
      |> assign(:session_state, RoomServer.get_session_state())
      |> assign(:reveal_cards, RoomServer.get_cards_state())

    {:ok, socket}
  end

  @impl true
  def handle_info({:current_task}, socket) do
    socket =
      socket
      |> assign(:current_task, RoomServer.get_current_task())
      |> assign(:session_state, RoomServer.get_session_state())
      |> assign(:reveal_cards, RoomServer.get_cards_state())
      |> assign(:users, RoomServer.get_users())
      |> assign(:current_index, nil)

    {:noreply, socket}
  end

  @impl true
  def handle_info({:reveal_cards}, socket) do
    {:noreply, assign(socket, :reveal_cards, RoomServer.get_cards_state())}
  end

  @impl true
  def handle_info({:estimate_task, username, points}, socket) do
    RoomServer.estimate_task(username, points)
    RoomServer.set_session_state(:can_reveal_cards)

    socket =
      socket
      |> assign(:users, RoomServer.get_users())
      |> assign(:session_state, RoomServer.get_session_state())

    {:noreply, socket}
  end

  @impl true
  def handle_info({:user_joined}, socket) do
    updated_users = RoomServer.get_users()

    socket =
      socket
      |> assign(:users, updated_users)

    {:noreply, socket}
  end

  @impl true
  def handle_event("reveal_cards", _unsigned_params, socket) do
    RoomServer.reveal_cards()
    Phoenix.PubSub.broadcast(PlanningPoker.PubSub, @cards_state_topic, {:reveal_cards})
    {:noreply, socket}
  end

  @impl true
  def handle_event("start-estimation", %{"task-id" => task_id}, socket) do
    task = Task.get_task(task_id)
    RoomServer.start_estimation(task, :voting)
    RoomServer.reset_cards_state()

    Phoenix.PubSub.broadcast(PlanningPoker.PubSub, @topic, {:current_task})
    {:noreply, socket}
  end

  @impl true
  def handle_event("submit-username", %{"username" => username}, socket) do
    RoomServer.add_user(username)

    :telemetry.execute(UserPlugin.submit_username_event_name(), %{count: 1}, %{username: username})

    socket =
      socket
      |> assign(:username, username)

    Phoenix.PubSub.broadcast(PlanningPoker.PubSub, @user_joined_topic, {:user_joined})
    {:noreply, socket}
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
end
