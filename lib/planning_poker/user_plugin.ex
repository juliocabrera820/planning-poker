defmodule PlanningPoker.UserPlugin do
  use PromEx.Plugin

  @submit_username_event [:planning_poker, :room, :submit_username]

  @impl true
  def event_metrics(_opts) do
    [
      user_general_event_metrics()
    ]
  end

  defp user_general_event_metrics do
    Event.build(:planning_poker_user_general_event_metrics, [
      counter(@submit_username_event ++ [:count],
        event_name: @submit_username_event,
        description: "Count of submit username events"
      )
    ])
  end

  def submit_username_event_name, do: @submit_username_event
end
