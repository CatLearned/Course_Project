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
    procedure AddCrossingItemClick(Sender: TObject);
    procedure AddStationButtonChange(Sender: TObject);
    procedure AddStationItemClick(Sender: TObject);
    procedure AddWayItemClick(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure UndergroundMapClick(Sender: TObject);
    Procedure AddStationList(v:TStation);
    Function CheckStationName(s:string):boolean;
    Function CheckCoords(x,y,r:integer):boolean;
    function GetStation(s:string):TStation;
  private
     Redactor:boolean;
     Stationlist:Item;
     Head:PItem;
     _station:TStation;
     P:PItem;
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
end;

procedure TForm1.UndergroundMapClick(Sender: TObject); // Рисование на Canvas и создание объекта "станция".
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
end;

procedure TForm1.AddWayItemClick(Sender: TObject);
begin
  AddStationPanel.Visible:=False;
  AddWayPanel.Visible:=True;
  AddCrossingPanel.Visible:=False;
end;


procedure TForm1.Edit1Click(Sender: TObject);
begin
end;

procedure TForm1.AddCrossingItemClick(Sender: TObject);
begin
  AddStationPanel.Visible:=False;
  AddWayPanel.Visible:=False;
  AddCrossingPanel.Visible:=True;
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

function TForm1.GetStation(s:string):TStation;
  var standart:PItem;
begin
  standart:=head;
  while Head<>nil do
  begin
    p:=Head;
    if p^.Value.GetName=s then GetStation:=p^.Value;
    Head:=Head^.next;
  end;
  head:=standart;
end;

end.

