unit Lists;
{$mode objfpc}{$H+}
interface
uses
  Classes, SysUtils, way, station;
type
  generic List <TItem> = class
    type
      PItem = ^Item;
      Item = record
        Value:TItem;
        next:PItem;
      end;
    private
      first : PItem;
    Public
      constructor Create;
      Procedure add(v:TItem);
      Destructor Done;
  end;
implementation

constructor List.Create;
begin
  First := NIL;
end;

Procedure List.add(v:TItem);
var
  P:PItem;
begin
  New(p);
  P^.value:=v;
  p^.next:=first;
  First:=p;
end;

Destructor List.Done;
var p:PItem;
Begin
  while first<>nil do
  begin
    p:=first;
    First:=First^.next;
    Dispose(p);
  end;
end;

end.

