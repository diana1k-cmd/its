unit Unit1;
// ==========================================
// Started to add traing move, passed first test of
// of inserting stones and processing options
// need to implement comparePce, updateNeuralNet,
// and writeNeural to produce to neural (NEU-1)
// output files.
//
// input file: goInput1.dat
// -----------------------------------------
// November 18th, 2003
//


//==============================
// Milestone 11 Completed
//   MakeMove with Protection and Random Move
//
// ------------------------------------
// October 27th, 2003
// By Dr. David Kanecki, Ph.D., A.C.S., Bio. Sci.
//
//
// =============================
// Milestone 10 Completed
// Full 10 move game using ITS - October 11th, 2003
//
// Needed to add traverseList data and routines to safe(), safeCount()
//   to avoid self referencing in later stages of match
//
// =============================
// Milestone 8 / 9 Completed
//
// September 24th, 2003 time 2 hours
// completed setup situation, evaluate, insert/removal and
//   correct board display ( i.e. full move cycle )
//
// =============================
// Milestone 7 Completed
// Sequence of w(1,2), b(1,1), and w(2,1) causes b(1,1) to be captured at
//    move 2 start: w(2,1) which is correct
// Time: 1.5 hours
//
// =============================
// Milestone 6 Completed
// InsertPce works for w(1,2) and b(1,1)
// September 5, 2003, time 1 hours by d. kanecki, a.c.s., bio. sci.
//
//
// ===========================
// Milestone 5 Completed
// SetPce, WritePce, GetAlt, boardArea, opptSize
// August 28, 2003
// Time: 3 hours - D. Kanecki, A.C.S., Bio. Sci.
//
// ===========================
// Milestone 4 Completed
// bool safe(...), int groupList(...), mkGroup2(...),
//     mkGroupList(...), add2(...) and others completed
//
// ---------------------------
// (C) 2003 by D. Kanecki, A.C.S., Bio. Sci.
// Go Using ITS Methodology
// August 18th, 2003 - Milsteone 4 completed
// Started August 11, 2003 by D. Kanecki
// ===========================
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, StdCtrls, jpeg, ExtCtrls, goData1,goCore1, goEval,
  testModules, process, mind1, mind1b, emulate{, goMove};

type
  TForm1 = class(TForm)
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    RadioGroup3: TRadioGroup;
    RadioGroup4: TRadioGroup;
    RadioGroup5: TRadioGroup;
    Image1: TImage;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  public
    procedure Member1;
  end;
  
var
  Form1: TForm1;
  state2:integer;
  Thread:integer;
  Id:Cardinal;

implementation

{$R *.dfm}

{
************************************ TForm1 ************************************
}
procedure TForm1.Button1Click(Sender: TObject);
begin
  writeln2(2,' ');
  writeln2(2,'==== Parameter List ====');
  
  continuousForm:=checkBox8.checked;
  alQuedaModePurple:=checkbox9.checked;
  
  if checkBox7.checked
  then begin
       writeln2(2,'-BEST  Best Option Selected');
       addParam('-BEST');
       end;
  if checkBox1.Checked
  then begin
       writeln2(2,'-T Training Mode Selected');
       addParam('-t');
       end;
  
  if checkBox2.checked
  then begin
       writeln2(2,'-RS Read Setup Mode Selected');
       addParam('-rs');
       end;
  
  if checkBox3.checked
  then begin
       writeln2(2,'-RIF Read Invalid Move File Selected');
       addParam('-rif');
       end;
  
  if checkBox4.checked
  then begin
       writeln2(2,'-AlQ Al Queda Mode Selected');
       addParam('-alq');
       end;
  
  if checkBox5.checked
  then begin
       writeln2(2,'-ALQ 1 - Al Queda White Only Mode ');
       addParam('-alq1');
       end;
  
  if checkBox6.Checked
  then begin
       writeln2(2,'-ALQ 2 - Al Queda Black Only Mode');
       addParam('-alq2');
       end;
  
  case radioGroup1.ItemIndex of
          0: begin writeln2(2,'EM Mode: EW1 Selected'); addParam('-ew'); end;
          1: begin writeln2(2,'EM Mode: EB1 Selected'); addParam('-eb'); end;
          2: begin writeln2(2,'EM Mode: EA1 Selected'); addParam('-ea'); end;
          3: begin writeln2(2,'EM Mode: EW2 Selected'); addParam('-ew2'); end;
          4: begin writeln2(2,'EM Mode: EB2 Selected'); addParam('-eb2'); end;
          5: begin writeln2(2,'EM Mode: EA2 Selected'); addParam('-ea2'); end;
          6: begin writeln2(2,'EM Mode: None Selected'); end;
          else begin writeln2(2,'EM Mode(B): -EA1 Selected'); addParam('-ea1'); end;
          end; { case }
  
  case radioGroup2.ItemIndex of
          0: begin writeln2(2,'Play Mode: -p0'); addParam('-p0'); end;
          1: begin writeln2(2,'Play Mode: -p1'); addParam('-p1'); end;
          2: begin writeln2(2,'Play Mode: -p2'); addParam('-p2'); end;
          else begin writeln2(2,'Play Mode(B): -p0 '); addParam('-p0'); end;
          end; { case }
  
  case radioGroup3.ItemIndex of
          0: begin writeln2(2,'Strategy Mode: -S1  First Capture');
                      addParam('-s1'); end;
          1: begin writeln2(2,'Strategy Mode: -S2  Traditional');
                      addParam('-s2'); end;
          else begin writeln2(2,'Strategy Mode: -S2 Traditional');
                      addParam('-s2'); end;
          end; { case }
  
  case radioGroup4.ItemIndex of
           0: begin writeln2(2,'Eval Method: Cellular -cell');
                        addParam('-cell'); end;
           1: begin writeln2(2,'Eval Method: Complete -complete');
                        addParam('-complete'); end;
           2: begin writeln2(2,'Eval Method: Complete -complete2');
                        completeMode:=false;
                        completeMode2:=true;
                        addParam('-complete2'); end;
           3: begin writeln2(2,'Eval Mode: Cellular 9 ');
                    maxX:=9; maxY:=9;
                    completeMode:=false; completeMode2:=false; cellularMode:=false;
                    cellularMode2:=true;
                    end;
           else
              begin writeln2(2,'Eval Method: Complete -complete');
                        addParam('-complete'); end;
           end; { case }
  
  case radioGroup5.ItemIndex of
           0: simMoves:=10;
           1: simMoves:=25;
           2: simMoves:=70;
           else simMoves:=70;
           end; { case }
  
  
  //processParameters;
  process_run_time_options;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if (state2=1)
  then begin
          Thread:=BeginThread(nil,0,@Main1,nil,0,id);
          state2:=2;
          status:=running;
       end
  else begin
       paused:=not paused;
       if paused
       then status:=paused2
       else status:=Running;
       end;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  i: Integer;
  goTest: goRecMaster;
  tl2: glist;
begin
  //testModule1
  //testModule2;
  testModule3;
  
  //testModule4;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  enterWait:=false;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  output1[1]:=pointer(Memo1);
  output1[2]:=pointer(Memo2);
  output2[3]:=pointer(Edit1);
  output2[4]:=pointer(Edit2);
  output2[5]:=pointer(Edit3);
  output2[6]:=pointer(Edit4);
  output2[7]:=pointer(Edit5);
  output2[8]:=pointer(Edit6);
  output2[9]:=pointer(Edit7);
  output2[10]:=pointer(edit8);
  output2[11]:=pointer(edit9);
end;

procedure TForm1.Member1;
begin
end;

initialization
  state2:=1;
  status:=suspended;

end.
