defmodule DungeonCrawl.CLI.Main do
  alias Mix.Shell.IO, as: Shell
  alias DungeonCrawl.Room

  def start_game do
    welcome_message()
    adjust_probability(DungeonCrawl.Room.all(),select_dificulty()) 
    Shell.prompt("Press Enter to continue")
    crawl(hero_choice(), DungeonCrawl.Room.all())
  end

  defp crawl(%{hit_points: 0}, _) do
    Shell.prompt("")
    Shell.cmd("clear")
    Shell.info("Unfortunately your wounds are too many to keep walking.")
    Shell.info("You fall onto the floor without strength to carry on.")
    Shell.info("Game over!")
    Shell.prompt("")
  end

  defp crawl(character, rooms) do
    Shell.info("You keep moving forward to the next room.")
    Shell.prompt("Press Enter to continue")
    Shell.cmd("clear")
    Shell.info(DungeonCrawl.Character.current_stats(character))

    rooms
    |> DungeonCrawl.CLI.RoomActionsChoice.random_room()
    |> DungeonCrawl.CLI.RoomActionsChoice.start()
    |> trigger_action(character)
    |> handle_action_result
  end



  defp welcome_message do
    Shell.info("== Dungeon Crawl ===")
    Shell.info("You awake in a dungeon full of monsters.")
    Shell.info("You need to survive and find the exit.")
  end

  defp select_dificulty do
    Shell.info("Select the dificulty: ")
    dificulty = Shell.prompt("1-Easy, 2-Medium, 3-Hard")
    {option, _} = Integer.parse(dificulty)
    option
  end

  def adjust_probability(rooms, input) when input == 1 do
    _adjusted_rooms = Enum.map(rooms, fn room ->
      case room.id do
        1 ->
          %Room{room | probability: Range.new(1,50)}

        2 ->
          %Room{room | probability: Range.new(51, 100)}
      end
    end)
  end

  def adjust_probability(rooms, input) when input == 2 do
    _adjusted_rooms = Enum.map(rooms, fn room ->
      case room.id do
        1 ->
          %Room{room | probability: Range.new(1,35)}

        2 ->
          %Room{room | probability: Range.new(36, 100)}
      end
    end)
  end

  def adjust_probability(rooms, input) when input == 3 do
    _adjusted_rooms = Enum.map(rooms, fn room ->
      case room.id do
        1 ->
          %Room{room | probability: Range.new(1,15)}

        2 ->
          %Room{room | probability: Range.new(16, 100)}
      end
    end)
  end


  defp hero_choice do
    hero = DungeonCrawl.CLI.HeroChoice.start()
    %{hero | name: "You"}
  end



  defp trigger_action({room, action}, character) do
    Shell.cmd("clear")
    room.trigger.run(character, action)
  end

  defp handle_action_result({_, :exit}),
    do: Shell.info("You found the exit. You won the game. Congratulations!")

  defp handle_action_result({character, _}),
    do: crawl(character, DungeonCrawl.Room.all())
end
