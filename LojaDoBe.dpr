program LojaDoBe;

uses
  Vcl.Forms,
  uPrincipal in 'uPrincipal.pas' {frmPrincipal},
  uCadClientes in 'uCadClientes.pas' {frmCadClientes},
  uCadProdutos in 'uCadProdutos.pas' {frmCadProdutos},
  uCadVendas in 'uCadVendas.pas' {frmCadVendas},
  funformatartexto in 'funformatartexto.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TfrmCadClientes, frmCadClientes);
  Application.CreateForm(TfrmCadProdutos, frmCadProdutos);
  Application.CreateForm(TfrmCadVendas, frmCadVendas);
  Application.Run;
end.
