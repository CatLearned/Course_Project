unit ConstantsTypes;
{$mode objfpc}{$H+}
interface
uses
  Classes, SysUtils, Station, way;
const r=5; // radius of stations
      mincr=1;
      maxcr=5;
      minway=1;
      maxway=30;
type
  PItem = ^SItem;
  SItem = record
    Value:Tstation;
    next:PItem;
  end;
type
  WPitem = ^WayItem;
  WayItem = record
    Value:TWay;
    next:WPitem;
  end;

implementation

end.

