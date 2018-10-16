unit UnitMacros;
interface
uses Sysutils, Classes, Contnrs, StdCtrls;
Type
  TTouche=record
    down:boolean;
    VK_code:word;
  end;

//   TMacroKey

  PTTouche = ^TTouche;

  TMacro = class(TObject)
  private
    FList:TList;
    FMacroName: string;
    FMacroID: integer;
    function GetItem(Index: Integer): TTouche;
    procedure SetItem(Index: Integer; const Value: TTouche);
    function GetCount: Integer;
    procedure SetCount(const Value: Integer);
    procedure SetMacroName(const Value: string);
    procedure SetMacroID(const Value: integer);
  public
    constructor Create;
    destructor Destroy; override;
    procedure SaveToStream(AStream:TStream);
    function LoadFromStream(AStream:TStream):boolean;
    function Add(Item:TTouche): Integer;
    procedure Delete(Index: Integer);
    procedure Insert(Index: Integer; Item: TTouche);
    procedure Move(CurIndex, NewIndex: Integer);
    procedure Exchange(Index1, Index2: Integer);
    procedure Clear;
    function IndexOf(const Value: TTouche): Integer;
    property MacroName:string read FMacroName write SetMacroName;
    Property MacroID:integer read FMacroID write SetMacroID;
    property Items[Index:Integer]:TTouche read GetItem write SetItem;default;
    property Count: Integer read GetCount write SetCount;
  end;

  TMacroList = class
  private
    FList: TObjectList;
    FFichier: string;
    FGameApp: string;
    function GetItem(Index: Integer): TMacro;
    function GetCapacity: Integer;
    function GetCount: Integer;
    procedure SetItem(Index: Integer; const Value: TMacro);
    procedure SetCapacity(const Value: Integer);
    procedure SetCount(const Value: Integer);
    function GetOwnsObjects: boolean;
    procedure SetOwnsObjects(const Value: boolean);
    procedure SetFichier(const Value: string);
    procedure SetGameApp(const Value: string);
  protected
    procedure SaveToStream(AStream:TStream);
    function LoadFromStream(AStream:TStream):boolean;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(Item: TMacro): Integer;
    procedure Clear; virtual;
    procedure Delete(Index: Integer);
    procedure Exchange(Index1, Index2: Integer);
    function Expand: TMacroList;
    function Extract(Item: TMacro): TMacro;
    function First: TMacro;
    function IndexOf(Item: TMacro): Integer;
    function IndexOfID(AMacroID:Integer): Integer;
    procedure Insert(Index: Integer; Item: TMacro);
    function Last: TMacro;
    procedure Move(CurIndex, NewIndex: Integer);
    procedure SortByNames;
    function Remove(Item: TMacro): Integer;
    procedure Pack;
    procedure Sort(Compare: TListSortCompare);
    procedure Assign(ListA: TMacroList; AOperator: TListAssignOp = laCopy; ListB: TMacroList = nil);
    property GameApp:string read FGameApp write SetGameApp;
    property Capacity: Integer read GetCapacity write SetCapacity;
    property Count: Integer read GetCount write SetCount;
    property Items[Index: Integer]: TMacro read GetItem write SetItem; default;
    property OwnsObjects: boolean read GetOwnsObjects write SetOwnsObjects;
    property Fichier:string read FFichier write SetFichier;
    function LoadFromFile:boolean;
    procedure SaveToFile;
  end;

{retourne une chaîne de caractères depuis le flux}
procedure WriteStreamString(Stream : TStream; UneChaine : string);
function ReadStreamString(Stream : TStream) : string;
implementation
{ TMacro }

procedure WriteStreamString(Stream : TStream; UneChaine : string);
var LongueurChaine : integer;
begin
  {obtenir la longueur de la chaîne de caractères}
  LongueurChaine := Length(UneChaine);
  {écrire cette longueur dans le flux}
  Stream.Write(LongueurChaine,SizeOf(integer));
  {écrire les caractères (tous d'un coup !)}
  Stream.Write(UneChaine[1], LongueurChaine);
end;

{retourne une chaîne de caractères depuis le flux}
function ReadStreamString(Stream : TStream) : string;
var LongueurChaine : integer;
begin
  {obtenir la longueur de la chaîne de caractères}
  Stream.Read(LongueurChaine,SizeOf(integer));
  {Redimensionner la chaine pour allouer la mémoire nécessaire}
  SetLength(Result, LongueurChaine);
  {Lire les caractères (Tous d'un coup)}
  Stream.Read(Result[1], LongueurChaine);
end;


function TMacro.Add(Item:TTouche): Integer;
var
  p:PTTouche;
begin
  GetMem(p,SizeOf(Item));
  p^ := Item;
  result := FList.Add(p);
end;

procedure TMacro.Clear;
var
  i:integer;
begin
  for i := 0 to FList.Count-1 do FreeMem(FList[i]);
  FList.Clear;
end;

constructor TMacro.Create;
begin
  FList := TList.Create;
end;

procedure TMacro.Delete(Index: Integer);
begin
  FreeMem(FList[Index]);
  FList.Delete(Index);
end;

destructor TMacro.Destroy;
begin
  Clear;
  FList.Free;
  inherited;
end;

procedure TMacro.Exchange(Index1, Index2: Integer);
begin
  FList.Exchange(Index1, Index2);
end;

function TMacro.GetCount: Integer;
begin
  result := FList.Count;
end;

function TMacro.GetItem(Index: Integer): TTouche;
begin
  result := PTTouche(FList[Index])^;
end;

function TMacro.IndexOf(const Value: TTouche): Integer;
var i: Integer;
    found:Boolean;
    AnItem:TTouche;
begin
  Result := -1;
  found:=False;
  i:=0;
  while ((i<FList.Count) and (not found)) do
  begin
    AnItem:=GetItem(i);
    found:=CompareMem(@Value,@AnItem,SizeOf(TTouche));
    if not found then Inc(i);
  end;
  if found then Result:=i;
end;

procedure TMacro.Insert(Index: Integer; Item: TTouche);
var
  p: PTTouche;
begin
  GetMem(p, SizeOf(Item));
  p^ := Item;
  FList.Insert(Index, p);
end;

function TMacro.LoadFromStream(AStream: TStream): boolean;
var NbreTouches,i:integer;
    ATouche:TTouche;
begin
  try
    Result:=true;
    FMacroName:=ReadStreamString(AStream);
    AStream.Read(FMacroID,sizeof(integer));
    AStream.Read(NbreTouches,sizeof(integer));
    for i := 0 to NbreTouches - 1 do
    begin
      AStream.Read(ATouche,sizeof(TTouche));
      add(Atouche);
    end;
  except
    result:=false;
  end;
end;

procedure TMacro.Move(CurIndex, NewIndex: Integer);
begin
  FList.Move(CurIndex, NewIndex);
end;

procedure TMacro.SaveToStream(AStream: TStream);
var NbreTouches,i:integer;
    ATouche:TTouche;
begin
  WriteStreamString(AStream,FMacroName);
  NbreTouches:=Count;
  AStream.Write(FMacroID,SizeOf(integer));
  AStream.Write(NbreTouches,SizeOf(integer));
  for i := 0 to NbreTouches - 1 do
  begin
    Atouche:=Items[i];
    AStream.Write(ATouche,sizeof(TTouche));
  end;

end;

procedure TMacro.SetCount(const Value: Integer);
var
  i, ListCount: Integer;
  p: PTTouche;
begin
  if FList.Count = Value then
    Exit
  else
  if Value < FList.Count then
  begin
    ListCount := FList.Count;
    for i := ListCount downto Value+1 do
    begin
      FList.Delete(i);
    end;
  end else
  if FList.Count < Value then
  begin
    for i := FList.Count+1 to Value do
    begin
      GetMem(p, SizeOf(TTouche));
      FillChar(p^, SizeOf(TTouche), 0);
      FList.Add(p);
    end;
  end;
end;

procedure TMacro.SetItem(Index: Integer; const Value: TTouche);
begin
  PTTouche(FList[Index])^ := value;
end;

procedure TMacro.SetMacroID(const Value: integer);
begin
  FMacroID := Value;
end;

procedure TMacro.SetMacroName(const Value: string);
begin
  FMacroName := Value;
end;

{ TMacroList }
function TMacroList.Add(Item: TMacro): Integer;
var AnID:integer;
begin
  AnID:=0;
  while IndexOfID(AnID)<>-1 do inc(AnID);
  Item.MacroID:=AnID;
  Result := FList.Add(Item);
end;

procedure TMacroList.Assign(ListA: TMacroList; AOperator: TListAssignOp;
  ListB: TMacroList);
begin
  if ListB <> nil then
    FList.Assign(ListA.FList, AOperator, ListB.FList) else
    FList.Assign(ListA.FList);
end;

procedure TMacroList.Clear;
begin
  FList.Clear;
end;

constructor TMacroList.Create;
begin
  FList := TObjectList.Create;
end;

procedure TMacroList.Delete(Index: Integer);
begin
  FList.Delete(Index);
end;

destructor TMacroList.Destroy;
begin
  FList.Free;
  inherited;
end;

procedure TMacroList.Exchange(Index1, Index2: Integer);
begin
  FList.Exchange(Index1, Index2);
end;

function TMacroList.Expand: TMacroList;
begin
  Result := TMacroList(FList.Expand);
end;

function TMacroList.Extract(Item: TMacro): TMacro;
begin
  Result := Extract(Item);
end;

function TMacroList.First: TMacro;
begin
  Result := TMacro(FList.First);
end;

function TMacroList.GetItem(Index: Integer): TMacro;
begin
  Result := TObject(FList[Index]) as TMacro;
end;

function TMacroList.GetCapacity: Integer;
begin
  Result := FList.Capacity;
end;

function TMacroList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TMacroList.IndexOf(Item: TMacro): Integer;
begin
  Result := FList.IndexOf(Item);
end;

function TMacroList.IndexOfID(AMacroID: Integer): Integer;
begin
  Result := 0;
  while (Result < Count) and (Items[Result].MacroID <> AMacroID) do
    Inc(Result);
  if Result = Count then
    Result := -1;
end;

procedure TMacroList.Insert(Index: Integer; Item: TMacro);
begin
  FList.Insert(Index, Item);
end;

function TMacroList.Last: TMacro;
begin
  Result := TMacro(FList.Last);
end;

function TMacroList.LoadFromFile:boolean;
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

function TMacroList.LoadFromStream(AStream: TStream):boolean;
var nbreMacros,i:integer;
    AMacro:TMacro;
begin
  try
    result:=true;
    Clear;
    FGameApp:=ReadStreamString(AStream);
    AStream.Read(nbreMacros,SizeOf(integer));
    for i:=0 to nbreMacros-1 do
    begin
      AMacro:=TMacro.Create;
      AMacro.LoadFromStream(AStream);
      Add(AMacro);
    end;
  except
    Result:=false;
  end;
end;

procedure TMacroList.Move(CurIndex, NewIndex: Integer);
begin
  FList.Move(CurIndex, NewIndex);
end;

procedure TMacroList.Pack;
begin
  FList.Pack;
end;

procedure TMacroList.SetItem(Index: Integer; const Value: TMacro);
begin
  FList.Items[Index] := Value;
end;

function TMacroList.Remove(Item: TMacro): Integer;
begin
  Result := FList.Remove(Item);
end;

procedure TMacroList.SaveToFile;
var AFS:TFileStream;
begin
  SortByNames;
  if FileExists(FFichier) then DeleteFile(fichier);
  AFS:=TFileStream.Create(Fichier,fmCreate);
  try
    SaveToStream(AFS);
  finally
    AFS.Free;
  end;
end;

procedure TMacroList.SaveToStream(AStream: TStream);
var nbreMacros,i:integer;
    AMacro:TMacro;
begin
  WriteStreamString(AStream,FGameApp);
  nbreMacros:=Count;
  AStream.Write(nbreMacros,SizeOf(integer));
  for i:=0 to nbreMacros-1 do
  begin
    AMacro:=Items[i];
    AMacro.SaveToStream(AStream);
  end;
end;

procedure TMacroList.SetCapacity(const Value: Integer);
begin
  FList.Capacity := Value;
end;

procedure TMacroList.SetCount(const Value: Integer);
begin
  FList.Count := Value;
end;

procedure TMacroList.SetFichier(const Value: string);
begin
  FFichier := Value;
end;

procedure TMacroList.SetGameApp(const Value: string);
begin
  FGameApp := Value;
end;

procedure TMacroList.Sort(Compare: TListSortCompare);
begin
  FList.Sort(Compare);
end;


function TMacroList.GetOwnsObjects: boolean;
begin
  Result := FList.OwnsObjects;
end;

procedure TMacroList.SetOwnsObjects(const Value: boolean);
begin
  FList.OwnsObjects := Value;
end;

procedure TMacroList.SortByNames;
function CompareNames(Item1, Item2: Pointer): Integer;
begin
  Result := CompareText(TMacro(Item1).MacroName, TMacro(Item2).MacroName);
end;
begin
  Sort(@CompareNames);
end;

end.
