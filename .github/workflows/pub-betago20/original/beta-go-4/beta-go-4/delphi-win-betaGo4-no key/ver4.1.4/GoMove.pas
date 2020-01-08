unit GoMove;

interface
uses GoData1,GoCore1,GoEval,testModules;

procedure evalModeSim;

implementation


procedure evalModeSim;
// started 10/08/03 by d. kanecki
//    using sample / milestone 9 setup
var
   goTest, goTest2:goRecMaster;
   stonesLost,stonesGained: captureType;
   i:integer;
   goW:goResource;
   pce:goResource;

begin
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
insertPce(pce {goTest.d1[1]},goBoard,stonesGained,stonesLost);
removePce(goResBl,stonesGained);
removePce(goResWh,stonesLost);

writeln2(2,'Stones Gained '+str2(stonesGained.idx) +
   '   Stones Lost '+str2(stonesLost.idx));
addMove(pce {goTest.d1[1]},stonesGained,stonesLost,whiteStone,goTest);
makeBoard;
displayBoard;

moveBlack(pce,goTest,0,0);
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
removePce(goResBl,stonesGained);
removePce(goResWh,stonesLost);

writeln2(2,'Stones Gained '+str2(stonesGained.idx) +
   '   Stones Lost '+str2(stonesLost.idx));
addMove(pce { goTest.d1[1]},stonesGained,stonesLost,blackStone,goTest);
makeBoard;
displayBoard;
end;

end.
