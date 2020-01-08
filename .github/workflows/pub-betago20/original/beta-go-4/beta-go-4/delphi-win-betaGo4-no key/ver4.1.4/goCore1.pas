unit goCore1;

// ========================================
// = Go Core 1, Started 8/11/03 by D. Kanecki, a.c.s., bio. sci.
// = Routines passing q/c are empty(), valid(), displayBoard(),
// =    str2(), sgn(), getBoard(), mkGroupList(), add2(), add(),
// =    makeBoard(), sgn2(), safe(), str4(), groupSize(),
// =    mkGroup2()
// -----------------------------------------
// = Ready for Board insert test and auto capture mode
// = August 18th, 2003 by D. Kanecki
// ========================================

interface
uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, StdCtrls, jpeg, ExtCtrls, goData1;



procedure removeAll;
procedure wait;
procedure displayBoard2;
procedure insertPce(var goX: goResource; var goBoard:array2;
                 var StonesGained, StonesLost:captureType );
procedure clearBoard(var goBoard:array2);
procedure setPce(var Gox:goResource);
function boardArea(goBoard:array2; pColor:integer):integer;
function getArea(goBoard:array2; x,y,pColor:integer):integer;
function getAlternative(var goBoard2:array2; x,y,pColor:integer):integer;
procedure clusterInfo(var largestCluster,x,y:integer; var safe:boolean;
       pColor:integer);

function empty(x,y:integer):boolean;
function valid(x,y:integer):boolean;
procedure displayBoard;
function str2(x:integer):string;
procedure writeStatus;
//function sgn(pce:integer):integer;
function getBoard(x,y:integer):integer;
          // strategic resource support
//procedure insert(x,y:integer; isSafe:boolean;
//                 var goX: goResource);
//procedure addRec(var goX:goResource; pceColor:integer);
procedure mkGroupList(x,y:integer;
        var glist:captureType; pceColor,xorg,yorg:integer;
        var tl2:glist);
procedure mkOpptGroupList(x,y:integer;
        var glist:captureType; color:integer);
procedure add2(var glist:captureType; x1,y1:integer);
procedure remove(var xlist:capturetype; color:integer);
procedure add(xlist:goResource; color:integer);
procedure makeBoard;
//function sgn2(x,y:integer):integer;
function safe(x,y,pceColor:integer;
             xorg,yorg:integer; var tl2:glist):boolean;
function str4(x:boolean):string;
function groupSize(x,y,pceColor:integer;
           var traverseList:glist):integer;
procedure mkGroup2(var glist2:captureType;
             x,y,color:integer);
function opptGroupSize(x,y,pceColor:integer; xorg,yorg:integer):integer;
procedure writePce(gox:goResource);
function str3(x:real; i,j:integer):string;
procedure makeBoard2;



implementation


procedure wait;
begin
end;

procedure clearBoard(var goBoard:array2);
var
  i,j:integer;
begin
for i:=1 to maxX
do for j:=1 to maxY
   do goBoard[i][j]:=0;
end;


procedure writePce(gox:goResource);
begin
write2(2,'Pce '+str2(gox.pce)+'::');
write2(2,'(x,y) = '+str2(gox.x)+':'+str2(gox.y)+') ');
write2(2,'PceRank '+str2(gox.groupSize)+'::');
write2(2,'FreeSpace '+str2(gox.freeSpace)+'::');
write2(2,'Dist '+str3(gox.dist,7,3)+'::');
write2(2,'KSafe '+str4(gox.largestGroupSafe)+'::');
write2(2,'KRank '+str2(gox.largestGroupSize)+'::');
write2(2,'Capt '+str2(gox.captGroupSize)+'::');
write2(2,'Area '+str2(gox.area)+'::');
write2(2,'Alt '+str2(gox.alt)+'::');
writeln2(2,'PceSafe '+str4(gox.groupSafe));
end;


procedure setPce(var GoX:goResource);
var
  x,y,clusterSize:integer;
  clusterSafe:boolean;
  tmpPce:integer;
  tl2:glist;
begin


if (valid(gox.x,gox.y))
then begin
     tmpPce:=goBoard[gox.x,gox.y];
     //writeln2(1,'Tmp pce ='+str2(tmpPce)+' @ '+str2(gox.x)+':'+str2(gox.y));
     goBoard[gox.x,gox.y]:=gox.pce;
     end
else tmpPce:=0;

gox.area:=getArea(goBoard,gox.x,gox.y,(gox.pce));          // area
gox.alt:=getAlternative(goBoard,gox.x,gox.y,(gox.pce));    // alt

//gox.alt:=getAlt(goBoard,gox.x,gox.y,sgn(gox.pce));          // alt
tl2.idx:=0;
GoX.groupSafe:=safe(goX.x,goX.y,goX.pce,goX.x,goX.y,tl2);         // pceSafe
goX.pceSafe:=gox.groupSafe;
tl2.idx:=0;
GoX.groupSize:=groupSize(gox.x,gox.y,gox.pce,tl2);    // pceRank
//clusterInfo(clusterSize,gox.largestx,gox.largesty,clusterSafe,sgn(goX.pce));

tl2.idx:=0;
goX.largestGroupSafe:=safe(gox.largestX,gox.largestY,gox.pce,
         gox.largestX,gox.largestY,tl2)
         or (( gox.largestX=0) and (gox.largestY=0));         // kingSafe
tl2.idx:=0;
goX.largestGroupSize:=groupSize(gox.largestX,gox.largestY,
         gox.pce, tl2);                // kingRnk
goX.dist:=(gox.x-gox.largestx)*(gox.x-gox.largestx)
   +(gox.y-gox.largesty)*(gox.y-gox.largesty);                // dist
gox.freeSpace:=boardArea(goBoard,(gox.pce));               // area
gox.captGroupSize:=opptGroupSize(gox.x,gox.y,
                     gox.pce,gox.x,gox.y);                    // capt

if (valid(gox.x,gox.y))
then goBoard[gox.x,gox.y]:=tmpPce;
end;


function opptGroupSize(x,y,pceColor:integer; xorg,yorg:integer):integer;
var
  i,j,k,tmp:integer;
  status, result1:boolean;
  tl2:glist;
begin
//writeln2(2,'*** OpptGroupSize *** '+str2(sgn(0-pceColor)));
//displayBoard;
tmp:=0;
status:=true;
//masterRemove:=sgn(0-pceColor);

{
case pceColor of
   whiteStone: begin
               if (random>0.5)
               then masterRemove:=blackStone
               else masterRemove:=purpleStone;
               end;
   blackStone: begin
               if (random>0.5)
               then masterRemove:=whiteStone
               else masterRemove:=purpleStone;
               end;
   purpleStone: begin
               if (random>=0.5)
               then masterRemove:=whiteStone
               else masterRemove:=blackStone;
               end;
               else;
               end; { case }

tl2.idx:=0;
for i:=-maxX {-1} to maxX {1}
do for j:=-maxY{1} to maxY{1}
   do if not ((x+i=xorg) and (y+j=yorg))
       and( ((i=0) and (j<>0)) or ((i<>0) and (j=0)) )
       then begin
            {
            if (x=2) and (y=1)
            then writeln2(2,'(x,y) = '+str2(x+i)+':'+str2(y+j)+
                     '   xorg,yorg = '+str2(xorg)+':'+str2(yorg)+
                         '  :  '+str2(i)+':'+str2(j));
            }
            tmp:=tmp+groupSize(x+i,y+j,masterRemove{sgn(0-pceColor)},tl2);
            //masterRemove:=sgn(0-pceColor);
            //result1:=safe(i,j,sgn(0-pceColor),i,j);
            //writeln2(2,'(x,y) = '+str2(i)+':'+str2(y)+' is '+str4(result1));
            //status:=status and (result1 or not valid(i,j));
            end;
//writeln2(2,'Safe status is '+str4(status));
//if status
//then tmp:=0;

opptGroupSize:=tmp;
end;

function boardArea(goBoard:array2; pColor:integer):integer;
// started 8/28/03 by d. kanecki
var
  i,j,count:integer;
begin
count:=0;
for i:=1 to maxX
 do for j:=1 to maxY
    do if ((goBoard[i,j])=(pColor))
       then count:=count+1;
boardArea:=count;
end;

function getArea(goBoard:array2; x,y,pColor:integer):integer;
// started 8/28/03  by dkanecki
var i,j, count1, count2:integer;

begin
count1:=0;
count2:=0;
count1:=boardArea(goBoard,pColor);
if (valid(x,y))
then goBoard[x,y]:=pColor;
count2:=boardArea(goBoard,pColor);
getArea:=count2-count1;
end;


procedure safeCount(x,y,pceColor:integer;xorg,yorg:integer; var count:integer;
         var tl2:glist);
// started 8/14/2003 by d. kanecki, a.c.s, bio.sci.
// q/c passed 8/15/2003 by d. kanecki, a.c.s, bio. sci.
var
   pce,i,j,k:integer;
   tmp:boolean;

   function inList(x,y:integer):boolean;
   var
     tmp:boolean;
     i:integer;
   begin
     tmp:=false;
     i:=1;
     while (i<=tl2.idx) and not tmp
     do begin
        tmp:=(tl2.x1[i]=x) and (tl2.y1[i]=y);
        i:=i+1;
        end;
     inList:=tmp;
     end;

begin
if not valid(x,y)
then begin
     //writeln2(2,'   A safe '+str2(x)+':'+str2(y)+' false');
     //safe:=false;
     end
else if empty(x,y)
     then begin
          //writeln2(2,'   E safe '+str2(x)+':'+str2(y)+' is true ');
          //safe:=true;
          count:=count+1;
          end
else begin
     pce:=goBoard[x,y];
     if (pceColor<>pce)   // for three pieces or more
     then begin
          //writeln2(2,'   B safe '+str2(x)+':'+str2(y)+' false');
          //safe:=false;
          end
     else if not inList(x,y)
     then begin
          tmp:=false;
          for i:=-1 to 1
          do for j:=-1 to 1
                do if (((i=0) and (j<>0)) or
                       ((i<>0) and (j=0)))
                       and not (((x+i)=xorg) and ((y+j)=yorg))
                       // avoid self referencing calling
                then begin
                     if not inList(x+i,y+j)
                     then begin
                          tl2.idx:=tl2.idx+1;
                          tl2.x1[tl2.idx]:=x+i;
                          tl2.y1[tl2.idx]:=y+j;
                          tmp:=tmp or safe(x+i,y+j,pceColor,x,y,tl2);
                          end;
                     //writeln2(2,'   C safe is '+str4(tmp));
                     end;
                //safe:=tmp;
          end
     end;
end;



function getAlternative(var goBoard2:array2; x,y,pColor:integer):integer;
var
  tmp:integer;
  goBoardTmp:array2;
  tl2:glist;
begin
goBoardTmp:=goBoard;
goBoard:=goBoard2;
tmp:=1;
tl2.idx:=0;
safeCount(x,y,pColor,x,y,tmp,tl2);
getAlternative:=tmp;
end;



procedure clusterInfo(var largestCluster,x,y:integer; var safe:boolean;
       pColor:integer);
// started 8/18/02 by d. kanecki
var i,j,k:integer;
    safe2:boolean;
    xl, yl:integer;
    cluster1:integer;
    tl:glist;
    tmp:integer;
begin
cluster1:=0;
xl:=0;
yl:=0;
safe2:=true;
tl.idx:=0;
if (pColor=whiteStone)
then begin
     for i:=1 to goResWh.idx
     do if (goResWh.d1[i].groupSize > cluster1)
        then begin
             cluster1:=goResWh.d1[i].groupSize;
             xl:=goResWh.d1[i].x;
             yl:=goResWh.d1[i].y;
             safe2:=goResWh.d1[i].groupSafe;
             end;
     end;
if (pColor=blackStone)
then begin
     for i:=1 to goResBl.idx
     do begin
        tmp:=groupSize(goResBl.d1[i].x,goResBl.d1[i].y,blackStone,tl);
        if (tmp > cluster1)
        then begin
                cluster1:=tmp {goResBl.d1[i].groupSize};
                xl:=goResBl.d1[i].x;
                yl:=goResBl.d1[i].y;
                safe2:=goResWh.d1[i].groupSafe;
             end;
        end;
     end;
if (pColor=purpleStone)
then begin
     for i:=1 to goResPurple.idx
     do begin
        tmp:=groupSize(goResPurple.d1[i].x,goResPurple.d1[i].y,purpleStone,tl);
        if (tmp>cluster1)
        then begin
             cluster1:=tmp;
             xl:=goResPurple.d1[i].x;
             yl:=goResPurple.d1[i].y;
             safe2:=goResPurple.d1[i].groupSafe;
             end;
        end;
     end;
safe:=safe2;
largestCluster:=cluster1;
x:=xl;
y:=yl;
end;

function groupSize(x,y,pceColor:integer;
    var traverseList:gList):integer;
// started 8/14/2003 by d. kanecki, a.c.s., bio. sci
// q/c passed 8/16/2003 by d. kanecki, a.c.s, bio. sci.
var
  i,j,k,pce:integer;
  count:integer;
  idx:integer;


  function inList(x,y:integer):boolean;
  var
    tmp:boolean;
    i:integer;
  begin
  tmp:=false;
  i:=1;
  while (i<=traverseList.idx) and not tmp
  do begin
     tmp:=(traverseList.x1[i]=x) and (traverseList.y1[i]=y);
     i:=i+1;
     end;
  if (tmp)
  then idx:=i-1
  else idx:=i;
  inList:=tmp;
  end;


begin
//writeln2(2,'XGS  :'+str2(x)+'::'+str2(y)+'->'+' Pce= '+str2(pceColor));
count:=0;

if (x<1) or (y<1)
then groupSize:=0
else
if not valid(x,y) or empty(x,y)
then begin
     //writeln2(2,'   A gs'+str2(x)+':'+str2(y)+' is 0');
     groupSize:=0;
     end
else if (pceColor<>GOboard[x,y])
     then begin
          //writeln2(2,'   B gs'+str2(x)+':'+str2(y)+' is 0');
          groupSize:=0
          end
     else if not inList(x,y) and not (idx=traverseList.idx)
     then begin
          count:=count+1;
           traverseList.idx:=traverseList.idx+1;

           k:=traverseList.idx;
           with traverseList
           do begin
                x1[k]:=x;
                y1[k]:=y;
               end;

          for i:=-maxX{1} to maxX{1}
          do for j:=-maxY{1} to maxY{1}
          do begin
             if (( (i=0) and (j<>0)) or ( (i<>0) and (j=0)))
               and  valid(x+i,y+j) and (pceColor=Goboard[x+i,y+j])
                  then begin
                       //writeln2(2,'     c2: '+str2(xorg)+':'+
                       //      str2(yorg)+' :: '+str2(x+i)+':'+
                       //      str2(y+j));

                       if not inList(x+i,y+j)
                       then begin  // call only if different from last caller
                            //writeln2(2,'   C :'+str2(x+i)+'::'+str2(y+j));
                            traverseList.idx:=traverseList.idx+1;

                            k:=traverseList.idx;
                            with traverseList
                            do begin
                               x1[k]:=x+i;
                               y1[k]:=y+j;
                               end;
                            count:=count+groupSize(x+i,y+j,pceColor,traverseList)+1;
                            end;
                       end;
                  //else groupSize:=count;
              end;
          groupSize:=count;
          end;
groupSize:=count;
end;

procedure writeStatus;
var
  x,y,lc,lc2 :integer;
  isSafe:boolean;
begin
case status of
   Suspended: write2(7,'Suspended '+str2(moveCount));
   Running:  write2(7,'Running '+str2(moveCount));
   Paused2:   write2(7,'Paused  '+str2(moveCount));
   Halted:   write2(7,'Halted  '+str2(moveCount));
   else ;
   end; // case

   write2(3,'->'+str2(goResWh.stonesAvail)+':'+str2(captCount[1]));
   write2(4,'->'+str2(goResBl.stonesAvail)+':'+str2(captCount[2]));
   lc:=boardArea(goBoard,whiteStone);
   clusterInfo(lc2,x,y,isSafe,whiteStone);
   write2(5,'->'+str2(lc));
   lc:=boardArea(goBoard,blackStone);
   clusterInfo(lc2,x,y,isSafe,blackStone);
   write2(6,'->'+str2(lc));
   write2(8,'->'+str2(goResPurple.stonesAvail)+':'+str2(captCount[3]));
   lc:=boardArea(goBoard,purpleStone);
   clusterInfo(lc2,x,y,isSafe,purpleStone);
   write2(9,'->'+str2(lc));
end;

function valid(x,y:integer):boolean;
var
  done:boolean;
begin
  if (x<=maxX) and (x>=1) and (y<=maxY) and (y>=1)
     then done:=true
     else done:=false;
  valid:=done;
end;

function empty(x,y:integer):boolean;

var
  done:boolean;
begin
if not valid(x,y)
then done:=false
else if (GoBoard[x,y]=0)
     then done:=true
     else done:=false;
empty:=done;
end;

function str2(x:integer):string;
// first q/c passed 8/11/03 by d. kanecki
var
 s1:string;
begin
str(x,s1);
str2:=s1;
end;

function str3(x:real;i,j:integer):string;
// first q/c passed by 8/11/03 by d. kanecki
var
  s1:string;
begin
str(x:i:j,s1);
str3:=s1;
end;

function str4(x:boolean):string;
begin
if x
then str4:='True  '
else str4:='False ';
end;

procedure removeAll;
  function findIx(pcolor,x,y:integer):integer;
  var
    i,j,k:integer;
    goTemp:goRecMaster;
    found:boolean;
  begin
     case pcolor of
     whiteStone: goTemp:=goResWh;
     blackStone: goTemp:=goresBl;
     purpleStone:gotemp:=goResPurple;
     else;
     end;
  i:=1;
  found:=false;
  while (i<=goTemp.idx) and not found
  do begin
     found:=(gotemp.d1[i].x=x) and (gotemp.d1[i].y=y);
     if not found
     then i:=i+1;
     end;
  if not Found
  then findIx:=0
  else findIx:=i;
  end;
var
   i,j,k:integer;
begin
for i:=1 to MaxX
do for j:=1 to MaxY
   do begin
      if (goBoard[i,j] <>0)
      then begin
           k:=findIx(goBoard[i,j],i,j);
           if (k<>0) and not safeArea[i,j]
           then begin
                write(fpOut,'Removing Stone ');
                case goBoard[i,j] of
                        whiteStone:begin
                                   writeln(fpOut,goResWh.d1[k].pce,'->',
                                     chr(ord('A')+goResWh.d1[k].x-1)
                                     +str2(goResWh.d1[k].y));
                                   goResWh.d1[k]:=nullStone;
                                   end;
                        blackStone: begin
                                    goResBl.d1[k]:=nullStone;
                                    writeln(fpOut,goResBl.d1[k].pce,'->',
                                     chr(ord('A')+goResBl.d1[k].x-1)
                                     +str2(goResBl.d1[k].y));
                                    end;
                        purpleStone:begin
                                    writeln(fpOut,goResPurple.d1[k].pce,'->',
                                     chr(ord('A')+goResPurple.d1[k].x-1)
                                     +str2(goResPurple.d1[k].y));
                                    goresPurple.d1[k]:=nullStone;
                                    end;
                        else;
                      end; { case }
                end;
           end;
      end;
end;

procedure displayBoard;
// first q/c passed 8/11/03 by d. kanecki
var
  i,j,k:integer;
  tl:glist;
begin
clear1;
writeln2(1,' ');

writeStatus;
writeln2(1,'Move: '+str2(moveCount));
writeln2(1,' ');
write2(1,'     ');
for i:=0 to MaxX-1
do   write2(1,'|'+chr(ord('A')+i)+' ');
writeln2(1,' ');

write2(1,'     ');
for i:=0 to maxX*3
do write2(1,'-');
writeln2(1,' ');

for i:=1 to MaxX
do for j:=1 to maxY
   do begin
      tl.idx:=0;
      safeArea[i,j]:=safe(i,j,goBoard[i,j],i,j,tl);
      end;


for i:=1 to MaxX
do begin
   write2(1,str3(i,2,0)+': |');

   for j:=1 to MaxY
   do begin
      if goBoard[i,j]=whiteStone
      then begin
           write2(1,'W');
           if (not safeArea[i,j])
           then write2(1,'*')
           else write2(1,' ');
           end
      else if GoBoard[i,j]=blackStone
      then begin
           write2(1,'B');
           if not safeArea[i,j]
           then write2(1,'*')
           else write2(1,' ');
           end
      else if GoBoard[i,j]=purpleStone
      then begin
           write2(1,'P');
           if not safeArea[i,j]
           then write2(1,'*')
           else write2(1,' ');
           end
      else if invalid_block[i,j]
      then write2(1,'**')
      else write2(1,'  ');

      write2(1,'|');
      end;
      writeln2(1,' ');

      write2(1,'     ');
      for k:=0 to maxX*3
      do write2(1,'-');
      writeln2(1,' ');
   end;
writeln2(1,' ');
//removeAll;
end;


procedure displayBoard2;
// first q/c passed 8/11/03 by d. kanecki
var
  i,j,k:integer;
begin
//clear1;
writeln2(1,' ');

writeStatus;
writeln2(1,'Move: '+str2(moveCount));
writeln2(1,' ');
write2(1,'     ');
for i:=0 to MaxX-1
do   write2(1,'|'+chr(ord('A')+i)+' ');
writeln2(1,' ');

write2(1,'     ');
for i:=0 to maxX*3
do write2(1,'-');
writeln2(1,' ');

for i:=1 to MaxX
do begin
   write2(1,str3(i,2,0)+': |');

   for j:=1 to MaxY
   do begin
      if goBoard[i,j]>0
      then begin
           write2(1,'W');
           //if (not safeArea[i,j])
           //then write2(1,'*')
           //else write2(1,' ');
           end
      else if GoBoard[i,j]<0
      then begin
           write2(1,'B');
           //if not safeArea[i,j]
           //then write2(1,'*')
           //else write2(1,' ');
           end
      else if invalid_block[i,j]
      then write2(1,'**')
      else write2(1,'  ');

      write2(1,'|');
      end;
      writeln2(1,' ');

      write2(1,'     ');
      for k:=0 to maxX*3
      do write2(1,'-');
      writeln2(1,' ');
   end;
writeln2(1,' ');
end;



function sgn(pce:integer):integer;
begin
if (pce=whiteStone)
then sgn:=whiteStone
else if (pce<0)
     then sgn:=blackStone
     else sgn:=purpleStone;
end;

function getBoard(x,y:integer):integer;
// started 8/14/03 by d. kanecki, a.c.s., bio. sci.
begin
if valid(x,y)
then getBoard:=GoBoard[x,y]
else getBoard:=9999;
end;

procedure remove(var xlist:capturetype; color:integer);
// started 8/14/03 by d. kanecki, a.c.s., bio. sci.
// added alQuedaMode to simulate terrorist playing
//    result is nearest neighbor removed even if protected

  function findIx(var goX:GoRecMaster; color,x,y:integer):integer;
  var
    i,j,k:integer;
    done:boolean;
  begin
  i:=1;
  done:=false;
  while not done and (i<=goX.idx)
  do begin
     done:=(gox.d1[i].x=x) and (gox.d1[i].y=y);
     if not done
     then i:=i+1;
     end;

  if not done
  then findIx:=0
  else findIx:=i;
  end;

var
  i:integer;
  result1:boolean;
  k,m:integer;
  tl2:glist;
begin
writeln2(2,' ');
writeln2(2,'=== IN REMOVE ===   color = '+str2(color));
for i:=1 to xlist.idx
do begin
   tl2.idx:=0;
   result1:=safe(xlist.x[i],xlist.y[i],color,xlist.x[i],xlist.y[i],tl2);
   writeln2(2,'safe '+str4(result1)+'->'+str2(xlist.x[i])+'::'+str2(xlist.y[i]));
   xlist.isCaptured[i]:=not result1 or AlQuedaMode
               or ((color=whiteStone) and AlQuedaModeWhite)
               or ((color=blackStone) and AlQuedaModeBlack)
               or ((color=purpleStone) and alQuedaModePurple);
   if (not result1 or alQuedaMode )
               or ((color=whiteStone) and AlQuedaModeWhite)
               or ((color=blackStone) and AlQuedaModeBlack)
               or ((color=purpleStone) and AlQuedaModePurple)
   then begin
        writeln2(2,'Removing :'+str2(xlist.x[i])+'::'+str2(xlist.y[i]));
        goBoard[xlist.x[i],xlist.y[i]]:=0;
        if (color=whiteStone)
        then j:=findIx(goResWh,color,xlist.x[i],xlist.y[i])
        else if (color=purpleStone)
             then j:=findIx(goResPurple,color,xlist.x[i],xlist.x[i])
             else j:=findIx(goResBl,color,xlist.x[i],xlist.y[i]);

        if (j<>0)
        then begin
             xlist.isCaptured[i]:=true;
             xlist.idx2[i]:=j;
             {
             if (color=whiteStone)
             then goResWh.d1[j]:=nullStone
             else goResBl.d1[j]:=nullStone;
             }
             end
        else begin
             writeln2(2,'Item not found in record at '+str2(xlist.x[i])+' , '
                     +str2(xlist.y[i]));
             xlist.isCaptured[i]:=false;
             xlist.idx2[i]:=0;
             end;
        end
        else begin
             xlist.isCaptured[i]:=false;
             xlist.idx2[i]:=0;
             writeln2(2,'*** Stone is safe');
             end;
   end;
// updated List - remove invalid nodes
k:=1;
while (k<=xlist.idx)
do begin
   if not xlist.isCaptured[k]
   then begin
        for m:=k to xlist.idx
        do with xlist
           do begin
              x[m]:=x[m+1];
              y[m]:=y[m+1];
              isCaptured[m]:=isCaptured[m+1];
              end;
        xlist.idx:=xlist.idx-1;
        end;
     k:=k+1;
   end;
writeln2(2,'New Remove idx: '+str2(xlist.idx));
writeln2(2,' ');
end;

procedure add(xlist:goResource; color:integer);
begin
case color of
   1:  begin // search white piece list
       writeln2(2,' Adding White Stone ');
       with goResWh
       do begin
           idx:=idx+1;
           d1[idx]:=xlist;
           stonesAvail:=stonesAvail-1;
           if (maxGroupSize < xlist.largestGroupSize)
             then maxGroupSize:=xlist.largestGroupSize;
          end;
       end;
   -1: begin // search black piece list
       writeln2(2,' Adding Black Stone');
       with goResBl
       do begin
           idx:=idx+1;
           d1[idx]:=xlist;
           stonesAvail:=stonesAvail-1;
           if (maxGroupSize < xlist.largestGroupSize)
             then maxGroupSize:=xlist.largestGroupSize;
          end;
       end;
   purpleStone: begin
       writeln2(2,' Adding Purple Stone');
       with goResPurple
       do begin
           idx:=idx+1;
           d1[idx]:=xlist;
           stonesAvail:=stonesAvail-1;
           if (maxGroupSize < xlist.largestGroupSize)
             then maxGroupSize:=xlist.largestGroupSize;
          end;
       end;
   else ;
   end; // case
end;

procedure insertPce(var goX: goResource; var goBoard:array2;
       var StonesGained, StonesLost:captureType);
// started 8/10/2003 by d. kanecki, a.c.s., bio. sci.
// setup 8/10/2003 by d. kanecki, a.c.s., bio. sci.
var
  color:integer;
  //glist, olist:captureType;
  x,y:integer;
  tl2:glist;
  removeColor:integer;
begin
//writeln2(2,'*** Insert to be implemented ');
if debug3
then writeln2(2,'=== BEFORE INSERT ===');
if debug3
then displayBoard2;

StonesGained.idx:=0;
StonesLost.idx:=0;
x:=gox.x;
y:=gox.y;
color:=(goX.pce);
if (empty(x,y))
then goBoard[x,y]:=color;



if not goX.groupSafe
then begin
     writeln2(2,'*** NOT INSERTED PIECE ****');
     stonesLost.idx:=0;
     tl2.idx:=0;
     mkGroupList(x,y,StonesLost,color,x,y,tl2);
     remove(StonesLost,color);
     end
else begin
     writeln2(2,'*** INSERTING PIECE ****');
     StonesLost.idx:=0;
     add(goX,color);
     end;

if debug3
then begin
        writeln2(2,' ');
        writeln2(2,'==== AFTER INSERT ===');
        displayBoard2;
     end;

makeBoard;
if (goX.captgroupSize>0)
then begin
        StonesGained.idx:=0;
        mkOpptGroupList(x,y,StonesGained,color);

        case color of
                whiteStone:  begin
                             //if (random>=0.5)
                             //then removeColor:=blackStone
                             //else removeColor:=purpleStone;
                             //masterRemove:=removeColor;
                             removeColor:=masterRemove;
                             end;
                blackStone:  begin
                             //if (random>=0.5)
                             //then removeColor:=purpleStone
                             //else removeColor:=whiteStone;
                             //masterRemove:=removeColor;
                             removeCOlor:=masterRemove;
                             end;
                purpleStone: begin
                             //if (random>=0.5)
                             //then removeColor:=whiteStone
                             //else removeColor:=blackStone;
                             //masterRemove:=removeColor;
                             removeCOlor:=masterRemove;
                             end;
        else;
        end; { case }

        remove(StonesGained,removeColor {0-color});
        if debug3
        then begin
                writeln2(2,' ');
                writeln2(2,'=== AFTER OPPONENT REMOVAL ===');
                displayBoard2;
             end;
     end;

end;

procedure insert(x,y:integer; isSafe:boolean;
                 var goX: goResource);
// started 8/10/2003 by d. kanecki, a.c.s., bio. sci.
// setup 8/10/2003 by d. kanecki, a.c.s., bio. sci.
var
  color:integer;
  glist2, olist:captureType;
  tl2:glist;

begin
writeln2(2,'*** Insert to be implemented ');
writeln2(2,'=== BEFORE INSERT ===');
displayBoard;

color:=(goX.pce);
if (empty(x,y))
then goBoard[x,y]:=color;



if not goX.pceSafe
then begin
     glist2.idx:=0;
     tl2.idx:=0;
     mkGroupList(x,y,glist2,color,x,y,tl2);
     remove(glist2,color);
     end
else begin
     glist2.idx:=0;
     add(goX,color);
     end;

writeln2(2,' ');
writeln2(2,'==== AFTER INSERT ===');
displayBoard;

if (goX.groupSize>0)
then begin
        olist.idx:=0;
        mkOpptGroupList(x,y,olist,color);
        remove(olist,0-color);
        writeln2(2,' ');
        writeln2(2,'=== AFTER OPPONENT REMOVAL ===');
        displayBoard;
     end;

end;




procedure addRec(var goX:goResource; pceColor:integer);
  // started 8/10/2003 by d. kanecki, a.c.s., bio. sci.
// setup 8/10/2003 by d. kanecki, a.c.s., bio. sci.

begin
writeln2(2,'*** AddRec to be implemented ');
add(goX,pceColor);
end;

procedure mkGroupList(x,y:integer;
        var glist:captureType;pceColor,xorg,yorg:integer;
        var tl2:glist);
// started 8/10/2003 by d. kanecki, a.c.s., bio. sci.
// setup 8/10/2003 by d. kanecki, a.c.s., bio. sci.
var
  i,j:integer;
  pce:integer;


  function inList(x,y:integer):boolean;
  var
    tmp:boolean;
    i:integer;
  begin
    tmp:=false;
    i:=1;
    while (i<=tl2.idx) and not tmp
    do begin
       tmp:=(tl2.x1[i]=x) and (tl2.y1[i]=y);
       i:=i+1;
       end;
    inList:=tmp;
    end;

begin
writeln2(2,'*** mkGroupList (x,y)'+str2(x)+'::'+str2(y));
//add2(glist,x,y);
if not inList(x,y)
then for i:=-1 to 1
do for j:=-1 to 1
   do begin
      if valid(x+i,y+j)
      then begin
           if (((i=0) and (j<>0)) or ((i<>0) and (j=0)))
               and not (((x+i)=xorg) and ((y+j)=yorg))
           then if not inList(x+i,y+y)
           then begin
                tl2.idx:=tl2.idx+1;
                tl2.x1[tl2.idx]:=x+i;
                tl2.y1[tl2.idx]:=y+j;
                pce:=getBoard(x+i,y+j);
                if (pceColor=(pce)) and (pce<>9999)
                then begin
                     add2(glist,x+i,y+j);
                     mkGroupList(x+i,y+j,glist,pceColor,x,y,tl2);
                     end;
                end;
           end;
      end;
end;

procedure mkGroup2(var glist2:captureType;
             x,y,color:integer);
var
  tl2:glist;
begin
glist2.idx:=0;
tl2.idx:=0;
add2(glist2,x,y);
mkGroupList(x,y,glist2,color,x,y,tl2);
end;

procedure mkGroup3(var glist2:captureType;
             x,y,color:integer);
var
  tl2:glist;
begin
glist2.idx:=0;
tl2.idx:=0;
mkGroupList(x,y,glist2,0-color,x,y,tl2);
end;

procedure mkOpptGroupList(x,y:integer;
    var glist:captureType; color:integer);
// started 8/10/2003 by d. kanecki, a.c.s., bio. sci.
// setup 8/10/2003 by d. kanecki, a.c.s., bio. sci.
var
  pceColor:integer;
begin
writeln2(2,'*** mkOpptGroupList to be implemented ');
pceColor:=0-color;
mkGroup3(glist,x,y,color);
//mkGroupList(x,y,glist,pceColor,x,y);
end;

procedure add2(var glist:captureType; x1,y1:integer);
// started 8/10/2003 by d. kanecki, a.c.s., bio. sci.
// setup 8/10/2003 by d. kanecki, a.c.s., bio. sci.

begin
//writeln2(2,'*** Add2 to be implemented ');
with glist
do begin
   idx:=idx+1;
   x[idx]:=x1;
   y[idx]:=y1;
   end;
end;

function sgn2(x,y:integer):integer;
// return 0 if not valid
// return 1 if pceColor is white
// return -1 if pceColor is black
var
  pce:integer;
begin
if not valid(x,y)
then sgn2:=0
else begin
     pce:=goBoard[x,y];
     if (pce<0)
     then sgn2:=blackStone
     else if (pce=whiteStone)
          then sgn2:=whiteStone
          else if (pce=PurpleStone)
          then sgn2:=purpleStone
          else sgn2:=blackStone;
     end;
end;

procedure doPause;
begin
if (status=paused2)
then begin
     writeln2(2,' ');
     writeln2(2,'*** Current Thread is Paused ');
     writeln2(2,' ');
     end;

while (status=paused2)
  do;   // busy wait
end;

function safe(x,y, pceColor:integer; xorg, yorg:integer;
                var tl2:glist):boolean;
var
  spaceFound:boolean;

function safe2(x,y,pceColor:integer;
   xorg,yorg:integer; var tl2:glist):boolean;
// started 8/14/2003 by d. kanecki, a.c.s, bio.sci.
// q/c passed 8/15/2003 by d. kanecki, a.c.s, bio. sci.
var
   pce,i,j,k:integer;
   tmp:boolean;
   lastIdx:integer;

   function inList(x,y:integer):boolean;
   var
     tmp:boolean;
     i:integer;
   begin
     tmp:=false;
     i:=1;
     while (i<=tl2.idx) and not tmp
     do begin
        tmp:=(tl2.x1[i]=x) and (tl2.y1[i]=y);
        i:=i+1;
        end;
     if (tmp)
     then lastIdx:=i-1
     else lastIdx:=i;
     inList:=tmp;
     end;

begin
//writeln2(2,' *** safe '+str2(x)+':'+str2(y));
tmp:=false;
if (x<1) or (y<1)
then safe2:=false
else
if not valid(x,y)
then begin
     //writeln2(2,'   A safe '+str2(x)+':'+str2(y)+' false');
     safe2:=false;
     end
else if empty(x,y)
     then begin
          //writeln2(2,'   E safe '+str2(x)+':'+str2(y)+' is true ');
          tl2.idx:=tl2.idx+1;
          tl2.x1[tl2.idx]:=x;
          tl2.y1[tl2.idx]:=y;
          spaceFound:=true;
          //while true
          //do ; // wait
          safe2:=true;
          end
else {if not inList(x,y)
     then} begin
     tl2.idx:=tl2.idx+1;
     tl2.x1[tl2.idx]:=x;
     tl2.y1[tl2.idx]:=y;
     pce:=goBoard[x,y];
     //writeln2(2,'B Pce = '+str2(pce)+' (x,y) = '+str2(x)+':'+str2(y));
     if (pceColor<>pce) and not((x=xorg) and (y=yorg))
     then begin
          //writeln2(2,'   B2 safe '+str2(x)+':'+str2(y)+' false');
          safe2:=false;
          end
     else begin
          tmp:=false;
          for i:=-1 to 1
          do for j:=-1 to 1
                do if (((i=0) and (j<>0)) or
                       ((i<>0) and (j=0)))
                       and not (((x+i)=xorg) and ((y+j)=yorg))
                       // avoid self referencing calling
                then begin
                     if not inList(x+i,y+j) and not(lastIdx=tl2.idx)
                     then begin
                          tl2.idx:=tl2.idx+1;
                          tl2.x1[tl2.idx]:=x+i;
                          tl2.y1[tl2.idx]:=y+j;
                          tmp:=tmp or safe2(x+i,y+j,pceColor,x,y,tl2);
                          //writeln2(2,'   C safe is '+str4(tmp));
                          end
                     end;
                safe2:=tmp;
          end
     end;
end;

begin
spaceFound:=false;
safe:=safe2(x,y,pceColor,xorg,yorg,tl2) and spaceFound;
end;

procedure makeBoard;
var i,j,k:integer;
begin
//removeAll;
for i:=0 to MaxX
do for j:=0 to maxY
   do goBoard[i,j]:=0;
for k:=1 to goResWh.idx
do  if (goResWh.d1[k].pce<>0)
    then
    with GoResWh
    do if valid(d1[k].x,d1[k].y) and (k<=maxTotal)
        then goBoard[d1[k].x,d1[k].y]:=d1[k].pce;

writeln2(2,'Black Stone idx= '+str2(goResBl.idx));

for k:=1 to goResBl.idx
do  if (goResBl.d1[k].pce<>0)
    then
    with GoResBl
    do if (valid(d1[k].x,d1[k].y)) and (k<=maxTotal)
       then goBoard[d1[k].x,d1[k].y]:=d1[k].pce;

for k:=1 to goResPurple.idx
do  if (goResPurple.d1[k].pce<>0)
    then
    with GoResPurple
    do if valid(d1[k].x,d1[k].y) and (k<=maxTotal)
       then goBoard[d1[k].x,d1[k].y]:=d1[k].pce;

    end;

procedure makeBoard2;
var i,j,k,tmp:integer;
    tl:glist;
begin
//removeAll;
for i:=0 to MaxX
do for j:=0 to maxY
   do goBoard[i,j]:=0;
for k:=1 to goResWh.idx
do  if (goResWh.d1[k].pce<>0)
    then
    with GoResWh
    do begin
       if valid(d1[k].x,d1[k].y) and (k<=maxTotal)
        then goBoard[d1[k].x,d1[k].y]:=d1[k].pce;
       tl.idx:=0;
       if not safe(d1[k].x,d1[k].y,whiteStone,d1[k].x,d1[k].y,tl)
       then begin
           d1[k].pce:=NullStone.pce;
           tmp:=goResBl.stonesAvail;
           goResBl.stonesAvail:=tmp+1;
           goBoard[d1[k].x,d1[k].y]:=0;
           end;
       end;
writeln2(2,'Black Stone idx= '+str2(goResBl.idx));

for k:=1 to goResBl.idx
do  if (goResBl.d1[k].pce<>0)
    then
    with GoResBl
    do begin
       if (valid(d1[k].x,d1[k].y)) and (k<=maxTotal)
           then goBoard[d1[k].x,d1[k].y]:=d1[k].pce;
       tl.idx:=0;
       if not safe(d1[k].x,d1[k].y,blackStone,d1[k].x,d1[k].y,tl)
       then begin
            d1[k].pce:=nullStone.pce;
            tmp:=goResWh.stonesAvail;
            goResWh.stonesAvail:=tmp+1;
            goBoard[d1[k].x,d1[k].Y]:=0;
            end;
       end;
for k:=1 to goResPurple.idx
do  if (goResPurple.d1[k].pce<>0)
    then
    with GoResPurple
    do if valid(d1[k].x,d1[k].y) and (k<=maxTotal)
       then goBoard[d1[k].x,d1[k].y]:=d1[k].pce;

end;


initialization

end.
