unit Brujula;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Dialogs, FMX.StdCtrls, FMX.Objects,
  System.Sensors, System.Sensors.Components, FMX.ListBox, FMX.Layouts, FMX.Forms,
  FMX.Controls.Presentation, System.Math;

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
    OrntSensor: TOrientationSensor;
    MtnSensor: TMotionSensor;
    RectMarca: TRectangle;
    LayMarca: TLayout;
    LNivel: TLabel;
    procedure SwitchSwitch(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure OrntSensorSensorChoosing(Sender: TObject;
      const Sensors: TSensorArray; var ChoseSensorIndex: Integer);
    procedure CircleExtPaint(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  Chartreuse=$FF7FFF00;
  Rojo=$FFFF0000;
  Blanco=$FFFFFF00;

  function Orientacion(Grados: single): string;

implementation

{$R *.fmx}

procedure TFrmBrujula.CircleExtPaint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
  LayMarca.Size.Width:=CircleExt.Size.Width;
end;

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
  MtnSensor.Active:=Switch.IsChecked;
  Timer.Enabled:=Switch.IsChecked;
  if Switch.IsChecked then
  begin
    LActivar.TextSettings.FontColor:=Chartreuse;
    LActivar.Text:='Desactivar Br�jula'
  end
  else
  begin
    LActivar.TextSettings.FontColor:=Rojo;
    LActivar.Text:='Activar Br�jula'
  end;
end;

procedure TFrmBrujula.TimerTimer(Sender: TObject);
const
  Rng=0.2;
var
  X,Y,D,Deg,X2,Y2: double;
begin
  X2:=MtnSensor.Sensor.AccelerationX;
  Y2:=MtnSensor.Sensor.AccelerationY;
  X:=OrntSensor.Sensor.HeadingX;
  Y:=OrntSensor.Sensor.HeadingY;
  if Y=0 then D:=Abs(X/1)  //se evita una divisi�n por cero
         else D:=Abs(X/Y);
  Deg:=RadToDeg(ArcTan(D));
  if (Y>=0) and (X<=0) then Deg:=Deg
  else
    if (Y<0) and (X<=0) then Deg:=180-Deg
    else
      if (Y<0) then Deg:=180+Deg
      else
        if (Y>=0) and (X>0) then Deg:=360-Deg;
  CircleInt.RotationAngle:=360-Deg;
  LPtoCard.Text:=Round(Deg).ToString+'� - '+Orientacion(Deg);
  //se indica si la br�jula est� nivelada o no:
  if ((X2>=-Rng) and (X2<=Rng)) and ((Y2>=-Rng) and (Y2<=Rng)) then
  begin
    LNivel.TextSettings.FontColor:=Chartreuse;
    LNivel.Text:='NIVELADO'
  end
  else
  begin
    LNivel.TextSettings.FontColor:=Blanco;
    LNivel.Text:='NO nivelado';
  end;
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
