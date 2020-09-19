unit Utiles;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Controls.Presentation, FMX.ListBox, FMX.Edit, FMX.EditBox,
  FMX.NumberBox, UTM_WGS84, FMX.Objects;

type
  TFrmUtiles = class(TFrame)
    LayPrinc: TLayout;
    ToolBar1: TToolBar;
    Label1: TLabel;
    LaySelect: TLayout;
    LayEste: TLayout;
    LayNorte: TLayout;
    LayBConv: TLayout;
    Layout5: TLayout;
    Label2: TLabel;
    CBSeleccion: TComboBox;
    BConvertir: TButton;
    LayEste1: TLayout;
    LayEste2: TLayout;
    LayNorte2: TLayout;
    LayNorte1: TLayout;
    LEste1: TLabel;
    LNorte1: TLabel;
    LEste2: TLabel;
    LNorte2: TLabel;
    LEsteConv1: TLabel;
    LNorteConv1: TLabel;
    LEsteConv2: TLabel;
    LNorteConv2: TLabel;
    LEste: TLabel;
    LNorte: TLabel;
    EEste: TEdit;
    ENorte: TEdit;
    Imagen: TImage;
    ClearEditButton1: TClearEditButton;
    ClearEditButton2: TClearEditButton;
    procedure CBSeleccionChange(Sender: TObject);
    procedure BConvertirClick(Sender: TObject);
    procedure EEsteValidate(Sender: TObject; var Text: string);
    procedure ClearEditButton1Tap(Sender: TObject; const Point: TPointF);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses Principal;

function EliminaEspacio(Cadena: string): string;
begin
  while Pos(' ',Cadena)>0 do Delete(Cadena,Pos(' ',Cadena),1);
  Result:=Cadena;
end;

procedure TFrmUtiles.BConvertirClick(Sender: TObject);
var
  LatLon: TRecLatLon;
  UTM: TRecUTM;
begin
  if (EliminaEspacio(EEste.Text)<>'') and (EliminaEspacio(ENorte.Text)<>'') then
  begin
    case CBSeleccion.ItemIndex of
      0: begin
           LatLon.Lat:=EEste.Text.ToDouble;
           LatLon.Lon:=ENorte.Text.ToDouble;
           LatLon_To_UTM(LatLon,UTM);
           LEsteConv1.Text:=FormatFloat('#0.00',UTM.X);
           LNorteConv1.Text:=FormatFloat('#0.00',UTM.Y);
         end;
      1: begin
           UTM.X:=EEste.Text.ToDouble;
           UTM.Y:=ENorte.Text.ToDouble;
           UTM_To_LatLon(UTM,LatLon);
           LEsteConv1.Text:=FormatFloat('#0.00',LatLon.Lat);
           LNorteConv1.Text:=FormatFloat('#0.00',LatLon.Lon);
           //showmessage(Str_UTM_To_LatLon(UTM));   /////
         end;
    end;
    LEsteConv2.Text:=DecAGrados(LatLon.Lat,true);
    LNorteConv2.Text:=DecAGrados(LatLon.Lon,false);
  end
  else ShowMessage('Debe introducir los datos en ambos campos');
end;

procedure TFrmUtiles.CBSeleccionChange(Sender: TObject);
begin
  case CBSeleccion.ItemIndex of
    0: begin
         LEste.Text:='Latitud:';
         LNorte.Text:='Longitud:';
         LEste1.Text:='Este (X):';
         LNorte1.Text:='Norte (Y):';
       end;
    1: begin
         LEste.Text:='Este (X):';
         LNorte.Text:='Norte (Y):';
         LEste1.Text:='Latitud:';
         LNorte1.Text:='Longitud:';
       end;
  end;
  LEste2.Text:='Latitud:';
  LNorte2.Text:='Longitud:';
  EEste.Text:='';
  ENorte.Text:='';
  LEsteConv1.Text:='';
  LNorteConv1.Text:='';
  LEsteConv2.Text:='';
  LNorteConv2.Text:='';
end;

procedure TFrmUtiles.ClearEditButton1Tap(Sender: TObject; const Point: TPointF);
begin
  TEdit(Sender).Text:='';
end;

procedure TFrmUtiles.EEsteValidate(Sender: TObject; var Text: string);
begin
  if Text.Contains(' ') or Text.Contains(',') or Text.Contains('..') or
     Text.Contains('--') or Text.Contains('-.') or Text.Contains('.-')
     or (Text.IndexOf('-')>0) or (Text.IndexOf('.')=0) or
     (Text.CountChar('-')>1) or (Text.CountChar('.')>1) then
    Text:='';
end;

end.

{function ExisteCaracter(Cadena: string; Letra: char): boolean;
var
  I: byte;
  Existe: boolean;
begin
  for I := 1 to Cadena.Length do
  begin
    Existe:=Cadena[I]=Letra;
    if Existe then Break;
  end;
  Result:=Existe;
end;      }
