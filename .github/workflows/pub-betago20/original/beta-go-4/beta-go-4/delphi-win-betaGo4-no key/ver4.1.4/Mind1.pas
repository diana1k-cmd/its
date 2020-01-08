// ===================================================
// = Modified for DK-GO1 on October 16th, 2003
// = D. Kanecki, Ph.D.
//
// ====================================================
{ Multiple mind/sensation processor for next generation ITS
  Started April 28, 1997 by David H. Kanecki, A.C.S., Bio. Sci.
}

// Do Not use halt --- use division by 0 to stop program gracefully

unit Mind1;
interface
uses SysUtils,goData1, goCore1;
{$Realcompatibility On }
type

  mindRec=record
        number:integer;  { number of entries }
        file_type:array[1..20] of integer;  { 1 - neu1, 2-neu2 }
        num_moves:array[1..20] of integer;
        fname: array[1..20] of string;
        end;
        r_array2= array[1..8] of real;
var
  whnInFp,
  blnInFp: file of r_array2;
  mind_data_white,
  mind_data_black:mindRec;
  fp_set:text;
  mindUsed_white,
  mindUsed_black:integer;
  pctFixWhite,
  pctFixBlack: integer;      { percent fixation of current thought }

  tmpWhite,
  tmpBlack:r_array2;

  fp2:text;
  i:integer;

procedure read_white_neurons2;
procedure read_black_neurons2;
procedure init_white_file;
procedure init_black_file;
procedure halt2;

Implementation

procedure halt3; forward;

procedure halt2;
var
  i:integer;
  fp2:text;
begin
  writeln2(2,'*** HALTING PROGRAM ');
  halt3;
end;

 procedure init_white_file;
var i,j:integer;
begin
for i:=1 to 8
do points_white[i]:=1.0;

assign(fp_set,'ITS5set1.dat');
reset(fp_set);
writeln2(2,'Readin ITS5SET1.DAT ...');
read(fp_set,mind_data_white.number,pctFixWhite);
writeln2(2,'Number of Mind Patterns: '+
           str3(mind_data_white.number,3,0)+
          'Mind Percent Fixation: '+
          str3(pctFixWhite,3,0));
readln(fp_set);
writeln2(2,'Number of memories '+str2(mind_data_white.number));

read(fp_set,i);
j:=1;
while (i<>9999) and (j<=20) and not eof(fp_set)
do begin
   mind_data_white.file_type[j]:=i;
   readln(fp_set,mind_data_white.num_moves[j]);
   readln(fp_set,mind_data_white.fname[j]);

   write2(2,'TYPE '+str3(mind_data_white.file_type[j],3,0));
   write2(2,'#MOVES '+str3(mind_data_white.num_moves[j],3,0));
   writeln2(2,'File Name ='+mind_data_white.fname[j]);
   read(fp_set,i);
   j:=j+1;
   end;
writeln2(2,str2(i));
close(fp_set);
wait;
end;

procedure init_black_file;
var
  i,j:integer;
begin
for i:=1 to 8
do points_black[i]:=1.0;
assign(fp_set,'ITS5set2.dat');
reset(fp_set);
writeln2(2,'Readin ITS5SET2.DAT ...');
read(fp_set,mind_data_black.number,pctFixBlack);
writeln2(2,'Number of Mind Patterns: '+
     str3(mind_data_black.number,3,0)+
          'Mind Percent Fixation: '+str3(pctFixBlack,3,0));
readln(fp_set);
writeln2(2,'Number of memories '+str2(mind_data_black.number));

read(fp_set,i);
j:=1;
while (i<>9999) and (j<=20) and not eof(fp_set)
do begin
   mind_data_black.file_type[j]:=i;
   readln(fp_set,mind_data_black.num_moves[j]);
   readln(fp_set,mind_data_black.fname[j]);

   write2(2,'TYPE '+str3(mind_data_black.file_type[j],3,0));
   write2(2,'#MOVES '+str3(mind_data_black.num_moves[j],3,0));
   writeln2(2,'File Name ='+mind_data_black.fname[j]);
   read(fp_set,i);
   j:=j+1;
   end;
writeln2(2,str2(i));
close(fp_set);
wait;
end;

Function abs2(v:real):real;
var
  temp:real;
begin
if (v>=0.0)
then temp:=v
else temp:=0.0-v;
abs2:=temp;
end;

Function log10(v:real):real;
begin
if (v<0)
 then log10:=-ln(abs2(v))/ln(10)
 else log10:=ln(v)/ln(10);
end;

Function rnd_k(mn,sdev:real):real;
var
 xt, u1,u2,xc1,r:real;
begin
randomize;
xt:=random;
u1:=random;
u2:=random;
xc1:=log10(u1);
xc1:=-2.0*xc1;
xc1:=cos(2*3.1415*u2)*xc1;
r:=xt*xc1*sdev+mn;
rnd_k:=r;
end;


procedure calc_neuron(var points_white:r_array2; sdev:r_array2);
var i:integer;
begin
for i:=1 to 8
do points_white[i]:=rnd_k(points_white[i],sdev[i]);
end;


procedure read_white_file(file_idx:integer;
                           move_count:integer;
                       var points_white:r_array2);
const
  debug1=false;
var
  i,j,k:integer;
  sdev:r_array2;
begin
writeln2(2,'Accesing white on move '+str2(move_count));
if (file_idx>mind_data_white.number) or (move_count>70)
then begin
     writeln2(2,'Error - Invalid Recall Access -White'+
         str2(file_idx)+' '+
                 str2(mind_data_white.number));
     i:=trunc(i/0);
     end
else begin
     i:=mind_data_white.file_type[file_idx];
     writeln2(2,'Reading File ...'+mind_data_white.fname[file_idx]);
     writeln2(2,'Mind Selection = '+str2(i));

     Assign(whnInFp,mind_data_white.fname[file_idx]);
     reset(whnInFp);
     if (i=1)
     then begin
          writeln2(2,'Reading NEU 1 format');
          seek(WhnInFp,move_count-1);
          read(WhnInFp,points_white);
          end
     else begin
          writeln2(2,'Reading NEU 2 format');
          seek(WhnInFp,(move_count-1)*2);
          read(WhnINFP,Points_white);
          read(WhnInFP,Sdev);
          calc_neuron(points_white,Sdev);
          end;
     end;
close(WhnInFp);
if debug1
then readln;
//for i:=1 to 8
//do write2(2,tmpwhite[i]:8:3);
//writeln;
//readln;
end;

procedure read_black_file(file_idx:integer;
                           move_count:integer;
                       var points_black:r_array2);
const
  debug1=false;
var
  i,j,k:integer;
  sdev:r_array2;
begin
writeln2(2,'Accesing black on move '+str2(move_count));
if (file_idx>mind_data_black.number)
then begin
     writeln2(2,'Error - Invalid Recall Access - black'+
        str2(file_idx)+' '+
                str2(mind_data_black.number));
     i:=trunc(i/0);
     end
else begin
     i:=mind_data_black.file_type[file_idx];

     writeln2(2,'Reading File ...'+mind_data_black.fname[file_idx]);
     assign(BlnInFp,mind_data_black.fname[file_idx]);
     reset(BlnInFp);
     if (i=1)
     then begin
          writeln2(2,'Reading NEU 1 format');
          seek(BlnInFp,move_count-1);
          read(BlnInFp,points_black);
          end
     else begin
          writeln2(2,'Reading NEU 2 format');
          seek(BlnInFp,(move_count-1)*2);
          read(BlnINFP,Points_black);
          read(BlnInFP,Sdev);
          calc_neuron(points_black,Sdev);
          end;
     end;
close(BlnInFp);
if debug1
then readln;
//for i:=1 to 8
//do write2(2,points_black[i]:8:3);
//writeln;
//readln;
end;


procedure read_white_neurons2;
var i,j:integer;
begin

j:=random(100);
writeln2(2,'*** RANDOM = '+str2(j));
if (j <=pctFixWhite)
then begin
     read_white_file(1,moveCount,tmpwhite);
     for j:=1 to 8
     do points_white[j]:=tmpWhite[j];
     i:=1;
     MindUsed_white:=i;
     end
else begin
     i:=1+random(Mind_data_white.number*10) div 10;
     writeln2(2,'Random Selection = '+str2(i));
     MindUsed_white:=i;
     read_white_file(i,moveCount,tmpwhite);
     for j:=1 to 8
     do points_white[j]:=tmpwhite[j];
     end;
writeln2(2,'Accessed White Mind Memory '+str2(i));
FOR I:=1 TO 7
    DO write2(2,str3(POINTS_WHITE[I],8,3)+ ' ');
writeln2(2,'');
{wait;}
//readln;
end;

procedure read_black_neurons2;
var i,j:integer;
begin
j:=random(100);
writeln2(2,'*** RANDOM = '+str2(j));
if (j <=pctFixBlack)
then begin
     read_black_file(1,moveCount,tmpblack);
     for j:=1 to 8
     do points_black[j]:=tmpBlack[j];
     i:=1;
     MindUsed_black:=i;
     end
else begin
     i:=1+random(Mind_data_black.number*10) div 10;
     MindUsed_black:=i;
     read_black_file(i,moveCount,tmpblack);
     for j:=1 to 8
     do points_black[j]:=tmpBlack[j];
     end;
writeln2(2,'Accessed Black Mind Memory '+str2(i));
FOR I:=1 TO 7
     DO write2(2,str3(POINTS_black[I],8,3)+ ' ');
writeln2(2,'');
{wait;}
//readln;
end;


procedure halt3;
var
  i,j:integer;
  //fpOut:text;

begin

     {*** Write piece records to file }
writeln2(2,'In Halt2 ');
//readln;

//assign(fpOut,'DkOut2.txt');
assign(fp2,'DKGoOut.dat');
rewrite(fp2);


FOR I:=1 TO 32
DO BEGIN
   if (goResWh.d1[i].pce in [1..6])
   then WITH goResWh.d1[I]
             DO begin
          WRITE(fpOut,i:3,' ',PCE:3,' ',X:3,' ',Y:3,' ');

          if isVisible
          then write(fpOut,1:5)
          else write(fpOut,0:5);
          if (isVip)
          then write(fpOut,1:5)
          else write(fpOut,0:5);

          writeln(fpOut,' ', moleRndFactor:8:3,' ',turnCount:5,' ',availRate:8:3,
                       availSetTime:6);

          WRITE(fp2,i:3,' ',PCE:3,' ',X:3,' ',Y:3,' ');
          {writeln(fp2,isVisible,' ', isVip}
          if isVisible
          then write(fp2,1:5)
          else write(fp2,0:5);
          if (isVip)
          then write(fp2,1:5)
          else write(fp2,0:5);
          writeln(fp2,' ', moleRndFactor:8:3,' ',turnCount:5,' ',availRate:8:3,
               availSetTime:6);
          end;

   if (abs(GoResBl.d1[i].pce) in [1..6])
   then WITH GoResBl.d1[I]
             DO begin
          WRITE(fpOut,i:3,' ',PCE:3,' ',X:3,' ',Y:3,' ');
          {writeln(fp_form,isVisible,' ', isVip,}
          if isVisible
          then write(fpOut,1:5)
          else write(fpOut,0:5);
          if (isVip)
          then write(fpOut,1:5)
          else write(fpOut,0:5);

          writeln(fpOut,' ', moleRndFactor:8:3,' ',turnCount:5,' ',
                   availRate:8:3,' ',availSetTime:6);

          WRITE(fp2,i:3,' ',PCE:3,' ',X:3,' ',Y:3);
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
WRITELN(FPOut,'9999   End of Version DKGO1 File');
WRITELN(FP2,'9999   End of Version D File');

{*** write white and black game and neural data to file}
writeln(fpOut,'White status ');
writeln(fp2,'White status ');
for i:=1 to 8
do begin
   write(FPOut,points_white[i]:8:3,' ');
   write(FP2,points_white[i]:8:3,' ');
   end;
writeln(fpOut);
writeln(fpOut,w_check_count,' ',w_protect_count,' ',w_retreat_count,
        ' ',w_capture_count);
writeln(fpOut,'Black Status ');
writeln(fp2);
writeln(fp2,w_check_count,' ',w_protect_count,' ',w_retreat_count,
        ' ',w_capture_count);
writeln(fp2,'Black Status ');
for i:=1 to 8
do begin
   write(FPOut,points_black[i]:8:3,' ');
   write(FP2,points_black[i]:8:3,' ');
   end;
writeln(fpOut);
writeln(fpOut,b_check_count,' ',b_protect_count,' ',b_retreat_count,
      ' ',b_capture_count);
writeln(fp2);
writeln(fp2,b_check_count,' ',b_protect_count,' ',b_retreat_count,
      ' ',b_capture_count);

{*** Close file }
//CLOSE(FPOut);
close(fp2);
{*** Stop program}

writeln2(2,'*** CLOSING OUTPUT FILES ***');
end;

initialization
        randomize;
        mind_data_white.number:=0;
        mind_data_black.number:=0;
        pctFixWhite:=100;
        pctFixBlack:=100;
finalization
//halt3;

end.