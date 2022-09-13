unit uCadProdutos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.Grids, Vcl.DBGrids,
  Data.DBXFirebird, Data.FMTBcd, Datasnap.DBClient, Datasnap.Provider,
  Data.SqlExpr;

type
  TfrmCadProdutos = class(TForm)
    dbGridCadProdutos: TDBGrid;
    Label2: TLabel;
    Label1: TLabel;
    edtValor: TEdit;
    edtDescricao: TEdit;
    edtFoto: TEdit;
    btnFechar: TBitBtn;
    btnExcluir: TBitBtn;
    btnCancelar: TBitBtn;
    btnAlterar: TBitBtn;
    btnGravar: TBitBtn;
    btnNovo: TBitBtn;
    edtCodigo: TEdit;
    Image1: TImage;
    conexaoBd: TSQLConnection;
    sdsCadProdutos: TSQLDataSet;
    dspCadProdutos: TDataSetProvider;
    cdsCadProdutos: TClientDataSet;
    dsCadProdutos: TDataSource;
    cdsCadProdutosPRODUTO_CODIGO: TIntegerField;
    cdsCadProdutosPRODUTO_DESCRICAO: TStringField;
    cdsCadProdutosPRODUTO_VALOR: TFMTBCDField;
    cdsCadProdutosPRODUTO_FOTO: TStringField;
    procedure edtValorKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnNovoClick(Sender: TObject);
    procedure LimpaCampos;
    procedure btnAlterarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure dbGridCadProdutosCellClick(Column: TColumn);
    procedure edtValorExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtValorKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCadProdutos: TfrmCadProdutos;
  status: String;
  transacao: TTransactionDesc;
implementation

{$R *.dfm}

Procedure FormatarComoMoeda( Componente : TObject; var Key: Char );
var
   str_valor  : String;
   dbl_valor  : double;
begin

   { verificando se estamos recebendo o TEdit realmente }
   IF Componente is TEdit THEN
   BEGIN
      { se tecla pressionada e' um numero, backspace ou del deixa passar }
      IF ( Key in ['0'..'9', #8, #9] ) THEN
      BEGIN
         { guarda valor do TEdit com que vamos trabalhar }
         str_valor := TEdit( Componente ).Text ;
         { verificando se nao esta vazio }
         IF str_valor = EmptyStr THEN str_valor := '0,00' ;
         { se valor numerico ja insere na string temporaria }
         IF Key in ['0'..'9'] THEN str_valor := Concat( str_valor, Key ) ;
         { retira pontos e virgulas se tiver! }
         str_valor := Trim( StringReplace( str_valor, '.', '', [rfReplaceAll, rfIgnoreCase] ) ) ;
         str_valor := Trim( StringReplace( str_valor, ',', '', [rfReplaceAll, rfIgnoreCase] ) ) ;
         {inserindo 2 casas decimais}
         dbl_valor := StrToFloat( str_valor ) ;
         dbl_valor := ( dbl_valor / 100 ) ;

         {reseta posicao do tedit}
         TEdit( Componente ).SelStart := Length( TEdit( Componente ).Text );
         {retornando valor tratado ao TEdit}
         TEdit( Componente ).Text := FormatFloat( '###,##0.00', dbl_valor ) ;
      END;
      {se nao e' key relevante entao reseta}
      IF NOT( Key in [#8, #9] ) THEN key := #0;
   END;

end;

function RetirarPonto(strSrc: string): string;
begin
  Result := StringReplace(strSrc, '.', '', [rfReplaceAll])
end;


//Limpa todos os EDITS do form
procedure TfrmCadProdutos.LimpaCampos;
  var i:Integer;
    begin
        for i:=0 To (ComponentCount - 1) do
         If Components[i] Is TCustomEdit Then (Components[i] As TCustomEdit).Clear;
    end;

procedure TfrmCadProdutos.btnAlterarClick(Sender: TObject);
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

procedure TfrmCadProdutos.btnCancelarClick(Sender: TObject);
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

procedure TfrmCadProdutos.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCadProdutos.btnGravarClick(Sender: TObject);
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
                conexaoBd.StartTransaction(transacao);
                sdsCadProdutos.Close;
                sdsCadProdutos.CommandType := ctQuery;
                sdsCadProdutos.CommandText:='INSERT INTO CADPRODUTOS(PRODUTO_CODIGO, PRODUTO_DESCRICAO, ';
                sdsCadProdutos.CommandText:=sdsCadProdutos.CommandText+'PRODUTO_VALOR, ';
                sdsCadProdutos.CommandText:=sdsCadProdutos.CommandText+'PRODUTO_FOTO)';
                sdsCadProdutos.CommandText:=sdsCadProdutos.CommandText+'values(:PRODUTO_CODIGO, ';
                sdsCadProdutos.CommandText:=sdsCadProdutos.CommandText+':PRODUTO_DESCRICAO, ';
                sdsCadProdutos.CommandText:=sdsCadProdutos.CommandText+':PRODUTO_VALOR, ';
                sdsCadProdutos.CommandText:=sdsCadProdutos.CommandText+':PRODUTO_FOTO)';
                sdsCadProdutos.ParamByName('PRODUTO_CODIGO').AsInteger := StrToInt(edtCodigo.Text);
                sdsCadProdutos.ParamByName('PRODUTO_DESCRICAO').AsString := edtDescricao.Text;
                sdsCadProdutos.ParamByName('PRODUTO_VALOR').AsFloat := StrToFloat(RetirarPonto(edtValor.Text));
                sdsCadProdutos.ParamByName('PRODUTO_FOTO').AsString := edtFoto.Text;
                sdsCadProdutos.ExecSQL;
                conexaoBd.Commit(transacao);
                cdsCadProdutos.Close;
                cdsCadProdutos.Open;
          except
              on E : Exception do
                  begin
                      ShowMessage('Ocorreu um erro na tentativa de inclus�o do registro: ' + E.Message);
                      conexaoBd.Rollback(transacao);
                  end;

          end;

      end;


  //Alterar
  if status = 'E' then
      begin
          try
            transacao.TransactionID := 1;
            transacao.IsolationLevel := xilREPEATABLEREAD;
            conexaoBd.StartTransaction(Transacao);
            sdsCadProdutos.Close;
            sdsCadProdutos.CommandType := ctQuery;
            sdsCadProdutos.CommandText:='UPDATE CADPRODUTOS SET PRODUTO_CODIGO = :PRODUTO_CODIGO, ';
            sdsCadProdutos.CommandText:=sdsCadProdutos.CommandText+'PRODUTO_DESCRICAO = :PRODUTO_DESCRICAO, PRODUTO_VALOR = :PRODUTO_VALOR, ';
            sdsCadProdutos.CommandText:=sdsCadProdutos.CommandText+'PRODUTO_FOTO = :PRODUTO_FOTO Where PRODUTO_CODIGO = :PRODUTO_CODIGO';
            sdsCadProdutos.ParamByName('PRODUTO_CODIGO').AsInteger := StrToInt(edtCodigo.Text);
            sdsCadProdutos.ParamByName('PRODUTO_DESCRICAO').AsString := edtDescricao.Text;
            sdsCadProdutos.ParamByName('PRODUTO_VALOR').AsFloat := StrToFloat(edtValor.Text);
            sdsCadProdutos.ParamByName('PRODUTO_FOTO').AsString := edtFoto.Text;
            sdsCadProdutos.ExecSQL;
            conexaoBd.Commit(transacao);
            cdsCadProdutos.Close;
            cdsCadProdutos.Open;
          except
              on E : Exception do
                  begin
                      ShowMessage('Ocorreu um erro na tentativa de altera��o do registro: ' + E.Message);
                      conexaoBd.Rollback(transacao);
                  end;
          end;
      end;




end;

procedure TfrmCadProdutos.btnNovoClick(Sender: TObject);
var
  i : integer;
begin
  for i := 0 to ComponentCount -1 do
  if Components[i] is Tedit then
  TEdit(Components[i]).Enabled := True;


  edtDescricao.SetFocus;

  btnNovo.Enabled := False;
  btnAlterar.Enabled := False;
  btnExcluir.Enabled := False;
  btnFechar.Enabled :=  False;
  btnGravar.Enabled := True;
  btnCancelar.Enabled :=  True;

  LimpaCampos;
  status:= 'N';

     //Incrementa automaticamente o EDIT do codigo
      with sdsCadProdutos do
        begin
          sdsCadProdutos.Close;
          sdsCadProdutos.CommandText := 'SELECT MAX(PRODUTO_CODIGO) +1 AS COD FROM CADPRODUTOS';
          sdsCadProdutos.Open;
          edtCodigo.Text := IntToStr(sdsCadProdutos.FieldByName('COD').AsInteger);
        end;
end;

procedure TfrmCadProdutos.dbGridCadProdutosCellClick(Column: TColumn);
begin
  edtCodigo.Text := dbGridCadProdutos.Columns[0].Field.AsString;
  edtDescricao.Text := dbGridCadProdutos.Columns[1].Field.AsString;
  //edtValor.Text := dbGridCadProdutos.Columns[2].Field.AsString;
  edtValor.Text := FormatFloat('#,##0.00', dbGridCadProdutos.Columns[2].Field.AsFloat);
  edtFoto.Text := dbGridCadProdutos.Columns[3].Field.AsString;
end;

procedure TfrmCadProdutos.edtValorExit(Sender: TObject);
begin
//edtValor.Text := FormatFloat(',0.00', StrToFloat(RetirarPonto(edtValor.Text)));
edtValor.Text := FormatFloat(',0.00', StrToFloat(edtValor.Text));


end;

procedure TfrmCadProdutos.edtValorKeyPress(Sender: TObject; var Key: Char);
begin
FormatarComoMoeda( edtValor, Key );
end;

procedure TfrmCadProdutos.edtValorKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
 var  s: String;

begin
{  if (Key in [96..107]) or (Key in [48..57]) then
     begin
      S := edtValor.Text;
      S := StringReplace(S,',','',[rfReplaceAll]);
      S := StringReplace(S,'.','',[rfReplaceAll]);
      if Length(s) = 3 then
        begin
          s := Copy(s,1,1)+','+Copy(S,2,15);
          edtValor.Text := S;
          edtValor.SelStart := Length(S);
        end
      else
        if (Length(s) > 3) and (Length(s) < 6) then
          begin
            s := Copy(s,1,length(s)-2)+','+Copy(S,length(s)-1,15);
            edtValor.Text := s;
            edtValor.SelStart := Length(S);
          end
        else
          if (Length(s) >= 6) and (Length(s) < 9) then
            begin
              s := Copy(s,1,length(s)-5)+'.'+Copy(s,length(s)-4,3)+','+Copy(S,length(s)-1,15);
              edtValor.Text := s;
              edtValor.SelStart := Length(S);
            end
          else
            if (Length(s) >= 9) and (Length(s) < 12) then
              begin
                s := Copy(s,1,length(s)-8)+'.'+Copy(s,length(s)-7,3)+'.'+
                       Copy(s,length(s)-4,3)+','+Copy(S,length(s)-1,15);
                edtValor.Text := s;
                edtValor.SelStart := Length(S);
              end
            else
              if (Length(s) >= 12) and (Length(s) < 15)  then
                begin
                  s := Copy(s,1,length(s)-11)+'.'+Copy(s,length(s)-10,3)+'.'+
                          Copy(s,length(s)-7,3)+'.'+Copy(s,length(s)-4,3)+','+Copy(S,length(s)-1,15);
                  edtValor.Text := s;
                  edtValor.SelStart := Length(S);
                end;
      end;      }
end;


procedure TfrmCadProdutos.FormCreate(Sender: TObject);
var
  i : integer;
begin
  for i := 0 to ComponentCount -1 do
  if Components[i] is Tedit then
  TEdit(Components[i]).Enabled := false;

  btnGravar.Enabled := False;
  btnCancelar.Enabled := False;
end;

end.
