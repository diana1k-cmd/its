unit testModules;

interface
 uses
  {Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, StdCtrls, jpeg, ExtCtrls,} godata1,goCore1,goEval,process,
  mind1;

var
   pceR2: array[1..3] of goResource;
   stonesLost2, stonesGained2: array[1..3] of captureType;
   pceList2: array[1..3] of goRecMaster;
   fpOut4:text;

procedure testModule4;
procedure testModule1;
procedure testModule2;
procedure testModule3;
procedure displayOutput1(goW,goB:goResource; moveNo:integer;
               goList,goListB:goRecMaster);
procedure displayReport(moveNo:integer);

procedure addMove(pceR:goResource; stonesGained, StonesLost:captureType;
              moveColor:integer; pceList:goRecMaster);
procedure evalModeSim(moveCount:integer);
procedure closeOutput;

implementation


procedure evalModeSim(moveCount:integer);
// started 10/08/03 by d. kanecki
//    using sample / milestone 9 setup
var
   goTest, goTest2:goRecMaster;
   stonesLost,stonesGained: captureType;
   i:integer;
   goW:goResource;
   pce:goResource;

begin
if (emulate_all or emulate_white)
then read_white_neurons;

if (goResWh.stonesAvail>0)
then moveWhite(pce,goTest,0,0)
else begin
     doneWhite:=true;
     pce:=nullStone;
     goTest.idx:=0;
     end;

writeln2(2,'Option List Index Length = '+str2(goTest.idx));
writeln2(2,'Best (x,y) = ('+str2(goTest.d1[1].x)+
                     ' , '+ str2(goTest.d1[1].y)+')');
goW:=goTest.d1[1];
for i:=1 to goTest.idx
do begin
   write2(2,str2(i)+'->');
   writePce(goTest.d1[i]);
   end;
insertPce(pce {goTest.d1[1]},goBoard,stonesGained,stonesLost);
//removePce(goResBl,stonesGained);

case masterRemove of
        whiteStone:  removePce(goResWh,stonesGained);
        blackStone:  removePce(goResBl,stonesGained);
        purpleStone: removePce(goResPurple,stonesGained);
        else;
        end;


writeln2(2,'Stones Gained '+str2(stonesGained.idx) +
   '   Stones Lost '+str2(stonesLost.idx));
pce1[1]:=pce;
addMove(pce{goTest.d1[1]},stonesGained,stonesLost,whiteStone,goTest);
makeBoard;
displayBoard;


// purple mode processing
if (goResPurple.stonesAvail>0)
then movePurple(pce,goTest,0,0)
else begin
     doneWhite:=true;
     pce:=nullStone;
     goTest.idx:=0;
     end;

writeln2(2,'Option List Index Length = '+str2(goTest.idx));
writeln2(2,'Best (x,y) = ('+str2(goTest.d1[1].x)+
                     ' , '+ str2(goTest.d1[1].y)+')');
goW:=goTest.d1[1];
for i:=1 to goTest.idx
do begin
   write2(2,str2(i)+'->');
   writePce(goTest.d1[i]);
   end;
insertPce(pce {goTest.d1[1]},goBoard,stonesGained,stonesLost);
//removePce(goResWh,stonesGained);
//removePce(goResPurple,stonesLost);
case masterRemove of
        whiteStone:  removePce(goResWh,stonesGained);
        blackStone:  removePce(goResBl,stonesGained);
        purpleStone: removePce(goResPurple,stonesGained);
        else;
        end;

writeln2(2,'Stones Gained '+str2(stonesGained.idx) +
   '   Stones Lost '+str2(stonesLost.idx));
addMove(pce{goTest.d1[1]},stonesGained,stonesLost,purpleStone,goTest);
pce1[3]:=pce;
makeBoard;
displayBoard;


// end purple mode processing



if (emulate_all or emulate_black)
then read_black_neurons;

if (goResBl.stonesAvail>0)
then moveBlack(pce,goTest,0,0)
else begin
     doneBlack:=true;
     pce:=nullStone;
     goTest.idx:=0;
     end;

writeln2(2,'Option List Index Length = '+str2(goTest.idx));
writeln2(2,'Best (x,y) = ('+str2(goTest.d1[1].x)+
                     ' , '+ str2(goTest.d1[1].y)+')');
goW:=goTest.d1[1];
for i:=1 to goTest.idx
do begin
   write2(2,str2(i)+'->');
   writePce(goTest.d1[i]);
   end;
insertPce(pce{goTest.d1[1]},goBoard,stonesGained,stonesLost);
//removePce(goResPurple,stonesGained);
//removePce(goResBl,stonesLost);
case masterRemove of
        whiteStone:  removePce(goResWh,stonesGained);
        blackStone:  removePce(goResBl,stonesGained);
        purpleStone: removePce(goResPurple,stonesGained);
        else;
        end;

writeln2(2,'Stones Gained '+str2(stonesGained.idx) +
   '   Stones Lost '+str2(stonesLost.idx));
pce1[2]:=pce;
addMove(pce {goTest.d1[1]},stonesGained,stonesLost,blackStone,goTest);
makeBoard;
removeAll;
displayBoard;
displayReport(moveCount);
end;


procedure addMove(pceR:goResource; stonesGained, StonesLost:captureType;
              moveColor:integer; pceList:goRecMaster);
begin
if (moveColor=1)
then begin
     pceR2[1]:=pceR;
     captCount[1]:=captCount[1]+stonesGained.idx;
     StonesGained2[1]:=stonesGained;
     StonesLost2[1]:=stonesLost;
     pceList2[1]:=pceList;
     end
else if (moveColor=purpleStone)
     then begin
          pceR2[3]:=pceR;
          captCount[2]:=captCount[2]+stonesGained.idx;
          stonesGained2[3]:=stonesGained;
          stonesLost2[3]:=stonesLost;
          pceList2[3]:=pceList;
          end
     else begin
          pceR2[2]:=pceR;
          captCount[3]:=captCount[3]+stonesGained.idx;
          stonesGained2[2]:=stonesGained;
          stonesLost2[2]:=stonesLost;
          pceList2[2]:=pceList;
     end;
end;

procedure closeOutput;
begin
close(fpOut);
close(fpOut4);
end;


procedure testModule3;
var
  i:integer;
  stonesLost,stonesGained:captureType;
  goPce:goResource;
  goList:goRecMaster;
begin
moveCount:=1;
clearBoard(goBoard);
for i:=1 to 10
do begin
   evalModeSim(moveCount);
   makeBoard;
   moveCount:=moveCount+1;
   end;

goList.idx:=0;
goPce:=nullStone;
stonesLost.idx:=0;
stonesGained.idx:=0;
addMove(goPce,stonesGained,stonesLost,whiteStone,goList);
addMove(goPce,stonesGained,stonesLost,blackStone,goList);
displayReport(moveCount);

halt2;
closeOutput;


writeln2(2,'=== WHITE RESOURCES===');
for i:=1 to goResWh.idx
do begin
   writePce(goResWh.d1[i]);
   writeln2(2,' ');
   end;
writeln2(2,' ');
writeln2(2,'=== BLACK RESOURCES === ');
for i:=1 to goResBl.idx
do begin
   writePce(goResBl.d1[i]);
   writeln2(2,' ');
   end;

writeln2(2,' ');
writeln2(2,'=== Milestone 10 Completed ===');
writeln2(2,' ');
end;

procedure testModule2;
var i:integer;
    goTest,goTest2:goRecMaster;
    tl2:glist;
    goW,goB:goResource;
    stonesGained,stonesLost:captureType;
    pce:goResource;
begin
moveCount:=1;
clearBoard(goBoard);

writeln2(2,' === Milestone 9 ====');
writeln2(1,' === Milestone 9 ==== ');
goPce.x:=1;
goPce.y:=1;
goPce.largestX:=0;
goPce.largestY:=0;
goPce.pce:=blackStone;
setPce(goPce);
goB:=goPce;
writePce(goPce);
goTest.idx:=0;
insertPce(goPce,goBoard,stonesGained,stonesLost);

writeln2(2,'Lost: '+str2(stonesLost.idx)+' Gained: '+str2(stonesGained.idx));

addMove(goPce,stonesGained,stonesLost,blackStone,goTest);
RemovePce(goResWh,stonesLost);
removePce(goResBl,stonesgained);
makeBoard;
displayBoard;


goPce.x:=2;
goPce.y:=1;
goPce.largestX:=0;
goPce.largestY:=0;
goPce.pce:=whiteStone;
setPce(goPce);
writePce(goPce);
InsertPce(goPce,goBoard,stonesGained,stonesLost);
writeln2(2,'Lost: '+str2(stonesLost.idx)+' Gained: '+str2(stonesGained.idx));

addMove(goPce,stonesGained,stonesLost,whiteStone,goTest);
makeBoard;
displayBoard;
displayReport(1);


writeln2(2,'Milestone 8');
writeln2(1,'Milestone 9 ');
{
clearBoard(goBoard);
goBoard[1,1]:=blackStone;
goBoard[1,2]:=whiteStone;
displayBoard2;
}



moveWhite(pce,goTest,0,0);
writeln2(2,'Option List Index Length = '+str2(goTest.idx));
writeln2(2,'Best (x,y) = ('+str2(goTest.d1[1].x)+
                     ' , '+ str2(goTest.d1[1].y)+')');
goW:=goTest.d1[1];
for i:=1 to goTest.idx
do begin
   write2(2,str2(i)+'->');
   writePce(goTest.d1[i]);
   end;
insertPce(goTest.d1[1],goBoard,stonesGained,stonesLost);
removePce(goResBl,stonesGained);
removePce(goResWh,stonesLost);

writeln2(2,'=== WHITE STONES ==='+str2(goResWh.idx)+':'+
         str2(stonesLost.idx));
for i:=1 to goResWh.idx
do begin
   write2(2,str2(i)+'->');
   writePce(goResWh.d1[i]);
   end;
writeln2(2,' ');

writeln2(2,'============================= ');
writeln2(2,'=== Black Stones ==='+str2(goResBl.idx)+':'+
         str2(stonesGained.idx));
for i:=1 to goResBl.idx
do begin
   write2(2,str2(i)+'->');
   writePce(goResBl.d1[i]);
   end;
writeln2(2,' ');
writeln2(2,'============================= ');
writeln2(2,'Stones Gained '+str2(stonesGained.idx) +
   '   Stones Lost '+str2(stonesLost.idx));
addMove(goTest.d1[1],stonesGained,stonesLost,whiteStone,goTest);
makeBoard;
displayBoard;

goTest2.idx:=0;
stonesGained.idx:=0;
stonesLost.idx:=0;
addMove(nullStone,stonesGained,stonesLost,blackStone,goTest2);
displayReport(2);
closeOutput;

displayBoard;
writeln2(2,' ');
goPce.pce:=blackStone;
goPce.x:=1;
goPce.y:=1;
goPce.largestX:=0;
goPce.largestY:=0;
setPce(goPce);
write2(2,'New Status: ');
writePce(goPce);
writeln2(2,' ');
{displayBoard2; }
end;


procedure testModule4;
var
  goPce:goResource;
begin
clearBoard(goBoard);
goBoard[1,2]:=whiteStone;
goBoard[2,1]:=whiteStone;
displayBoard;
goPCe.pce:=BlackStone;
goPce.x:=1;
goPce.y:=1;
goPce.largestX:=0;
goPce.largestY:=0;
setPce(goPce);
write2(2,' Status: ');
writePce(goPce);
writeln2(2,' ');
goBoard[1,1]:=blackStone;
displayBoard;

goPCe.x:=1;
goPce.y:=2;
goPce.largestX:=0;
goPce.largestY:=0;
setPce(goPce);
write2(2,'Status 2 ');
writePce(goPce);
writeln2(2,' ');
end;

procedure writePreamble(moveNo:integer);
begin
writeln(fpOut);
writeln(fpOut,'====================================');
writeln(fpOut,' =  GO/ITS 1 Report 1 - (C) 1986-2003 by D. Kanecki, Ph.D., All Rights Reserved');
writeln(fpOut,'====================================');
writeln(fpOut,'Move : ',moveNo:4);
writeln(fpOUt,'White Option Selected:  ',OptionWhite);
writeln(fpOut,'Black Option Selected:  ',OptionBlack);
writeln(fpOut,'Purple Option Selected: ',optionPurple);
writeln(fpOut);
end;


procedure writeBoard;
var
  goBoard1:array2;
     procedure makeBoard(var goBoard:array2);
        var i,j,k:integer;
        begin
        for i:=1 to MaxX
        do for j:=1 to maxY
                do goBoard[i,j]:=0;

        for k:=1 to goResWh.idx
        do  with GoResWh
                do if (d1[k].pce<>0) and (k<=maxTotal)
                     and valid(d1[k].x,d1[k].y)
                   then goBoard[d1[k].x,d1[k].y]:=d1[k].pce;

        //writeln2(2,'Black Stone idx= '+str2(goResBl.idx));

        for k:=1 to goResBl.idx
        do  if (goResBl.d1[k].pce<>0)
        then
        with GoResBl
        do if (d1[k].pce<>0) and (k<=maxTotal)
              and valid(d1[k].x,d1[k].y)
           then goBoard[d1[k].x,d1[k].y]:=d1[k].pce;

        for k:=1 to goResPurple.idx
        do with goResPurple
           do if (goResPurple.d1[k].pce<>0) and (k<=maxTotal)
               and valid(d1[k].x,d1[k].y)
               then goBoard[d1[k].x,d1[k].y]:=d1[k].pce;
        end;


        procedure displayBoard2(goBoard:array2);
        // first q/c passed 8/11/03 by d. kanecki
        var
                i,j,k:integer;
                tl:glist;
        begin
        //clear1;
        writeln(fpOut,'(1) -- Board Display After Insertion');
        writeln(fpOut,' ');

        writeStatus;
        writeln(fpOut,'Move: '+str2(moveCount));
        writeln(fpOut,' ');
        write(fpOut,'     ');

        for i:=1 to maxX
        do for j:=1 to maxY
           do begin
              tl.idx:=0;
              safeArea[i,j]:=safe(i,j,goBoard[i,j],i,j,tl);
              end;
        for i:=0 to MaxX-1
        do   write(fpOut,'|'+chr(ord('A')+i)+' ');
        writeln(fpOut,' ');

        write(fpOut,'     ');
        for i:=0 to maxX*3
        do write(fpOut,'-');
        writeln(fpOut,' ');

        for i:=1 to MaxX
        do begin
                write(fpOut,str3(i,2,0)+': |');

                for j:=1 to MaxY
                do begin
                        if goBoard[i,j]=whiteStone
                        then begin
                                write(fpOut,'W');
                                if (not safeArea[i,j])
                                then write(fpOut,'*')
                                else write(fpOut,' ');
                             end
                        else if GoBoard[i,j]=blackStone
                        then begin
                                write(fpOut,'B');
                                if not safeArea[i,j]
                                then write(fpOut,'*')
                                else write(fpOut,' ');
                             end
                        else if GoBoard[i,j]=purpleStone
                        then begin
                             write(fpOut,'P');
                             if not safeArea[i,j]
                             then write(fpOut,'*')
                             else write(fpOut,' ')
                             end
                        else if invalid_block[i,j]
                        then write(fpOut,'**')
                        else write(fpOut,'  ');
                        write(fpOut,'|');
                end;
        writeln(fpOut,' ');

        write(fpOut,'     ');
        for k:=0 to maxX*3
        do write(fpOut,'-');
        writeln(fpOut,' ');
        end;
     writeln(fpOut,' ');
     end;


begin
  makeBoard(goBoard1);
  displayBoard2(goBoard1);

end;


{procedure writePce2(gox:goResource);
        begin
        //writeln(fpOut);
        write(fpOut,'Pce '+str2(gox.pce)+'::');
        write(fpOut,'(x,y) =  ('+str2(gox.x)+':'+str2(gox.y)+') ');
        write(fpOut,'PceRank '+str2(gox.groupSize)+'::');
        write(fpOut,'FreeSpace '+str2(gox.freeSpace)+'::');
        write(fpOut,'Dist '+str3(gox.dist,7,3)+'::');
        write(fpOut,'KSafe '+str4(gox.largestGroupSafe)+'::');
        write(fpOut,'KRank '+str2(gox.largestGroupSize)+'::');
        write(fpOut,'Capt '+str2(gox.captGroupSize)+'::');
        write(fpOut,'Area '+str2(gox.area)+'::');
        write(fpOut,'Alt '+str2(gox.alt)+'::');
        writeln(fpOut,'PceSafe '+str4(gox.groupSafe));
        //writeln(fpOut);
        end;
}
procedure writePce2(gox:goResource);
        begin
        //writeln(fpOut);
        write(fpOut4,'Pce '+str2(gox.pce)+'::');
        write(fpOut4,'(x,y) =  ('+str2(gox.x)+':'+str2(gox.y)+') ');
        write(fpOut4,'A '+str2(gox.groupSize)+'::');
        write(fpOut4,'B '+str2(gox.freeSpace)+'::');
        write(fpOut4,'C '+str3(gox.dist,7,3)+'::');
        write(fpOut4,'D '+str4(gox.largestGroupSafe)+'::');
        write(fpOut4,'E '+str2(gox.largestGroupSize)+'::');
        write(fpOut4,'F '+str2(gox.captGroupSize)+'::');
        write(fpOut4,'G '+str2(gox.area)+'::');
        write(fpOut4,'H '+str2(gox.alt)+'::');
        writeln(fpOut4,'I '+str4(gox.groupSafe));
        //writeln(fpOut);
        end;


procedure writeMoves(goW,goB:goResource);
var
  i:integer;
begin
writeln(fpOut);
writeln(fpOut,'White Stone: ',chr(ord('A')+goW.x-1),':',goW.y);
writePce2(goW);
writeln(fpOut);

writeln(fpOut,'Stones Lost Potential '+str2(stonesLost2[1].idx));
for i:=1 to stonesLost2[1].idx
do if (stonesLost2[1].isCaptured[i])
   then write(fpOut,chr(ord('A')+stonesLost2[1].x[i]-1),':',stonesLost2[1].y[i],' ');
writeln(fpOut);

writeln(fpOut,'Stones Gained Potenital '+str2(stonesGained2[1].idx));
for i:=1 to stonesGained2[1].idx
do if (stonesGained2[1].isCaptured[i])
   then write(fpOut,chr(ord('A')+stonesGained2[1].x[i]-1),':',stonesGained2[1].y[i],' ');
writeln(fpOut);
writeln(fpOut);
writeln(fpOut,'=== WHITE NEURONS ===');
for i:=1 to 7
do write(fpOut,points_white[i]:8:3);
writeln(fpOut);

writeln(fpOut);

writeln(fpOut,'Black Stone: ',chr(ord('A')+goB.x-1),':',goB.y);
writePce2(goB);
writeln(fpOut);

writeln(fpOut,'Stones Lost Potential '+str2(stonesLost2[2].idx));
for i:=1 to stonesLost2[2].idx
do {if (stonesLost2[2].isCaptured[i])
   then} write(fpOut,chr(ord('A')+stonesLost2[2].x[i]-1),':',stonesLost2[2].y[i],' ');
writeln(fpOut);

writeln(fpOut,'Stones Gained Potential '+str2(stonesGained2[2].idx));
for i:=1 to stonesGained2[2].idx
do {if (stonesGained2[2].isCaptured[i])
   then} write(fpOut,chr(ord('A')+stonesGained2[2].x[i]-1),':',stonesGained2[2].y[i],' ');
writeln(fpOut);
writeln(fpOut);
writeln(fpOut,'=== BLACK NEURONS ===');
for i:=1 to 7
do write(fpOut,points_black[i]:8:3);
writeln(fpOut);
writeln(fpOut);

writeln(fpOut,'Purple Stones---');
writeln(fpOut,'Purple Stone: ',chr(ord('A')+pcer2[3].x-1),' : ',pcer2[3].y);
writePce2(pcer2[3]);
writeln(fpOut);

writeln(fpOut,'Stones Lost Potential '+str2(stonesLost2[3].idx));
for i:=1 to stonesLost2[2].idx
do {if (stonesLost2[2].isCaptured[i])
   then} write(fpOut,chr(ord('A')+stonesLost2[3].x[i]-1),':',stonesLost2[3].y[i],' ');
writeln(fpOut);

writeln(fpOut,'Stones Gained Potential '+str2(stonesGained2[3].idx));
for i:=1 to stonesGained2[2].idx
do {if (stonesGained2[2].isCaptured[i])
   then} write(fpOut,chr(ord('A')+stonesGained2[3].x[i]-1),':',stonesGained2[3].y[i],' ');
writeln(fpOut);
writeln(fpOut);
writeln(fpOut);
end;


procedure writeOptions(goTest:goRecMaster; id:String);
var i:integer;
begin
writeln(fpOut4);
writeln(fpOut4,'Move: ',moveCount,'(2)'+id+' --- Explanation of Options ----');
writeln(fpOut4);
if (goTest.idx=0)
then writeln(fpOut4,' *** No Options Available')
else
for i:=1 to goTest.idx
do begin
   write(fpOut4,str2(i)+'->');
   writePce2(goTest.d1[i]);
   end;
writeln(fpOut4);
end;

procedure displayOutput1(goW,goB:goResource; moveNo:integer;
               goList,goListB:goRecMaster);
begin
writePreamble(MoveNo);
writeMoves(goW,goB);
writeBoard;
WriteOptions(goList,'White');
WriteOptions(goListB,'Black');
writeOptions(PceList2[3],'Purple');
end;

procedure displayReport(moveNo:integer);
begin
displayOutput1(pceR2[1],pceR2[2],moveNo,PceList2[1],pceList2[2]);
end;

procedure testModule1;
var i:integer;
    goTest:goRecMaster;
    tl2:glist;
    goW,goB:goResource;
    stonesGained,stonesLost:captureType;
begin

// simple status i/o
write2(3,'Test 1: 3');
write2(4,'Test 1: 4');
write2(5,'Test 1: 5');
write2(6,'Test 1: 6');
write2(7,'Test 1: 7');

// screen based i/o
write2(1,'Test 1: Setup I/O ');
writeln2(1,'... completed');

write2(2,'Test 2: Setup I/O ');
writeln2(2,'... completed' );

displayBoard;
goPce:=nullStone;
goPce.x:=1;
goPce.y:=2;
goPce.pce:=whiteStone;
add(goPce,whiteStone);
makeBoard;
tl2.idx:=0;
writeln2(2,'Is Safe : (1,2) = '+str4(safe(1,2,whiteStone,1,2,tl2)));

goPce.x:=2;
goPce.y:=1;
goPce.pce:=whiteStone;
add(goPce,whiteStone);
makeBoard;
tl2.idx:=0;
writeln2(2,'Is Safe : (2,1) = '+str4(safe(2,1,whiteStone,2,1,tl2)));

goPce.x:=1;
goPce.y:=1;
goPce.pce:=blackStone;
add(goPce,blackStone);
makeBoard;
tl2.idx:=0;
writeln2(2,'Is Safe : (1,1) = '+str4(safe(1,1,blackStone,1,1,tl2)));

goPce.x:=3;
goPce.y:=1;
goPce.pce:=whiteStone;
add(goPce,whiteStone);
makeBoard;
tl2.idx:=0;
writeln2(2,'Is Safe : (3,1) = '+str4(safe(3,1,whiteStone,3,1,tl2)));
tl2.idx:=0;
writeln2(2,'Is Safe : (2,1) = '+str4(safe(2,1,whiteStone,2,1,tl2)));
displayBoard;
writeln2(2,' ');
tl2.idx:=0;
writeln2(2,'groupSize(1,1) is '+str2(groupSize(1,1,blackStone,tl2)));
tl2.idx:=0;
writeln2(2,'groupSize(3,1) is '+str2(groupSize(3,1,whiteStone,tl2)));
writeln2(2,' ');
writeln2(2,'=== Milestone 4 - groupList test');
safeList.idx:=0;

writeln2(2,'Stone Color = '+str2(whiteStone));
mkGroup2(safeList,3,1,whiteStone);
//add2(safeList,3,1);
//mkGroupList(3,1,SafeList,whiteStone,3,1);
writeln2(2,'Group List Size = '+str2(SafeList.idx));
for i:=1 to safeList.idx
do writeln2(2,' (x,y) = '+str2(safeList.x[i])+'::'+
        str2(SafeList.y[i]));

writeln2(2,' ');
writeln2(2,'Stone Color = '+str2(blackStone));
mkGroup2(safeList,1,1,blackStone);
//add2(safeList,3,1);
//mkGroupList(3,1,SafeList,whiteStone,3,1);
writeln2(2,'Group List Size = '+str2(SafeList.idx));
for i:=1 to safeList.idx
do writeln2(2,' (x,y) = '+str2(safeList.x[i])+'::'+
        str2(SafeList.y[i]));

writeln2(2,' ');
writeln2(2,'MileStone 5');
goPce:=nullStone;
goPce.pce:=whiteStone;
goPce.x:=2;
goPce.y:=1;
goBoard[3,1]:=0;
goBoard[2,1]:=0;
setPce(goPce);
writePce(goPce);
displayBoard;

writeln2(2,' ');
writeln2(2,'==== MILESTONE 6 === ');
clearBoard(goBoard);
clear1;
goPce.pce:=whiteStone;
goPce.x:=1;
goPce.y:=2;
goPce.largestX:=0;
goPce.largestY:=0;
setPce(goPce);
writePce(goPce);
insertPce(goPCe,goBoard,stonesGained,StonesLost);
writeln2(2,'Stones Gained : '+str2(stonesGained.idx)+
       '  Stones Lost: '+str2(stonesLost.idx));
displayBoard;
writeln2(2,' ');
goPce.pce:=blackStone;
goPce.x:=1;
goPce.y:=1;
goPce.largestX:=0;
goPce.largestY:=0;
setPce(goPce);
write2(2,'New Status: ');
writePce(goPce);
writeln2(2,' ');
end;

initialization
pcer2[1]:=nullStone;
pcer2[2]:=nullStone;
StonesGained2[1].idx:=0;
Stonesgained2[2].idx:=0;
StonesLost2[2].idx:=0;
StonesLost2[2].idx:=0;

pceList2[1].idx:=0;
pceList2[1].idx:=0;
assign(fpOut4,'resultsDetailed.txt');
rewrite(fpOut4);
end.
