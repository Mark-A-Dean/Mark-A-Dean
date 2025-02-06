section Metadata;
shared Metadata.document=(
//Indicates the object is a parameter. Default: false.
    IsParameter as logical,
//Indicates the object is required. Default: true.
    IsRequired as logical,
//Person or entity who created the object.
    Creator as text,
//An account of the object.
    Description as text,
//Name of the object to document.
    ObjectName as text,
// Name of the base type. Default: "any".
    OfType as text,
/*
One or more examples of the object's use. Requires the elements Description,
Code, and Result in order.
Ex: {"What the function does", "myFxn(x)","Actual result"}
*/
    optional Examples as nullable list
    ) as record =>
    let
        _param=if IsParameter=true then true else false,
        _required=if IsRequired=true then true else false,
        _type=if OfType <> "any" then OfType else "any",
        _doc=[
            Documentation.Creator=Creator,
            Documentation.IsParameter=_param,
            Documentation.IsRequired=_required,
            Documentation.LongDescription=Description,
            Documentation.Type=_type,
            Documentation.Examples=Examples
        ]
    in
        _doc;
