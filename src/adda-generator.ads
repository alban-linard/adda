with Ada.Containers.Indefinite_Hashed_Maps;
with Ada.Containers.Indefinite_Hashed_Sets;
with Ada.Finalization;
use Ada.Containers;

generic
    type Variable_Type is private;
    with function Hash_Variable
       (Element : in Variable_Type)
        return Hash_Type;
    type Value_Type is private;
    with function Hash_Value
       (Element : in Value_Type)
        return Hash_Type;
    type Terminal_Type is private;
    with function Hash_Terminal
       (Element : in Terminal_Type)
        return Hash_Type;
package Adda.Generator is
    type Decision_Diagram is private;

    type Structure (<>) is private;
    function Make
       (Value : in Terminal_Type)
        return Decision_Diagram;
    function Make
       (Variable  : in Variable_Type;
        Value     : in Value_Type;
        Successor : in Decision_Diagram)
        return Decision_Diagram;

private
    use Ada.Finalization;

    type Any_Structure is access constant Structure;

    type Decision_Diagram is
        new Controlled with record
            Data : Any_Structure;
        end record;
    overriding procedure Initialize
       (Object : in out Decision_Diagram);
    overriding procedure Adjust
       (Object : in out Decision_Diagram);
    overriding procedure Finalize
       (Object : in out Decision_Diagram);
    function Hash
       (Element : in Decision_Diagram)
        return Hash_Type;
    function "="
       (Left, Right : in Decision_Diagram)
        return Boolean;
    package Successors is new Indefinite_Hashed_Maps (Key_Type => Value_Type,
        Element_Type => Decision_Diagram, Hash => Hash_Value,
        Equivalent_Keys => "=", "=" => "=");

    type Structure_Type is
       (Terminal,
        Non_Terminal);

    type Structure (Of_Type : Structure_Type) is
        record
            Identifier        : Natural        := 0;
            Reference_Counter : access Natural := null;
            case Of_Type is
                when Terminal =>
                    Value : Terminal_Type;

                when Non_Terminal =>
                    Variable : Variable_Type;
                    Alpha    : Successors.Map;
            end case;
        end record;
    function Hash
       (Element : in Structure)
        return Hash_Type;
    function "="
       (Left, Right : in Structure)
        return Boolean;
    package Unicity is new Indefinite_Hashed_Sets (Element_Type => Structure,
        Hash => Hash, Equivalent_Elements => "=", "=" => "=");
    Identifier    : Natural := 0;
    Unicity_Table : Unicity.Set;
end Adda.Generator;
