program MiGPS;

uses
  System.StartUpCopy,
  FMX.Forms,
  Principal in 'Principal.pas' {FPrinc},
  UTM_WGS84 in 'UTM_WGS84.pas',
  Utiles in 'Utiles.pas' {FrmUtiles: TFrame},
  Acerca in 'Acerca.pas' {FrmAcerca: TFrame},
  Brujula in 'Brujula.pas' {FrmBrujula: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait];
  Application.CreateForm(TFPrinc, FPrinc);
  Application.Run;
end.
