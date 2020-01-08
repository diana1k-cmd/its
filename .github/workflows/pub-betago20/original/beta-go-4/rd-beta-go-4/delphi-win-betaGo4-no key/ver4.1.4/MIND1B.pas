unit mind1b;
interface
{$Realcompatibility On }
uses goData1, goCore1;

procedure setNeuralFile(nFileOpt:integer;var wfp2:text; var bfp2:text);
procedure read_white_neurons1(var wfp2:text; var NeuralEof:boolean);
procedure read_black_neurons1(var bfp2:text; var NeuralEof:boolean);


implementation

Procedure setNeuralFile(nFileOpt:integer;
           var wfp2:text; var bfp2:text);
begin
if (nFileOpt=1) or (nFileOpt=3)
then begin
     assign(wfp2,'wneuron1.dat');
     reset(wfp2);
     end;
if (nFileOpt=2) or (nFileOpt=3)
then begin
     assign(bfp2,'bneuron1.dat');
     reset(bfp2);
     end;
end;

procedure read_white_neurons1(var wfp2:text; var NeuralEof:boolean);
var i:integer;
begin
writeln2(2,'*** READING WHITE NEU-1');
if not eof(wfp2)
then begin
     for i:=1 to 7
     do begin
        read(wfp2,points_white[i]);
        write2(2,str3(points_white[i],7,3)+' ');
        //if (i mod 3)=0 then writeln2(2,'');
        end;
     writeln2(2,'');
     readln(wfp2);
     readln(wfp2);
     points_white[8]:=0.0;
     end
else NeuralEof:=true;
end;

procedure read_black_neurons1(var bfp2:text; var NeuralEof:boolean);
var i:integer;
begin
writeln2(2,'*** READING BLACK NEU-1');
if not eof(bfp2)
then begin
     for i:=1 to 7
     do begin
        read(bfp2,points_black[i]);
        write2(2,str3(points_black[i],7,3)+' ');
        //if (i mod 3)=0 then writeln2(2,'');
        end;
     writeln2(2,'');
     readln(bfp2);
     readln(bfp2);
     points_black[8]:=0.0;
     end
else NeuralEOF:=true;
end;


end.
