unit ConstantsTypes;
{$mode objfpc}{$H+}
interface
uses
  Classes, SysUtils, Station;
const r=5; // radius of stations
      mincr=1;
      maxcr=5;
      minway=1;
      maxway=30;
type
  PItem = ^Item;
  Item = record
    Value:Tstation;
    next:PItem;
  end;

implementation

end.

