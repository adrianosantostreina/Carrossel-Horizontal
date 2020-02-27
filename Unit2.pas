unit Unit2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Objects, FMX.Controls.Presentation, FMX.Edit, FMX.Effects,

  Loading,
  UntLib, FMX.StdCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet,

  System.IOUtils;

type
  TForm2 = class(TForm)
    lytGeral: TLayout;
    Layout1: TLayout;
    Rectangle1: TRectangle;
    Layout2: TLayout;
    Circle1: TCircle;
    Layout3: TLayout;
    Rectangle2: TRectangle;
    Edit1: TEdit;
    Layout4: TLayout;
    Layout5: TLayout;
    Layout6: TLayout;
    horzScroll: THorzScrollBox;
    recBaseCard: TRectangle;
    ShadowEffect1: TShadowEffect;
    imgFotoCard: TImage;
    Button1: TButton;
    FDConnection1: TFDConnection;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    QryProdutos: TFDQuery;
    QryProdutosPRO_ID: TIntegerField;
    QryProdutosPRO_EMPRESA: TIntegerField;
    QryProdutosPRO_CODIGO: TStringField;
    QryProdutosPRO_DESCRICAO: TStringField;
    QryProdutosPRO_UNIDADEMEDIDA: TStringField;
    QryProdutosPRO_ATIVOINATIVO: TStringField;
    QryProdutosPRO_PRCVENDA: TFMTBCDField;
    QryProdutosPRO_DESC_MAXIMO: TFMTBCDField;
    QryProdutosPRO_SALDO_DISPONIVEL: TFMTBCDField;
    QryProdutosPRO_FOTO: TBlobField;
    QryProdutosGUID_CONTROLE: TStringField;
    StyleBook1: TStyleBook;
    procedure Button1Click(Sender: TObject);
    procedure FDConnection1BeforeConnect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure LimparLista(Sender: TObject; AScroll: THorzScrollBox; ARectBase: string);
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

procedure TForm2.Button1Click(Sender: TObject);
begin
  //
  TLibrary.CustomThread(
    procedure ()
    begin
      //Start
      TLoading.Show(Self, EmptyStr);
      Self.horzScroll.Visible := False;
      Self.horzScroll.BeginUpdate;
      Self.LimparLista(Sender, horzScroll, recBaseCard.Name);
      Self.QryProdutos.DisableControls;
    end,
    procedure ()
    var
      LPos    : Single;
      LCard   : TRectangle;
    begin
      LPos := 8;

      Self.QryProdutos.Active := False;
      Self.QryProdutos.Active := True;
      Self.QryProdutos.First;

      Self.recBaseCard.Visible := False;

      while not Self.QryProdutos.EOF do
      begin
        Self.imgFotoCard.Bitmap.Assign(Self.QryProdutosPRO_FOTO);

        LCard                    := TRectangle(recBaseCard.Clone(horzScroll));
        LCard.Parent             := horzScroll;
        LCard.Position.Y         := 4;
        LCard.Position.X         := LPos;
        LCard.Margins.Left       := 4;
        LCard.Margins.Right      := 4;
        LCard.Margins.Bottom     := 4;
        LCard.Margins.Top        := 4;

        LCard.Visible            := True;

        LPos                     := LPos + recBaseCard.Width + 4;

        Self.QryProdutos.Next;
      end;

    end,
    procedure ()
    begin
      TLoading.Hide;
      Self.horzScroll.EndUpdate;
      Self.horzScroll.Visible := True;
      Self.horzScroll.ScrollTo(0, 0);
      Self.QryProdutos.EnableControls;
    end,
    procedure (const AException : string)
    begin
      //
    end,
    True
  );
end;

procedure TForm2.FDConnection1BeforeConnect(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
    FDConnection1.Params.Values['Database'] :=
      'D:\1. Exemplos Cursos\Clube Mobile Full\58. Rolagem horizontal com imagens\cpvendas.db';
  {$ELSE}
    FDConnection1.Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, 'cpvendas.db');
    FDConnection1.Params.Values['OpenMode'] := 'ReadWrite';
  {$ENDIF}
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  recBaseCard.Visible := False;
end;

procedure TForm2.LimparLista(Sender: TObject; AScroll: THorzScrollBox;
  ARectBase: string);
var
  I      : Integer;
  lFrame : TRectangle;
begin
  //Pesquisar e deixar isso no formulário padrão de listas.
  AScroll.BeginUpdate;
  for I := Pred(AScroll.Content.ChildrenCount) downto 0 do
  begin
    if (AScroll.Content.Children[I] is TRectangle) then
    begin
      if not (TRectangle(AScroll.Content.Children[I]).Name = ARectBase) then
      begin
        lFrame := (AScroll.Content.Children[I] as TRectangle);
        lFrame.DisposeOf;
        lFrame := nil;
      end;
    end;
  end;
  AScroll.EndUpdate;

end;

end.
