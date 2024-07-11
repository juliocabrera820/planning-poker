defmodule PlanningPokerWeb.RoomServer do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    {:ok, %{users: [], session_state: :waiting_users, reveal_cards: false, current_task: nil}}
  end

  def add_user(username) do
    GenServer.call(__MODULE__, {:add_user, username})
  end

  def get_users do
    GenServer.call(__MODULE__, :get_users)
  end

  def reveal_cards do
    GenServer.call(__MODULE__, {:reveal_cards})
  end

  def get_cards_state do
    GenServer.call(__MODULE__, {:get_cards_state})
  end

  def set_current_task(task) do
    GenServer.call(__MODULE__, {:set_current_task, task})
  end

  def get_current_task do
    GenServer.call(__MODULE__, {:get_current_task})
  end

  def estimate_task(username, points) do
    GenServer.call(__MODULE__, {:estimate_task, username, points})
  end

  def set_session_state(state) do
    GenServer.call(__MODULE__, {:set_session_state, state})
  end

  def get_session_state do
    GenServer.call(__MODULE__, {:get_session_state})
  end

  def handle_call({:set_session_state, session_state}, _from, state) do
    updated_state = %{state | session_state: session_state}
    {:reply, updated_state, updated_state}
  end

  def handle_call({:get_session_state}, _from, state) do
    {:reply, state.session_state, state}
  end

  def handle_call({:estimate_task, username, points}, _from, state) do
    updated_users =
      Enum.map(state.users, fn user ->
        if user.username == username do
          %{user | points: points, voted: true}
        else
          user
        end
      end)

    updated_state = %{state | users: updated_users}
    {:reply, updated_state, updated_state}
  end

  def handle_call({:set_current_task, task}, _from, state) do
    updated_state = %{state | current_task: task}
    {:reply, updated_state, updated_state}
  end

  def handle_call({:get_current_task}, _from, state) do
    {:reply, state.current_task, state}
  end

  def handle_call({:add_user, username}, _from, state) do
    updated_users = [%{username: username, points: 0, voted: false} | state.users]
    updated_state = %{state | users: updated_users}
    {:reply, updated_users, updated_state}
  end

  def handle_call(:get_users, _from, state) do
    {:reply, state.users, state}
  end

  def handle_call({:reveal_cards}, _from, state) do
    updated_state = %{state | reveal_cards: true}
    {:reply, updated_state, updated_state}
  end

  def handle_call({:get_cards_state}, _from, state) do
    {:reply, state.reveal_cards, state}
  end
end
