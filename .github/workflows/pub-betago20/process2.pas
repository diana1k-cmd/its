unit process2;


interface

uses goData2, goCore2,mind1,mind1b;

var
  rdWhiteOpt,
  rdBlackOPt:integer;
  NeuralEof:boolean;

  fpNw,bfp2:text;
  invalsq:text;

  ExitSave:pointer;
  Ch:char;

  training_mode:boolean;
  MoveFileEOF:boolean;
  LookAhead:integer;
  simulation_mode:boolean;
  player3:integer;
  player:integer;
  emulate_mode:boolean;
  emulate_black:boolean;
  emulate_white:boolean;
  emulate_all:boolean;

  cellularMode2:boolean;
  cellularMode:boolean;
  completeMode:boolean;
  completeMode2:boolean;
  firstCaptureMode:boolean;
  traditionalMode:boolean;

  paused:boolean;

  alQuedaMode2:boolean;

  bestOption:boolean;

procedure processParameters;
Procedure process_run_time_options;
//Procedure main;
//Procedure main2;
procedure read_white_neurons;
procedure read_black_neurons;
procedure doPause;

implementation



Procedure ClrScr2;
begin
//ClrScr;
end;

Procedure ClrScr;
begin
end;


procedure readSetup;
var
  i,j,idx,pce,lineNo:integer;
  //fpOut:text;
  fp2:text;
begin

     {*** Write piece records to file }
writeln2(2,'*** In Read Setup ');
//readln;
lineNo:=1;
//assign(fpOut,'DkOut2.txt');
assign(fp2,'DKGoOut.dat');
reset(fp2);

read(fp2,idx);
write2(2,str2(idx)+' ');

while (idx<>9999) and not eof(fp2)
DO BEGIN
   read(fp2,pce);
   writeln2(2,'Processing Line No: '+str2(LineNo)+' Pce: '+str2(pce)+
       ' Idx: '+str2(idx));

   case pce of
   1: begin
      goResWh.d1[idx]:=nullStone;
      goResWh.idx:=goResWh.idx+1;
      goResWh.d1[idx].pce:=pce;
      WITH goResWh.d1[idx]
             DO begin
                read(fp2,X,Y);
                read(fp2,i);
                isVisible:=i=1;

                read(fp2,i);
                isVip:=i=1;

                readln(fp2, moleRndFactor,turnCount,availRate,availSetTime);
                end;
      end;
   -1: begin
      goResBl.d1[idx]:=nullStone;
      goResBl.idx:=goResBl.idx+1;
      goResBl.d1[idx].pce:=pce;
      WITH goResBl.d1[idx]
             DO begin
                read(fp2,X,Y);
                read(fp2,i);
                isVisible:=i=1;

                read(fp2,i);
                isVip:=i=1;

                readln(fp2, moleRndFactor,turnCount,availRate,availSetTime);
                end;
       end
       else;
       END; { case }
       lineNo:=lineNo+1;
       read(fp2,idx);
       write2(2,str2(idx)+' ');
   end;

{*** Write piece terminator record}
readln(FP2);

{*** write white and black game and neural data to file}
readln(fp2);
for i:=1 to 8
do begin
   read(FP2,points_white[i]);
   end;
readln(fp2);
readln(fp2,w_check_count,w_protect_count,w_retreat_count,w_capture_count);

readln(fp2);
for i:=1 to 8
do begin
   read(FP2,points_black[i]);
   end;
readln(fp2);
readln(fp2,b_check_count,b_protect_count,b_retreat_count,b_capture_count);

{*** Close file }
//CLOSE(FPOut);
close(fp2);
{*** Stop program}

end;


procedure read_white_neurons;
begin
if (rdWhiteOpt=2)
then read_white_neurons2
else if not neuralEof
     then read_white_neurons1(fpNw,neuralEof);
end;

procedure read_black_neurons;
begin
if (rdBlackOpt=2)
then read_black_neurons2
else if not neuralEof
     then read_black_neurons1(bfp2, NeuralEof);
end;




procedure setup1;
// read setup for dk go its
begin
end;

procedure setUpFile;
// read file for training data
begin
end;

procedure modifyNeuralSetup;
// change neural setup via dialog
begin
end;



function boolStr(x:boolean):string;
begin
if (x)
then boolStr:='True  '
else boolStr:='False ';
end;


Procedure process_run_time_options;
var
  cmd1,cmd2:string[80];
  x,y,line,j:integer;
  i:integer;
begin
writeln2(2,' ');
writeln2(2,'*** Processing Setup Parameters ***');
writeln2(2,' ');

paused:=false;
rdWhiteOpt:=2;
rdBlackOpt:=2;
neuralEof:=false;

 FOR i := 1 TO 13
 DO FOR j := 1 TO 13
    DO begin
       goBoard[i,j] := 0;
       invalid_block[i,j]:=false;
       end;
 //setBoard;

 training_mode:=false;
 MoveFileEOF:=false;
 LookAhead:=0;
 simulation_mode:=false;
 player3:=2;
 player:=2;
 emulate_mode:=false;
 emulate_black:=false;
 emulate_white:=false;
 emulate_all:=false;
 neuralEof:=false;

 cellularMode:=false;
 completeMode:=true;
 completeMode2:=false;
 firstCaptureMode:=false;
 traditionalMode:=true;
 bestOption:=false;

for i:=1 to ParamCount2
do begin
   cmd2:=paramStr2[i];
   for j:=1 to length(cmd2)
   do cmd2[j]:=upcase(cmd2[j]);
   if (cmd2[1]='-')
   then if (cmd2='-NOLIST') then begin
        writeln('Setting LIST GROUP OFF');
        noList:=true;
        end
   else if (cmd2='-NODELAY') then begin
        writeln('Setting DELAY OFF');
        noDelay:=true;
        end
   else if (cmd2='-ALQ') then begin
        writeln2(2,'Tactic Mode All : Al Queda Selected');
        alQuedaMode:=true;
        alQuedaModeWhite:=true;
        alQuedaModeBlack:=true;
        end
   else if (cmd2='-ALQ1') then begin
        writeln2(2,'Tactic Mode White: Al Queda Selected');
        alQuedaModeWhite:=true;
        end
   else if (cmd2='ALQ2') then begin
        writeln2(2,'Tactic Mode Black: Al Queda Selected');
        alQuedaModeBlack:=true;
        end
   else if (cmd2 = '-CELL') then begin
        writeln2(2,'Evaluation Mode: Cellular ');
        cellularMode:=true;
        completeMode:=false;
        completeMode2:=false;
        maxX:=6; maxY:=6;
        end
   else if (cmd2='-COMPLETE') then begin
        writeln2(2,'Evaluation Mode: 19 x 19');
        completeMode:=true;
        completeMode2:=false;
        cellularMode:=false;
        maxX:=19; maxY:=19;
        end
   else if (cmd2='-COMPLETE2') then begin
        completeMode:=false;
        completeMode2:=true;
        cellularMode:=false;
        maxX:=13; maxY:=13;
        writeln2(2,'Evaluation Mode: 13 by 13 ');
        end
   else if (cmd2='-BEST') then begin
        writeln2(2,'Best Option Mode Selected');
        bestOption:=true;
        end
   else if (cmd2='-S1') then begin
        writeln2(2,'Strategy Mode: First Capture');
        firstCaptureMode:=true;
        traditionalMode:=false;
        end
   else if (cmd2='-S2') then begin
        writeln2(2,'Strategy Mode: Traditional');
        traditionalMode:=true;
        firstCaptureMode:=false;
        end
   else if (cmd2 = '-RS') then begin
         //writeln2(2,'*** In Read Setup ');
         //wait5000;
              {*** Acquire run time options }
              {*** * If 1 then do setup 1 }
              Setup1;
              readSetup;
              makeBoard;
              displayBoard;
         end
   else if ((cmd2 ='-P0') or (cmd2 ='-P1') or (cmd2='-P2')) then begin
         write2(2,'*** In player mode: ');
         cmd1:=paramStr2[i];
         player3:=ord(cmd1[3])-ord('0');
         player:=player3;
         writeln2(2,str2(player3));
         {readln;}
         if (player3=0)
         then simulation_mode:=true
         else simulation_mode:=false;
         end
   else  if (cmd2 ='-T') then  begin
         writeln2(2,'*** In Training mode ');
         writeln2(2,' ');
         MoveFileEOF:=false;
         training_mode:=true;
         setUpFile;
         end
   else  if (cmd2='-CN') then begin
         writeln2(2,'*** in Modify Neural mode');
         //readln;
         modifyNeuralSetup;
         end
   else  if (cmd2='-LK') then begin
         write2(2,'How Many LookAhead levels ?');
         readln(LookAHead);
         end
   else  if (cmd2='-SET') then begin
         writeln2(2,'*** SET Mode');

         if (player3=0) and simulation_mode
         then writeln2(2,'Simulation mode SET')
         else if (training_mode) then writeln(2,'Training mode SET')
              else begin
                   writeln2(2,'Normal mode SET, Opponent plays ');
                   if (player3=whiteStone) then      writeln2(2,' White')
                   else if (player3=blackStone) then writeln2(2,' Black')
                                           else writeln2(2,' Self');
                   end;
         writeln2(2,'Lookahead level at '+str2(lookAhead));
         //readln;
         end
   else  if (cmd2 = '-EA') then begin
         writeln2(2,'*** Emulate All 1 Mode');
         emulate_all:=true;
         emulate_mode:=true;
         emulate_white:=true;
         emulate_black:=true;
         rdWhiteOpt:=1;
         rdBlackOpt:=1;
         setNeuralFile(3,fpNW,bfp2);
         end
   else  if (cmd2 = '-EW') then begin
         writeln2(2,'*** Emulate White 1 Mode');
         emulate_white:=true;
         emulate_mode:=true;
         rdWhiteOpt:=1;
         setNeuralFile(1,fpNW,bfp2);
         end
   else  if (cmd2 = '-EB') then begin
         writeln2(2,'*** Emulate Black 1 Mode');
         emulate_black:=true;
         emulate_mode:=true;
         rdBlackOpt:=1;
         setNeuralFile(2,fpNW,bfp2);
         end
   else  if (cmd2 = '-EA2') then begin
         writeln2(2,'*** Emulate All Mode 2');
         emulate_all:=true;
         emulate_mode:=true;
         emulate_white:=true;
         emulate_black:=true;
         rdWhiteOpt:=2;
         rdBlackOpt:=2;
         init_white_file;
         init_black_file;
         end
   else  if (cmd2= '-EW2')  then begin
         writeln2(2,'*** Emulate White 2 Mode');
         rdWhiteOpt:=2;
         emulate_white:=true;
         emulate_mode:=true;
         init_white_file;
         end
   else  if (cmd2= '-EB2') then begin
         writeln2(2,'*** Emulate Black 2 Mode');
         rdBlackOpt:=2;
         emulate_black:=true;
         emulate_mode:=true;
         init_black_file;
         end
   else  if (cmd2='-H') then begin
         writeln2(2,'*** Help Mode');
         writeln2(2,'          Default Settings');
         writeln2(2,'Normal Mode, Opponent plays '+str2(player3)+' Lookahead at '+str2(lookahead));
         writeln2(2,'-RS    Read Set Up ');
         writeln2(2,'-P0, -P1, -P2   Simulation mode, opponent plays white, opponent plays black');
         writeln2(2,'-T     Train program ');
         writeln2(2,'-CN    Change neural settings ');
         writeln2(2,'-LK    Set lookahead level ');
         writeln2(2,'-SET   Display current settings ');
         writeln2(2,'-H     Display command explanations ');
         writeln2(2,'-EW2   Emulate White Move');
         writeln2(2,'-EB2   Emulate Black Move');
         writeln2(2,'-EA2   Emulate both white and Black Move');
         writeln2(2,'-EA    Emulate All NEU -1 ');
         writeln2(2,'-EW    Emulate White NEU -1');
         writeln2(2,'-EB    Emulate Black NEU -2');
         writeln2(2,'-RIF   Read invalid square file');
         //readln;
         //halt;
         system.Exit;
         end
   else  if (cmd2= '-RIF') then begin
         writeln2(2,'*** Read Invalid File Mode');
         assign(invalsq,'invalid.dat');
         reset(invalsq);
         read(invalsq,x);
         line:=1;
         while (x<> 9999) and not eof(invalsq)
         do begin
            readln(invalsq,y);
            writeln2(2,'Invalid block Selected '+chr(x+ord('A')-1)+str2(y));
            if valid(x,y)
            then invalid_block[x,y]:=true
            else writeln2(2,'Line: '+str2(line)+' has invalid coordinates');
            line:=line+1;
            read(invalsq,x);
            end;
         end;
   end;
emulate_all:=emulate_white and emulate_black;
writeln2(2,'Emulate All Status: '+boolStr(emulate_all)+':'+
     boolStr(emulate_white)+':'+boolStr(emulate_black));
wait;
end;

procedure writeSetup1;
var
  i:integer;
  fp2:text;

begin
{*** Write piece records to file }
write2(2,'In writeSetup1 ...');
//readln;

assign(fp2,'chessOut.dat');
rewrite(fp2);


FOR I:=1 TO 32
DO BEGIN
   if (goResWh.d1[i].pce in [1..6])
   then WITH goResWh.d1[I]
             DO begin
                WRITE(fp2,i:3,' ',PCE:3,' ',X:3,' ',Y:3,' ');
                {writeln(fp2,isVisible,' ', isVip}
                if isVisible
                        then write(fp2,1:5)
                        else write(fp2,0:5);
                if (isVip)
                        then write(fp2,1:5)
                else write(fp2,0:5);
                writeln(fp2,' ', moleRndFactor:8:3,' ',turnCount:5,' ',
                        availRate:8:3,availSetTime:6);
          end;

   if (abs(goResBl.d1[i].pce) in [1..6])
   then WITH goResBl.d1[I]
             DO begin
                WRITE(fp2,i:3,' ',PCE:3,' ',X:3,' ',Y:3,' ');
                {writeln(fp2,isVisible,' ', isVip,}
                if isVisible
                        then write(fp2,1:5)
                        else write(fp2,0:5);
                if (isVip)
                then write(fp2,1:5)
                else write(fp2,0:5);
                writeln(fp2,' ', moleRndFactor:8:3,' ',turnCount:5,' ',
                        availRate:8:3,availSetTime:6);
             end;
   END;

{*** Write piece terminator record}
WRITELN(FP2,'9999   End of Version D File');

{*** write white and black game and neural data to file}
writeln(fp2,'White status ');
for i:=1 to 8
do begin
   write(FP2,points_white[i]:8:3,' ');
   end;

writeln(fp2);
writeln(fp2,w_check_count,' ',w_protect_count,' ',w_retreat_count,
        ' ',w_capture_count);
writeln(fp2,'Black Status ');
for i:=1 to 8
do begin
   write(FP2,points_black[i]:8:3,' ');
   end;

writeln(fp2);
writeln(fp2,b_check_count,' ',b_protect_count,' ',b_retreat_count,
      ' ',b_capture_count);

{*** Close file }
close(fp2);
{*** Stop program}

writeln2(2,'*** Completed ***');
writeln2(2,' ');
wait;
end;

procedure doPause;
begin
if (paused)
then begin
     writeln2(2,' ');
     writeln2(2,'*** Current Thread is Paused ');
     writeln2(2,' ');
     end;

while (paused)
  do;   // busy wait
end;

Procedure main2;
var i:integer;
BEGIN
{


assign(fp_form,'test.out');
rewrite(fp_form);
writeSetup1;

ClrScr2;
InitWindows;

pceConst:=0;
debug4:=false;
DEBUG5:=FALSE;


Writeln2('Kanecki ITS55 by Dr. David H. Kanecki (C) 1983 - *2002');

FIRST_MOVE:=TRUE;
INFO_WANTED:=TRUE;
Move_count:=1;
PceOpptx:=0;
move_made:=1;
Randomize;


SetWindow3;
ClrScr;
Title;


ClrScr;
SetWindow1;

lastX:=9999;
lastY:=9999;
lastIdx:=9999;
res1g:=res1;
res2g:=res2;
px2:=res1[12].x2;
py2:=res1[12].y2;
for i:=1 to 32
do begin
   res1[i].pceSafe:=true;
   res2[i].pceSafe:=true;
   end;



if not (training_mode or simulation_mode)
then begin
     write('Enter 9999 to stop ');
     readln(istop);
     end
else istop:=0;

SET_UP_FILE;



writeSetup1;

while (istop<>9999) and not MoveFileEOF
do begin


   doPause;

   px2:=res1[12].x2;
   py2:=res1[12].y2;
   qx2:=res2[12].x2;
   qy2:=res2[12].y2;


   IF (NOT TRAINING_MODE or emulate_mode)
   THEN Do_moves(LookAhead,Player3)
   ELSE DO_MOVES_TRAINING(LookAHead);


   Move_count:=Move_count+1;


   if not training_mode and not simulation_mode
   then begin
        Write('Enter 9999 to stop');
        readln(istop);
        end;
   res1g:=res1;
   res2g:=res2;
   flush(fp_form);
   writeSetup1;
   end;

}
END;

Procedure main;
var i:integer;
BEGIN
{

assign(fp_form,'test.out');
rewrite(fp_form);
writeSetup1;


ClrScr2;
InitWindows;

pceConst:=0;
debug4:=false;
DEBUG5:=FALSE;

Writeln2('     Kanecki ITS55 by Dr. David H. Kanecki (C) 1983 - *2002');

FIRST_MOVE:=TRUE;
INFO_WANTED:=TRUE;
Move_count:=1;
PceOpptx:=0;
move_made:=1;
Randomize;

SetWindow3;
ClrScr;
Title;




ClrScr;
SetWindow1;

process_run_time_options;

lastX:=9999;
lastY:=9999;
lastIdx:=9999;
res1g:=res1;
res2g:=res2;
px2:=res1[12].x2;
py2:=res1[12].y2;
for i:=1 to 32
do begin
   res1[i].pceSafe:=true;
   res2[i].pceSafe:=true;
   end;


if not (training_mode or simulation_mode)
then begin
     write('Enter 9999 to stop ');
     readln(istop);
     end
else istop:=0;

SET_UP_FILE;



writeSetup1;

while (istop<>9999) and not MoveFileEOF
do begin


   px2:=res1[12].x2;
   py2:=res1[12].y2;
   qx2:=res2[12].x2;
   qy2:=res2[12].y2;

   IF (NOT TRAINING_MODE or emulate_mode)
   THEN Do_moves(LookAhead,Player3)
   ELSE DO_MOVES_TRAINING(LookAHead);

   Move_count:=Move_count+1;

   if not training_mode and not simulation_mode
   then begin
        Write('Enter 9999 to stop');
        readln(istop);
        end;
   res1g:=res1;
   res2g:=res2;
   flush(fp_form);
   writeSetup1;
   end;
}
END;



procedure processParameters;
var
  i:integer;
begin
writeln2(2,' ');
for i:=1 to ParamCount2
do writeln2(2,'Parameter '+str2(i)+'::'+paramStr2[i]);

end;

initialization

training_mode:=false;
  MoveFileEOF:=false;
  LookAhead:=0;
  simulation_mode:=true;
  player3:=0;
  player:=0;
  emulate_mode:=true;
  emulate_black:=true;
  emulate_white:=true;
  emulate_all:=true;

  cellularMode:=true;
  completeMode:=false;
  completeMode2:=false;
  cellularMode2:=false;
  firstCaptureMode:=false;
  traditionalMode:=true;

  paused:=false;
  alQuedaMode2:=false;

end.
