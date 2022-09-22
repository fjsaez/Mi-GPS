program MiGPS;

uses
  //para mantener la pantalla activa:
  Androidapi.JNI.App,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.Helpers,
  //
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
  SharedActivity.getWindow.addFlags(TJWindowManager_LayoutParams.JavaClass.FLAG_KEEP_SCREEN_ON);
  Application.FormFactor.Orientations := [TFormOrientation.Portrait];
  Application.CreateForm(TFPrinc, FPrinc);
  Application.Run;
end.
