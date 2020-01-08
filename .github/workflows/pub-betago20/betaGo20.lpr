program betaGo20;
//=========================================
// First Full Simulation Match of 70 Moves
// Jan 2, 2020
// Time: 1 hour
//=========================================
// First Successful Test Match
// Dec 31, 2019
// TestModule3
//=========================================
// Static Recode & Compile of All Modules Passed
// Time: 3.5 hours
//       Diana Kanecki
//=========================================
// BetaGo20 - update dec 2019
//   from betaGo6 source (delphi 7)
//-----------------------------------------
// Source Compiler: Lazarus 2.0.2
// Source OS: Windows 10
// Source Computer: Dell Gamer 16 GB, Pentium 7
// Object Compiler: Lazarus 2.0.2
// Object OS: Windows 10
// Object Computer: Dell Gamer 16gb, Pentium 7
//=========================================
{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp, goCore2, godata2,
  testModules2, emulate2,
  { you can add units after this }
  process2;

type

  { TMyApplication }

  TMyApplication = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;

var
 // paramCount2:integer;
 // paramStr2: array[1..32] of string;
  i:integer;

{ TMyApplication }

procedure TMyApplication.DoRun;
var
  ErrorMsg: String;
begin
  // quick check parameters
  ErrorMsg:=CheckOptions('h', 'help');
  if ErrorMsg<>'' then begin
    //ShowException(Exception.Create(ErrorMsg));
    //Terminate;
    //Exit;
  end;

  // parse parameters
  if HasOption('h', 'help') then begin
    WriteHelp;
    Terminate;
    Exit;
  end;

  { add your program here }
  writeln('BetaGo-20 (C) 1983-2019 Diana Kanecki, All Rights Reserved');
  readln;
  writeln('Copying command parms to internal parms');
  paramCount2:=0;
  for i:=2 to paramCount
  do paramStr2[i]:=paramStr(i);
  paramCount2:=paramCount;
  writeln;
  writeln('Number of Parameters: ',paramCount2);
  for i:=2 to paramCount2
  do writeln(i:5,':',paramStr2[i]:20);
  write('Press ENTER to Continue?'); readln;

  if (paramStr(1) ='-test1') or (paramStr(1)='-run1')
  then begin

       case paramStr(1) of
       '-test1': begin
                 addParam('-p0');
                 addParam('-EA');
                 addParam('-Complete');
                 addParam('-S1');
                 process_run_time_options;
                 write('Press ENTER to Continue? ');readln;
                 testModule3;
                 end;
       '-run1':  begin
                 simMoves:=70;
                 writeln('Full Sim Run Move(s)=',SimMoves);
                 write('Press ENTER to Continue? ');readln;

                 addParam('-nolist');
                 addParam('-p0');
                 addParam('-EA');
                 addParam('-Complete');
                 addParam('-S1');
                 process_run_time_options;
                 write('Press ENTER to Continue? ');readln;
                 main1;
                 writeln('END OF SIMULATION');
                 write('Press ENTER to Continue?'); readln;
                 end;

       end; //case
       end;
  // stop program loop
  writeln;
  write('Press ENTER to Exit Program? ');readln;
  Terminate;
end;

constructor TMyApplication.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor TMyApplication.Destroy;
begin
  inherited Destroy;
end;

procedure TMyApplication.WriteHelp;
begin
  { add your help code here }
  writeln('Usage: ', ExeName, ' -h');
end;

var
  Application: TMyApplication;
begin
  Application:=TMyApplication.Create(nil);
  Application.Title:='My Application';
  Application.Run;
  Application.Free;
end.

