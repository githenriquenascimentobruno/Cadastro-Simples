unit uCadClientes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Mask, Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.Imaging.jpeg,
  Vcl.Imaging.pngimage, Data.FMTBcd, Datasnap.DBClient, Datasnap.Provider,
  Data.SqlExpr, Data.DBXFirebird;

type
  TfrmCadClientes = class(TForm)
    edtNome: TEdit;
    edtEndereco: TEdit;
    edtNumero: TEdit;
    edtBairro: TEdit;
    edtEmail: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Email: TLabel;
    Image1: TImage;
    btnNovo: TBitBtn;
    btnGravar: TBitBtn;
    btnAlterar: TBitBtn;
    btnCancelar: TBitBtn;
    btnExcluir: TBitBtn;
    btnFechar: TBitBtn;
    dbGridCadClientes: TDBGrid;
    edtTelefone: TEdit;
    edtDataNascimento: TEdit;
    edtCpf: TEdit;
    edtFoto: TEdit;
    edtCodigo: TEdit;
    conexao: TSQLConnection;
    dataSetClient: TSQLDataSet;
    providerClient: TDataSetProvider;
    cdsClient: TClientDataSet;
    dSourceClient: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure edtTelefoneExit(Sender: TObject);
    procedure edtCpfExit(Sender: TObject);
    procedure edtDataNascimentoExit(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure LimpaCampos;
    procedure dbGridCadClientesCellClick(Column: TColumn);
    procedure btnFecharClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCadClientes: TfrmCadClientes;
  status: String;
  transacao: TTransactionDesc;

implementation

{$R *.dfm}

uses funformatartexto;

//Limpa todos os EDITS do form
procedure TfrmCadClientes.LimpaCampos;
  var i:Integer;
    begin
        for i:=0 To (ComponentCount - 1) do
         If Components[i] Is TCustomEdit Then (Components[i] As TCustomEdit).Clear;
    end;




procedure TfrmCadClientes.btnAlterarClick(Sender: TObject);
var
  i : integer;
begin
  btnNovo.Enabled := False;
  btnAlterar.Enabled := False;
  btnExcluir.Enabled := False;
  btnFechar.Enabled := False;
  btnGravar.Enabled := True;
  btnCancelar.Enabled := True;

  for i := 0 to ComponentCount -1 do
  if Components[i] is Tedit then
  TEdit(Components[i]).Enabled := True;

  status:= 'E';
end;

procedure TfrmCadClientes.btnCancelarClick(Sender: TObject);
var
  i : integer;
begin
  btnGravar.Enabled := False;
  btnCancelar.Enabled := False;
  btnNovo.Enabled := True;
  btnAlterar.Enabled := True;
  btnExcluir.Enabled := True;
  btnFechar.Enabled := True;

  for i := 0 to ComponentCount -1 do
  if Components[i] is Tedit then
  TEdit(Components[i]).Enabled := False;
end;

procedure TfrmCadClientes.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCadClientes.btnGravarClick(Sender: TObject);
var
  i : integer;
begin
  btnGravar.Enabled := False;
  btnCancelar.Enabled := False;
  btnNovo.Enabled := True;
  btnAlterar.Enabled := True;
  btnExcluir.Enabled := True;
  btnFechar.Enabled := True;

  for i := 0 to ComponentCount -1 do
  if Components[i] is Tedit then
  TEdit(Components[i]).Enabled := False;

  //Salvar
  if status = 'N' then
      begin
          try
                transacao.TransactionID := 1;
                transacao.IsolationLevel := xilREPEATABLEREAD;
                conexao.StartTransaction(transacao);
                dataSetClient.Close;
                dataSetClient.CommandType := ctQuery;
                dataSetClient.CommandText:='INSERT INTO CADCLIENTE(CLIENTE_CODIGO, ';
                dataSetClient.CommandText:=dataSetClient.CommandText+'CLIENTE_NOME, ';
                dataSetClient.CommandText:=dataSetClient.CommandText+'CLIENTE_ENDERECO, ';
                dataSetClient.CommandText:=dataSetClient.CommandText+'CLIENTE_NUMERO, ';
                dataSetClient.CommandText:=dataSetClient.CommandText+'CLIENTE_BAIRRO, ';
                dataSetClient.CommandText:=dataSetClient.CommandText+'CLIENTE_TELEFONE, ';
                dataSetClient.CommandText:=dataSetClient.CommandText+'CLIENTE_DATANASCIMENTO, ';
                dataSetClient.CommandText:=dataSetClient.CommandText+'CLIENTE_CPF, ';
                dataSetClient.CommandText:=dataSetClient.CommandText+'CLIENTE_EMAIL, ';
                dataSetClient.CommandText:=dataSetClient.CommandText+'CLIENTE_FOTO)';
                dataSetClient.CommandText:=dataSetClient.CommandText+'values(:CLIENTE_CODIGO, ';
                dataSetClient.CommandText:=dataSetClient.CommandText+':CLIENTE_NOME, ';
                dataSetClient.CommandText:=dataSetClient.CommandText+':CLIENTE_ENDERECO, ';
                dataSetClient.CommandText:=dataSetClient.CommandText+':CLIENTE_NUMERO, ';
                dataSetClient.CommandText:=dataSetClient.CommandText+':CLIENTE_BAIRRO, ';
                dataSetClient.CommandText:=dataSetClient.CommandText+':CLIENTE_TELEFONE, ';
                dataSetClient.CommandText:=dataSetClient.CommandText+':CLIENTE_DATANASCIMENTO, ';
                dataSetClient.CommandText:=dataSetClient.CommandText+':CLIENTE_CPF, ';
                dataSetClient.CommandText:=dataSetClient.CommandText+':CLIENTE_EMAIL, ';
                dataSetClient.CommandText:=dataSetClient.CommandText+':CLIENTE_FOTO)';
                dataSetClient.ParamByName('CLIENTE_CODIGO').AsInteger := StrToInt(edtCodigo.Text);
                dataSetClient.ParamByName('CLIENTE_NOME').AsString := edtNome.Text;
                dataSetClient.ParamByName('CLIENTE_ENDERECO').AsString := edtEndereco.Text;
                dataSetClient.ParamByName('CLIENTE_NUMERO').AsString := edtNumero.Text;
                dataSetClient.ParamByName('CLIENTE_BAIRRO').AsString := edtBairro.Text;
                dataSetClient.ParamByName('CLIENTE_TELEFONE').AsString := edtTelefone.Text;
                dataSetClient.ParamByName('CLIENTE_DATANASCIMENTO').AsString := edtDataNascimento.Text;
                dataSetClient.ParamByName('CLIENTE_CPF').AsString := edtCpf.Text;
                dataSetClient.ParamByName('CLIENTE_EMAIL').AsString := edtEmail.Text;
                dataSetClient.ParamByName('CLIENTE_FOTO').AsString := edtFoto.Text;
                dataSetClient.ExecSQL;
                conexao.Commit(transacao);
                cdsClient.Close;
                cdsClient.Open;
          except
              on E : Exception do
                  begin
                      ShowMessage('Ocorreu um erro na tentativa de inclus�o do registro: ' + E.Message);
                      conexao.Rollback(transacao);
                  end;

          end;

      end;


  //Alterar
  if status = 'E' then
      begin
          try
            transacao.TransactionID := 1;
            transacao.IsolationLevel := xilREPEATABLEREAD;
            conexao.StartTransaction(Transacao);
            dataSetClient.Close;
            dataSetClient.CommandType := ctQuery;
            dataSetClient.CommandText:='UPDATE CADCLIENTE SET CLIENTE_CODIGO = :CLIENTE_CODIGO, ';
            dataSetClient.CommandText:=dataSetClient.CommandText+'CLIENTE_NOME = :CLIENTE_NOME, CLIENTE_ENDERECO = :CLIENTE_ENDERECO, CLIENTE_NUMERO = :CLIENTE_NUMERO, ';
            dataSetClient.CommandText:=dataSetClient.CommandText+'CLIENTE_BAIRRO = :CLIENTE_BAIRRO, CLIENTE_TELEFONE = :CLIENTE_TELEFONE, CLIENTE_DATANASCIMENTO = :CLIENTE_DATANASCIMENTO, CLIENTE_CPF = :CLIENTE_CPF, ';
            dataSetClient.CommandText:=dataSetClient.CommandText+'CLIENTE_EMAIL = :CLIENTE_EMAIL, CLIENTE_FOTO = :CLIENTE_FOTO Where CLIENTE_CODIGO = :CLIENTE_CODIGO';
            //dataSetClient.CommandText:=dataSetClient.CommandText+'Where CLIENTE_CODIGO=:CLIENTE_CODIGO';
            dataSetClient.ParamByName('CLIENTE_CODIGO').AsInteger := StrToInt(edtCodigo.Text);
            dataSetClient.ParamByName('CLIENTE_NOME').AsString := edtNome.Text;
            dataSetClient.ParamByName('CLIENTE_ENDERECO').AsString := edtEndereco.Text;
            dataSetClient.ParamByName('CLIENTE_NUMERO').AsString := edtNumero.Text;
            dataSetClient.ParamByName('CLIENTE_BAIRRO').AsString := edtBairro.Text;
            dataSetClient.ParamByName('CLIENTE_TELEFONE').AsString := edtTelefone.Text ;
            dataSetClient.ParamByName('CLIENTE_DATANASCIMENTO').AsString := edtDataNascimento.Text;
            dataSetClient.ParamByName('CLIENTE_CPF').AsString := edtCpf.Text;
            dataSetClient.ParamByName('CLIENTE_EMAIL').AsString := edtEmail.Text;
            dataSetClient.ParamByName('CLIENTE_FOTO').AsString := edtFoto.Text;
            dataSetClient.ExecSQL;
            conexao.Commit(transacao);
            cdsClient.Close;
            cdsClient.Open;
          except
              on E : Exception do
                  begin
                      ShowMessage('Ocorreu um erro na tentativa de altera��o do registro: ' + E.Message);
                      conexao.Rollback(transacao);
                  end;
          end;
      end;




end;

procedure TfrmCadClientes.btnNovoClick(Sender: TObject);
var
  i : integer;
begin
  for i := 0 to ComponentCount -1 do
  if Components[i] is Tedit then
  TEdit(Components[i]).Enabled := True;

  for i := 0 to ComponentCount -1 do
  if Components[i] is TMaskEdit then
  TMaskEdit(Components[i]).Enabled := True;

  edtNome.SetFocus;

  btnNovo.Enabled := False;
  btnAlterar.Enabled := False;
  btnExcluir.Enabled := False;
  btnFechar.Enabled :=  False;
  btnGravar.Enabled := True;
  btnCancelar.Enabled :=  True;

  LimpaCampos;
  status:= 'N';

     //Incrementa automaticamente o EDIT do codigo
      with dataSetClient do
        begin
          dataSetClient.Close;
          dataSetClient.CommandText := 'SELECT MAX(CLIENTE_CODIGO) +1 AS COD FROM CADCLIENTE';
          dataSetClient.Open;
          edtCodigo.Text := IntToStr(dataSetClient.FieldByName('COD').AsInteger);
        end;

end;

procedure TfrmCadClientes.dbGridCadClientesCellClick(Column: TColumn);
begin
  edtCodigo.Text := dbGridCadClientes.Columns[0].Field.AsString;
  edtNome.Text := dbGridCadClientes.Columns[1].Field.AsString;
  edtEndereco.Text := dbGridCadClientes.Columns[2].Field.AsString;
  edtNumero.Text := dbGridCadClientes.Columns[3].Field.AsString;
  edtBairro.Text := dbGridCadClientes.Columns[4].Field.AsString;
  edtTelefone.Text := dbGridCadClientes.Columns[5].Field.AsString;
  edtDataNascimento.Text := dbGridCadClientes.Columns[6].Field.AsString;
  edtCpf.Text := dbGridCadClientes.Columns[7].Field.AsString;
  edtEmail.Text := dbGridCadClientes.Columns[8].Field.AsString;
  edtFoto.Text := dbGridCadClientes.Columns[9].Field.AsString;
end;

procedure TfrmCadClientes.edtCpfExit(Sender: TObject);
begin
  edtCpf.Text:=formacpf(edtCpf.Text);
end;

procedure TfrmCadClientes.edtDataNascimentoExit(Sender: TObject);
begin
  edtDataNascimento.Text:=formaDataNascimento(edtDataNascimento.Text);
end;

procedure TfrmCadClientes.edtTelefoneExit(Sender: TObject);
begin
  edtTelefone.Text:=formatelefone(edtTelefone.Text); // para formatar Telefone (00)0000-0000
end;

procedure TfrmCadClientes.FormCreate(Sender: TObject);
var
  i : integer;
begin
  for i := 0 to ComponentCount -1 do
  if Components[i] is Tedit then
  TEdit(Components[i]).Enabled := false;

  for i := 0 to ComponentCount -1 do
  if Components[i] is TMaskEdit then
  TMaskEdit(Components[i]).Enabled := false;

  btnGravar.Enabled := False;
  btnCancelar.Enabled := False;
end;


end.
