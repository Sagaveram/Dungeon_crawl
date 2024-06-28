defmodule DungeonCrawl.Room do
  alias DungeonCrawl.Room
  alias DungeonCrawl.Room.Triggers

  import DungeonCrawl.Room.Action

  defstruct id: nil, description: nil, actions: [], trigger: nil, probability: nil

  def all do
    [
      %Room{
        id: 1,
        description: "You can see the light of day. You found the exit!",
        actions: [forward()],
        trigger: Triggers.Exit,
        probability: 1..30
      },
      %Room{
        id: 2,
        description: "You can see an enemy blocking your path.",
        actions: [forward()],
        trigger: Triggers.Enemy,
        probability: 31..100
      }
    ]
  end
end
