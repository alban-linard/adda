package body Adda.Generator is

    use Successors;

    overriding procedure Initialize
       (Object : in out Decision_Diagram) is
    begin
        if Object.Data /= null then
            Object.Data.Reference_Counter.all :=
               Object.Data.Reference_Counter.all + 1;
        end if;
    end Initialize;
    overriding procedure Adjust
       (Object : in out Decision_Diagram) renames Initialize;

    overriding procedure Finalize
       (Object : in out Decision_Diagram) is
    begin
        if Object.Data /= null then
            Object.Data.Reference_Counter.all :=
               Object.Data.Reference_Counter.all - 1;

            if Object.Data.Reference_Counter.all = 0 then
                null; -- FIXME
            end if;
        end if;
    end Finalize;

    function Hash
       (Element : in Decision_Diagram)
        return Hash_Type is
    begin
        return Hash_Type (Element.Data.Identifier);
    end Hash;

    function "="
       (Left, Right : in Decision_Diagram)
        return Boolean is
    begin
        return Left.Data
           = Right.Data; -- TODO: check that it is a pointer comparison
    end "=";

    function Hash
       (Element : in Structure)
        return Hash_Type is
    begin
        case Element.Of_Type is
            when Terminal =>
                return Hash_Terminal (Element.Value);

            when Non_Terminal =>
                declare

                    Result  : Hash_Type := Hash_Variable (Element.Variable);
                    Current : Successors.Cursor :=
                       Successors.First (Element.Alpha);

                begin
                    while Successors.Has_Element (Current) loop
                        Result :=
                           Result
                           xor
                           (Hash_Value (Successors.Key (Current))
                            xor Hash (Successors.Element (Current)));
                        Successors.Next (Current);
                    end loop;
                    return Result;
                end;
        end case;
    end Hash;

    overriding function "="
       (Left, Right : in Structure)
        return Boolean is
    begin
        if Left.Of_Type = Right.Of_Type then
            case Left.Of_Type is
                when Terminal =>
                    return Left.Value = Right.Value;

                when Non_Terminal =>
                    return Left.Variable = Right.Variable
                       and then Left.Alpha = Right.Alpha;
            end case;

        else
            return False;
        end if;
    end "=";

    function Make
       (Value : in Terminal_Type)
        return Decision_Diagram is

        To_Insert : constant Structure :=
           (Of_Type           => Terminal,
            Identifier        => 0,
            Reference_Counter => null,
            Value             => Value);
        Position : Unicity.Cursor;
        Inserted : Boolean;

    begin
        Unicity_Table.Insert
           (New_Item => To_Insert,
            Position => Position,
            Inserted => Inserted);

        declare

            Subdata : aliased Structure      := Unicity.Element (Position);
            Data    : constant Any_Structure := Subdata'Unchecked_Access;

        begin
            if Inserted then
                Identifier                := Identifier + 1;
                Subdata.Identifier        := Identifier + 1;
                Subdata.Reference_Counter := new Natural'(0);
            end if;
            return (Controlled with Data => Data);
        end;
    end Make;

    function Make
       (Variable  : in Variable_Type;
        Value     : in Value_Type;
        Successor : in Decision_Diagram)
        return Decision_Diagram is

        Result : Decision_Diagram;

    begin
        return Result;
    end Make;

begin
    null;
end Adda.Generator;
