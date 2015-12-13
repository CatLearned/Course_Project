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
      Transition:boolean;   // true - путь, false - переход.
      isVisited:boolean;    // При поиске пути.True - посещена.
    public
      Procedure SetTime(i:integer);
      Function GetTime:integer;
      Procedure SetFStation(S:TStation);
      Function GetFStation:TStation;
      Procedure SetSStation(S:TStation);
      Function GetSStation:TStation;
      Procedure SetTransition(b:boolean);
      Function GetTransition:boolean;
      Procedure SetVisited(b:boolean);
      Function GetVisited:boolean;
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

Procedure TWay.SetFStation(S:TStation);
Begin
  Station1:=S;
end;

Function TWay.GetFStation:TStation;
Begin
  GetFStation:=Station1;
end;

Procedure TWay.SetSStation(S:TStation);
begin
  Station2:=S;
end;

Function TWay.GetSStation:TStation;
begin
  GetSStation:=Station2;
end;

Procedure TWay.SetTransition(b:boolean);
begin
  Transition:=b;
end;

Function TWay.GetTransition:boolean;
begin
  GetTransition:=Transition;
end;

Procedure TWay.SetVisited(b:boolean);
begin
  isVisited:=b;
end;

Function TWay.GetVisited:boolean;
begin
  GetVisited:=isVisited;
end;

Destructor TWay.Done;
begin end;

end.

