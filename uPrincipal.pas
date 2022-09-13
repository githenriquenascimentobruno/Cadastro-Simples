unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons;

type
  TfrmPrincipal = class(TForm)
    btnClientes: TBitBtn;
    btnProdutos: TBitBtn;
    btnVendas: TBitBtn;
    procedure btnClientesClick(Sender: TObject);
    procedure btnProdutosClick(Sender: TObject);
    procedure btnVendasClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

uses uCadClientes, uCadProdutos, uCadVendas;

procedure TfrmPrincipal.btnClientesClick(Sender: TObject);
begin
  frmCadClientes := TfrmCadClientes.Create(Application);
  frmCadClientes.Show;
end;

procedure TfrmPrincipal.btnProdutosClick(Sender: TObject);
begin
  frmCadProdutos := TfrmCadProdutos.Create(Application);
  frmCadProdutos.Show;
end;

procedure TfrmPrincipal.btnVendasClick(Sender: TObject);
begin
  frmCadVendas := TfrmCadVendas.Create(Application);
  frmCadVendas.Show;
end;

end.
