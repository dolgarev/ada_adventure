with Ada.Text_IO;
with Ada.Strings.Unbounded;
with Ada.Strings.Unbounded.Text_IO;
with GNAT.Regpat; use GNAT.Regpat;
with Ada.Exceptions;
with Ada.Directories;

package body Map_Loader is
    use Ada.Text_IO;
    use Ada.Strings.Unbounded;
    use Ada.Strings.Unbounded.Text_IO;

    procedure Load_Map (File_Name : String; Map : out Location_Maps.Map) is
        File             : File_Type;
        Line             : Unbounded_String;
        Current_Loc_Name : Unbounded_String := Null_Unbounded_String;
        Current_Data     : Location_Data;

        -- Regex patterns
        -- Header: [Name]
        Header_Re : constant Pattern_Matcher := Compile ("^\[(.*)\]$");
        -- Description: Text
        Desc_Re   : constant Pattern_Matcher := Compile ("^Description: (.*)$");
        -- Exit: Cmd -> Dest
        Exit_Re   : constant Pattern_Matcher := Compile ("^Exit: (.*) \-\> (.*)$");

        Matches : Match_Array (0 .. 2); -- 0 is full match, 1 and 2 are groups

        procedure Save_Current_Loc is
        begin
            if Current_Loc_Name /= Null_Unbounded_String then
                Map.Include (Current_Loc_Name, Current_Data);
            end if;
        end Save_Current_Loc;

    begin
        Open (File, In_File, File_Name);
        while not End_Of_File (File) loop
            Line := Get_Line (File);
            Line := Trim (Line, Ada.Strings.Both);

            if Length (Line) > 0 then
                declare
                    S : constant String := To_String (Line);
                begin
                    -- Try Header
                    Match (Header_Re, S, Matches);
                    if Matches (1) /= No_Match then
                        Save_Current_Loc;
                        Current_Loc_Name := To_Unbounded_String (S (Matches (1).First .. Matches (1).Last));
                        Current_Data := (Description => Null_Unbounded_String,
                                        Exits       => Exit_Vectors.Empty_Vector);
                    else
                        -- Try Description
                        Match (Desc_Re, S, Matches);
                        if Matches (1) /= No_Match then
                            Current_Data.Description := To_Unbounded_String (S (Matches (1).First .. Matches (1).Last));
                        else
                            -- Try Exit
                            Match (Exit_Re, S, Matches);
                            if Matches (1) /= No_Match and Matches (2) /= No_Match then
                                Current_Data.Exits.Append
                                   ((Command     => To_Unbounded_String (S (Matches (1).First .. Matches (1).Last)),
                                     Destination => To_Unbounded_String (S (Matches (2).First .. Matches (2).Last))));
                            end if;
                        end if;
                    end if;
                end;
            end if;
        end loop;
        Save_Current_Loc;
        Close (File);
    exception
        when E : others =>
            Put_Line
               ("Error: Could not load " & File_Name);
            Put_Line ("Exception: " & Ada.Exceptions.Exception_Name (E));
            Put_Line ("Message: " & Ada.Exceptions.Exception_Message (E));
            Put_Line ("Current directory: " & Ada.Directories.Current_Directory);
            if Is_Open (File) then
                Close (File);
            end if;
    end Load_Map;

end Map_Loader;
