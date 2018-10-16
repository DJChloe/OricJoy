unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, GIFImg, Vcl.ComCtrls,
  System.ImageList, Vcl.ImgList, System.Generics.Collections,inifiles,
  typinfo,ShellApi, Vcl.Buttons, IPPeerClient, REST.Backend.ParseProvider,
  ES.BaseControls, ES.Switch,mmsystem, JvComponentBase, JvCreateProcess,
  JvShellHook, JvExStdCtrls, JvHtControls;

const
  j_up=0;
  j_down=1;
  j_left=2;
  j_right=3;
  j_b=3;
  j_upleft=36;
  j_upright=37;
  j_downleft=38;
  j_downright=39;
  b_up=1;
  b_down=2;
  b_left=4;
  b_right=8;
  b_upleft=b_up+b_left;
  b_upright=b_up+b_right;
  b_downleft=b_down+b_left;
  b_downright=b_down+b_right;

  ButtonCodes:array[1..12] of cardinal=
  (JOY_BUTTON1,JOY_BUTTON2,JOY_BUTTON3,JOY_BUTTON4,JOY_BUTTON5,JOY_BUTTON6,
  JOY_BUTTON7,JOY_BUTTON8,JOY_BUTTON9,JOY_BUTTON10,JOY_BUTTON11,JOY_BUTTON12);
type
  Tfilekind=(fktape,fkdisk,fkwav);
  TGame=record
    Name,filename,img:string;
    Commands:array[j_up..j_downright] of byte;
    filekind:Tfilekind;
    keepdown:byte;
  end;

  Tf_main = class(TForm)
    JoyState: TLabel;
    ImageList1: TImageList;
    ListView1: TListView;
    JoyTimer: TTimer;
    Memo1: TMemo;
    Panel1: TPanel;
    EsSwitch1: TEsSwitch;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    GridPanel1: TGridPanel;
    jup: TStaticText;
    jleft: TStaticText;
    jb1: TStaticText;
    jb3: TStaticText;
    jb5: TStaticText;
    jb7: TStaticText;
    jb9: TStaticText;
    jdown: TStaticText;
    jright: TStaticText;
    jb2: TStaticText;
    jb4: TStaticText;
    jb11: TStaticText;
    jb6: TStaticText;
    jb8: TStaticText;
    jb10: TStaticText;
    jb12: TStaticText;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure JoyTimerTimer(Sender: TObject);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  private
    { Déclarations privées }
    games:TList<TGame>;
    apath:string;
    Commands:array[j_up..j_downright] of byte;
    KStates:array[j_up..j_downright] of boolean;
    keepdown:integer;
    lastbutton:integer;
    gametoplay:integer;
    FProfilActif: boolean;
    SEInfo: TShellExecuteInfo;
    ExitCode: DWORD;
    restorestate:TWindowState;
    procedure CreateThumbnails;
    procedure CreateListItems;
    procedure SetProfilActif(const Value: boolean);
    procedure resetJoykeys;
    procedure executejoykey(joybutton:byte;pressed:boolean);
    procedure play;
  public
    { Déclarations publiques }
    property ProfilActif:boolean read FProfilActif write SetProfilActif;
  end;

var
  f_main: Tf_main;

implementation

{$R *.dfm}
uses unitkeyb,UnitSystem,pngimage,Jpeg;
const
  THUMB_WIDTH = 120;
  THUMB_HEIGHT = 120;
  THUMB_PADDING = 4;
  oricutronpath='Oricutron';
  oricutron=oricutronpath+'\oricutron.exe';


function SafeCloseHandle(var H: hwnd): Boolean;
begin
  if H <> 0 then
  begin
    Result := CloseHandle(H);
    if Result then
      H := 0;
  end
  else
    Result := True;
end;

procedure GetSubDirs(const sRootDir: string; slt: TStrings);
var
  srSearch: TSearchRec;
  sSearchPath: string;
  sltSub: TStrings;
begin
  sltSub := TStringList.Create;
  slt.BeginUpdate;
  try
    sSearchPath := includetrailingbackslash(sRootDir);
    if FindFirst(sSearchPath + '*', faDirectory, srSearch) = 0 then
      repeat
        if ((srSearch.Attr and faDirectory) = faDirectory) and
          (srSearch.Name <> '.') and
          (srSearch.Name <> '..') then
          slt.Add(srSearch.Name);
      until (FindNext(srSearch) <> 0);

    FindClose(srSearch);

  finally
    slt.EndUpdate;
    FreeAndNil(sltSub);
  end;
end;

function findfile(const PathName,Extensions:string; var filename:string):boolean;
const
  FileMask = '*.*';
var
  Rec: TSearchRec;
  Path: string;
  lstFiles: TStringList;
begin
  lstFiles:=TStringList.Create;
  result:=False;
  filename:='';
  Path := IncludeTrailingBackslash(PathName);
  if FindFirst(Path + FileMask, faAnyFile - faDirectory, Rec) = 0 then
    try
      repeat
        if AnsiPos(lowercase(ExtractFileExt(Rec.Name)), Extensions) > 0 then
          lstFiles.Add(Path + Rec.Name);
      until FindNext(Rec) <> 0;
    finally
      SysUtils.FindClose(Rec);
    end;

    if lstfiles.Count>0 then
    begin
       result:=true;
       filename:=lstFiles.Strings[0];
    end;
    lstFiles.Free;
end;

function tovk(s:string):byte;
var t:string;
    sc:byte;
begin
  t:=lowercase(s);
  if t='up' then result:=vk_up
  else if t='down' then result:=vk_down
  else if t='left' then result:=vk_left
  else if t='right' then result:=vk_right
  else if t='space' then result:=vk_space
  else if t='del' then result:=VK_BACK
  else if t='ctrl' then result:=VK_LCONTROL
  else if t='return' then result:=VK_RETURN
  else if t='shift' then result:=VK_LSHIFT
  else if t='lshift' then result:=VK_LSHIFT
  else if t='rshift' then result:=VK_RSHIFT
  else if t='esc' then result:=VK_ESCAPE


  else if length(t)=1 then
  begin
    sc:=OricToSC(t[1]);
    result:=MapVirtualKey(sc,1);//VkKeyScan(s[1]);
  end
  else result:=0;

end;

procedure Tf_main.resetJoykeys;
var i:byte;
begin
  for i := j_up to j_downright do
  begin
    KStates[i]:=false;
    SimulateKeyUp(commands[i]);
  end;
  lastbutton:=-1;
end;
procedure Tf_main.executejoykey(joybutton:byte;pressed:boolean);
var Acolor:Tcolor;
Abutton:TStatictext;
componame:string;
i:integer;
begin
  Abutton:=nil;
  if KStates[joybutton]<>pressed then
  begin
    KStates[joybutton]:=pressed;
    if ((commands[joybutton]<>0) and FProfilActif and (commands[joybutton]<>0)) then
    case pressed of
      true:begin
             if (keepdown=1) then begin
                if (i<>joybutton)
                   then SimulateKeyUp(commands[lastbutton]);
             end;
             lastbutton:=joybutton;
             SimulateKeydown(commands[joybutton]);
           end;
      false:if (keepdown=0) then SimulateKeyUp(commands[joybutton])
            else begin
              if ((joybutton>3) and (joybutton<36)) then
              SimulateKeyUp(commands[joybutton]);
            end;
    end;
  end;
  if pressed
  then acolor:=clred
  else acolor:=clwhite;

  case joybutton of
    j_up:Abutton:=jup;
    j_down:Abutton:=jdown;
    j_left:Abutton:=jleft;
    j_right:Abutton:=jright;
    (j_b+1)..(j_b+12):begin
       componame:='jb'+IntToStr(joybutton-j_b);
       Abutton:=(FindComponent(componame) as TStaticText);
    end;
  end;

  if assigned(Abutton) then Abutton.Color:=Acolor;
end;

procedure Tf_main.FormCreate(Sender: TObject);
var asl:tstringlist;
    agame:tgame;
    i,j:Integer;
    found:Boolean;
    commandlist:Tstringlist;
    gamepath:string;
    s:string;
begin
  ProfilActif:=false;
  games:=TList<TGame>.create;
  apath:=IncludeTrailingBackslash(extractfilepath(application.exename));
  asl:=tstringlist.create;
  GetSubDirs(apath+'games\',asl);
  found:=True;
  for i := 0 to asl.count-1 do
  begin
    agame.name:=asl.strings[i];
    gamepath:=apath+'games\'+agame.name;

    for j := j_up to j_downright do agame.commands[j]:=0;
    keepdown:=0;

    found:=found and findfile(gamepath,'.tap;.dsk',agame.filename);
    if found then
       found:=found and findfile(gamepath,'.jpg;.jpeg;.bmp;.png',agame.img);
    if found then
       found:=found and fileexists(gamepath+'\commands.txt');
    if found then
    begin
      commandlist:=Tstringlist.Create;
      commandlist.loadfromfile(gamepath+'\commands.txt');
      s:=commandlist.values['up'];
      agame.commands[j_up]:=tovk(s);
      s:=commandlist.values['down'];
      agame.commands[j_down]:=tovk(s);
      s:=commandlist.values['left'];
      agame.commands[j_left]:=tovk(s);
      s:=commandlist.values['right'];
      agame.commands[j_right]:=tovk(s);
      s:=commandlist.values['up-left'];
      agame.commands[j_upleft]:=tovk(s);
      s:=commandlist.values['down-left'];
      agame.commands[j_downleft]:=tovk(s);
      s:=commandlist.values['up-right'];
      agame.commands[j_upright]:=tovk(s);
      s:=commandlist.values['down-right'];
      agame.commands[j_downright]:=tovk(s);
      s:=commandlist.values['keepdown'];
      j:=StrToIntDef(s,0);
      if j>1 then j:=1;
      agame.keepdown:=j;
      for j := 1 to 12 do
      begin
      s:=commandlist.values['b'+inttostr(j)];
      agame.commands[j_b+j]:=tovk(s);
      end;
      commandlist.free;
      games.add(agame);
    end;
  end;
  asl.Free;
end;

procedure Tf_main.FormDestroy(Sender: TObject);
begin
  games.free;
end;

procedure Tf_main.FormShow(Sender: TObject);
begin
  ImageList1.Width:=THUMB_WIDTH+10;
  ImageList1.Height:=THUMB_HEIGHT+10;
  CreateThumbnails;
  CreateListItems;
  JoyTimer.Enabled:=true;
end;

procedure Tf_main.JoyTimerTimer(Sender: TObject);
var JoyInfo : JOYINFOEX;
    Result : MMRESULT;
    i:byte;
    jpov:cardinal;
    direction:byte;
begin
  if ProfilActif then
  begin
  GetExitCodeProcess(SEInfo.hProcess, ExitCode);
  if (ExitCode <> STILL_ACTIVE)
  then begin
         ProfilActif:=false;
         WindowState:=restorestate;
         Application.BringToFront;
         BringToFront;
         //BringWindowToTop(Application.h)
  end;
  end;
  // On calcule la taille de la structure
  JoyInfo.dwSize := SizeOf(JoyInfo);
  // JOY_RETURNALL equivaut à activer tous les bots JOY_RETURN sauf JOY_RETURNRAWDATA
  JoyInfo.dwFlags := JOY_RETURNALL;
  // Interroge la manette sur l'état et le statut de ses boutons
  Result := JoyGetPosEx(JOYSTICKID1, @JoyInfo);
  // Si tout s'est bien passé, le joystick est prêt à être testé
  if Result = JOYERR_NOERROR then JoyState.Caption := 'Joystick OK'
  else begin
  // Sinon on indique le type d'erreur
      case Result of
        MMSYSERR_NODRIVER    : JoyState.Caption := 'Joystick driver is not installed';
        MMSYSERR_INVALPARAM  : JoyState.Caption := 'Invalid Parameter';
        MMSYSERR_BADDEVICEID : JoyState.Caption := 'Bad Joystick ID';
        JOYERR_UNPLUGGED     : JoyState.Caption := 'Joystick not connected';
        JOYERR_PARMS         : JoyState.Caption := 'No joystick, invalide parameter';
      end;
      exit;
  end;

 //if (not ProfilActif) then exit;
 for i := 1 to 12 do
     executejoykey(j_b+i,(ButtonCodes[i] and JoyInfo.wButtons)= ButtonCodes[i]);

 // On teste la manette de gauche
 //if JoyInfo.wXpos and JoyInfo.wYpos <> 32767 then JoyL.Brush.Color:= clRed
 //else JoyL.Brush.Color:= clBlack;
// On teste la manette de droite
// if JoyInfo.wZpos and JoyInfo.dwRpos <> 32767 then JoyR.Brush.Color:= clRed
// else JoyR.Brush.Color:= clBlack;
// On teste si le POV est en avant
if EsSwitch1.Checked then
begin
 executejoykey(j_up,(JoyInfo.wYpos < 26767));
// On teste si le POV est à droite
 executejoykey(j_right,(JoyInfo.wXpos > 38767));
// On teste si le POV est à gauche
 executejoykey(j_left,(JoyInfo.wXpos < 26767));
// On teste si le POV est en arrière
 executejoykey(j_down,(JoyInfo.wYpos > 38767));

 executejoykey(j_upleft,(JoyInfo.wYpos < 26767) and (JoyInfo.wXpos < 26767));
 executejoykey(j_upright,(JoyInfo.wYpos < 26767) and (JoyInfo.wXpos > 38767));
 executejoykey(j_downleft,(JoyInfo.wYpos >38767) and (JoyInfo.wXpos < 26767));
 executejoykey(j_downright,(JoyInfo.wYpos >38767) and (JoyInfo.wXpos > 38767));
end
else
begin
 // Ici on teste si le Point Of View est centré
 //if (JoyInfo.dwPOV = 65535) then
 //for i := j_up to j_right do executejoykey(i,false);
 // On teste si le POV est en avant
  jpov:=JoyInfo.dwPOV;
  //JoyState.Caption:=IntToStr(jpov);
  direction:=0;
  case jpov of
     0:direction:=b_up;
     4500:direction:=b_up+b_right;
     9000:direction:=b_right;
     13500:direction:=b_right+b_down;
     18000:direction:=b_down;
     22500:direction:=b_down+b_left;
     27000:direction:=b_left;
     31500:direction:=b_left+b_up;
  end;

  executejoykey(j_up,(direction and b_up)=b_up);
  // On teste si le POV est à droite
  executejoykey(j_right,(direction and b_right)=b_right);
  // On teste si le POV est à gauche
  executejoykey(j_left,(direction and b_left)=b_left);
  // On teste si le POV est en arrière
  executejoykey(j_down,(direction and b_down)=b_down);

  executejoykey(j_upleft,direction=b_upleft);
  executejoykey(j_upright,direction=b_upright);
  executejoykey(j_downleft,direction=b_downleft);
  executejoykey(j_downright,direction=b_downright);
end;
end;


procedure Tf_main.play;
var
  so,sop : string;
  selectedItem : TListItem;
  cmdlineparams,extension:string;
  i:byte;
  AGame:TGame;
  Ahandle:hwnd;
  pid:cardinal;
begin
  if ListView1.Selected<>nil then
  begin
    restorestate:=WindowState;
    WindowState:=wsMinimized;
    selectedItem := ListView1.Selected;
    if ProfilActif then

    //do something with the double clicked item!
    gametoplay:=selectedItem.Index;
    agame:=games.items[gametoplay];
    extension:=ExtractFileExt(agame.filename);
    if extension='.tap' then
    cmdlineparams:='-t "'+agame.filename+'" -f'
    else
    cmdlineparams:='-k m -d "'+agame.filename+'" -f';

    for I := j_up to j_downright do Commands[i]:=agame.Commands[i];
    keepdown:=AGame.keepdown;

    so:='"'+apath+oricutron+'"';
    sop:='"'+apath+oricutronpath+'"';


    FillChar(SEInfo, SizeOf(SEInfo), 0) ;
    SEInfo.cbSize := SizeOf(TShellExecuteInfo) ;
    with SEInfo do begin
       fMask := SEE_MASK_NOCLOSEPROCESS;
       Wnd := 0;
       Lpverb:='open';
       lpFile := PChar(so) ;
       lpParameters:=Pwidechar(cmdlineparams);
       lpDirectory := PChar(sop) ;
       nShow := SW_SHOW;
    end;
    if ShellExecuteEx(@SEInfo) then
    begin
     ProfilActif:=true;
     AHandle := OpenProcess(PROCESS_ALL_ACCESS, False, SEInfo.hProcess);
     if AHandle > 0 then
      try
        ForceForegroundWindow(AHandle);
        pid := GetProcessId(SEInfo.hProcess); // SPECIFY PID
        AllowSetForegroundWindow(pid);
        SetForegroundWindow(AHandle);
        SetActiveWindow(AHandle);
      finally
        SafeCloseHandle(AHandle);
      end;

    end
    else ProfilActif:=false;
  end;
end;

procedure Tf_main.ListView1DblClick(Sender: TObject);
begin
  play;
end;

procedure Tf_main.ListView1SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var agame:tgame;
    filename:string;
begin
  if not Selected then exit;

  apath:=IncludeTrailingBackslash(extractfilepath(application.exename));
  gametoplay:=Item.Index;
  agame:=games.items[gametoplay];
  filename:=apath+'games\'+agame.Name+'\teaser.txt';
  if FileExists(filename)
  then memo1.Lines.LoadFromFile(filename)
  else memo1.Lines.clear;
end;

procedure Tf_main.SetProfilActif(const Value: boolean);
var AHandle:HWND;
begin
  if FProfilActif<>Value then
  begin
    FProfilActif := Value;
    resetJoykeys;
    if not FProfilActif then Self.BringToFront
    else begin

     AHandle := OpenProcess(PROCESS_ALL_ACCESS, False, SEInfo.hProcess);
     if AHandle > 0 then
      try
        ForceForegroundWindow(AHandle);
      finally
        SendMessage(AHandle,WM_CLOSE,0,0);
        SafeCloseHandle(AHandle);
      end;
    end;
  end;
end;

procedure Tf_main.CreateListItems;
var
  i: Integer;
begin
  for i := 0 to games.Count - 1 do
  begin
    with ListView1.Items.Add do
    begin
      Caption := games.Items[i].Name;
      ImageIndex := i;
    end;
  end;
end;

procedure Tf_main.CreateThumbnails;
var
  i: Integer;
  FJpeg: TJpegImage;
  Fpng:TPngImage;
  thumb1,thumb2:Tbitmap;
  R: TRect;
  extension:string;
  agame:TGame;
begin
  for i := 0 to games.Count - 1 do
  begin
      agame:=games.Items[i];

      extension:=ExtractFileExt(agame.img);
      thumb1 := TBitmap.Create;
      thumb2 := TBitmap.Create;
      if ((extension='.jpg') or (extension='.jpeg')) then
      begin
        FJpeg := TJpegImage.Create;
        FJpeg.LoadFromFile(agame.img);
        thumb1.Assign(FJpeg);
        FJpeg.Free;
      end else if (extension='.png') then
      begin
        Fpng:=TPngImage.Create;
        Fpng.LoadFromFile(agame.img);
        thumb1.Assign(Fpng);
        Fpng.Free;
      end else
      thumb1.LoadFromFile(agame.img);
      //resize code
      ResizeBitmap(thumb1,THUMB_WIDTH, THUMB_HEIGHT,clwhite);
      R.top:=5;
      R.Left:=5;
      R.Bottom:=THUMB_HEIGHT+5;
      R.Right:=THUMB_WIDTH+5;
      thumb2.SetSize(THUMB_WIDTH+10, THUMB_HEIGHT+10);
      thumb2.Canvas.FloodFill(0,0,clwhite,fsSurface);
      thumb2.Canvas.StretchDraw(R, thumb1);
      //all images must be same size for listview
      ImageList1.Add(thumb2, nil);
      thumb1.free;
  end;
  ListView1.LargeImages := ImageList1;

end;

end.
