unit ObjectID;
{$mode objfpc}{$H+}
interface
uses
  Classes, SysUtils;
type
  TObjWithID = object
    private
      id:integer;
    Public
      Constructor Create;
      Destructor Done;
  end;
implementation

Constructor TObjWithID.Create;
begin end;

Destructor TObjWithID.Done;
begin end;

end.

