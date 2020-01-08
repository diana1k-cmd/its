unit emulate2;
//==========================================
// Updated 2019-Dec 29th for Lazarus 2.0.2
//   from Delphi 7 source
// =========================================
// Emulation Module for DK GO ITS
// October 21st, 2004
// By D. Kanecki
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, goData2,goCore2,goEval2,process2,TestModules2,mind1;

procedure main1;
procedure emulateMain;
procedure learnMain;

implementation
type
   coord2=record
      x,y:integer;
   end;

var
   xWh,xBl:coord2;
   fpInGo:text;
   pceTmp,pceCmp:goResource;
   fpNeural1, fpNeural2:text;

//-----------------------------------------------------


function rating3(var pce1x,pce1y:goResource):real;
begin

{pceOpptx:=pce1y.pceOppt;
if (abs(pce1y.pce)=king)
then bonus_point:= - pce1y.bonus_point
else bonus_point:=0;
}
 rating3:=rating(pce1x,pce1y);
 {pce1x.kingSafe,pce1y.kingSafe,
                            pce1x.pceSafe,pce1y.pceSafe,
                            pce1x.alt,pce1y.alt,
                            pce1x.dist,pce1y.dist,
                            pce1x.area,pce1y.area,
                            pce1x.capt,pce1y.capt,
                            pce1x.pce,pce1x.pceOppt,
                            pce1x.opptKingSafe,pce1y.opptKingSafe); }
end;


function game_status(playerStone:integer; update1:boolean):integer;
begin
        game_status:=0;
end;

Procedure Update_neural_net(player:integer;pceTmp,pceCmp:goResource);
var tmp:real;
    points_tmp:array[1..8] of real;
    i,k2,update_player:integer;
    k:real;
begin

writeln2(2,'+++ IN UPDATE NEURAL NET ++++');

if player=blackStone
then update_player:=whiteStone
else update_player:=blackStone;


for i:=1 to 8
do
   if (player=blackStone)
   then points[i]:=points_black[i]
   else points[i]:=points_white[i];

{if (abs(pceCmp.pce)=king)
then bonus_point:=-pceCmp.Bonus_point
else bonus_point:=0;
}

k:=rating3(pceTmp,pceCmp);


writeln2(2,'Rating A vs. C = '+str3(k,8,3));

writeln2(2,'** STATUS NEURONS ');

for i:=1 to 8
do write2(2,str2(i)+' ');
writeln2(2,' ');


tmp:=0;
for i:=1 to 8
do
   if ChPos[i]
   then begin
        write2(2,'+  ');
        {IF (I<>8) THEN PUT_STRING('+',49,94+(I-1)*7); }
        tmp:=tmp+abs(points[i]);
        end
   else

        if ChNeg[i]
        then begin
             write2(2,'-  ');
             tmp:=tmp+abs(points[i]);
             {IF (I<>8) THEN PUT_STRING('-',49,94+(I-1)*7);  }
             end


        else BEGIN
             write2(2,'=  ');
             {IF (I<>8) THEN PUT_STRING('=',49,94+(I-1)*7); }
             END;


writeln2(2,' ');
writeln2(2,' ');
writeln2(2,'Total Points Changed, Correction '+str3(tmp,8,0)+' '+str3(1-K,9,3));

if player=blackStone
then write2(2,'Game Status-BLACK: ')
else write2(2,'Game Status-WHITE: ');

{Writeln2(2,str2(game_status(player,true)));}
wait;

{put_int(game_status(player,false),23,8); }


FOR I:=1 TO 7
DO BEGIN
   {
   write(fpNeural1,points_white[i]:8:3);
   write(fpNeural2,points_black[i]:8:3);
   }
   {
   PUT_REAL(POINTS_WHITE[I],44,92+(I-1)*7);
   PUT_REAL(POINTS_BLACK[I],46,92+(I-1)*7);
   }
   END;
{
writeln(fpNeural1);
writeln(fpNeural2);
}
if (tmp=0)
then tmp:=(1-k);


if ((1-k)<>0) and (tmp<>0)
then begin

     WRITE2(2,'OLD: ');
     FOR I:=1 TO 8
     DO BEGIN
        WRITE2(2,Str3(POINTS[I],7,2));
        if (i mod 4)=0 then writeln2(2,' ');

        END;
     writeln2(2,' ');
     wait;

     WRITE2(2,'NEW: ');
     FOR I:=1 TO 8
     do begin

        if chNeg[i]
        then begin

          points[i]:=points[i]-(1-k)*ABS(points[i]/tmp)

          end


        ELSE IF CHPOS[I]
          THEN begin

             points[i]:=points[i]+(1-k)*ABS(points[i]/tmp)

              end;


     write2(2,Str3(points[i],7,3));
     if (i mod 4)=0 then writeln2(2,' ');



     end;
     writeln2(2,' ');
     wait;



     TMP:=0;
     FOR I:=1 TO 8
     DO
        IF ChPos[i]
       then tmp:=tmp+points[i]


       else if ChNeg[i]
           then tmp:=tmp-points[i];


     writeln2(2,'New Rating: '+str3(tmp,8,2));
     {PUT_REAL(TMP,50,94);}



     for i:=1 to 7
     do if (player=blackStone)


     then BEGIN
          points_black[i]:=points[i];
          {put_real(points_black[i],47,92+(i-1)*7); }
          END
     else begin
          points_white[i]:=points[i];
          {put_real(points_WHITE[i],45,92+(i-1)*7); }
          end;
     end;



if (game_status(player,false) > 0 )
then begin


     if player=blackStone
     then writeln2(2,'Updating White Neurons')
     else writeln2(2,'Updating Black Neurons');


     for i:=1 to 7
     do if (player=blackStone)
        then points_tmp[i]:=points_white[i]
        else points_tmp[i]:=points_black[i];

     writeln2(2,'OLD: ');
     for i:=1 to 7
     do begin
        write2(2,str3(points_tmp[i],7,3)+' ');
        if (i mod 7)=0 then writeln2(2,' ');
        end;
     writeln2(2,' ');


     tmp:=game_status(player,false)/10.0;


     for i:=1 to 7
     do points_tmp[i]:=points[i]*tmp+points_tmp[i]*(1-tmp);


     writeln2(2,'NEW: ');
     for i:=1 to 7
     do begin
        write2(2,str3(points_tmp[i],7,3)+' ');
        if (i mod 7)=0 then writeln2(2,' ');
        end;


     FOR I:=1 TO 7
     DO begin
        IF (PLAYER=BLACKStone)
        THEN POINTS_WHITE[I]:=POINTS_TMP[I]
        ELSE POINTS_BLACK[I]:=POINTS_TMP[I];

        end;

     writeln2(2,' ');
     end;


FOR I:=1 TO 7
DO BEGIN
   if (player=whiteStone)
   then write(fpNeural1,points_white[i]:8:3)
   else write(fpNeural2,points_black[i]:8:3);

   {
   PUT_REAL(POINTS_WHITE[I],45,92+(I-1)*7);
   PUT_REAL(POINTS_BLACK[I],47,92+(I-1)*7);
   }
   END;
if (player=whiteStone)
then writeln(fpNeural1)
else writeln(fpNeural2);

if (player=whiteStone)
then writeln(fpNeural1)
else writeln(fpNeural2);
wait;



//SetWindow1;
end;



//-----------------------------------------------------
procedure readMove(var gWh, gBl:coord2);
// started 11/18/2003
begin
// read white move
read(fpInGo,ch);
while (ch=' ') and  not eof(fpInGo)
do read(fpInGo,ch);
//read(fpInGo,ch);
ch:=upcase(ch);
gWh.x:=ord(ch)-ord('A')+1;
read(fpInGo,gWh.y);
//read(fpInGo,ch);
//gWh.y:=ord(ch)-ord('0');

// read black move
read(fpInGo,ch);
while (ch=' ') and  not eof(fpInGo)
do read(fpInGo,ch);
//read(fpInGo,ch);
ch:=upcase(ch);
gBl.x:=ord(ch)-ord('A')+1;

read(fpInGo,gBl.y);
//read(fpInGo,ch);
//gBl.y:=ord(ch)-ord('0');

// gobble up eoln
readln(fpInGo);
end;

procedure learnMain;
label end_learn;
var
  idx,i:integer;
  tmp,tmp2:integer;

  goWhiteINput,
  GoBlackInput:goResource;

  pce,goW,goBl:goResource;
  goTest:goRecMaster;

  stonesGained, stonesLost:captureType;

begin
writeln2(2,'=== Starting Learn Main ===');

moveCount:=1;
clearBoard(goBoard);

assign(fpInGo,'goInput1.dat');
reset(fpInGo);

while not eof(fpInGo) and (idx<>9999)
do begin
   doPause;
   read(fpInGo,idx);
   if (idx<>9999)
   then readMove(xWh,xBl)
   else begin
        xWh.x:=9999;  xWh.y:=9999;
        xBl.x:=9999;  xBl.y:=9999;
        goto end_learn;
        end;
   //readln(fpInGo);
   write2(2,'   Loop  '+str2(idx));
   if (idx<>9999)
   then begin
        tmp:=xWh.x+ord('A')-1;
        tmp2:=xBl.x+ord('A')-1;
        writeln2(2,' ::'+chr(tmp)+','+str2(xWh.y)+'   '+chr(tmp2)+','+str2(xBl.y));
        end
   else writeln2(2,'  ');
   //idx:=9999;


   // emulate white
   goWhiteINput:=nullStone;
   goWhiteInput.pce:=whiteStone;
   goWhiteInput.x:=xWh.x;
   goWhiteInput.y:=xWh.y;
   goWhiteINput.largestX:=xWh.x;
   goWhiteINput.largestY:=xWh.y;
   setPce(GoWhiteINput);


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
insertPce(goWhiteInput {pce} {goTest.d1[1]},goBoard,stonesGained,stonesLost);
removePce(goResBl,stonesGained);
removePce(goResWh,stonesLost);

writeln2(2,'Stones Gained '+str2(stonesGained.idx) +
   '   Stones Lost '+str2(stonesLost.idx));
addMove(goWhiteInput{goTest.d1[1]},stonesGained,stonesLost,whiteStone,goTest);

update_neural_net(whiteStone,goWhiteInput,pce);

makeBoard;
displayBoard;


   // emulate black
   goBlackInput:=nullStone;
   goBlackInput.pce:=blackStone;
   goBlackInput.x:=xBl.x;
   goBlackInput.y:=xBl.y;
   goBlackInput.largestX:=xBl.x;
   goBlackINput.largestY:=xBl.y;
   setPce(GoBlackInput);

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
insertPce(GoBlackInput {pce}{goTest.d1[1]},goBoard,stonesGained,stonesLost);
removePce(goResWh,stonesGained);
removePce(goResBl,stonesLost);

writeln2(2,'Stones Gained '+str2(stonesGained.idx) +
   '   Stones Lost '+str2(stonesLost.idx));
addMove(GoBlackInput {goTest.d1[1]},stonesGained,stonesLost,blackStone,goTest);

update_neural_net(blackStone,goBlackInput,pce);

makeBoard;
displayBoard;
displayReport(moveCount);
moveCount:=moveCount+1;


   end;
end_learn:writeln(fpNeural1,9999);
writeln(fpNeural2,9999);
close(fpNeural1);
close(fpNeural2);

makeBoard;
displayBoard;
displayReport(moveCount);
end;

procedure emulateMain;
label
  eval_exit;
var
  i:integer;
  stonesLost,stonesGained:captureType;
  goPce:goResource;
  goList:goRecMaster;
  k:integer;
begin
moveCount:=1;
clearBoard(goBoard);

//if completeMode
//then k:=70
//else k:=25;

for i:=1 to simMoves {k}
do begin
   doPause;
   evalModeSim(moveCount);
   makeBoard;
   moveCount:=moveCount+1;
   if (donewhite or doneBlack)
   then goto eval_exit;
   end;

eval_exit:
goPce:=pce1[1];
insertPce(goPce,goBoard,stonesGained,StonesLost);
goPce:=pce1[2];
insertPce(goPce,goBoard,stonesGained,stonesLost);
goPce:=pce1[3];
insertPce(goPce,goBoard,stonesGained,stonesLost);
makeBoard;

if (doneWhite or DoneBlack)
then begin
     writeln2(2,' ');
     writeln2(2,'*** Match Stopped due to lack of options ***');
     writeln2(2,' ');
     end;

goList.idx:=0;
goPce:=nullStone;
stonesLost.idx:=0;
stonesGained.idx:=0;
//addMove(goPce,stonesGained,stonesLost,whiteStone,goList);
//addMove(goPce,stonesGained,stonesLost,blackStone,goList);

makeBoard;
//removeAll;
writeStatus;
displayBoard;
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

procedure main1;
begin
if training_mode
then learnMain
else emulateMain;
end;

initialization

assign(fpNeural1,'neu1white.txt');
rewrite(fpNeural1);

assign(fpNeural2,'neu1black.txt');
rewrite(fpNeural2);

end.

