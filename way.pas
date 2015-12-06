unit Way;
{$mode objfpc}{$H+}
interface
uses
  Classes, SysUtils, ObjectID, Station;
type
  TWay=object(TObjWithID)
    private
      Station1:TStation;
      Station2:TStation;
      Time:integer;
      Transition:boolean; // true - путь, false - переход.
      isVisited:boolean;  // При поиске пути.True - посещена.
    public
      Procedure SetTime(i:integer);
      Function GetTime:integer;
      Constructor Create;
      Destructor Done;
  end;

implementation
Procedure TWay.SetTime(i:integer);
begin
  Time:=i;
end;

Function TWay.GetTime:integer;
begin
  GetTime:=Time;
end;

Constructor TWay.Create;
begin
  //Station1:=;
  //Station2:=;
  Time:=0;
  Transition:=false;
  IsVisited:=false;
end;

Destructor TWay.Done;
begin end;

end.

