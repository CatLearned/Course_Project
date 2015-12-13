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
    AlgorithmRunButton: TButton;
    DelWayButton: TButton;
    DelStationButton: TButton;
    DelStationEdit: TEdit;
    BackGround: TImage;
    DelElementItem: TMenuItem;
    DelStationItem: TMenuItem;
    DelSubWayItem: TMenuItem;
    DelStationPanel: TPanel;
    DelStationLabel: TLabel;
    DelWayPanel: TPanel;
    DelFStationWayEdit: TEdit;
    DelSStationWayEdit: TEdit;
    DelWayLabel: TLabel;
    AlgorithmItem: TMenuItem;
    AlgorithmPanel: TPanel;
    AlgorithmFStationEdit: TEdit;
    AlgorithmSStationEdit: TEdit;
    AlgorithmFStationLabel: TLabel;
    AlgorithmSStationLabel: TLabel;
    AlgorithmCaptionOfAlgorithm: TLabel;
    RunAlgorithmItem: TMenuItem;
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
    procedure AlgorithmRunButtonClick(Sender: TObject);
    procedure DelStationButtonClick(Sender: TObject);
    procedure DelStationItemClick(Sender: TObject);
    procedure DelSubWayItemClick(Sender: TObject);
    procedure DelWayButtonClick(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    {Station}
    procedure AddStationButtonChange(Sender: TObject);
    procedure DelElementItemClick(Sender: TObject);
    procedure BackGroundClick(Sender: TObject);
    procedure RunAlgorithmItemClick(Sender: TObject);
    procedure UndergroundMapClick(Sender: TObject);
    Procedure AddStationList(v:TStation);
    Function CheckStationName(s:string):boolean;
    Function CheckCoords(x,y,r:integer):boolean;
    function GetStation(s:string):PItem;
    {Way}
    procedure AddWayButtonClick(Sender: TObject);
    Procedure AddWayList(v:TWay);
    function GetWay(s,s1:string):WPItem;
    function CheckWay(s,s1:string):boolean;
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
      _station.SetVisited(false);
      _station.SetCoefficient(32767);
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
  DelStationPanel.Visible:=False;
  DelWayPanel.Visible:=False;
  AlgorithmPanel.Visible:=False;
end;

procedure TForm1.AddWayButtonClick(Sender: TObject);
var Selected:integer;
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
        if CheckWay(NameOfStationFirstField.Text, NameOfStationSecondField.Text) then
        begin
          Selected:=MessageDlg('Между этими станциями уже есть связь, перезаписать?', mtConfirmation, [mbYes, mbNo], 0);
          if Selected = mrYes then
          begin
            //GetWay(NameOfStationFirstField.Text, NameOfStationSecondField.Text)^.Value.SetFStation(GetStation(NameOfStationFirstField.Text)^.Value);
            //GetWay(NameOfStationFirstField.Text, NameOfStationSecondField.Text)^.Value.SetSStation(GetStation(NameOfStationSecondField.Text)^.Value);
            GetWay(NameOfStationFirstField.Text, NameOfStationSecondField.Text)^.Value.SetTransition(True);
            GetWay(NameOfStationFirstField.Text, NameOfStationSecondField.Text)^.Value.SetTime(TimeWayEdit.Value);
            GetWay(NameOfStationFirstField.Text, NameOfStationSecondField.Text)^.Value.SetVisited(False);
            Form1.UndergroundMap.Canvas.MoveTo(GetWay(NameOfStationFirstField.Text, NameOfStationSecondField.Text)^.Value.GetFStation.GetXCoord,_way.GetFStation.GetYCoord);
            Form1.UndergroundMap.Canvas.LineTo(GetWay(NameOfStationFirstField.Text, NameOfStationSecondField.Text)^.Value.GetSStation.GetXCoord,_way.GetSStation.GetYCoord);
            Form1.UndergroundMap.Canvas.TextOut((GetWay(NameOfStationFirstField.Text, NameOfStationSecondField.Text)^.Value.GetFStation.GetXCoord+_way.GetSStation.GetXCoord) div 2,
                                                (GetWay(NameOfStationFirstField.Text, NameOfStationSecondField.Text)^.Value.GetFStation.GetYCoord+_way.GetSStation.GetYCoord) div 2,
                                                inttostr(GetWay(NameOfStationFirstField.Text, NameOfStationSecondField.Text)^.Value.GetTime));
            ShowMessage('Изменение Выполнено');
          end
        end
        else
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
        else ShowMessage('У одной из станций исчерпан лимит путей. Попробуйте создать переход.')
        end
      else ShowMessage('Станции пути должны существовать');
    end
    else ShowMessage('Названия станций совпадают или не существуют');
  end
  else ShowMessage('Названия станций пути не могут быть пустыми');
end;

procedure TForm1.AddWayItemClick(Sender: TObject);
begin
  AddStationPanel.Visible:=False;
  AddWayPanel.Visible:=True;
  AddCrossingPanel.Visible:=False;
  AddStationButton.Checked:=False;
  DelStationPanel.Visible:=False;
  DelWayPanel.Visible:=False;
  AlgorithmPanel.Visible:=False;
end;

procedure TForm1.AlgorithmRunButtonClick(Sender: TObject);
begin

end;

procedure TForm1.DelStationButtonClick(Sender: TObject);
begin
  if not (DelStationEdit.Text='') then
  if CheckStationName(DelStationEdit.Text)=false then
  if CheckWay(DelStationEdit.Text, '')=false then
  ShowMessage('Deleting')
  else ShowMessage('Эта станция является связной, Удалите все связи этой станции')
  else ShowMessage('Такой Станции не существует, возможно она уже удалена.')
  else ShowMessage('Нельзя удалить пустую станцию.');
end;

procedure TForm1.DelStationItemClick(Sender: TObject);
begin
  AddStationPanel.Visible:=False;
  AddWayPanel.Visible:=False;
  AddCrossingPanel.Visible:=False;
  AddStationButton.Checked:=False;
  DelStationPanel.Visible:=True;
  DelWayPanel.Visible:=False;
  AlgorithmPanel.Visible:=False;
end;

procedure TForm1.DelSubWayItemClick(Sender: TObject);
begin
  AddStationPanel.Visible:=False;
  AddWayPanel.Visible:=False;
  AddCrossingPanel.Visible:=False;
  AddStationButton.Checked:=False;
  DelStationPanel.Visible:=False;
  DelWayPanel.Visible:=True;
  AlgorithmPanel.Visible:=False;
end;

procedure TForm1.DelWayButtonClick(Sender: TObject);
begin
  if not (DelFStationWayEdit.Text='') and not (DelSStationWayEdit.Text='') then
  if not (DelFStationWayEdit.Text=DelSStationWayEdit.Text) then
  if not CheckStationName(DelFStationWayEdit.Text) and not CheckStationName(DelSStationWayEdit.Text) then
  if CheckWay(DelFStationWayEdit.Text, DelSStationWayEdit.Text) then
  ShowMessage('Процедура удаления')
  else ShowMessage('Путь не существует, возможно он был удалён')
  else ShowMessage('Станции должны существовать')
  else ShowMessage('Введённые станции одинаковы или не существуют')
  else ShowMessage('Нельзя удалить путь между несуществующими станциями');
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
  DelStationPanel.Visible:=False;
  DelWayPanel.Visible:=False;
  AlgorithmPanel.Visible:=False;
end;

procedure TForm1.AddCrossingButtonClick(Sender: TObject);
var Selected:integer;
begin
  if not (NameOfStationFirstCrossingField.Text='') and not (NameOfStationSecondCrossingField.Text='') then
  Begin
    if not (NameOfStationFirstCrossingField.Text=NameOfStationSecondCrossingField.Text) then
    begin
      if not CheckStationName(NameOfStationFirstCrossingField.Text) and not CheckStationName(NameOfStationSecondCrossingField.Text) then
      begin
        if CheckWay(NameOfStationFirstCrossingField.Text, NameOfStationSecondCrossingField.Text) then
        begin
          Selected:=MessageDlg('Между этими станциями уже есть связь, перезаписать?', mtConfirmation, [mbYes, mbNo], 0);
          if Selected = mrYes then
          begin
            //GetWay(NameOfStationFirstField.Text, NameOfStationSecondField.Text)^.Value.SetFStation(GetStation(NameOfStationFirstField.Text)^.Value);
            //GetWay(NameOfStationFirstField.Text, NameOfStationSecondField.Text)^.Value.SetSStation(GetStation(NameOfStationSecondField.Text)^.Value);
            GetWay(NameOfStationFirstCrossingField.Text, NameOfStationSecondCrossingField.Text)^.Value.SetTransition(False);
            GetWay(NameOfStationFirstCrossingField.Text, NameOfStationSecondCrossingField.Text)^.Value.SetTime(TimeCrossingEdit.Value);
            GetWay(NameOfStationFirstCrossingField.Text, NameOfStationSecondCrossingField.Text)^.Value.SetVisited(False);
            Form1.UndergroundMap.Canvas.Pen.Style:= psDot;
            Form1.UndergroundMap.Canvas.MoveTo(GetWay(NameOfStationFirstCrossingField.Text, NameOfStationSecondCrossingField.Text)^.Value.GetFStation.GetXCoord,_way.GetFStation.GetYCoord);
            Form1.UndergroundMap.Canvas.LineTo(GetWay(NameOfStationFirstCrossingField.Text, NameOfStationSecondCrossingField.Text)^.Value.GetSStation.GetXCoord,_way.GetSStation.GetYCoord);
            Form1.UndergroundMap.Canvas.TextOut((GetWay(NameOfStationFirstCrossingField.Text, NameOfStationSecondCrossingField.Text)^.Value.GetFStation.GetXCoord+_way.GetSStation.GetXCoord) div 2,
                                                (GetWay(NameOfStationFirstCrossingField.Text, NameOfStationSecondCrossingField.Text)^.Value.GetFStation.GetYCoord+_way.GetSStation.GetYCoord) div 2,
                                                inttostr(GetWay(NameOfStationFirstCrossingField.Text, NameOfStationSecondCrossingField.Text)^.Value.GetTime));
            Form1.UndergroundMap.Canvas.Pen.Style:= psSolid;
            ShowMessage('Изменение Выполнено');
          end;
        end
        else
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
        end;
      end
      else ShowMessage('Станции перехода должны существовать');
    end
    else ShowMessage('Названия станций совпадают или не существуют');
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

procedure TForm1.DelElementItemClick(Sender: TObject);
begin

end;

procedure TForm1.BackGroundClick(Sender: TObject);
begin

end;

procedure TForm1.RunAlgorithmItemClick(Sender: TObject);
begin
  AddStationPanel.Visible:=False;
  AddWayPanel.Visible:=False;
  AddCrossingPanel.Visible:=False;
  AddStationButton.Checked:=False;
  DelStationPanel.Visible:=False;
  DelWayPanel.Visible:=False;
  AlgorithmPanel.Visible:=True;
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

function TForm1.GetWay(s,s1:string):WPItem;
  var standart:WPItem;
begin
  standart:=WayHead;
  while WayHead<>nil do
  begin
    WP:=WayHead;
    if ((Wp^.Value.GetFStation.GetName=s) and (Wp^.Value.GetSStation.GetName=s1)) or ((Wp^.Value.GetFStation.GetName=s1) and (Wp^.Value.GetSStation.GetName=s)) then GetWay:=wp;
    WayHead:=WayHead^.next;
  end;
   WayHead:=standart;
end;

function TForm1.CheckWay(s,s1:string):boolean;
var standart:WPItem;
begin
  standart:=WayHead;
  CheckWay:=false;
  if s1='' then
  begin
    while WayHead<>nil do
    begin
      WP:=WayHead;
      if ((Wp^.Value.GetFStation.GetName=s) or (Wp^.Value.GetSStation.GetName=s)) then CheckWay:=true;
      WayHead:=WayHead^.next;
    end;
  end
  else
  begin
    while WayHead<>nil do
    begin
      WP:=WayHead;
      if ((Wp^.Value.GetFStation.GetName=s) and (Wp^.Value.GetSStation.GetName=s1)) or ((Wp^.Value.GetFStation.GetName=s1) and (Wp^.Value.GetSStation.GetName=s)) then CheckWay:=true;
      WayHead:=WayHead^.next;
    end;
  end;
   WayHead:=standart;
end;

Procedure TForm1.AddWayList(v:TWay);
begin
  New(WP);
  WP^.value:=v;
  WP^.next:=WayHead;
  WayHead:=WP;
end;

end.

