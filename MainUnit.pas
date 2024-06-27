{
Written by Xu Ganquan
gqxunet@163.com
http://www.AdvNetsoft.com
2002.12.16
modify2004-3-15

}
unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, ComCtrls, ExtCtrls;

type
  TMainForm = class(TForm)
    Player1Control_DrawGrid: TDrawGrid;
    Start_bn: TButton;
    Exit_bn: TButton;
    Player2Control_DrawGrid: TDrawGrid;
    RichEdit1: TRichEdit;
    RichEdit2: TRichEdit;
    RB1: TRadioButton;
    RB2: TRadioButton;
    RB3: TRadioButton;
    RB5: TRadioButton;
    rb4: TRadioButton;
    PCvsPCTimer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Player1Control_DrawGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure Player1Control_DrawGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure Start_bnClick(Sender: TObject);
    procedure Exit_bnClick(Sender: TObject);
    procedure Player2Control_DrawGridDrawCell(Sender: TObject; ACol,
      ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure RB1Click(Sender: TObject);
    procedure RB2Click(Sender: TObject);
    procedure RB3Click(Sender: TObject);
    procedure rb4Click(Sender: TObject);
    procedure RB5Click(Sender: TObject);
    procedure Player2Control_DrawGridSelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure PCvsPCTimerTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Procedure InitSetup(IsPlayer1:boolean;ishuman:boolean);
    procedure ComputerMove(IsPlayer1:boolean;out Sx:integer;out Sy:integer);
    function PlayerMove(IsPlayer1:boolean;IsHuman:boolean;theX,theY:integer):boolean;
    procedure CheckWin(IsPlayer1:boolean;IsHuman:boolean;theshipIndex:integer);
    Procedure DisplayInfo(theMsg:String;IsPlayer1:boolean;IsHuman:boolean;infotype:integer;theColor:Tcolor);
    function BeginNewGame:boolean;
   // Procedure computermove;
  end;
 {
Written by Xu Ganquan
gqxunet@163.com
http://www.advnetsoft.com
2002.12.16
modify2004-3-15

}
var
  MainForm: TMainForm;
  
type  TShip=record
    Name:string[25];
    shipLength:integer;
    liveparts:array[1..2,1..5] of integer;
    deadparts:array[1..2,1..5] of integer;
end;

const  GridX=16;    GridY=16;
       PicNum=20;   ShipTypeNum=4;
       MaxShipNum=11;
const ship:array[1..ShipTypeNum] of TShip=
 (  ( Name:'…®¿◊Õß';shipLength:2;
      liveparts:((1,5,0,0,0),(6,10,0,0,0));
      deadparts:((15,17,0,0,0),(18,20,0,0,0))
     ),

    ( Name:'ª§Œ¿Ω¢';shipLength:3;
      liveparts:((1,2,5,0,0),(6,7,10,0,0));
      deadparts:((15,16,17,0,0),(18,19,20,0,0))
    ),


    ( Name:'—≤—ÛΩ¢';shipLength:4;
      liveparts:((1,2,3,5,0),(6,7,8,10,0));
      deadparts:((15,16,16,17,0),(18,19,19,20,0))
    ),

    ( Name:'∫Ωø’ƒ∏Ω¢';shipLength:5;
     liveparts:((1,2,3,4,5),(6,7,8,9,10));
     deadparts:((15,16,16,16,17),(18,19,19,19,20))
    )
 );
const shipNum:array [1..ShipTypeNum] of integer=(4,4,2,1);
const idlist:array[1..PicNum] of integer=(1,2,3,4,5,6,7,8,9,10,100,101,102,103,201,202,203,204,205,206);
var   Player1ControlGrid,Player2ControlGrid:array[1..GridX,1..GridY,1..4]of integer;
 ///[x][y][1] Real_Status  [x][y][2]Display_Now_status  [x][y][3]Display_dead_status
 /////[4] the index of  the XXXshiplives

type TShipLists=record
 Name:string[25];
 Lives:integer;
end;

var   Player1ShipLists,Player2ShipLists:array[1..MaxShipNum] of TShipLists;
      Player1AllLives:integer = 0;
      Player2AllLives:integer = 0;
      ShipPic:array[1..PicNum] of TBitmap;
      MsgNewGame,canplay1,canplay2:boolean;
      GameMode:integer;

implementation

{$R *.dfm}
{$R ships.res}

procedure TmainForm.DisplayInfo(theMsg:String;IsPlayer1:boolean;IsHuman:boolean;infotype:integer;theColor:Tcolor);
begin
if IsPlayer1 then
with RichEdit1 do
begin
Font.Color:=theColor;
if infotype=1 then clear;
Lines.Add(theMsg);
end else
with RichEdit2 do
begin
Font.Color:=theColor;
if infotype=1 then clear;
Lines.Add(theMsg);
end; 
end;

procedure TmainForm.CheckWin(IsPlayer1:boolean;IsHuman:boolean;theshipIndex:integer);
var I,j:Integer;
begin
 if isplayer1 and ishuman then
 begin
 //////////////////
  if Player1ShipLists[theshipIndex].Lives=0 then
    begin
      for i:=1 to GridX do
       for j:= 1 to GridY do
      begin
      if Player1ControlGrid[i][j][4]=theshipIndex then
      Player1ControlGrid[i][j][2]:=Player1ControlGrid[i][j][3];
      end;
    DisplayInfo('Kill '+Player1ShipLists[theshipIndex].Name,true,true,1,clblue);
    end;
   if Player1AllLives=0 then  DisplayInfo('Win',true,true,1,clred);
  /////////////////////////////////////////////////////////////////////
 end;

  if (not isplayer1) and (not ishuman) then
 begin
 //////////////////////////////////////////////////////////////////
     if Player2ShipLists[theshipIndex].Lives=0 then
    begin
      for i:=1 to GridX do
       for j:= 1 to GridY do
      begin
      if Player2ControlGrid[i][j][4]=theshipIndex then
      Player2ControlGrid[i][j][2]:=Player2ControlGrid[i][j][3];
      end;
    DisplayInfo('Kill '+Player2ShipLists[theshipIndex].Name,false,false,1,clblue);
     if Player2AllLives=0 then
     begin
     DisplayInfo('Win',false,false,1,clred);
       if (Player1AllLives>=0) then
        begin
         for i:=1 to GridX do
         for j:=1 to GridX do
          if Player1ControlGrid[i][j][2]<13 then
         Player1controlGrid[i][j][2]:=Player1ControlGrid[i][j][1];
        end;
     end;
    end;
  /////////////////////////////////////////////////////////////////////////////////  
 end;

  if (not isplayer1) and ishuman then
 begin
 //////////////////
  if Player2ShipLists[theshipIndex].Lives=0 then
    begin
      for i:=1 to GridX do
       for j:= 1 to GridY do
      begin
      if Player2ControlGrid[i][j][4]=theshipIndex then
      Player2ControlGrid[i][j][2]:=Player2ControlGrid[i][j][3];
      end;
    DisplayInfo('Kill '+Player2ShipLists[theshipIndex].Name,false,true,1,clblue);
    end;
   if Player2AllLives=0 then  DisplayInfo('Win',false,true,1,clred);
  /////////////////////////////////////////////////////////////////////
 end;

 if isplayer1 and (not ishuman) then
 begin
 //////////////////////////////////////////////////////////////////
     if Player1ShipLists[theshipIndex].Lives=0 then
    begin
      for i:=1 to GridX do
       for j:= 1 to GridY do
      begin
      if Player1ControlGrid[i][j][4]=theshipIndex then
      Player1ControlGrid[i][j][2]:=Player1ControlGrid[i][j][3];
      end;
    DisplayInfo('Kill '+Player1ShipLists[theshipIndex].Name,true,false,1,clblue);
     if Player1AllLives=0 then
     begin
     DisplayInfo('Win',true,false,1,clred);
       if (Player2AllLives>0) then
        begin
         for i:=1 to GridX do
         for j:=1 to GridX do
          if Player2ControlGrid[i][j][2]<13 then
         Player2controlGrid[i][j][2]:=Player2ControlGrid[i][j][1];
        end;
     end;
    end;
  /////////////////////////////////////////////////////////////////////////////////  
 end;

 if (Player1AllLives=0) then
   begin
    for i:=1 to GridX do
    for j:=1 to GridX do
     if Player2ControlGrid[i][j][2]<13 then
      Player2controlGrid[i][j][2]:=Player2ControlGrid[i][j][1];
   end else
   if (Player2AllLives=0) then
   begin
    for i:=1 to GridX do
    for j:=1 to GridX do
     if Player1ControlGrid[i][j][2]<13 then
      Player1controlGrid[i][j][2]:=Player1ControlGrid[i][j][1];
   end;


end;


procedure Tmainform.ComputerMove(IsPlayer1:Boolean;out Sx:integer;out Sy:integer);
var i,j,x,y,pass:integer;
    SelectedOk:boolean;
    noup,nodown,noleft,noright:boolean;
    yesup,yesdown,yesleft,yesright:boolean;
    tempControlGrid:array[1..GridX,1..GridY] of integer;
begin
SelectedOk:=false;
 if isPlayer1 then
 begin
 for i:=1 to GridX do
  for j:=1 to GridY do
  tempControlGrid[i][j]:=player1ControlGrid[i][j][2];
 end else
 begin
   for i:=1 to GridX do
  for j:=1 to GridY do
  tempControlGrid[i][j]:=player2ControlGrid[i][j][2];
 end;

//////////////////////////////////////////////////////////////////////////
 for pass:=1 to 2  do   //if one ship have been hit partly
 begin                   //pass represnet 2 direction to choose
    for x:=1 to GridX do
    begin
      for y:=1 to GridY do
      begin
       if tempControlGrid[x][y]=14 then ///have been hit partly
          begin
           Sx:=x;Sy:=y;
           noup:=(y>1)and(tempControlGrid[x][y-1]<=11);
           nodown:=(y<GridY) and (tempControlGrid[x][y+1]<=11);
           noleft:=(x>1)and (tempControlGrid[x-1][y]<=11);
           noright:=(x<GridX) and (tempControlGrid[x+1][y]<=11);
              if pass=1 then
              begin
              yesup:=(y>1) and (tempControlGrid[x][y-1]=14);
              yesdown:=(y<GridY) and (tempControlGrid[x][y+1]=14);
              yesleft:=(x>1) and (tempControlGrid[x-1][y]=14);
              yesright:=(x<GridX) and (tempControlGrid[x+1][y]=14);
              if (noleft and yesright) then begin sx:=x-1; SelectedOK:=true; end else
              if (noright and yesleft) then begin sx:=x+1; SelectedOK:=true; end else
              if (noup and yesdown) then begin sy:=y-1; SelectedOK:=true; end else
              if (nodown and yesup) then begin sy:=y+1; SelectedOK:=true; end ;
              end else
              begin
              if (noleft) then begin sx:=x-1; SelectedOK:=true; end else
              if (noright) then begin sx:=x+1; SelectedOK:=true; end else
              if (noup) then begin sy:=y-1; SelectedOK:=true; end else
              if (nodown) then begin sy:=y+1; SelectedOK:=true; end ;
              end;
           end;  //// if enbdy;
          if SelectedOk then break;
        end;///for y;
       if SelectedOk then break;
      end;  ///for x
    if SelectedOk then break;
 end; //for pass

 if (not SelectedOK) then
 begin
 repeat
   Sx:=random(GridX)+1;
   Sy:=random(GridY div 2)*2+Sx mod 2;
 until(tempControlGrid[Sx][Sy]<=11);
 end;
//////////////////////////////////////////////////////////////////////////////////////

end;

function Tmainform.PlayerMove(isPlayer1:boolean;IsHuman:boolean;theX,theY:integer):boolean;
var ShipIndex:integer;
    cx,cy:Integer;
begin
result:=false;
  ///////////////////////////////////////////////////
if IsPlayer1 and ishuman then
 begin 
    if Player1ControlGrid[theX,theY][2]=11   then
    begin
    ShipIndex:=Player1ControlGrid[theX,theY][4];
      if (Player1ControlGrid[theX,theY][1]<=10) then //hit it!
      begin
      Player1ControlGrid[theX,theY][2]:=14;
      DEC(Player1ShipLists[ShipIndex].Lives);
      DEC(Player1AllLives);
      if shipindex>0 then CheckWin(true,true,ShipIndex);
      end else Player1ControlGrid[theX,theY][2]:=13;
    result:=true;
    canplay1:=false;
    canplay2:=true;
    end;
   if (Player1AllLives=0) then MsgNewGame:=true;
 end;
//////////////////////////////////////////

if (not isPlayer1) and (not isHuman) then
begin
   ComputerMove(false,cx,cy);
   if Player2ControlGrid[cx,cy][2]<=11   then
   begin
      ShipIndex:=Player2ControlGrid[cx,cy][4];
      if (Player2ControlGrid[cx,cy][1]<=10) then //hit it!
      begin
      Player2ControlGrid[cx,cy][2]:=14;
      DEC(Player2ShipLists[ShipIndex].Lives);
      DEC(Player2AllLives);
      if shipIndex>0 then CheckWin(false,false,ShipIndex);
      end else Player2ControlGrid[cx,cy][2]:=13;
   result:=true;
   end;
   if (Player2AllLives=0) then MsgNewGame:=true;
end;
////////////////////////////////////////////////////////////////////////////////////
if (not IsPlayer1) and  Ishuman then
begin
    if Player2ControlGrid[theX,theY][2]=11   then
    begin
    ShipIndex:=Player2ControlGrid[theX,theY][4];
      if (Player2ControlGrid[theX,theY][1]<=10) then //hit it!
      begin
      Player2ControlGrid[theX,theY][2]:=14;
      DEC(Player2ShipLists[ShipIndex].Lives);
      DEC(Player2AllLives);
      if shipindex>0 then CheckWin(false,true,ShipIndex);
      end else Player2ControlGrid[theX,theY][2]:=13;
    result:=true;
    canplay1:=true;
    canplay2:=false;
    end;
   if (Player2AllLives=0) then MsgNewGame:=true;
end;
////////////////////////////////////////////////////////////////////////////////////
if isPlayer1 and (not isHuman) then
begin
   ComputerMove(true,cx,cy);
   if Player1ControlGrid[cx,cy][2]<=11   then
   begin
      ShipIndex:=Player1ControlGrid[cx,cy][4];
      if (Player1ControlGrid[cx,cy][1]<=10) then //hit it!
      begin
      Player1ControlGrid[cx,cy][2]:=14;
      DEC(Player1ShipLists[ShipIndex].Lives);
      DEC(Player1AllLives);
      if shipIndex>0 then CheckWin(true,false,ShipIndex);
      end else Player1ControlGrid[cx,cy][2]:=13;
   result:=true;
   end;
   if (Player1AllLives=0) then MsgNewGame:=true;
end; 
//////////////////////////////////////////////////////
Player1Control_DrawGrid.Repaint;
Player2Control_DrawGrid.Repaint;

end;

function  Tmainform.BeginNewGame:boolean;
begin
result:=false;
 if IDYES=MessageBox(application.handle,pchar('New game?'),pchar('information'),MB_ICONQUESTION or MB_YESNO) then
 begin
 result:=True;
 end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var i:integer;
begin
//////Load Image//‘ÿ»ÎÕº∆¨/////////////////////////
  for i:=1 to PicNum do
  begin
    ShipPic[i]:=Tbitmap.Create;
    try
    ShipPic[i].LoadFromResourceName(Hinstance,'batt'+inttostr(idlist[i]));
    except
     continue;
    end;
  end;

////////Initial real ship posiiion/≥ı ºªØ¥¨µƒŒª÷√/////////
     GameMode:=2;
     InitSetup(true,true,);
     InitSetup(false,false);
     MsgNewGame:=false;
     
end;

procedure TMainForm.Player1Control_DrawGridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
try
Player1Control_DrawGrid.Canvas.StretchDraw(Rect,ShipPic[Player1ControlGrid[ACol+1][ARow+1][2]]);
except
end;
end;

procedure TMainForm.Player1Control_DrawGridSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if MsgNewGame then
  begin
  if  BeginNewGame then  Start_bn.Click;
  end
  
  else  begin

  case gamemode of
  1: begin
      if canplay1 then
       begin
       PlayerMove(True,True,ACol+1,ARow+1);
       end;
       end;
  2: begin
      if PlayerMove(True,True,ACol+1,ARow+1) then  PlayerMove(false,false,-1,-1);
     end;
  3:begin
      exit;

    end;
  end;///case end;

  end;//else end;

end;

procedure TMainform.InitSetup(IsPlayer1:boolean;ishuman:boolean);
var theControlGrid:array[1..GridX,1..GridY,1..4]of integer;
    i,j,k,ATypesum,Ashipnum:integer;
    Adirection,ALen,dx,dy,Rx,Ry,Sx,Sy:integer;
    shipindex,AllLives:integer;
    ShipLists:array[1..Maxshipnum]of TshipLists;
    selectOK:Boolean;
begin                                                          
   for i:=1 to Gridx do
   for j:=1 to Gridy do
   begin
    for k:=1 to 3  do   theControlGrid[i][j][k]:=11;
    theControlGrid[i][j][4]:=-1;
   end;

   for i:=1 to MaxShipNum do
   begin
    ShipLists[i].Name:='asd';
    ShipLists[i].Lives:=-1;
   end;

Randomize;
AllLives:=0;
shipindex:=0;
  for ATypesum:=1 to shipTypenum do
  begin
     for Ashipnum:=1 to shipnum[ATypesum] do
     begin
     ////////////choose ship's direction ////—°‘Ò¥¨µƒ∑ΩœÚ//////////
      Adirection:=Random(2)+1;   //// 0 <= X < Range. //extended
      ALen:=ship[ATypesum].shipLength;
      dx:=0;dy:=0;
      if Adirection=1 then dx:=1 else dy:=1;
      
    ///find the enough space
      repeat
       Rx:=Random(GridX)+1;
       Ry:=Random(GridY)+1;
       Sx:=Rx;Sy:=Ry;
       selectOK:=True;
        for k:=1 to ALen do
        begin
         //if ( then begin selectOK:=false;break; end;
          if (Sx>GridX) or(Sy>GridY)or(theControlGrid[Sx][Sy][1]<=10) then
            begin
              selectOK:=false;
              break;
            end;
         Sx:=Sx+dx;
         Sy:=Sy+dy;
        end;
      until (selectOK);

       inc(shipindex);
       Sx:=Rx;Sy:=Ry;
       for k:=1 to ALen do
        begin
         theControlGrid[Sx][Sy][1]:=ship[ATypesum].liveparts[Adirection][k];
         theControlGrid[Sx][Sy][3]:=ship[ATypesum].deadparts[Adirection][k];
         theControlGrid[Sx][Sy][4]:=shipindex;
         INC(Sx,dx);
         INC(Sy,dy);
        end;
       ShipLists[shipindex].Name:=ship[ATypesum].Name+' No.'+inttoStr(Ashipnum);
       ShipLists[shipindex].Lives:=ALen;
       INC(AllLives,ALen);
     end;  //for ship num
  end;///for typenum


  /////////////////////////////////////////////////////////////////////////////////
 if  IsPlayer1 and Ishuman then
 begin
        for i:=1 to Gridx do
       begin
       for j:=1 to Gridy do
       begin
       for k:=1 to 4  do
       begin
       Player1ControlGrid[i][j][k]:=theControlGrid[i][j][k];
       Player1AllLives:=AllLives;
       end;
       end;
       end;
     
       for i:=1 to MaxshipNum do
       begin
       Player1ShipLists[i].Name:=ShipLists[i].Name;
       Player1ShipLists[i].Lives:=ShipLists[i].Lives;
       end;
 end;
///////////////////////////////////////////////////////
 if IsPlayer1 and (not IsHuman) then
 begin
      for i:=1 to Gridx do
      begin
      for j:=1 to Gridy do
      begin
        for k:=1 to 4  do
        begin
        Player1ControlGrid[i][j][k]:=theControlGrid[i][j][k];
        Player1AllLives:=AllLives;
        end;
         Player1ControlGrid[i][j][2]:= Player1ControlGrid[i][j][1];
      end;
      end;
        
      for i:=1 to MaxshipNum do
       begin
       Player1ShipLists[i].Name:=ShipLists[i].Name;
       Player1ShipLists[i].Lives:=ShipLists[i].Lives;
       end;

 end;
///////////////////////////////////////////////////////
if (not isPlayer1) and isHuman then
 begin
          for i:=1 to Gridx do
       begin
       for j:=1 to Gridy do
       begin
       for k:=1 to 4  do
       begin
       Player2ControlGrid[i][j][k]:=theControlGrid[i][j][k];
       Player2AllLives:=AllLives;
       end;
       end;
       end;
     
       for i:=1 to MaxshipNum do
       begin
       Player2ShipLists[i].Name:=ShipLists[i].Name;
       Player2ShipLists[i].Lives:=ShipLists[i].Lives;
       end;
 end; 

////////////////////////////////////////////////////////////
if (not isPlayer1) and (not ishuman) then
 begin
      for i:=1 to Gridx do
      begin
      for j:=1 to Gridy do
      begin
        for k:=1 to 4  do
        begin
        Player2ControlGrid[i][j][k]:=theControlGrid[i][j][k];
        Player2AllLives:=AllLives;
        end;
         Player2ControlGrid[i][j][2]:= Player2ControlGrid[i][j][1];
      end;
      end;
        
      for i:=1 to MaxshipNum do
       begin
       Player2ShipLists[i].Name:=ShipLists[i].Name;
       Player2ShipLists[i].Lives:=ShipLists[i].Lives;
       end;
 end;
/////////////////////////////////////////////

end;

procedure TMainForm.Start_bnClick(Sender: TObject);
begin
PCvsPCTimer.Enabled:=false;
case gamemode of
1: begin
   InitSetup(true,true);
   InitSetup(false,true);
   canplay1:=true;
   canplay2:=true;
   end;
2: begin
   InitSetup(true,true);
   InitSetup(false,false);
   canplay1:=true;
   canplay2:=false;
   end;
3: begin
   InitSetup(true,false);
   InitSetup(false,false);
   canplay1:=false;
   canplay2:=false;
   PCvsPCTimer.Enabled:=true;
   end;
4: begin
   InitSetup(true,false);
   InitSetup(false,true);
   PlayerMove(True,false,-1,-1);
   canplay1:=false;
   canplay2:=true;
   end;
5: begin
 //  InitSetup(true,true);
  // InitSetup(false,true);
   end;

end;

MsgNewgame:=false;
Player1Control_DrawGrid.Repaint;
Player2Control_DrawGrid.Repaint;
end;

procedure TMainForm.Exit_bnClick(Sender: TObject);
begin
close;
end;

procedure TMainForm.Player2Control_DrawGridDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
try
Player2Control_DrawGrid.Canvas.StretchDraw(Rect,ShipPic[Player2ControlGrid[ACol+1][ARow+1][2]]);
except
end;
end;


procedure TMainForm.RB1Click(Sender: TObject);
begin
 if GameMode<>1 then
 begin
  if BeginNewgame then
   begin
    GameMode:=1;
    Start_bn.Click;
   end;
 end;
end;

procedure TMainForm.RB2Click(Sender: TObject);
begin
 if GameMode<>2 then
 begin
  if BeginNewgame then 
   begin
    GameMode:=2;
    Start_bn.Click;
   end;
 end;
end;

procedure TMainForm.RB3Click(Sender: TObject);
begin
 if GameMode<>3 then
 begin
  if BeginNewgame then 
   begin
    GameMode:=3;
    Start_bn.Click;
   end;
 end;
end;

procedure TMainForm.rb4Click(Sender: TObject);
begin
 if GameMode<>4 then
 begin
  if BeginNewgame then 
   begin
    GameMode:=4;
    Start_bn.Click;
   end;
 end;
end;

procedure TMainForm.RB5Click(Sender: TObject);
begin
 if GameMode=5 then exit else
 begin
  if not BeginNewgame then exit else
   begin
    GameMode:=5;
    Start_bn.Click;
   end;
 end;
end;

procedure TMainForm.Player2Control_DrawGridSelectCell(Sender: TObject;
  ACol, ARow: Integer; var CanSelect: Boolean);
begin
  if MsgNewGame then
  begin
  if  BeginNewGame then  Start_bn.Click;
  end
  
  else  begin

  case gamemode of
  1: begin
      if canplay2 then
       begin
       PlayerMove(false,True,ACol+1,ARow+1);
       end;
       end;
  2: begin

     end;
  3:begin
      exit;
    end;
  4:begin
      if PlayerMove(false,True,ACol+1,ARow+1) then  PlayerMove(true,false,-1,-1);
    end;
  end;///case end;

  end;//else end;
end;

procedure TMainForm.PCvsPCTimerTimer(Sender: TObject);
begin
PlayerMove(True,false,-1,-1);
PlayerMove(false,false,-1,-1);
if (Player1AllLives=0 ) or (Player2AllLives=0 ) then
 PCvsPCTimer.Enabled:=false;
end;

end.
