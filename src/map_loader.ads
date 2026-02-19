with Game_Types; use Game_Types;

package Map_Loader is

    -- Helper to parse the locations.txt file
    procedure Load_Map (File_Name : String; Map : out Location_Maps.Map);

end Map_Loader;
