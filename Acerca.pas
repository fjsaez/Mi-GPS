unit Acerca;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Controls.Presentation, FMX.Objects, FMX.Effects;

type
  TFrmAcerca = class(TFrame)
    ToolBar1: TToolBar;
    Label1: TLabel;
    Image: TImage;
    LayImagen: TLayout;
    LayTitulo: TLayout;
    LayAutor: TLayout;
    ShadowEffect: TShadowEffect;
    Label2: TLabel;
    Label3: TLabel;
    LayMensaje: TLayout;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Layout1: TLayout;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
