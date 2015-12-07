unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, windows, Menus,
  ExtCtrls, StdCtrls, ComCtrls, Spin, Way, Station, ObjectID, ConstantsTypes;

//type TStationlist = specialize List<TStation>;
type
  { TForm1 }
  TForm1 = class(TForm)
    AddWayButton: TButton;
    AddCrossingButton: TButton;
    AddElementItem: TMenuItem;
    AddStationItem: TMenuItem;
    AddWayItem: TMenuItem;
    AddCrossingItem: TMenuItem;
    Image1: TImage;
    UnderGroundMap: TImage;
    MinWayLabel: TLabel;
    AddCrossingPanel: TPanel;
    MinCrossingLabel: TLabel;
    NameOfStationFirstCrossingField: TEdit;
    NameOfStationFirstCrossingLabel: TLabel;
    NameOfStationSecondCrossingField: TEdit;
    NameOfStationSecondCrossingLabel: TLabel;
    MapPanel: TPanel;
    TimeWayEdit: TSpinEdit;
    TimeCrossingEdit: TSpinEdit;
    TimeWayLabel: TLabel;
    NameOfStationFirstField: TEdit;
    NameOfStationSecondLabel: TLabel;
    NameOfStationSecondField: TEdit;
    NameOfStationLabel: TLabel;
    NameOfStationField: TEdit;
    MainMenu: TMainMenu;
    FileItem: TMenuItem;
    NameOfStationFirstLabel: TLabel;
    NewItem: TMenuItem;
    AddStationPanel: TPanel;
    AddWayPanel: TPanel;
    SaveFileItem: TMenuItem;
    OpenFileItem: TMenuItem;
    AddStationButton: TToggleBox;
    TimeCrossingLabel: TLabel;
    procedure AddCrossingButtonClick(Sender: TObject);
    procedure AddCrossingItemClick(Sender: TObject);
    procedure AddStationItemClick(Sender: TObject);
    procedure AddWayItemClick(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    {Station}
    procedure AddStationButtonChange(Sender: TObject);
    procedure UndergroundMapClick(Sender: TObject);
    Procedure AddStationList(v:TStation);
    Function CheckStationName(s:string):boolean;
    Function CheckCoords(x,y,r:integer):boolean;
    function GetStation(s:string):PItem;
    {Way}
    procedure AddWayButtonClick(Sender: TObject);
    Procedure AddWayList(v:TWay);
  private
    {Переменные для Station}
    _station:TStation;
    Stationlist:SItem;
    Head:PItem;
    P:PItem;
    {Переменные для Way}
    _way:TWay;
    WayList:WayItem;
    WayHead:WPItem;
    WP:WPItem;
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }


procedure TForm1.FormCreate(Sender: TObject);
begin
//  Stationlist.Create;
  _station.Create;
  Head:=nil;
  _way.create;
  WayHead:=nil;
end;

procedure TForm1.UndergroundMapClick(Sender: TObject); // Рисование на Canvas и создание объекта "станция". Добавление Объекта станция в список с использованием процедуры.
var
  coord: TPoint;
begin
  if AddStationButton.Checked and not (NameOfStationField.Text = '') and CheckStationName(NameOfStationField.Text) then
  begin
    GetCursorPos(coord);
    coord := Form1.UndergroundMap.ScreenToClient(coord);
    if CheckCoords(coord.x, coord.y, r) then
    begin
      //ShowMessage('(' + IntToStr(coord.X) + ' ,' + IntToStr(coord.Y) + ')');
      Form1.UndergroundMap.Canvas.ellipse(coord.X-r, coord.Y-r, coord.X+r, coord.Y+r);
      Form1.UndergroundMap.Canvas.TextOut(coord.X+2*r, coord.Y-r, NameOfStationField.Text);
      _station.SetName(NameOfStationField.Text);
      _station.SetXCoord(coord.X);
      _station.SetYCoord(coord.y);
      AddStationList(_station);
      NameOfStationField.Text:='';
      NameOfStationField.SetFocus;
      AddStationButton.Checked:=not(AddStationButton.Checked);
    end
    else ShowMessage('Добавление невозможно. Рядом уже находится станция');
  end;
end;

procedure TForm1.AddStationItemClick(Sender: TObject);
begin
  AddStationPanel.Visible:=true;
  AddWayPanel.Visible:=False;
  AddCrossingPanel.Visible:=False;
  AddStationButton.Checked:=False;
end;

procedure TForm1.AddWayButtonClick(Sender: TObject);
begin
  if not (NameOfStationFirstField.Text='') and not (NameOfStationSecondField.Text='') then
  Begin
    if not (NameOfStationFirstField.Text=NameOfStationSecondField.Text) then
    begin
      if not CheckStationName(NameOfStationFirstField.Text) and not CheckStationName(NameOfStationSecondField.Text) then
      begin
        if GetStation(NameOfStationFirstField.Text)^.Value.CheckSWays
           and
           GetStation(NameOfStationSecondField.Text)^.Value.CheckSWays then
        begin
          _way.SetFStation(GetStation(NameOfStationFirstField.Text)^.Value);
          GetStation(NameOfStationFirstField.Text)^.Value.AddSWay;
          _way.SetSStation(GetStation(NameOfStationSecondField.Text)^.Value);
          GetStation(NameOfStationSecondField.Text)^.Value.AddSWay;
          _way.SetTime(TimeWayEdit.Value);
          _way.SetTransition(True);
          _way.SetVisited(False);
          AddWayList(_way);
          Form1.UndergroundMap.Canvas.MoveTo(_way.GetFStation.GetXCoord,_way.GetFStation.GetYCoord);
          Form1.UndergroundMap.Canvas.LineTo(_way.GetSStation.GetXCoord,_way.GetSStation.GetYCoord);
          Form1.UndergroundMap.Canvas.TextOut((_way.GetFStation.GetXCoord+_way.GetSStation.GetXCoord) div 2,
                                              (_way.GetFStation.GetYCoord+_way.GetSStation.GetYCoord) div 2,
                                              inttostr(_way.GetTime));
          ShowMessage(_way.GetFStation.GetName
                    + _way.GetSStation.GetName
                    + inttostr(_way.GetTime)
                    + booltostr(GetStation(NameOfStationFirstField.Text)^.Value.CheckSWays,'True','False')
                    + inttostr(GetStation(NameOfStationFirstField.Text)^.Value.NumSWays)
                    + BoolToStr(GetStation(NameOfStationSecondField.Text)^.Value.CheckSWays, 'True', 'False')
                    + inttostr(GetStation(NameOfStationSecondField.Text)^.Value.NumSWays));
        end
        else ShowMessage('У одной из станций исчерпан лимит путей. Попробуйте создать переход.');
      end
      else ShowMessage('Станции пути должны существовать');
    end
    else ShowMessage('Названия станций пути не могут совпадать');
  end
  else ShowMessage('Названия станций пути не могут быть пустыми');
end;

procedure TForm1.AddWayItemClick(Sender: TObject);
begin
  AddStationPanel.Visible:=False;
  AddWayPanel.Visible:=True;
  AddCrossingPanel.Visible:=False;
  AddStationButton.Checked:=False;
end;


procedure TForm1.Edit1Click(Sender: TObject);
begin
end;

procedure TForm1.AddCrossingItemClick(Sender: TObject);
begin
  AddStationPanel.Visible:=False;
  AddWayPanel.Visible:=False;
  AddCrossingPanel.Visible:=True;
  AddStationButton.Checked:=False;
end;

procedure TForm1.AddCrossingButtonClick(Sender: TObject);
begin
  if not (NameOfStationFirstCrossingField.Text='') and not (NameOfStationSecondCrossingField.Text='') then
  Begin
    if not (NameOfStationFirstCrossingField.Text=NameOfStationSecondCrossingField.Text) then
    begin
      if not CheckStationName(NameOfStationFirstCrossingField.Text) and not CheckStationName(NameOfStationSecondCrossingField.Text) then
      begin
        _way.SetFStation(GetStation(NameOfStationFirstCrossingField.Text)^.Value);
        _way.SetSStation(GetStation(NameOfStationSecondCrossingField.Text)^.Value);
        _way.SetTime(TimeCrossingEdit.Value);
        _way.SetTransition(False);
        _way.SetVisited(False);
        AddWayList(_way);
        //RISOVANIE
        Form1.UndergroundMap.Canvas.Pen.Style:= psDot;
        Form1.UndergroundMap.Canvas.MoveTo(_way.GetFStation.GetXCoord,_way.GetFStation.GetYCoord);
        Form1.UndergroundMap.Canvas.LineTo(_way.GetSStation.GetXCoord,_way.GetSStation.GetYCoord);
        Form1.UndergroundMap.Canvas.TextOut((_way.GetFStation.GetXCoord+_way.GetSStation.GetXCoord) div 2,(_way.GetFStation.GetYCoord+_way.GetSStation.GetYCoord) div 2,inttostr(_way.GetTime));
        Form1.UndergroundMap.Canvas.Pen.Style:= psSolid;
        //DOBAVIT'
      end
      else ShowMessage('Станции перехода должны существовать');
    end
    else ShowMessage('Названия станций перехода не могут совпадать');
  end
  else ShowMessage('Названия станций перехода не могут быть пустыми');
end;

procedure TForm1.AddStationButtonChange(Sender: TObject);
begin
  if not (CheckStationName(NameOfStationField.Text)) then
  Begin
    ShowMessage('Станция с названием '+NameOfStationField.Text+' уже существует, введите другое название');
    NameOfStationField.Text:='';
    NameOfStationField.SetFocus;
    AddStationButton.Checked:=not(AddStationButton.Checked);
  end;
end;
// New procedures
Procedure TForm1.AddStationList(v:TStation);
begin
  New(p);
  P^.value:=v;
  p^.next:=Head;
  Head:=p;
end;

Function TForm1.CheckStationName(s:string):boolean; // fixed.
  var standart:PItem;
begin
  standart:=head;
  CheckStationName:=true;
  while Head<>nil do
  begin
    p:=Head;
    if p^.Value.GetName=s then CheckStationName:=false;
    Head:=Head^.next;
  end;
  head:=standart;
end;

Function TForm1.CheckCoords(x,y,r:integer):boolean;
  var standart:PItem;
begin
  standart:=head;
  CheckCoords:=true;
  while Head<>nil do
  begin
    p:=Head;
    if (p^.Value.GetXCoord>x-2*r) and (p^.Value.GetXCoord<x+2*r) and
       (p^.Value.GetYCoord>y-2*r) and (p^.Value.GetYCoord<y+2*r) then CheckCoords:=false;
    Head:=Head^.next;
  end;
  head:=standart;
end;

function TForm1.GetStation(s:string):PItem;
  var standart:PItem;
begin
  standart:=head;
  while Head<>nil do
  begin
    p:=Head;
    if p^.Value.GetName=s then GetStation:=p;
    Head:=Head^.next;
  end;
  head:=standart;
end;

//Function TForm1.GetItemStation(s:string):PItem;
//  var standart:PItem;
//begin
//  standart:=head;
//  while Head<>nil do
//  begin
//    p:=Head;
//    if p^.Value.GetName=s then GetItemStation:=p;
//    Head:=Head^.next;
//  end;
//  head:=standart;
//end;

Procedure TForm1.AddWayList(v:TWay);
begin
  New(WP);
  WP^.value:=v;
  WP^.next:=WayHead;
  WayHead:=WP;
end;

end.

