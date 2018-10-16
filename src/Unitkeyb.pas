unit Unitkeyb;

interface
uses windows,sysutils;
// touche oric-or_sc->scancode-maptokey->vk_pc

const
VK_A = 65;	VK_B = 66;	VK_C = 67;	VK_D = 68;	VK_E = 69;
VK_F = 70;	VK_G = 71;	VK_H = 72;	VK_I = 73;	VK_J = 74;
VK_K = 75;	VK_L = 76;	VK_M = 77;	VK_N = 78;	VK_O = 79;
VK_P = 80;	VK_Q = 81;	VK_R = 82;	VK_S = 83;	VK_T = 84;
VK_U = 85;	VK_V = 86;	VK_W = 87;	VK_X = 88;	VK_Y = 89;
VK_Z = 90;
VK_0 = 48;	VK_1 = 49;	VK_2 = 50;	VK_3 = 51;	VK_4 = 52;
VK_5 = 53;	VK_6 = 54;	VK_7 = 55;	VK_8 = 56;	VK_9 = 57;

function OricToSC(s:string):byte;


implementation
function OricToSC(s:string):byte;
var achar:char;
    t:string;

begin
 t:=LowerCase(s);
 result:=0;
 if Length(t)=1 then
 begin
   achar:=t[1];
   case achar of
     '1'..'9':result:=ord(achar)-ord('1')+2;
     '0':result:=$0B;
     '=':result:=$0C;
     '\':result:=$0D;
     'q':result:=$10;
     'w':result:=$11;
     'e':result:=$12;
     'r':result:=$13;
     't':result:=$14;
     'y':result:=$15;
     'u':result:=$16;
     'i':result:=$17;
     'o':result:=$18;
     'p':result:=$19;
     '[':result:=$1A;
     ']':result:=$1B;
     'a':result:=$1E;
     's':result:=$1F;
     'd':result:=$20;
     'f':result:=$21;
     'g':result:=$22;
     'h':result:=$23;
     'j':result:=$24;
     'k':result:=$25;
     'l':result:=$26;
     ';',':':result:=$27;
     '''','"':result:=$28;
     'z':result:=$2C;
     'x':result:=$2D;
     'c':result:=$2E;
     'v':result:=$2F;
     'b':result:=$30;
     'n':result:=$31;
     'm':result:=$32;
     ',','<':result:=$33;
     '.','>':result:=$34;
     '/','?':result:=$35;
   end
   end else
   begin
     if t='esc' then result:=$01
     else if t='del' then result:=$0E
     else if t='ctrl' then result:=$1D
     else if t='return' then result:=$1C
     else if t='shift' then result:=$2A
     else if t='lshift' then result:=$2A
     else if t='rshift' then result:=$36
     else if t='left' then result:=$01
     else if t='down' then result:=$01
     else if t='space' then result:=$39
     else if t='up' then result:=$36
     else if t='right' then result:=$01;
   end;
end;
end.
