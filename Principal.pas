unit Principal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.StdCtrls, FMX.Controls.Presentation, System.Sensors, FMX.Platform.Android,
  System.Sensors.Components, FMX.TabControl, UTM_WGS84, Utiles, Acerca, Brujula,
  FMX.Effects, Androidapi.JNI.Location;

type
  TFPrinc = class(TForm)
    VertScrollBox: TVertScrollBox;
    LayPrincipal: TLayout;
    ToolBarTop: TToolBar;
    Label1: TLabel;
    StyleBook: TStyleBook;
    TabControl: TTabControl;
    TabGPS: TTabItem;
    TabUtiles: TTabItem;
    TabAcerca: TTabItem;
    FramedVertScrollBox1: TFramedVertScrollBox;
    Layout2: TLayout;
    Layout3: TLayout;
    Layout4: TLayout;
    Layout5: TLayout;
    Layout6: TLayout;
    ToolBarBottom: TToolBar;
    SBSalir: TSpeedButton;
    LActivar: TLabel;
    SwitchGPS: TSwitch;
    Label3: TLabel;
    Label4: TLabel;
    LEste: TLabel;
    Label6: TLabel;
    LNorte: TLabel;
    Label8: TLabel;
    Layout7: TLayout;
    Label9: TLabel;
    LLon: TLabel;
    Layout8: TLayout;
    Label11: TLabel;
    LLat: TLabel;
    FrmUtiles1: TFrmUtiles;
    Layout9: TLayout;
    Label2: TLabel;
    Layout10: TLayout;
    Label5: TLabel;
    LLatGMS: TLabel;
    Layout11: TLayout;
    Label7: TLabel;
    LLonGMS: TLabel;
    FramedVertScrollBox3: TFramedVertScrollBox;
    FramedVertScrollBox2: TFramedVertScrollBox;
    FrmAcerca1: TFrmAcerca;
    TabBrujula: TTabItem;
    FrmBrujula1: TFrmBrujula;
    LctSensor: TLocationSensor;
    procedure SBSalirClick(Sender: TObject);
    procedure SwitchGPSSwitch(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LctSensorLocationChanged(Sender: TObject; const OldLocation,
      NewLocation: TLocationCoord2D);
    procedure FrmBrujula1SwitchSwitch(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  Chartreuse=$FF7FFF00;
  Rojo=$FFFF0000;

var
  FPrinc: TFPrinc;
  LDecSeparator: char;

implementation

uses
  System.Permissions, FMX.DialogService;

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}
{$R *.NmXhdpiPh.fmx ANDROID}

procedure TFPrinc.FormCreate(Sender: TObject);
begin
  TabControl.ActiveTab:=TabGPS;
end;

procedure TFPrinc.FrmBrujula1SwitchSwitch(Sender: TObject);
begin
  FrmBrujula1.SwitchSwitch(Sender);
end;

procedure TFPrinc.LctSensorLocationChanged(Sender: TObject; const OldLocation,
  NewLocation: TLocationCoord2D);
var
  LatLon: TRecLatLon;
  UTM: TRecUTM;
begin
  //muestra la posición actual:
  LatLon.Lat:=NewLocation.Latitude;
  LatLon.Lon:=NewLocation.Longitude;
  LatLon_To_UTM(LatLon,UTM);
  LLat.Text:=Format('%2.6f',[NewLocation.Latitude]);
  LLon.Text:=Format('%2.6f',[NewLocation.Longitude]);
  LEste.Text:=FormatFloat('#0.00',UTM.X);
  LNorte.Text:=FormatFloat('#0.00',UTM.Y);
  LLatGMS.Text:=DecAGrados(LatLon.Lat,true);
  LLonGMS.Text:=DecAGrados(LatLon.Lon,false);
end;

procedure TFPrinc.SBSalirClick(Sender: TObject);
begin
  FormatSettings.DecimalSeparator:=LDecSeparator;
  MainActivity.finish;
end;

procedure TFPrinc.SwitchGPSSwitch(Sender: TObject);
const
  PermissionAccessFineLocation='android.permission.ACCESS_FINE_LOCATION';
begin
  PermissionsService.RequestPermissions([PermissionAccessFineLocation],
    procedure(const APermissions: TClassicStringDynArray;
              const AGrantResults: TClassicPermissionStatusDynArray)
    begin
      if (Length(AGrantResults)=1) and (AGrantResults[0]=TPermissionStatus.Granted) then
        LctSensor.Active := SwitchGPS.IsChecked
      else
      begin
        SwitchGPS.IsChecked:=false;
        TDialogService.ShowMessage('Permiso de Localización no fue concedido');
      end;
    end);
  LctSensor.Active:=SwitchGPS.IsChecked;
  if SwitchGPS.IsChecked then
  begin
    LActivar.TextSettings.FontColor:=Chartreuse;
    LActivar.Text:='Desactivar GPS'
  end
  else               //8.935810      -67.395737
  begin              //676383.87      988138.92
    LActivar.TextSettings.FontColor:=Rojo;
    LActivar.Text:='Activar GPS';
    LLat.Text:='--.------';
    LLon.Text:='--.------';
    LEste.Text:='------';
    LNorte.Text:='------';
    LLatGMS.Text:='--.------';
    LLonGMS.Text:='--.------';
  end;
end;

end.
