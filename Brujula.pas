unit Brujula;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  System.Sensors, System.Sensors.Components, FMX.ListBox, FMX.Layouts,
  FMX.Controls.Presentation, System.Math, FMX.Objects;

type
  TFrmBrujula = class(TFrame)
    LayPrinc: TLayout;
    Timer: TTimer;
    Switch: TSwitch;
    LayActivar: TLayout;
    Layout5: TLayout;
    LayPtoCard: TLayout;
    LActivar: TLabel;
    LPtoCard: TLabel;
    LayImagen: TLayout;
    CircleInt: TCircle;
    CircleExt: TCircle;
    LineExt: TLine;
    OrntSensor: TOrientationSensor;
    procedure SwitchSwitch(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure OrntSensorSensorChoosing(Sender: TObject;
      const Sensors: TSensorArray; var ChoseSensorIndex: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function Orientacion(Grados: single): string;

implementation

{$R *.fmx}

procedure TFrmBrujula.OrntSensorSensorChoosing(Sender: TObject;
  const Sensors: TSensorArray; var ChoseSensorIndex: Integer);
var
  Indice,I: integer;
begin
  Indice:=-1;
  for I := 0 to High(Sensors) do
    if (TCustomOrientationSensor.TProperty.HeadingX in
         TCustomOrientationSensor(Sensors[I]).AvailableProperties) then
    begin
      Indice:=I;
      Break;
    end;
  ChoseSensorIndex:=Indice;
end;

procedure TFrmBrujula.SwitchSwitch(Sender: TObject);
begin
  OrntSensor.Active:=Switch.IsChecked;
  Timer.Enabled:=Switch.IsChecked;
  if Switch.IsChecked then
  begin
    LActivar.TextSettings.FontColor:=$FF7FFF00;   //chartreuse
    LActivar.Text:='Desactivar Brújula'
  end
  else
  begin
    LActivar.TextSettings.FontColor:=$FFFF0000;   //rojo
    LActivar.Text:='Activar Brújula'
  end;
end;

procedure TFrmBrujula.TimerTimer(Sender: TObject);
var
  X,Y,D,Deg: double;
begin
  X:=OrntSensor.Sensor.HeadingX;
  Y:=OrntSensor.Sensor.HeadingY;
  if Y=0 then D:=Abs(X/1)  //se evita una división por cero
         else D:=Abs(X/Y);
  Deg:=RadToDeg(ArcTan(D));
  if (Y>=0) and (X<=0) then Deg:=Deg
  else
    if (Y<0) and (X<=0) then Deg:=180-Deg
    else
      if (Y<0) then Deg:=180+Deg
      else
        if (Y>=0) and (X>0) then Deg:=360-Deg;
  Application.ProcessMessages;
  Sleep(10);
  CircleInt.RotationAngle:=360-Deg;
  LPtoCard.Text:=Round(Deg).ToString+'º - '+Orientacion(Deg);
end;

function Orientacion(Grados: single): string;
begin
  case Round(Grados) of
    0..10,350..360: Result:='N';  //norte
    11..34: Result:='N - NE';     //norte-noreste
    35..54: Result:='NE';         //noreste
    55..79: Result:='E - NE';     //este-noreste
    80..100: Result:='E';         //este
    101..124: Result:='E - SE';   //este-sureste
    125..144: Result:='SE';       //sureste
    145..169: Result:='S - SE';   //sur-sureste
    170..190: Result:='S';        //sur
    191..214: Result:='S - SW';   //sur-suroeste
    215..234: Result:='SW';       //suroeste
    235..259: Result:='W - SW';   //oeste-suroeste
    260..280: Result:='W';        //oeste
    281..304: Result:='W - NW';   //oeste-noroeste
    305..324: Result:='NW';       //noroeste
    325..349: Result:='N - NW';   //norte-noroeste
  end;
end;

end.
