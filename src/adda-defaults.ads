with Ada.Containers;
with Adda;
with Adda.Generator;

package Adda.Defaults is
    use Ada.Containers;
    function Hash
       (Element : in Integer)
        return Hash_Type;
    package All_Integer is new Adda.Generator (Variable_Type => Integer,
        Value_Type => Integer, Terminal_Type => Integer, Hash_Variable => Hash,
        Hash_Value => Hash, Hash_Terminal => Hash);
end Adda.Defaults;
