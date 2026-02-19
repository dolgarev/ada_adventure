with Ada.Text_IO;
with Ada.Strings.Unbounded;
with Ada.Strings.Unbounded.Text_IO;
with Game_Types; use Game_Types;
with Map_Loader;

procedure Main is
    use Ada.Text_IO;
    use Ada.Strings.Unbounded;
    use Ada.Strings.Unbounded.Text_IO;

    Game_Map : Location_Maps.Map;

    -- Global game state
    Player_At : Unbounded_String := To_Unbounded_String ("Start_Room");
    Finished  : Boolean := False;
    Input     : Unbounded_String;

begin
    -- Initialize game by loading from file
    Map_Loader.Load_Map ("res/locations.txt", Game_Map);

    if Game_Map.Is_Empty then
        Put_Line ("No locations found. Exiting.");
        return;
    end if;

    Put_Line ("Welcome to the Ada Adventure (Modular Edition)!");
    Put_Line ("Type 'quit' to exit.");
    New_Line;

    -- Main game loop
    while not Finished loop
        if not Game_Map.Contains (Player_At) then
            Put_Line
               ("Error: Current location '"
                & To_String (Player_At)
                & "' does not exist in the map.");
            exit;
        end if;

        declare
            Current_Data  : Location_Data renames Game_Map.Element (Player_At);
            Command_Found : Boolean := False;
        begin
            Put_Line (To_String (Current_Data.Description));
            Put ("> ");
            Input := Get_Line;

            if Input = "quit" then
                Finished := True;
                Put_Line ("Goodbye!");
            else
                -- Check exits
                for I in
                   Current_Data.Exits.First_Index
                   .. Current_Data.Exits.Last_Index
                loop
                    declare
                        Current_Exit : constant Exit_Type :=
                           Current_Data.Exits.Element (I);
                    begin
                        if Input = Current_Exit.Command then
                            Player_At := Current_Exit.Destination;
                            Put_Line
                               ("You go "
                                & To_String (Current_Exit.Command)
                                & ".");
                            Command_Found := True;
                            exit;
                        end if;
                    end;
                end loop;

                if not Command_Found then
                    Put_Line
                       ("I don't understand that command, or you cannot go that way.");
                end if;
            end if;
        end;

        New_Line;
    end loop;

end Main;
