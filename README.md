# Ada Adventure

A simple text-based adventure game written in Ada. The game map is loaded dynamically from a resource file, allowing for easy expansion and modification of the adventure.

## Project Structure

- `src/main.adb`: The main source code containing game logic and the resource parser.
- `res/locations.txt`: The game's map data, including descriptions and exits.
- `ada_adventure.gpr`: GNAT Project file for building the application.
- `dest/`: Directory for compiled objects and the final executable.

## How to Build

The project uses the GNAT toolchain. To build the game, run the following command from the project root:

```bash
gprbuild -P ada_adventure.gpr
```

The resulting executable will be located in the `dest/` directory.

## How to Play

Run the executable:

```bash
./dest/main
```

Follow the on-screen prompts to explore the world. Commands are usually directions (like `north`, `south`, `east`, `west`) or specific actions described in the location text. Type `quit` to exit the game.

## Map Resource Format (`res/locations.txt`)

The game map is defined in `res/locations.txt` using a simple text format:

- **Locations** are defined within square brackets: `[Location_Name]`
- **Descriptions** must start with `Description: `
- **Exits** must start with `Exit: ` followed by `command -> Destination_Name`

Example:
```text
[Start_Room]
Description: You are in a small room.
Exit: north -> Dark_Forest
```

The game always starts at a location named `Start_Room`.
