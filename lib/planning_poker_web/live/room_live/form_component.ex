defmodule PlanningPokerWeb.RoomLive.FormComponent do
  use PlanningPokerWeb, :live_component

  @user_joined_topic "room:user_joined"

  @impl true
  def render(assigns) do
    ~H"""
    <div class="bg-white shadow-lg rounded-lg overflow-hidden border-gray-300 mb-6">
      <div class="px-4 py-2">
        <h1 class="text-xl font-bold">Username</h1>
        <form phx-submit="submit-username">
          <input
            type="text"
            name="username"
            class="w-full px-3 py-2 mt-2 border rounded-lg"
            placeholder="type username"
          />
          <button
            type="submit"
            class="mt-4 bg-indigo-500 hover:bg-indigo-700 text-white font-bold py-2 px-3 rounded w-full"
          >
            Enter
          </button>
        </form>
      </div>
    </div>
    """
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
