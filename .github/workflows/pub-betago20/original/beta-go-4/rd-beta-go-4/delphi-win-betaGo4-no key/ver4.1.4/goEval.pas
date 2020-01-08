unit goEval;

interface
// started 9/14/2003
// -----------------------------------------
// 9/14/2003 Added rating: passed compile
// Time 1.5 hours
// The goal is to use the ITS process as applied to Go and characteristics
// -----------------------------------------

uses goData1,goCore1,process;

type
   evalCoordinate=record
      x,y:integer;
      x2,y2:integer;
      end;

var
   evalSet, evalSet2:array[1..5] of evalCoordinate;
      {(1,1,13,13,
        1,1,6,6,6,
        6,1,13,6,
        1,6,6,13,
        6,6,13,6);  }


function rating(var pceA,pceB:goResource):real;
procedure moveWhite(var pce:goResource; var gox:goRecMaster; largestX, largestY:integer);
procedure moveBlack(var pce:goResource; var gox:goRecMaster; largestX, largestY:integer);
procedure removePce(var pList:goRecMaster; var rList:captureType);
procedure makeMove(var pce:goResource; rList:goRecMaster;pColor:integer);
procedure movePurple(var pce:goResource; var gox:goRecMaster; largestX, largestY:integer);

implementation

procedure getCoordinates(var EvalCoord:evalCoordinate);
var
  k:integer;
  r:real;
begin
if cellularMode
then with evalCoord
     do begin
        x:=1;
        y:=1;
        x2:=5;
        y2:=5;
        end
else if cellularMode2
then with evalCoord
     do begin
        x:=1; y:=1;
        x2:=9; y2:=9;
        end
else begin
     randomize;
     r:=random;
     if (r<=0.25)
     then begin
          if completeMode
           then evalCoord:=evalSet[1]      // complete 50% of the time
           else evalCoord:=evalSet2[1];
          end
     else begin
          k:=trunc(random*4)+2;      // sectors 2 through 5; 20% of time
          if completeMode
          then evalCoord:=evalSet[k]       // 13x13 eval
          else evalCoord:=evalSet2[k];     //  9x9 eval
          end;
     end;
end;

procedure makeMove(var pce:goResource; rList:goRecMaster; pColor:integer);
label move_exit;

var
  largestCluster:integer;
  x,y:integer;
  clusterSafe:boolean;
  i,tmp:integer;
  r:real;
  idx,k:integer;

begin
if bestOption
then begin
     pce:=rlist.d1[1];
     idx:=1;
     if (pColor=whiteStone)
     then optionWhite:=1
     else if (pColor=purpleStone)
        then optionPurple:=1
        else optionBlack:=1;

     goto move_exit;
     end;



makeBoard;
clusterInfo(largestCluster,x,y,clusterSafe,pColor);

if not clusterSafe
then begin // option 1
     // find option that makes cluster safe
     pce:=rlist.d1[1];
     if (pColor=whiteStone)
     then optionWhite:=1
     else if (pColor=PurpleStone)
        then optionPurple:=1
        else optionBlack:=1;
     end
else begin // find if cluster size new is bigger
     tmp:=largestCluster;
     idx:=0;
     for i:=1 to rlist.idx
     do if (rlist.d1[i].largestGroupSize > tmp)
         then begin
              tmp:=rlist.d1[i].largestGroupSize;
              idx:=i;
              end;
     if (idx=0)
     then begin
     // pick normal move
          r:=random;
          if (r>=0.30)
          then begin
               pce:=rlist.d1[1];                 // best move
               idx:=1;
               end
          else begin
               k:=trunc(random*rlist.idx-1)+2;
               idx:=k;
               pce:=rlist.d1[k];                // random move
               end;
          end;
     if (pColor=whiteStone)
     then optionWhite:=idx
     else if (pColor=purpleStone)
        then optionPurple:=idx
        else optionBlack:=idx;
     end;
move_exit:
end;


procedure removePce(var pList:goRecMaster; var rList:captureType);
var
  i,j,k:integer;
begin
for i:=1 to rlist.idx
do begin
   if (plist.idx>1)
   then begin
        j:=rlist.idx2[i];
        pList.d1[j]:=nullStone;
        for k:=j+1 to pList.idx
        do pList.d1[k-1]:=plist.d1[k];
        plist.idx:=plist.idx-1;
        end;
   end;
end;



procedure pickBest(var gox:goRecMaster);
var
  i,j,k:integer;
  tmp:goResource;
  gox2:goRecMaster;
begin
  k:=gox.idx;
  i:=1;
  j:=0;
  while (i<=k)
  do begin
     if (gox.d1[i].pce<>0)
     then begin
          j:=j+1;
          gox2.d1[j]:=gox.d1[i];
          end;
     i:=i+1;
     end;

  gox2.idx:=j;
  k:=gox2.idx;
  writeln2(2,' ');
  writeln2(2,'Pick Best Idx = '+str2(k));
  for i:=1 to k
  do for j:=i+1 to k
        do if (rating(gox2.d1[i],gox2.d1[j])>0)
            then begin
                 tmp:=gox2.d1[i];
                 gox2.d1[i]:=gox2.d1[j];
                 gox2.d1[j]:=tmp;
                 end;
gox:=gox2;
end;

procedure pickBest2(var gox:goRecMaster);
// first capture basis
var
  i,j,k:integer;
  tmp:goResource;
  gox2:goRecMaster;
begin

  i:=1;
  j:=0;
  while (i<=k)
  do begin
     if (gox.d1[i].pce<>0)
     then begin
          j:=j+1;
          gox2.d1[j]:=gox.d1[i];
          end;
     i:=i+1;
     end;

  gox2.idx:=j;
  k:=gox2.idx;

  writeln2(2,' ');
  writeln2(2,'Pick Best Idx2 = '+str2(k));
  for i:=1 to k
  do for j:=i+1 to k
        do if (rating(gox2.d1[i],gox2.d1[j])<0)
            then begin
                 tmp:=gox2.d1[i];
                 gox2.d1[i]:=gox2.d1[j];
                 gox2.d1[j]:=tmp;
                 end;
gox2:=gox;
end;


procedure getXY(moveString:string; var x,y:integer);
var
  i,j,k,errCode:integer;
begin
i:=1;
while (i<=length(moveString)) and (moveString[i]=' ')
do i:=i+1;

x:=ord(upcase(moveString[i]))-ord('A')+1;
val(copy(moveString,2,10),y,errCode);
end;


procedure moveWhite(var pce:goResource; var gox:goRecMaster; largestX,largestY:integer);
label
  start_again;
var
   i,j,k:integer;
   tmp:goResource;
   ec:evalCoordinate;
   count:integer;
   xTmp,yTmp:integer;
   moveStr:string;

begin
k:=0;
gox.idx:=0;
for i:=1 to 169 {25}
do gox.d1[i]:=nullStone;

enterWait:=true;
if (player=1 )
then begin
     output2[10].text:='Pls Enter Move'+str2(moveCount);
     while enterWait
     do ;
     output2[10].text:='';
     moveStr:=output2[11].text;
     getXy(moveStr,xTmp,yTmp);
     end;

getCoordinates(ec);
count:=0;

if (random>0.5)
then masterRemove:=blackStone
else masterRemove:=purpleStone;

start_again: count:=count+1;
for i:=ec.x {1} to ec.x2 {5}
do for j:=ec.y {1} to ec.y2 {5}
   do begin
       //write2(7,'Ev:(x,y) '+str2(i)+':'+str2(j));
      if (valid(i,j) and empty(i,j) and not invalid_block[i,j])
      then begin
           tmp:=nullStone;
           tmp.x:=i;
           tmp.y:=j;
           tmp.largestX:=largestX;
           tmp.largestY:=largestY;
           tmp.pce:=whiteStone;
           setPce(tmp);
           k:=k+1;
           gox.idx:=k;
           gox.d1[k]:=tmp;
           end;
      end;

if (gox.idx=0) and (count<=2)
then begin
     writeln2(2,' ');
     writeln2(2,'*** Starting Again White ***');
     writeln2(2,'(x,y) -> '+str2(ec.x)+','+str2(ec.y)+' :: '+
          str2(ec.x2)+','+str2(ec.y2));
     writeln2(2,' ');
     ec:=evalSet[1];
     gox.idx:=0;
     goto start_again;
     end;

donewhite:=gox.idx=0;

if firstCaptureMode
then pickBest2(gox)
else pickBest(gox);

if player<>whiteStone
then makeMove(pce,gox,whiteStone)
else begin
     tmp:=nullStone;
     tmp.x:=xTmp;
     tmp.y:=yTmp;
     tmp.largestX:=largestX;
     tmp.largestY:=largestY;
     tmp.pce:=whiteStone;
     setPce(tmp);
     gox.idx:=1;
     gox.d1[1]:=tmp;
     goResWh.idx:=goResWh.idx+1;
     goResWh.d1[goResWH.idx]:=tmp;
     makeBoard2;
     displayBoard;
     end;
end;

procedure movePurple(var pce:goResource; var gox:goRecMaster; largestX,largestY:integer);
label
  start_again;
var
   i,j,k:integer;
   tmp:goResource;
   ec:evalCoordinate;
   count:integer;

begin
k:=0;
gox.idx:=0;
for i:=1 to 169 {25}
do gox.d1[i]:=nullStone;

getCoordinates(ec);
count:=0;

if (random>0.5)
then masterRemove:=blackStone
else masterRemove:=whiteStone;

start_again: count:=count+1;
for i:=ec.x {1} to ec.x2 {5}
do for j:=ec.y {1} to ec.y2 {5}
   do begin
       //write2(7,'Ev:(x,y) '+str2(i)+':'+str2(j));
      if (valid(i,j) and empty(i,j) and not invalid_block[i,j])
      then begin
           tmp:=nullStone;
           tmp.x:=i;
           tmp.y:=j;
           tmp.largestX:=largestX;
           tmp.largestY:=largestY;
           tmp.pce:=PurpleStone;
           setPce(tmp);
           k:=k+1;
           gox.idx:=k;
           gox.d1[k]:=tmp;
           end;
      end;

if (gox.idx=0) and (count<=2)
then begin
     writeln2(2,' ');
     writeln2(2,'*** Starting Again Purple ***');
     writeln2(2,'(x,y) -> '+str2(ec.x)+','+str2(ec.y)+' :: '+
          str2(ec.x2)+','+str2(ec.y2));
     writeln2(2,' ');
     ec:=evalSet[1];
     gox.idx:=0;
     goto start_again;
     end;

donewhite:=gox.idx=0;

if firstCaptureMode
then pickBest2(gox)
else pickBest(gox);

makeMove(pce,gox,purpleStone);
end;




procedure moveBlack(var pce:goResource; var gox:goRecMaster; largestX,largestY:integer);
label
  start_again;
var
   i,j,k, xtmp,ytmp:integer;
   tmp:goResource;
   ec:evalCoordinate;
   count:integer;
   moveStr:string;
begin
k:=0;
gox.idx:=0;
count:=0;

if (random>0.5)
then masterRemove:=purpleStone
else masterRemove:=whiteStone;

for i:=1 to 169 {25}
do gox.d1[i]:=nullStone;

enterWait:=true;
if player=2
then begin
     output2[10].text:='Please Enter Move for Black';
     while enterWait do;

     output2[10].text:='';
     moveStr:=output2[11].text;
     getXY(moveStr,ytmp,xTmp);
     end;

getCoordinates(ec);

start_again: count:=count+1;

for i:=ec.x {1} to ec.x2 {5}
do for j:=ec.y {1} to ec.y2 {5}
   do begin
       //write2(7,'Ev:(x,y) '+str2(i)+':'+str2(j));
      if (valid(i,j) and empty(i,j) and not invalid_block[i,j])
      then begin
           tmp:=nullStone;
           tmp.x:=i;
           tmp.y:=j;
           tmp.largestX:=largestX;
           tmp.largestY:=largestY;
           tmp.pce:=blackStone;
           setPce(tmp);
           k:=k+1;
           gox.idx:=k;
           gox.d1[k]:=tmp;
           end;
      end;

if (gox.idx=0) and (count<=2)
then begin
     writeln2(2,' ');
     writeln2(2,'*** Starting Again Black ***');
     writeln2(2,'(x,y) -> '+str2(ec.x)+','+str2(ec.y)+' :: '+
          str2(ec.x2)+','+str2(ec.y2));
     writeln2(2,' ');
     writeln2(2,' ');
     ec:=evalSet[1];
     gox.idx:=0;
     goto start_again;
     end;

doneBlack:=(gox.idx=0);

if firstCaptureMode
then pickBest2(gox)
else pickBest(gox);

if player<>blackStone
then makeMove(pce,gox,blackStone)
else begin
     tmp:=nullStone;
     tmp.x:=xTmp;
     tmp.y:=yTmp;
     tmp.largestX:=largestX;
     tmp.largestY:=largestY;
     tmp.pce:=blackStone;
     setPce(tmp);
     gox.idx:=1;

     gox.d1[1]:=tmp;
     GoResBl.idx:=goResBl.idx+1;
     GoResBl.d1[goResBl.idx]:=tmp;
     makeBoard2;
     displayBoard;
     end;
end;





function rating(var pceA, pceB:goResource):real;
// started 9/14/2003 by D. Kanecki, Ph.D., A.C.S., Bio. Sci.
// adopted using ITS5X to GoITS characteristics

label rating_exit;
var
   i:integer;
   i2, iprev:real;
begin

points_changed:=0;
i2:=0;
for i:=1 to 10
do begin
    chPos[i]:=false;
    chNeg[i]:=false;
    end;

if (debug4 and (pceConst = pceA.pce))
then begin
     if (pceB.pce=0)
     then writeln2(2,'No Opponent')
     else writeln2(2,'Opponent '+str2(pceB.pce)+' at ');
     end;

if (pceA.alt =9999) and ( pceA.dist>9000)
then begin
        points_changed:=010;
        i2:=points_changed;
        goto rating_exit;
        end;

if (not pceA.largestGroupSafe)   // king safe
then begin
     i2:=-points[1];     points_changed:=i2;
     chNeg[1]:=true;
     writeln2(2,' *** Largest Group Not Safe ');
     goto rating_exit;
     end;

i2:=0;
iprev:=0;

if (pceA.largestGroupSafe and not pceB.largestGroupSafe)  // king safe 2
then begin
      i2:=i2+points[1];
      chPos[1]:=true;
      end
else if (pcea.largestGroupSafe <> pceB.largestGroupSafe)
then begin
      i2:=i2-points[1];
      chNeg[1]:=true;
      end;

points_changed:=points_changed+abs(i2-iprev);
iprev:=i2;

if (debug4 and (pceA.pce = pceConst))
then begin
     write2(2,'KS ');
     write2(2,str3(i2,6,3)+' ');
     end;


// alternative evaluation
if (pceA.alt < pceB.alt)
    and ( pcea.pceSafe or (pceA.groupSize > pceB.groupSize))
then begin
      i2:=i2+points[2];
      chPos[2]:=true;
      end
else if (pceA.alt <> pceB.alt)
then begin
      i2:=i2-points[2];
      chNeg[2]:=true;
      end;

if (debug4 and ( pceA.pce = pceConst)) 
then begin
      write2(2,' AL '+str3(i2,6,3));
      end;

points_changed:=points_changed+abs(i2-iprev);
iprev:=i2;

// pce and opptKing Safe eval
if (not pceB.largestGroupSafe and pceA.pceSafe)
    and not ( not pceA.largestGroupSafe and pceB.pceSafe)
then begin
      i2:=i2+points[3];
      chPos[3]:=true;
      end
else if ((not pceB.largestGroupSafe and pceA.pceSafe)
        <> (not pceA.largestGroupSafe and pceB.pceSafe))
then begin
       i2:=i2-points[3];
       chNeg[3]:=true;
       end;

if (debug4 and (pceA.pce = pceConst))
then begin
      write2(2,' OKS '+str3(i2,6,3));
      end;

points_changed:=points_changed+abs(i2-iprev);
iprev:=i2;

// piece safety eval
if (pceA.pceSafe and not pceB.pceSafe)
     {and not ( pceA.captGroupSize >=pceB.captGroupSize)}
then begin
      i2:=i2+points[4];
      chPos[4]:=true;
      end
else if (pceA.captGroupSize > pceB.captGroupSize)
then begin
      i2:=i2+points[4];   // capture greater than loss
      chPos[4]:=true;
      end
else if (pceA.pceSafe <> pceB.pceSafe)
       or (pceA.captGroupSize < pceB.captGroupSize)
then begin
      i2:=i2-points[4];
      chNeg[4]:=true;
      end;

points_changed:=points_changed+abs(i2-iprev);
iprev:=i2;

if (debug4 and (pceA.pce = pceConst))
then begin
      write2(2,' PS '+str3(i2,6,3));
      end;


// area capture eval - n5
if (pceA.captGroupSize > pceB.captGroupSize)
then begin
      if (pceA.pceSafe or ( pceB.groupSize >= pceA.groupSize))
      then begin
            i2:=i2+points[5];
            chPos[5]:=true;
            end
      else begin
            i2:=i2-points[5]*abs(1+pceB.groupSize);
            chPos[5]:=true;
            end;
      end
else if (pceA.captGroupSize <> pceB.captGroupSize)
      or (pceB.groupSize < pceA.groupSize)
      then begin
            i2:=i2-points[5]*abs(1+pceB.groupSize);
            chNeg[5]:=true;
            end;

if (Debug4 and (pceA.pce = pceConst))
then begin
      write2(2,' CA '+str3(i2,6,3));
      end;

points_changed:=points_changed+abs(i2-iprev);
iprev:=i2;

// distance away from main cluster
if (pceA.dist < pceB.dist)
then begin
      i2:=i2+points[6];
      chPos[6]:=true;
      end
else if(pceA.dist <> pceB.dist)
then begin
      i2:=i2-points[6];
      chNeg[6]:=true;
      end;

if (debug4 and (pceA.pce = pceConst))
then begin
      write2(2,' DI '+str3(i2,6,3));
      end;

points_changed:=points_changed+abs(i2-iprev);
iprev:=i2;

// area evaluation n7
if (pceA.area > pceB.area)
then begin
      i2:=i2+points[7];
      chPos[7]:=true;
      end
else if (pceA.area <> pceB.area)
then begin
      i2:=i2-points[7];
      chNeg[7]:=false;
      end;

points_changed:=points_changed+abs(i2-iprev);
iPrev:=i2;

i2:=i2+bonus_point;

if (i2>iprev)
then ChPos[8]:=true;

points_changed:=points_changed+abs(i2-iprev);
iprev:=i2;

if (debug4 and (pceA.pce = pceConst))
then begin
     write2(2,' BP '+str3(i2,6,3));
     end;

if (debug4 and (pceA.pce = pceConst))
then writeln2(2,' ');


rating_exit:
    rating:=i2;

end;

initialization

//evalSet:array[0..4] of evalCoordinate;

with evalSet[1]
do begin
    x:=1;
    y:=1;
    x2:=19;
    y2:=19;
    end;

with evalSet[2]
do begin
   x:=1;
   y:=1;
   x2:=8;
   y2:=8;
   end;

with evalSet[3]
do begin
   x:=8;
   y:=1;
   x2:=19;
   y2:=8;
   end;

with evalSet[4]
do begin
   x:=1;
   y:=8;
   x2:=8;
   y2:=19;
   end;

with evalSet[5]
do begin
   x:=8;
   y:=8;
   x2:=19;
   y2:=8;
   end;

with evalSet2[1]
do begin
    x:=1;
    y:=1;
    x2:=13;
    y2:=13;
    end;

with evalSet2[2]
do begin
   x:=1;
   y:=1;
   x2:=6;
   y2:=6;
   end;

with evalSet2[3]
do begin
   x:=6;
   y:=1;
   x2:=13;
   y2:=6;
   end;

with evalSet2[4]
do begin
   x:=1;
   y:=6;
   x2:=6;
   y2:=13;
   end;

with evalSet2[5]
do begin
   x:=6;
   y:=6;
   x2:=13;
   y2:=6;
   end;

end.
