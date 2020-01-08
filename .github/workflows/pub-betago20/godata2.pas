unit godata2;
// ===================================
// Kanecki GO Using ITS
// Conceived August 9th, 2003 by D. Kanecki, A.C.S., Bio. Sci.
// --s add2(), mkGroup2(), mkGroupList(),
//    safe(), groupSize() passed q/c on 8/16-8/18/03
// ------------------------------------

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

const
//--------------------------------
// Setup I/O Variables and Functions
// August 10th, 2003 - Time 1 hour
// -----------------------------------
// Routine
     debug4=false;
     debug3=false;
     pceConst=1;

     //MaxY=19;
     //MaxX=19;
     MaxTotal=381; //maxX*maxy;

     Suspended=0;
     Running=1;
     Paused2=2;
     Halted=3;

     whiteStone=1;
     blackStone=-1;
     purpleStone=2;
type
  array2= array[0..19, 0..19] of integer;

  glist=record
      x1,y1:array[1..381] of integer;
      idx:integer;
      end;

  captureType=record
      x,y,idx2 :array [1..381] of integer;
      isCaptured:array[1..381] of boolean;
      idx:integer;
      end;

  goResource=record
       x,y:integer;
       groupSize: integer;     // a
       captGroupSize: integer; // b
       NetGroupSize: integer;         // capt(its) = a-b
       dist:real;
       largestX,
       largestY: integer;               // king location 1
       largestGroupSafe: boolean;     // kingsafe(its)
       groupSafe: boolean;            // pceSafe
       OpptLargestGroupSafe: boolean; // opptKingSafe
       largestGroupSize:integer;       // altx
       freeSpace:integer;             // area
       pce:integer;
       pceSafe:boolean;
       alt:integer;
       area:integer;

       // covert operative section - added 10/16/03 by d. kanecki
       isVisible:boolean;
       isVip:boolean;
       moleRndFactor:real;
       turnCount:integer;
       availRate:real;
       availSetTime:integer;

       end;

  goRecMaster=record
        d1:array[0..381] of goResource;
        idx:integer;
        stonesAvail:integer;
        maxGroupSize:integer;
        end;

   rarray2=array[1..10] of real;

var
  //output1: array[1..2] of TMemo;
  //output2: array[3..11] of TEdit;

  safeList, lostList: captureType;

  GoResWh, GoResBl,GoResPurple: goRecMaster;

  safeArea: array[0..19,0..19] of boolean;
  goBoard:  array2;
  invalid_block:array[0..19, 0..19] of boolean;

  nullStone: goResource;

  i,j:integer;
  moveCount:integer;
  status:integer;
  goPce:goResource;

  points_changed:real;
  chPos, chNeg:array[1..10] of boolean;
  points: rarray2 =
      ( 32.000, 16.000, 9.000,  7.000, 6.000, 2.000, 1.000, 0.000,
         0.000, 0.000);
  points_white, points_black: rarray2;
  bonus_point:real;

  fpOut:text;

  paramCount2:integer;
  paramStr2:array[1..30] of string;

  // game status variables
  w_check_count, b_check_count:integer;
  w_protect_count,b_protect_count:integer;
  w_retreat_count, b_retreat_count:integer;
  w_capture_count, b_capture_count:integer;

  alQuedaMode:boolean;
  alQuedaModeWhite, alQuedaModeBlack,alQuedaModePurple:boolean;


  optionWhite, optionBlack,optionPurple:integer;

  donewhite, doneBlack:boolean;
  simMoves:integer;
  maxX,maxY:integer;
  continuousForm:boolean;

  captCount:array[1..3] of integer;
  masterRemove:integer;

  pce1:array[1..3] of goResource;

  enterWait:boolean;
  NoList:boolean;
  NoDelay:boolean;

  // i/o support
procedure write2(DevNum:integer; s1:string);
procedure writeln2(devNum:integer; s1:string);
procedure clear1;
procedure addParam(p1:string);

implementation

var
   scrBuf:array[1..2] of string;
   scrIndex: array[1..2] of integer;

procedure write2(DevNum:integer; s1:string);
// started 8/10/2003 by d. kanecki, a.c.s., bio. sci.
// completed 8/10/2003 by d. kanecki, a.c.s., bio. sci.
// q/c passed 8/10/2003 by d. kanecki, a.c.s., bio. sci.

begin
{
case DevNum of
   1,2:  begin
         scrBuf[devNum]:=scrBuf[devNum]+s1;
         scrIndex[devNum]:=scrIndex[devNum]+
              length(s1);
         if (scrIndex[devNum] >=132)
         then begin
                scrIndex[devNum]:=0;
                output1[devNum].Lines.Add(scrBuf[devNum]);
                scrBuf[DevNum]:='';
              end;
         end;
   3..9: begin
         output2[devNum].Text:=s1;
         end;
   else ;
   end; // case
}
write(s1);
end;

procedure writeln2(devNum:integer; s1:string);
// started 8/10/2003 by d. kanecki, a.c.s., bio. sci.
// completed 8/10/2003 by d. kanecki, a.c.s., bio. sci.
// q/c passed 8/10/2003 by d. kanecki, a.c.s., bio. sci.

begin
{
case DevNum of
   1,2:  begin
         scrBuf[devNum]:=scrBuf[devNum]+s1;
         scrIndex[devNum]:=scrIndex[devNum]+
              length(s1);

         scrIndex[devNum]:=0;
         output1[devNum].Lines.Add(scrBuf[DevNum]);
         scrBuf[DevNum]:='';

         end;
   3..9: begin
         output2[devNum].Text:=s1;
         end;
   else ;
   end; // case
}
writeln(s1);
end;

procedure clear1;
begin
if not continuousForm
then begin
        {
        output1[1].SelectAll;
        output1[1].Clear;
        scrBuf[1]:='';
        scrIndex[1]:=0;
        }
     end;
end;


procedure addParam(p1:string);
begin
paramCount2:=paramCount2+1;
paramStr2[paramCount2]:=p1;
end;

initialization
noList:=false;
noDelay:=false;

// setup i/o control
scrIndex[1]:=0;
scrBuf[1]:='';
scrIndex[2]:=0;
scrBuf[2]:='';

// setup null record
nullStone.x:=9999;
nullStone.y:=9999;
nullStone.groupSize:=0;
nullStone.captGroupSize:=0;
nullStone.NetGroupSize:=0;
nullStone.dist:=9999;
nullStone.largestGroupSafe:=true;
nullStone.groupSafe:=true;
nullStone.OpptLargestGroupSafe:=true;
nullStone.largestGroupSize:=0;
nullStone.freeSpace:=0;
nullStone.pce:=0;   // no piece
nullStone.pceSafe:=true;
nullStone.alt:=0;
nullStone.area:=0;
nullStone.isVisible:=true;
nullStone.isVip:=false;
nullStone.moleRndFactor:=0.000;  // complete loyaty
nullStone.turnCount:=100;
nullStone.availRate:=1.00;       // always ready
nullStone.availSetTime:=100;     // alway full mission

// transfer null record to all entries
for i:=1 to MaxTotal
do begin
        GoResWh.d1[i]:=nullStone;
        GoResBl.d1[i]:=nullStone;
        GoResPurple.d1[i]:=nullStone;
   end;

// set resource initial conditions
GoResWh.idx:=0;
GoResWh.stonesAvail:=maxTotal;
GoResWh.maxGroupSize:=0;

GoResBl.idx:=0;
GoResBl.stonesAvail:=maxTotal;
GoResBl.maxGroupSize:=0;

With goResPurple
do begin
   idx:=0;
   stonesAvail:=maxTotal;
   maxGroupSize:=0;
   end;

for i:=0 to MaxX
do for j:=0 to MaxY
   do begin
      safeArea[i,j]:=true;
      invalid_block[i,j]:=false;
      end;

status:=suspended;

points_changed:=0;
for i:=1 to 10
do begin
  chPos[i]:=false;
  chNeg[i]:=false;

  //points[i]:=0;
  points_white[i]:=0;
  points_black[i]:=0;
  end;

bonus_point:=0;
points_white:=points;
points_black:=points;

assign(fpOut,'results.txt');
try
rewrite(fpOut);
except
    // If there was an error the reason can be found here
    on E: EInOutError do
      writeln('GD2(1000) File handling error occurred. Details: ', E.ClassName, '/', E.Message);
  end;

paramCount2:=0;
alQuedaMode:=false;
alQuedaModeWhite:=false;
alQuedaModeBlack:=false;
alQuedaModePurple:=false;
doneWhite:=false;
doneBlack:=false;
simMoves:=70;
maxX:=19;
maxY:=19;
continuousForm:=false;
for i:=1 to 3
do captCount[i]:=0;
enterWait:=false;
end.


