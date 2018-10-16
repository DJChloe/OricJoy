unit unitjoystick;
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, MMSystem,inifiles;

type
    TGamePort = (Gameport1,Gameport2);
    TJoyMoveEvent = procedure(Sender:TObject; XPos,YPos:Integer; ButtonStatus :Word; IsCalibrating :Boolean) of object;
    TJoyZMoveEvent = procedure(Sender:TObject; ZPos:Integer; ButtonStatus :Word;IsCalibrating:Boolean) of object;
    TButtonNotifyEvent = procedure(Sender:TObject; ButtonNum:byte;pressed :Boolean; Xpos,YPos : Integer )of object;
    TJoyStateEvent = procedure(Sender:TObject; StateReult:MMResult) of object;
    TScalevalue = 1..32767; //Scale X;Y;Z- Value from 1 to 100; handyer to use
type
  TJoystickex = class(TComponent)
  private
         FDummi :HWND;
    //Var
    FPolling: Boolean;
    FDummiWindow :Hwnd; //to get a handle for Joysetcapture
    FEnabled :Boolean;
    FGAmeport :TGameport;
    FCalAutoSave : Boolean;
    FCalAutoLoad : Boolean;
    Fstatus:MMRESULT;
    FInterval :integer;
    FIsCalibrating :Boolean;
    FCenter :TPoint;
    FThreshold :Real;
    FScaled : Boolean;
    FXScaleBy : Tscalevalue;
    FYScaleby : Tscalevalue;
    FZScaleby : Tscalevalue ;

    FMaxLeftUP:TPoint;
    FMaxrightDown :TPoint;
    FMaxZ :Integer;
    FMinZ :Integer;
    FPeriodMin, FPeriodMax :Integer;
    FNumButtons: Integer;

    FJoyCaps :TJoycaps;

    FYDivAboveCenter,FYDivBelowCenter,
    FXDivAboveCenter,FXDivBelowCenter,
    FDividerZ :Real; // Used for scaled mode


    //Events
    FJoyStateChange : TJoyStateEvent;
    FOnButtonChange   :TButtonNotifyEvent;

    FJoyMoveEvent : TJoyMoveEvent;
    FJoyZMoveEvent : TJoyZMoveEvent;
    // prop Methodes
    procedure FSetEventByChangeOnly (Value :Boolean);
    procedure FSetGameport(Port: TGameport);

    procedure FSetInterval (Value :Integer);
    procedure FsetThreshold (Value : Real);
    procedure FSetScaled (Value :Boolean);
    procedure FXsetScaleBy (Value :Tscalevalue);
    procedure FYsetScaleBy (Value :Tscalevalue);
    procedure FZsetScaleBy (Value :Tscalevalue);
    procedure FSetCalAutoLoad (Value : Boolean);


    // private procedures and functions

    procedure FScale; //Calculating Divider for scaled output
    function FScaledXVal( TrueValue: Word) : Integer;
    function FScaledYVal( TrueValue: Word) : Integer;
    function FScaledZVal( TrueValue: Word) : Integer;
  protected
    { Protected declarations }
    procedure wndProc(var Message :TMessage);
    procedure SetStatus(AValue:MMResult);
  public
    { Public declarations }
    constructor Create(AOwner :TComponent);override;
    destructor Destroy;override;

    // Get Infos about device
    Function GetDevices   :Byte;
    function GetButtons :Byte;

    // Set to or set out of Operation
    procedure disableJoystick;
    function EnableJoyStick :Boolean;

   // Calibrating functions
   function CalibrateCenter : Boolean;
   function BeginCalibrateRange  : Boolean;
   procedure StopCalibrateRange;

   // save settings
   procedure SaveCalibration;
   procedure LoadCalibration;
  published
    { Published declarations }
    property GamePort: TGamePort read FGamePort write FSetGamePort;
    property Polling: Boolean read FPolling write FSetEventByChangeOnly;
    property Interval :Integer read FInterval Write FSetInterval;
    property Center : TPoint read FCenter;
    property EventThreshold : Real read FThreshold Write FSetThreshold;
    property Scaled : Boolean read FScaled Write FSetScaled;

    property XScaledBy :TScalevalue read FXScaleby Write FXSetScaleby;
    property YScaledBy :TScalevalue read FYScaleby Write FYSetScaleby;
    property ZScaledBy :TScalevalue read FZScaleby Write FZSetScaleby;
    property CalAutoSave :Boolean read FCalAutoSave Write FCalAutoSave;
    property CalAutoLoad :Boolean read FCalAutoLoad Write FSetCalAutoLoad;

    // Read onlys
    property MaxLeftUP :TPoint read FMaxLeftUP;
    property MaxRightDown :TPoint  read FMaxrightDown;
    property MaxZ :integer read FMaxZ;
    property MinZ :integer read FMinZ ;
    property NumButtons :Integer read FNumbuttons;
    //Events
    property OnJoyStateChange:TJoyStateEvent read FJoyStateChange write FJoyStateChange;
    property OnButtonChange: TButtonNotifyEvent read  FOnButtonChange Write  FOnButtonChange;

    property JoyZMove :TJoyZMoveEvent read FJoyZMoveEvent write FJoyZMoveEvent;
    property JoyMove : TJoyMoveEvent read FJoyMoveEvent Write FJoyMoveEvent;
    property JoyStatus:MMRESULT read Fstatus write SetStatus;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Addons', [TJoystickex]);
end;



//+++++++++++++++++++++++++++++++++++++++++Public methodes ++++++++++++++++++++++++++++++++++++++++++++




constructor TJoystickex.Create(AOwner :TComponent);
begin
     inherited Create(AOwner);
     FdummiWindow := AllocateHWnd(WndProc);
     FPolling:=False; //Events only appear, if Jystick is moved
     FEnabled := False;//capturing  Joystick is not enabled
     FGAmeport := Gameport1;// Device 1
     FInterval := 50;
     FThreshold := 0.1;
     FScaled := True;
     FXScaleBy := 400;
     FYScaleBy := 300;
     FZScaleBy := 100;

     FMaxLeftUP.x:= -32767;
     FMaxLeftUP.y:= -32767;

     FMaxrightDown.x := 32767;
     FMaxrightDown.y := 32767;

     FMaxZ :=32767;
     FMinZ :=0;

     FPeriodMin := 10;
     FPeriodMax := 1000;
     FNumButtons:=2;
     FCenter.x := 0;
     Fcenter.Y := 0;

     FCalAutoSave := True;
     FCalAutoLoad := True;
     end;



destructor TJoystickex.Destroy;
begin
     if FCalAutosave then SaveCalibration;
     joyReleaseCapture(ord(FGameport));
     DeallocateHWnd(FDummiWindow);
     inherited Destroy;
end;

procedure TJoystickex.SaveCalibration;
var
    IniFile : TIniFile;
begin

        IniFile := TIniFile.Create(copy(Application.exename,1,length(Application.exename)-3)+'INI');
        //Range
        IniFile.writeInteger('Range', 'MaxLeftUPX',FMaxLeftUP.x);
        IniFile.writeInteger('range', 'MaxLeftUPy',FMaxLeftUP.y);
        IniFile.writeInteger('range', 'MaxrightDownx',FMaxrightDown.x);
        IniFile.writeInteger('range', 'MaxrightDowny',FMaxrightDown.y);
        IniFile.writeInteger('range', 'MaxZ',FMaxZ);
        IniFile.writeInteger('range', 'MinZ',FMinZ);
        //Center
        IniFile.writeInteger('Center', 'CenterX',FCenter.X);
        IniFile.writeInteger('Center', 'CenterY',FCenter.y);

        IniFile.free;
    end;

procedure TJoystickex.SetStatus(AValue: MMResult);
begin
  if Fstatus<>AValue then
  begin
    Fstatus:=AValue;
    if Assigned(FJoyStateChange) then
    FJoyStateChange(self,Fstatus);

  end;
end;

procedure TJoystickex.LoadCalibration;
var
    IniFile : TIniFile;
begin

        IniFile := TIniFile.Create(copy(Application.exename,1,length(Application.exename)-3)+'INI');
        //Range
        FMaxLeftUP.x:=  IniFile.ReadInteger('Range', 'MaxLeftUPX',-32767);
        FMaxLeftUP.y:=  IniFile.ReadInteger('range', 'MaxLeftUPy',-32767);
        FMaxrightDown.x:=  IniFile.ReadInteger('range', 'MaxrightDownx',32767);
        FMaxrightDown.y:=  IniFile.ReadInteger('range', 'MaxrightDowny',32767);
        FMaxZ:= IniFile.ReadInteger('range', 'MaxZ',32000);
        FMinZ:= IniFile.ReadInteger('range', 'MinZ',0);
                //Center
        FCenter.X:=  IniFile.ReadInteger('Center', 'CenterX',0);
        FCenter.y:=  IniFile.ReadInteger('Center', 'CenterY',0 );
        IniFile.free;
    end;



function TJoystickex.CalibrateCenter : Boolean;
var Info :TJoyinfo;
Begin
Result := false;
if not FEnabled then exit;
joyGetPos(ord(FGameport),@Info);
FCenter.x := Info.wXpos;
FCenter.y := Info.wYpos;
Fscale;
Result := True;
end;


function TJoystickex.BeginCalibrateRange  : Boolean;
Begin
Result := False;
if not FEnabled then exit;
FMaxLeftUP.x := FCenter.x;
FMaxLeftUP.y := FCenter.y;
FMaxrightDown.x := Fcenter.x;
FMaxrightDown.y := Fcenter.y;
FMaxZ := FJoyCaps.wZmax div 2;
FMinZ := FMaxZ;

FIsCalibrating := true;
Result := True;
end;


procedure TJoyStickex.StopCalibrateRange;
Begin
FIsCalibrating := False;
FScale; // Scale with new range values
end;


function TJoystickex.EnableJoyStick :Boolean;
var Status:MMRESULT;
Begin
Result := False;
Status:=joySetCapture(FDummiWindow,ord(FGAmeport),FInterval,not FPolling);
if Status = JOYERR_NOERROR then
   Begin
   joySetThreshold(ord(FGameport), Round(FJoycaps.wXmax*FThreshold/100));
   FEnabled := True;
   Fscale;
   Result := True;
   end else FEnabled := false;
   JoyStatus:=Status;
end;

procedure TJoystickEx.DisableJoyStick;
Begin
joyReleaseCapture(ord(FGameport));
JoyStatus:=0;
FEnabled := False;
end;

Function TJoystickex.GetDevices: Byte;
begin
     Result := joyGetNumDevs;
     if result > 2 then
        result := 2;
end;

Function TJoystickex.GetButtons : Byte;
begin
result := FJoyCaps.wNumButtons;
end;





// ----------------------------------------Private procedures -------------------------------


procedure TJoyStickex.FSetCalAutoLoad (Value : Boolean);
Begin
FCalAutoLoad := Value;
if FCalAutoLoad then LoadCalibration;
end;

function TJoystickex.FScaledXVal(TrueValue: Word) : Integer;
Begin
if  (FXDivBelowCenter = 0) or (FXDiVAboveCenter = 0) then
    Begin
    result := 0;
    exit;
    end;
if TrueValue < FCenter.x then
   Result := round((TrueValue-FCenter.X)/FXDivBelowCenter) else
   Result := round((TrueValue-FCenter.X)/FXDiVAboveCenter);
end;

function TJoystickex.FScaledYVal(TrueValue: Word) : Integer;
Begin
if  (FYDivBelowCenter = 0) or (FYDiVAboveCenter = 0) then
    Begin
    result := 0;
    exit;
    end;

if TrueValue < FCenter.Y then
   Result := round((TrueValue-FCenter.Y)/FYDivBelowCenter) else
   Result := round((TrueValue-FCenter.Y)/FYDiVAboveCenter);

end;

function TJoystickex.FScaledZVal(TrueValue: Word) : Integer;
Begin
//Feel free to complete this part of code as I do not own a
//a joy stick with Z direction . So I'm not able to test it :((
end;

procedure TJoyStickex.FScale;
Begin
FXDivAboveCenter := (FMaxrightDown.x - FCenter.x)/FXScaleby;
FXDivBelowCenter := (FCenter.x-FMaxLeftUP.x)/FXScaleby;

FYDivAboveCenter  := (FMaxrightDown.Y - FCenter.Y)/FYScaleby;
FYDivBelowCenter := (FCenter.y-FMaxLeftUP.y  )/FYScaleby;
if FmaxZ=0 then FMaxZ := 32767;
FDividerZ     := (FMaxZ-FMinZ)/FZscaleBy;

// to prevent division by zero

if FXDivAboveCenter < 1 then FXDivAboveCenter := 1;
if FXDivBelowCenter < 1  then FXDivBelowCenter := 1;
if FYDivAboveCenter < 1 then FYDivAboveCenter := 1;
if FYDivBelowCenter < 1  then FYDivBelowCenter := 1;

end;



procedure TJoystickex.FSetThreshold(Value :Real);
Begin
if (Value>0) and (Value <=10.00) then
   FThreshold := Value else
   if Value < 0 then FThreshold := 0 else
      if Value > 10 then FThreshold := 10;

joySetThreshold(ord(FGameport), Round((FJoycaps.wXmax-FJoycaps.wXmin)*Fthreshold/100));
end;

procedure TJoyStickex.FSetScaled (Value :Boolean);
Begin
FScaled := Value;
end;

procedure TJoyStickex.FXSetScaleBy(Value :TScaleValue);
Begin
FXscaleBy := Value;
if FXScaleBy <= 0 then FXScaleBy := 1;
FScale;
end;

procedure TJoyStickex.FYSetScaleBy(Value :TScaleValue);
Begin
FYscaleBy := Value;
if FYScaleBy <= 0 then FYScaleBy := 1;
FScale;
end;

procedure TJoyStickex.FZSetScaleBy(Value :TScaleValue);
Begin
FZscaleBy := Value;
if FZScaleBy <= 0 then FZScaleBy := 1;
FScale;
end;


procedure TJoystickex.FSetinterval (Value :Integer);
Begin
FInterval := Value;
if FEnabled then EnableJoyStick;
end;

procedure TJoystickex.FSetEventByChangeOnly (Value :Boolean);
Begin
FPolling := Value;
if Fenabled then
   Begin
   disableJoystick;
   EnableJoyStick;
   end;
end;





procedure TJoystickex.FSetGamePort(Port: TGamePort );
begin
joyGetDevCaps(ord(FGameport),@FJoycaps,SizeOf(TJoycaps));
with FJoyCaps do
        Begin

        FMaxLeftUP.x:= wXmin ;
        FMaxLeftUP.y:= wYmin;

        FMaxrightDown.x := wXmax;
        FMaxrightDown.y := wYmax;

        FMaxZ :=wZmax;
        FMinZ :=wZmin;

        FPeriodMin := wPeriodMin;
        FPeriodMax := wPeriodMax;
        FNumButtons:= wNumButtons;
        end;

if FEnabled then
   Begin
   disableJoystick;
   Fgameport := Port;
   EnableJoyStick;
   end else
       FGameport := Port;
end;





procedure TJoyStickex.wndProc(var Message : TMessage);
Begin
with Message do
case Msg of
MM_JOY2ZMOVE,
MM_JOY1ZMOVE : Begin
                // Z Max- Values
                if LParam< FMinZ then
                   FMinZ := LParam;
                if LParamLo > FMaxZ then
                   FMaxZ := LParamLo;


               if Assigned (FJoyZMoveEvent) then
                if not FScaled then
                   FJoyZMoveEvent(Self,LParam,wParam,FIsCalibrating)
                   else
                   FJoyZMoveEvent(Self,round((lParam-Fminz)/FDividerZ),wParam,FIsCalibrating);
               end;

MM_JOY2MOVE,
MM_JOY1MOVE: Begin
             if FIsCalibrating then
                Begin
                // X Max- Values
                if LParamLo< FMaxLeftUP.x then
                   Begin
                   FMaxLeftUP.x := LParamLo;
                   FScale;
                   end;
                if LParamLo > FMaxrightDown.x then
                   Begin
                   FMaxrightDown.x := LParamLo;
                   FScale;
                   end;
                 // Y-MAx Values
                if LParamHi < FMaxLeftUP.y then
                   Begin
                   FMaxLeftUP.y := LParamHi;
                   FScale;
                   end;
                if LParamHi > FMaxrightDown.y then
                   Begin
                   FMaxrightDown.y := LParamHi;
                   FScale;
                   end;
                end; // Here else ?
             if Assigned (FJoyMoveEvent) then
                if not FScaled then
                   FJoyMoveEvent(Self,LParamLo,LParamHi,wParam,FIsCalibrating)
                   else
                    //FJoyMoveEvent(Self,LParamLo,LParamHi,wParam,FIsCalibrating); //For tests
                  try
                   FJoyMoveEvent(Self,FScaledXVal(LParamLo),FScaledYVal(LParamHi),wParam,FIsCalibrating);
                   except
                   end;
             end;


MM_JOY1BUTTONDOWN,
MM_JOY2BUTTONDOWN,
MM_JOY1BUTTONUP,
MM_JOY2BUTTONUP :   Begin

                    if (Wparam AND JOY_BUTTON1CHG)= JOY_BUTTON1CHG then
                       if assigned(FOnButtonChange)then
                          if not FScaled then
                             FOnButtonChange(Self,1, (Wparam and JOY_BUTTON1)= Joy_BUTTON1,LParamLo,LParamHi) else
                               FOnButtonChange(Self,1, (Wparam and JOY_BUTTON1)= Joy_BUTTON1,FScaledXVal(LparamLO),FScaledYVal(LParamHi));


                    if (Wparam AND JOY_BUTTON2CHG)= JOY_BUTTON2CHG then
                       if assigned(FOnButtonChange)then
                          if not FScaled then
                             FOnButtonChange(Self,2, (Wparam and JOY_BUTTON2)= Joy_BUTTON2,LParamLo,LParamHi) else
                               FOnButtonChange(Self,2, (Wparam and JOY_BUTTON2)= Joy_BUTTON2,FScaledXVal(LparamLO),FScaledYVal(LParamHi));

                    if (Wparam AND JOY_BUTTON3CHG)= JOY_BUTTON3CHG then
                       if assigned(FOnButtonChange)then
                          if not FScaled then
                             FOnButtonChange(Self,3, (Wparam and JOY_BUTTON3)= Joy_BUTTON3,LParamLo,LParamHi) else
                               FOnButtonChange(Self,3, (Wparam and JOY_BUTTON3)= Joy_BUTTON3,FScaledXVal(LparamLO),FScaledYVal(LParamHi));

                    if (Wparam AND JOY_BUTTON4CHG)= JOY_BUTTON4CHG then
                       if assigned(FOnButtonChange)then
                          if not FScaled then
                             FOnButtonChange(Self,4, (Wparam and JOY_BUTTON4)= Joy_BUTTON4,LParamLo,LParamHi) else
                               FOnButtonChange(Self,4, (Wparam and JOY_BUTTON4)= Joy_BUTTON4,FScaledXVal(LparamLO),FScaledYVal(LParamHi));


                    end

                    else
                    Result := defWindowProc(FDummiWindow,Msg,wParam,lParam);
                    end;
end;

end.

