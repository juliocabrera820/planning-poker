defmodule PlanningPokerWeb.RoomLive.Index do
  use PlanningPokerWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:session, nil)
      |> assign(:url, nil)

    {:ok, socket}
  end

  @impl true
  def handle_event("submit-session", %{"session" => session}, socket) do
    slug = Slug.slugify(session, lower: true)
    session_url = url(~p"/room/planning/#{slug}")

    socket =
      socket
      |> assign(:session, session)
      |> assign(:url, session_url)

    {:noreply, socket}
  end
end
