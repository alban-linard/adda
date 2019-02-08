package body Adda.Defaults is

    function Hash
       (Element : in Integer)
        return Hash_Type is
    begin
        return Hash_Type (Element);
    end Hash;

end Adda.Defaults;
