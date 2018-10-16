unit UnitSystem;
interface
uses Forms,Windows,classes,Graphics,StdCtrls;
type
  TMouseButtons=(BoutonGauche,BoutonDroit,LesDeuxBoutons);
//Simulation du clic sur l'écran : cliques réellement (déplace la souris)
procedure MouseClickOnScreen(Boutons:TMouseButtons;APoint: TPoint);
//Simulation du clic sur l'écran : clic virtuel (ne déplace pas la souris)
procedure VirtualMouseClickOnWindow(AWindowHandle:HWND;Boutons:TMouseButtons;APoint: TPoint);

//Boutons de souris inversés ??
function LeftHandledMouseConfig:Boolean;

//Activation d'une fenètre (clic sur sa barre de titre)
procedure ActiverFenetre(AHandle:HWND);

//Fermeture d'une application
procedure FermerApplication(AHandle:HWND);

//Simulation d'appui de touches (fonctionnent sur une fenêtre active)
procedure SimulateKeyDown(Key : byte);
procedure SimulateKeyUp(Key : byte);
procedure SimulateKeystroke(Key : byte; extra : DWORD);
procedure SendKeys(s : string);
procedure ResizeBitmap(Bitmap: TBitmap; Width, Height: Integer; Background: TColor);
function ApplicationDirectory:string;
function FindWindowByTitle(WindowTitle: string): Hwnd;
function ForceForegroundWindow(hwnd: THandle): Boolean;
implementation
uses types,SysUtils,Messages,registry;

procedure VirtualMouseClickOnWindow(AWindowHandle:HWND;Boutons:TMouseButtons;APoint: TPoint);
var BoutonsSelonConfig:TMouseButtons;
    ou_ca:cardinal;
begin
  {Positionne la souris}
  ou_ca:=APoint.X+APoint.Y shl 16;

  BoutonsSelonConfig:=Boutons;
  {si on est dans une configuration de gaucher, les boutons sont inversés}
  if LeftHandledMouseConfig
  then begin
         if Boutons=BoutonGauche
         then BoutonsSelonConfig:=BoutonDroit;
         if Boutons=BoutonDroit
         then BoutonsSelonConfig:=BoutonGauche;
       end;
  {Et cliques dessus }
  case BoutonsSelonConfig of
    BoutonGauche:begin
             PostMessage(AWindowHandle, WM_LBUTTONDOWN,0,ou_ca);
             PostMessage(AWindowHandle, WM_LBUTTONUP,0,ou_ca);
           end;
    BoutonDroit:begin
             PostMessage(AWindowHandle, WM_RBUTTONDOWN,0,ou_ca);
             PostMessage(AWindowHandle, WM_RBUTTONUP,0,ou_ca);
           end;
    LesDeuxBoutons:begin
             PostMessage(AWindowHandle, WM_LBUTTONDOWN,0,ou_ca);
             PostMessage(AWindowHandle, WM_RBUTTONDOWN,0,ou_ca);
             PostMessage(AWindowHandle, WM_RBUTTONUP,0,ou_ca);
             PostMessage(AWindowHandle, WM_LBUTTONUP,0,ou_ca);
           end;
  end;
end;

procedure MouseClickOnScreen(Boutons:TMouseButtons;APoint: TPoint);
var BoutonsSelonConfig:TMouseButtons;
begin
  {Positionne la souris}
  SetCursorPos(APoint.X,APoint.Y);
  BoutonsSelonConfig:=Boutons;

  {si on est dans une configuration de gaucher, les boutons sont inversés}
  if LeftHandledMouseConfig
  then begin
         if Boutons=BoutonGauche
         then BoutonsSelonConfig:=BoutonDroit;
         if Boutons=BoutonDroit
         then BoutonsSelonConfig:=BoutonGauche;
       end;
  {Et cliques dessus }
  case BoutonsSelonConfig of
    BoutonGauche:begin
             mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
             mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
           end;
    BoutonDroit:begin
             mouse_event(MOUSEEVENTF_RIGHTDOWN, 0, 0, 0, 0);
             mouse_event(MOUSEEVENTF_RIGHTUP, 0, 0, 0, 0);
           end;
    LesDeuxBoutons:begin
             mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
             mouse_event(MOUSEEVENTF_RIGHTDOWN, 0, 0, 0, 0);
             mouse_event(MOUSEEVENTF_RIGHTUP, 0, 0, 0, 0);
             mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
           end;
  end;
end;

procedure ActiverFenetre(AHandle:HWND);
var ARect:TRect;
begin
  //si la fenètre est cachée, on la montre
  if not IsWindowVisible(AHandle)
  then ShowWindow(AHandle,SW_SHOW);

  //on récupère le "rectangle" de la fenètre, en coordonnées écran
  GetWindowRect(AHandle,ARect);
  //on clique sur la barre de titre
  MouseClickOnScreen(BoutonGauche,Point(ARect.Left+50,ARect.Top+5));
  //la fenètre est activée, même si on est pas propriétaire du thread
  //(échec de l'API Windows SetActiveWindow et SetFocus dans ce cas)
end;

procedure FermerApplication(AHandle:HWND);
begin
  SendMessage(AHandle,WM_CLOSE,0,0);
end;

function FindWindowByTitle(WindowTitle: string): Hwnd;
var
  NextHandle: Hwnd;
  NextTitle: array[0..260] of char;
begin
  // Get the first window
  NextHandle := GetWindow(Application.Handle, GW_HWNDFIRST);
  while NextHandle > 0 do
  begin
    // retrieve its text
    GetWindowText(NextHandle, NextTitle, 255);
    if Pos(WindowTitle, StrPas(NextTitle)) <> 0 then
    begin
      Result := NextHandle;
      Exit;
    end
    else
      // Get the next window
      NextHandle := GetWindow(NextHandle, GW_HWNDNEXT);
  end;
  Result := 0;
end;


procedure SimulateKeyDown(Key : byte);
begin
  if (Key = VK_UP)
or (Key = VK_DOWN)
or (Key = VK_LEFT)
or (Key = VK_RIGHT)
or (Key = VK_HOME)
or (Key = VK_END)
or (Key = VK_PRIOR)
or (Key = VK_NEXT)
or (Key = VK_INSERT)
or (Key = VK_DELETE) then
  keybd_event(Key, MapVirtualKey(key,0), KEYEVENTF_EXTENDEDKEY, 0)
else keybd_event(Key, MapVirtualKey(key,0), 0, 0);
end;

procedure SimulateKeyUp(Key : byte);
begin
if (Key = VK_UP)
or (Key = VK_DOWN)
or (Key = VK_LEFT)
or (Key = VK_RIGHT)
or (Key = VK_HOME)
or (Key = VK_END)
or (Key = VK_PRIOR)
or (Key = VK_NEXT)
or (Key = VK_INSERT)
or (Key = VK_DELETE) then
keybd_event(Key, MapVirtualKey(key,0), KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0)
else  keybd_event(Key, MapVirtualKey(key,0), KEYEVENTF_KEYUP, 0);
end;

procedure SimulateKeystroke(Key : byte; extra : DWORD);
begin
  keybd_event(Key, extra, 0, 0);
  keybd_event(Key, extra, KEYEVENTF_KEYUP, 0);
end;

procedure SendKeys(s : string);
var i : integer;
    flag : bool;
    w : word;
begin
  flag := not GetKeyState(VK_CAPITAL)=1;
  if flag then SimulateKeystroke(VK_CAPITAL, 0);
  for i :=1 to Length(s) do
  begin w := VkKeyScan(s[i]);
  if ((HiByte(w) <> $FF) and (LoByte(w) <> $FF))
  then begin
      if HiByte(w)=1
      then SimulateKeyDown(VK_SHIFT);
      SimulateKeystroke(LoByte(w), 0);
      if HiByte(w)=1
      then SimulateKeyUp(VK_SHIFT);
    end;
  end;
  if flag then SimulateKeystroke(VK_CAPITAL, 0);
end;

function LeftHandledMouseConfig:Boolean;
var registre:TRegistry;
begin
  registre:=TRegistry.Create;
  try
    registre.RootKey:=HKEY_CURRENT_USER;
    Registre.OpenKey('Control Panel\Mouse', False);
    Result := (Registre.ReadString('SwapMouseButtons')='1');
  finally
    registre.Free;
  end;
end;

Procedure ToggleBit(var Value: cardinal; const Bit: byte); Register;
asm
  BTC [eax],edx
end;

procedure SetBit(var Value: cardinal; const Bit: byte); Register;
asm
  BTS [eax],edx
end;

Procedure ClearBit(var Value: cardinal; const Bit: byte); Register;
asm
  BTR [eax],edx
end;

function TestBit(const Value: cardinal; const Bit: byte): Boolean; register;
asm
 BT eax,edx
 setb al
end;

function NumBitsOn(const Value: cardinal; const Bit: byte):byte;
var i,imax:byte;
begin
  Result:=0;
  imax:=bit;
  if imax>31 then imax:=31;
  for i:=0 to imax do
    if TestBit(Value,i) then Inc(Result);
end;

function ApplicationDirectory:string;
begin
  Result:=ExtractFilePath(Application.ExeName);
end;

procedure ResizeBitmap(Bitmap: TBitmap; Width, Height: Integer; Background: TColor);
var
  R: TRect;
  B: TBitmap;
  X, Y: Integer;
begin
  if assigned(Bitmap) then begin
    B:= TBitmap.Create;
    try
      if Bitmap.Width > Bitmap.Height then begin
        R.Right:= Width;
        R.Bottom:= ((Width * Bitmap.Height) div Bitmap.Width);
        X:= 0;
        Y:= (Height div 2) - (R.Bottom div 2);
      end else begin
        R.Right:= ((Height * Bitmap.Width) div Bitmap.Height);
        R.Bottom:= Height;
        X:= (Width div 2) - (R.Right div 2);
        Y:= 0;
      end;
      R.Left:= 0;
      R.Top:= 0;
      B.PixelFormat:= Bitmap.PixelFormat;
      B.Width:= Width;
      B.Height:= Height;
      B.Canvas.Brush.Color:= Background;
      B.Canvas.FillRect(B.Canvas.ClipRect);
      B.Canvas.StretchDraw(R, Bitmap);
      Bitmap.Width:= Width;
      Bitmap.Height:= Height;
      Bitmap.Canvas.Brush.Color:= Background;
      Bitmap.Canvas.FillRect(Bitmap.Canvas.ClipRect);
      Bitmap.Canvas.Draw(X, Y, B);
    finally
      B.Free;
    end;
  end;
end;

function ForceForegroundWindow(hwnd: THandle): Boolean;
const
  SPI_GETFOREGROUNDLOCKTIMEOUT = $2000;
  SPI_SETFOREGROUNDLOCKTIMEOUT = $2001;
var
  ForegroundThreadID: DWORD;
  ThisThreadID: DWORD;
  timeout: DWORD;
begin
  if IsIconic(hwnd) then ShowWindow(hwnd, SW_RESTORE);

  if GetForegroundWindow = hwnd then Result := True
  else
  begin
    // Windows 98/2000 doesn't want to foreground a window when some other
    // window has keyboard focus

    if ((Win32Platform = VER_PLATFORM_WIN32_NT) and (Win32MajorVersion > 4)) or
      ((Win32Platform = VER_PLATFORM_WIN32_WINDOWS) and
      ((Win32MajorVersion > 4) or ((Win32MajorVersion = 4) and
      (Win32MinorVersion > 0)))) then
    begin
      // Code from Karl E. Peterson, www.mvps.org/vb/sample.htm
      // Converted to Delphi by Ray Lischner
      // Published in The Delphi Magazine 55, page 16

      Result := False;
      ForegroundThreadID := GetWindowThreadProcessID(GetForegroundWindow, nil);
      ThisThreadID := GetWindowThreadPRocessId(hwnd, nil);
      if AttachThreadInput(ThisThreadID, ForegroundThreadID, True) then
      begin
        BringWindowToTop(hwnd); // IE 5.5 related hack
        SetForegroundWindow(hwnd);
        AttachThreadInput(ThisThreadID, ForegroundThreadID, False);
        Result := (GetForegroundWindow = hwnd);
      end;
      if not Result then
      begin
        // Code by Daniel P. Stasinski
        SystemParametersInfo(SPI_GETFOREGROUNDLOCKTIMEOUT, 0, @timeout, 0);
        SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(0),
          SPIF_SENDCHANGE);
        BringWindowToTop(hwnd); // IE 5.5 related hack
        SetForegroundWindow(hWnd);
        SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(timeout), SPIF_SENDCHANGE);
      end;
    end
    else
    begin
      BringWindowToTop(hwnd); // IE 5.5 related hack
      SetForegroundWindow(hwnd);
    end;

    Result := (GetForegroundWindow = hwnd);
  end;
end;
end.

