defmodule DungeonCrawl.CLI.RoomActionsChoice do
  alias Mix.Shell.IO, as: Shell
  import DungeonCrawl.CLI.BaseCommands

  def start(room) do
    Shell.info(room.description)
    chosen_action = ask_for_option(room.actions)
    {room, chosen_action}
  end

  def random_room(rooms) do
    probability_room = Enum.random(1..100)
    Enum.find(rooms, fn room -> probability_room in room.probability end)
    # Enum.find(rooms, & probability_room in &1.probability)
  end
end
