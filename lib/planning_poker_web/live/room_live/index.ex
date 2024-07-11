defmodule PlanningPokerWeb.RoomLive.Index do
  use PlanningPokerWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:session, nil)

    {:ok, socket}
  end

  @impl true
  def handle_event("submit-session", %{"session" => session}, socket) do
    socket =
      socket
      |> assign(:session, session)

    {:noreply, socket}
  end
end
