unit Unit10;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,unit4, jpeg, ExtCtrls,unit3,unit11,unit1;

const
  accountInfo='123-45-6789';
  expireDate='07/17/2104';

type
  TForm10 = class(TForm)
    Label1: TLabel;
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form10: TForm10;

implementation

{$R *.dfm}

procedure TForm10.Button1Click(Sender: TObject);
var
 s1:string;
 datecurrent:TdateTime;
 date2:string;

 found:boolean;
 count:integer;

 function convert1(d1:string):string;
 var
   tmp,yr, mn, day:string;
   k,idx:integer;
 begin
 idx:=1; k:=1;
 idx:=pos('/',d1);
 mn:=copy(d1,k,idx-k);
 d1:=copy(d1,idx+1,10);

 idx:=1; k:=1;
 idx:=pos('/',d1);
 day:=copy(d1,k,idx-k);
 d1:=copy(d1,idx+1,10);

 yr:=copy(d1,1,4);

 if length(mn)=1
 then mn:='0'+mn;
 if length(day)=1
 then day:='0'+day;

 tmp:=yr+'/'+mn+'/'+day;
 convert1:=tmp;
 end;

begin
//okRun:=true;

count:=1;
repeat
  found:=silentDongleCheck;
  count:=count+1;
until found or (count>3);

if not found
then halt(0);

s1:=edit1.Text;
dateCurrent:=date;
date2:=dateTimeToStr(dateCurrent);

if (s1=accountInfo)
then begin
     form10.close;
     if (convert1(date2)<=convert1(expireDate))
     then begin
          CheckForKeylok1Click;
          Application.initialize;
          Application.CreateForm(TForm1, Form1);
          Form1.show;
          end
     else begin
          application.initialize;
          application.createForm(Tform4,form4);
          form4.show;
          end;
     end
else form10.close;
end;


procedure TForm10.Button2Click(Sender: TObject);
begin
form3.close;
end;

end.
