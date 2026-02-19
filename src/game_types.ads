with Ada.Strings.Unbounded;
with Ada.Containers.Vectors;
with Ada.Containers.Indefinite_Hashed_Maps;
with Ada.Strings.Unbounded.Hash;

package Game_Types is
    use Ada.Strings.Unbounded;

    -- Record to represent a single exit from a location
    type Exit_Type is record
        Command     : Unbounded_String;
        Destination : Unbounded_String;
    end record;

    -- Vector to hold a dynamic number of exits for a location
    package Exit_Vectors is new
       Ada.Containers.Vectors
          (Index_Type   => Natural,
           Element_Type => Exit_Type);

    -- Record to hold all data for a single location
    type Location_Data is record
        Description : Unbounded_String;
        Exits       : Exit_Vectors.Vector;
    end record;

    -- Hashed Map to store locations by their name (string key)
    package Location_Maps is new
       Ada.Containers.Indefinite_Hashed_Maps
          (Key_Type        => Unbounded_String,
           Element_Type    => Location_Data,
           Hash            => Ada.Strings.Unbounded.Hash,
           Equivalent_Keys => Ada.Strings.Unbounded."=");

end Game_Types;
