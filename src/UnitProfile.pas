unit UnitProfile;
interface
 uses Sysutils, Classes, Contnrs, StdCtrls, unitmacros, Controls;

Type
  TActionKind=(akNone,akMacro,akLed,akTempLed,akMouseButton);
  TProgLed=(PLNormal,PLBlue,PLGreen,PLRed,PLNext);
  TButtons=(Button01,Button02,Button03,Button04,Button05,
            Button06,Button07,Button08,Button09,Button10,
            SliderUp,SliderDown,dpOO,dpNO,dpNN,dpNE,dpEE,dpSE,dpSS,
            dpSO);
   //TMouseButton=(mbLeft,mbRight,mbMiddle); //already defined by Delphi
   TMouseAction=(maClick,maDblClick,maUserAction);

const ButtonNames:array[Button01..dpSO] of string=
           ('Button 01','Button 02','Button 03','Button 04',
           'Button 05','Button 06','Button 07','Button 08',
           'Button 09','Button 10','Slider Up','Slider Down',
           'Direction Pad : Up',
           'Direction Pad : Forward,Up',
           'Direction Pad : Forward',
           'Direction Pad : Forward / Down',
           'Direction Pad : Down',
           'Direction Pad : Backward /Down',
           'Direction Pad : Backward',
           'Direction Pad : Backward /Up');
NoAction='No Action';
LedAction:array[PLNormal..PLNext] of string=
           ('Normal','Blue','Green','Red','Cycle');
MouseButtons:array[mbLeft..mbMiddle] of String=('Left mouse','Right mouse','Middle mouse');
MouseActions:array[maClick..maUserAction] of String=(' click',' double-click',' User action');


type
  TActionK=class
  public
    //Common action properties
    ActionKind:TActionKind;
    RepeatAction:boolean;
    RepeatTime:cardinal;

    //Basic events   (akMacro,akLed,akTempLed)
    Macro:TMacro;
    IndexUp:integer;
    FirstKeyUp,LastKeyDown:integer;
    ProgLed:TProgLed;

    //Mouse Events  (akMouse)
    MouseButton:TMouseButton;
    MouseAction:TMouseAction;
    //Shell, Specials, etc... (future implementation)
    MacroCombo:boolean;

    constructor Create;
    destructor Destroy; override;
    procedure SaveTo_BasicEvent(AStream:TStream);
    function LoadFrom_BasicEvent(AStream:TStream):boolean;
    procedure SaveTo_MouseEvent(AStream:TStream);
    function LoadFrom_MouseEvent(AStream:TStream):boolean;
  end;

  TProfile=class(TObject)
    private
    FList:array[0..3,Button01..dpSO] of TActionK;
    FFichier: string;
    FGameApp: string;
    FMacroFile: string;
    function GetItem(Level:smallint;Index: TButtons): TActionK;
    procedure SetItem(Level:smallint;Index: TButtons; const Value: TActionK);
    procedure SetFichier(const Value: string);
    procedure SetGameApp(const Value: string);
    procedure SetMacroFile(const Value: string);
  protected
    procedure SaveToStream(AStream:TStream);
    function LoadFromStream(AStream:TStream):boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear; virtual;
    function LoadFromFile:boolean;
    procedure SaveToFile;
    property GameApp:string read FGameApp write SetGameApp;
    property Items[Level:smallint;Index: TButtons]: TActionK read GetItem write SetItem; default;
    property Fichier:string read FFichier write SetFichier;
    property MacroFile:string read FMacroFile write SetMacroFile;
  end;

implementation

{ TProfile }

procedure TProfile.Clear;
var i:TButtons;
    j:smallint;
begin
  for j := 0 to 3 do
  for i:=low(TButtons) to high(TButtons) do
  begin
    FList[j,i].ActionKind:=akNone;
    FList[j,i].ProgLed:=PLNext;
    FList[j,i].Macro.Clear;
  end;
end;

constructor TProfile.Create;
var i:TButtons;
    j:smallint;
begin
  FFichier:='';
  for j := 0 to 3 do
  for i:=low(TButtons) to high(TButtons) do
  begin
    FList[j,i]:=TActionK.Create;
  end;
end;

destructor TProfile.Destroy;
var i:TButtons;
    j:smallint;
begin
  for j := 0 to 3 do
  for i:=low(TButtons) to high(TButtons) do
  begin
    FList[j,i].Free;
  end;

  inherited;
end;

function TProfile.GetItem(Level:smallint;Index: TButtons): TActionK;
begin
  Result:=FList[Level,index];
end;

function TProfile.LoadFromFile: boolean;
var AFS:TFileStream;
begin
  result:=false;
  if not FileExists(Fichier) then exit;
  AFS:=TFileStream.Create(Fichier,fmOpenRead);
  try
    result:=LoadFromStream(AFS);
  finally
    AFS.Free;
  end;
end;

function TProfile.LoadFromStream(AStream: TStream): boolean;
var i:TButtons;
    AnActionK:TActionK;
    j:smallint;
begin
  try
    result:=true;
    Clear;
    FGameApp:=ReadStreamString(AStream);
    FMacroFile:=ReadStreamString(AStream);
    for j := 0 to 3 do
      for i:=Button01 to dpSO do
      begin
        AnActionK:=Items[j,i];
        AStream.Read(AnActionK.ActionKind,sizeof(TActionKind));
        case AnActionK.ActionKind of
          akNone,akMacro,akLed,akTempLed:AnActionK.LoadFrom_BasicEvent(AStream);
          akMouseButton:AnActionK.LoadFrom_MouseEvent(AStream);
        end;
      end;
  except
    Result:=false;
  end;

end;

procedure TProfile.SaveToFile;
var AFS:TFileStream;
begin
  if FileExists(FFichier) then DeleteFile(fichier);
  AFS:=TFileStream.Create(Fichier,fmCreate);
  try
    SaveToStream(AFS);
  finally
    AFS.Free;
  end;
end;

procedure TProfile.SaveToStream(AStream: TStream);
var i:TButtons;
    AnActionK:TActionK;
    j:smallint;
begin
  WriteStreamString(AStream,FGameApp);
  WriteStreamString(AStream,FMacroFile);
  for j := 0 to 3 do
  for i:=Button01 to dpSO do
  begin
    AnActionK:=Items[j,i];
    AStream.Write(AnActionK.ActionKind,sizeof(TActionKind));
    case AnActionK.ActionKind of
      akNone,akMacro,akLed,akTempLed:AnActionK.SaveTo_BasicEvent(AStream);
      akMouseButton:AnActionK.SaveTo_MouseEvent(AStream);
     end;
  end;
end;

procedure TProfile.SetFichier(const Value: string);
begin
  FFichier := Value;
end;

procedure TProfile.SetGameApp(const Value: string);
begin
  FGameApp := Value;
end;

procedure TProfile.SetItem(Level:smallint;Index: TButtons; const Value: TActionK);
begin
  FList[level,index]:= value;
end;

procedure TProfile.SetMacroFile(const Value: string);
begin
  FMacroFile := Value;
end;

{ TActionK }

constructor TActionK.Create;
begin
  ActionKind:=akNone;
  ProgLed:=PLNext;
  Macro:=TMacro.Create;
  MouseButton:=mbLeft;
end;

destructor TActionK.Destroy;
begin
  Macro.Free;
  inherited;
end;

function TActionK.LoadFrom_BasicEvent(AStream: TStream): boolean;
begin
   Result:=true;
   AStream.Read(ProgLed,sizeof(TProgLed));
   AStream.Read(RepeatAction,sizeof(boolean));
   AStream.Read(RepeatTime,sizeof(cardinal));
   Macro.LoadFromStream(AStream);
end;

function TActionK.LoadFrom_MouseEvent(AStream: TStream): boolean;
begin
  Result:=true;
  AStream.Read(MouseButton,sizeof(TMouseButton));
  AStream.Read(MouseAction,sizeof(MouseAction));
end;

procedure TActionK.SaveTo_BasicEvent(AStream: TStream);
begin
   AStream.Write(ProgLed,sizeof(TProgLed));
   AStream.Write(RepeatAction,sizeof(boolean));
   AStream.Write(RepeatTime,sizeof(cardinal));
   Macro.SaveToStream(AStream);
end;

procedure TActionK.SaveTo_MouseEvent(AStream: TStream);
begin
  AStream.Write(MouseButton,sizeof(TMouseButton));
  AStream.Write(MouseAction,sizeof(MouseAction));
end;

end.
