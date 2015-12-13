unit Station;
{$mode objfpc}{$H+}
interface
uses
  Classes, SysUtils, ObjectID;
type
  TStation = object(TObjWithID)
    Private
      name:string;
      SWayNum:integer;
      x:integer;
      y:integer;
      isvisited:boolean;
      Coefficient:integer;
    Public
      Procedure SetName(s:string);
      Function GetName:string;
      Procedure SetXCoord(i:integer);
      Function GetXCoord:integer;
      Procedure SetYCoord(i:integer);
      Function GetYCoord:integer;
      Procedure AddSWay;
      Function NumSWays:integer; // Testing
      Procedure SetVisited(b:boolean);
      Function GetVisited:boolean;
      Function CheckSWays:boolean;
      Procedure SetCoefficient(i:integer);
      Function GetCoefficient:integer;
    Public
      Constructor Create;
      Destructor Done;
  end;

implementation
Procedure TStation.SetName(s:string);
Begin
  Name:=s;
end;

Function TStation.GetName:string;
begin
  GetName:=name;
end;

Procedure TStation.SetXCoord(i:integer);
begin
  x:=i;
end;

Function TStation.GetXCoord:integer;
begin
  GetXCoord:=x;
end;

Procedure TStation.SetYCoord(i:integer);
begin
  y:=i;
end;

Function TStation.GetYCoord:integer;
begin
  GetYCoord:=y;
end;

Procedure TStation.AddSWay;
begin
  SWayNum:=SWayNum+1;
end;

Function TStation.NumSWays:integer;  // FOR TEST. TESTING
begin
  NumSWays:=SWayNum;
end;

Function TStation.CheckSWays:boolean;
begin
  CheckSWays:=true;
  if SWayNum>=2 then CheckSWays:=false;
end;

Procedure TStation.SetVisited(b:boolean);
begin
  isVisited:=b;
end;

Function TStation.GetVisited:boolean;
begin
  GetVisited:=isVisited;
end;

Procedure TStation.SetCoefficient(i:integer);
begin
  Coefficient:=i;
end;

Function TStation.GetCoefficient:integer;
begin
  GetCoefficient:=Coefficient;
end;

Constructor TStation.Create;
begin
  Name:='';
  SWayNum:=0;
  x:=0;
  y:=0;
  Coefficient:=32767;
end;


Destructor TStation.Done;
begin end;

end.

