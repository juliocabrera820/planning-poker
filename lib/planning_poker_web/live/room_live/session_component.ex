defmodule PlanningPokerWeb.RoomLive.SessionComponent do
  use PlanningPokerWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="rounded-lg overflow-hidden border-gray-300 mb-6">
      <div class="px-4 py-2">
        <h1 class="text-xl font-bold">Session</h1>
        <form phx-submit="submit-session">
          <input
            type="text"
            name="session"
            class="w-full px-3 py-2 mt-2 border rounded-lg"
            placeholder="Type session"
          />
          <button
            type="submit"
            class="mt-4 bg-indigo-500 hover:bg-indigo-700 text-white font-bold py-2 px-3 rounded w-full"
          >
            Create
          </button>
        </form>
      </div>
    </div>
    """
  end
end
