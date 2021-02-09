unit Produtos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.ExtCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.Buttons, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtDlgs,
  Vcl.Imaging.pngimage;

type
  TfrmProdutos = class(TForm)
    txtNome: TLabel;
    butSalvar: TSpeedButton;
    butEditar: TSpeedButton;
    butExcluir: TSpeedButton;
    butNOVO: TSpeedButton;
    DBGrid1: TDBGrid;
    edNome: TEdit;
    Label1: TLabel;
    imgCod: TImage;
    Image2: TImage;
    edValor: TEdit;
    Label2: TLabel;
    edDescricao: TEdit;
    Label3: TLabel;
    butAdd: TSpeedButton;
    Label4: TLabel;
    cbUnd: TEdit;
    butImprimir: TSpeedButton;
    edCodigo: TMaskEdit;
    butGerarCodigo: TSpeedButton;
    buscarCodigo: TRadioButton;
    buscarNome: TRadioButton;
    Label5: TLabel;
    txtBuscarProduto: TEdit;
    txtBuscarCodigo: TEdit;
    dialog: TOpenPictureDialog;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Image1: TImage;
    procedure FormShow(Sender: TObject);
    procedure butNOVOClick(Sender: TObject);
    procedure butSalvarClick(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure butImprimirClick(Sender: TObject);
    procedure butGerarCodigoClick(Sender: TObject);
    procedure butEditarClick(Sender: TObject);
    procedure butExcluirClick(Sender: TObject);
    procedure buscarNomeClick(Sender: TObject);
    procedure buscarCodigoClick(Sender: TObject);
    procedure txtBuscarCodigoChange(Sender: TObject);
    procedure txtBuscarProdutoChange(Sender: TObject);
    procedure butAddClick(Sender: TObject);
    procedure edCodigoChange(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);

  private
    { Private declarations }
    procedure limpar;
    procedure habilitarCampos;
    procedure desabilitarCampos;

    procedure associarCampos;
    procedure listar;
    procedure buscarNome1;
    procedure buscarCodigo1;
    procedure salvarFoto;
    procedure carregarImgPadrao;
    procedure GerarCodigo(codigo: string; Canvas: TCanvas);

  public
    { Public declarations }
  end;

var
  frmProdutos: TfrmProdutos;
  id : string;
  cod : string;
  img : TPicture;
  caminhoImg : string;
  alterou : Boolean;

implementation

{$R *.dfm}

uses Modulo, ImprimirBarras, CadastroCliente;

{ TfrmProdutos }

procedure TfrmProdutos.associarCampos;
begin
dm.fb_produtos.FieldByName('codigo').Value := edCodigo.Text;
dm.fb_produtos.FieldByName('nome').Value := edNome.Text;
dm.fb_produtos.FieldByName('descricao').Value := edDescricao.Text;
dm.fb_produtos.FieldByName('valor').Value := edValor.Text;
dm.fb_produtos.FieldByName('und').Value := cbUnd.Text;
dm.fb_produtos.FieldByName('data').Value := DateToStr(Date);
end;

procedure TfrmProdutos.buscarCodigo1;
begin
     dm.query_produtos.Close;
     dm.query_produtos.SQL.Clear;
     dm.query_produtos.SQL.Add('SELECT * from produtos where codigo LIKE :codigo order by nome asc');
     dm.query_produtos.ParamByName('codigo').Value := txtBuscarCodigo.Text + '%';
     dm.query_produtos.Open;
end;

procedure TfrmProdutos.buscarCodigoClick(Sender: TObject);
begin
listar;
txtbuscarCodigo.Visible := true;
txtbuscarProduto.Visible := false;
txtbuscarCodigo.SetFocus;
end;

procedure TfrmProdutos.buscarNome1;
begin
     dm.query_produtos.Close;
     dm.query_produtos.SQL.Clear;
     dm.query_produtos.SQL.Add('SELECT * from produtos where nome LIKE :nome order by nome asc');
     dm.query_produtos.ParamByName('nome').Value := txtBuscarProduto.Text + '%';
     dm.query_produtos.Open;
end;

procedure TfrmProdutos.buscarNomeClick(Sender: TObject);
begin
listar;
txtbuscarCodigo.Visible := false;
txtbuscarProduto.Visible := true;
txtBuscarProduto.SetFocus;
end;

procedure TfrmProdutos.butAddClick(Sender: TObject);
begin
dialog.Execute();
Image2.Picture.LoadFromFile(dialog.FileName);
alterou := true;
end;

procedure TfrmProdutos.butEditarClick(Sender: TObject);
begin
if Trim(edNome.Text) = '' then
     begin
         MessageDlg('Preencha o Nome do Produto!', mtInformation, mbOKCancel, 0);
         EdNome.SetFocus;
         exit;
     end;
      if Trim(edDescricao.Text) = '' then
     begin
         MessageDlg('Preencha a Descrição!', mtInformation, mbOKCancel, 0);
         edDescricao.SetFocus;
         exit;
     end;
      if Trim(edValor.Text) = '' then
     begin
         MessageDlg('Preencha o Valor!', mtInformation, mbOKCancel, 0);
         edValor.SetFocus;
         exit;
     end;

     associarcampos;
     dm.query_produtos.Close;
     dm.query_produtos.SQL.Clear;

     if alterou then
     begin
     dm.query_produtos.SQL.Add('UPDATE produtos set nome = :nome, descricao = :descricao, valor = :valor, codigo = :codigo, und = :und, imagem = :imagem where id = :id');
     img := TPicture.Create;
     img.LoadFromFile(dialog.Filename);
     dm.query_produtos.ParamByName('imagem').Assign(img);
     img.Free;
     alterou := false;
     end
     else
     begin
     dm.query_produtos.SQL.Add('UPDATE produtos set nome = :nome, descricao = :descricao, valor = :valor, codigo = :codigo, und = :und where id = :id');
     end;
     dm.query_produtos.ParamByName('nome').Value := edNome.Text;
     dm.query_produtos.ParamByName('descricao').Value := edDescricao.Text;
     dm.query_produtos.ParamByName('valor').Value := strToFloat(edValor.Text);
     dm.query_produtos.ParamByName('und').Value := cbUnd.Text;
     dm.query_produtos.ParamByName('codigo').Value := edCodigo.Text;
     dm.query_produtos.ParamByName('id').Value := id;
     dm.query_produtos.ExecSQL;

     listar;
     MessageDlg('Alterado com Sucesso!!', mtInformation, mbOKCancel, 0);
     butEditar.Enabled := false;
     butExcluir.Enabled := false;
     desabilitarCampos;
     listar;
end;

procedure TfrmProdutos.butExcluirClick(Sender: TObject);
begin
if MessageDlg('Deseja Excluir o Registro de Cargo?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
begin
  dm.query_produtos.Delete;
  MessageDlg('Deletado com Sucesso!!', mtInformation, mbOKCancel, 0);
  butEditar.Enabled := false;
  butExcluir.Enabled := false;
  edNome.Text := '';
  listar;
end;
end;

procedure TfrmProdutos.butGerarCodigoClick(Sender: TObject);
begin
GerarCodigo(edCodigo.Text, imgCod.Canvas);
butSalvar.Enabled := true;

   begin
   if Trim(edCodigo.Text) = '' then
     begin
         MessageDlg('Preencha o Código!', mtInformation, mbOKCancel, 0);
         edCodigo.SetFocus;
         exit;
     end;

           ///Verificar se o codigo ja Existe
           dm.query_coringa.Close;
           dm.query_coringa.SQL.Clear;
           dm.query_coringa.SQL.Add('SELECT * from produtos where codigo = ' + edCodigo.Text);
           dm.query_coringa.Open;

           if not dm.query_coringa.isEmpty then
           begin
              cod := dm.query_coringa['codigo'];
              MessageDlg('O Código ' + cod + ' já está cadastrado!', mtInformation, mbOKCancel, 0);
              edCodigo.Text := '';
              edCodigo.SetFocus;
              exit;
           end;
     end;

end;

procedure TfrmProdutos.butImprimirClick(Sender: TObject);
begin
FrmImprimirBarras := TFrmImprimirBarras.Create(self);
FrmImprimirBarras.ShowModal;
end;

procedure TfrmProdutos.butNOVOClick(Sender: TObject);
begin
habilitarCampos;
dm.fb_produtos.Insert;
butSalvar.Enabled := true;
edCodigo.SetFocus;
limpar;
end;

procedure TfrmProdutos.butSalvarClick(Sender: TObject);
begin
if Trim(edNome.Text) = '' then
     begin
         MessageDlg('Preencha o Nome do Produto!', mtInformation, mbOKCancel, 0);
         edNome.SetFocus;
         exit;
     end;
      if Trim(edCodigo.Text) = '' then
     begin
         MessageDlg('Preencha o Código!', mtInformation, mbOKCancel, 0);
         edCodigo.SetFocus;
         exit;
     end;
      if Trim(cbUnd.Text) = '' then
     begin
         MessageDlg('Preencha a Unidade do Produto!', mtInformation, mbOKCancel, 0);
         cbUnd.SetFocus;
         exit;
     end;

      try
        associarCampos;
        salvarFoto;


        dm.fb_produtos.Post;
        MessageDlg('Salvo com Sucesso', mtInformation, mbOKCancel, 0);
        limpar;
        desabilitarCampos;
        butSalvar.Enabled := false;
        listar;

        except
        MessageDlg('Imagem grande demais', mtInformation, mbOKCancel, 0);

        dm.fb_produtos.Active := true;
        dm.fb_produtos.Insert;
        carregarImgPadrao;
        listar;
        end;
end;


procedure TfrmProdutos.carregarImgPadrao;
begin
caminhoImg := GetCurrentDir + '\img\sem-foto.jpg';
Image2.Picture.LoadFromFile(caminhoImg);
end;
{PROCEDIMENTO PADRÃO PARA RECUPERAR FOTO DO BANCO}
procedure ExibeFoto(DataSet : TDataSet; BlobFieldName : String; ImageExibicao :
TImage);

 var MemoryStream:TMemoryStream; jpg : TPicture;
 const
  OffsetMemoryStream : Int64 = 0;

begin
  if not(DataSet.IsEmpty) and
  not((DataSet.FieldByName(BlobFieldName) as TBlobField).IsNull) then
    try
      MemoryStream := TMemoryStream.Create;
      Jpg := TPicture.Create;
      (DataSet.FieldByName(BlobFieldName) as
      TBlobField).SaveToStream(MemoryStream);
      MemoryStream.Position := OffsetMemoryStream;
      Jpg.LoadFromStream(MemoryStream);
      ImageExibicao.Picture.Assign(Jpg);
    finally
     // Jpg.Free;
      MemoryStream.Free();
    end
  else
    ImageExibicao.Picture := Nil;
end;


procedure TfrmProdutos.DBGrid1CellClick(Column: TColumn);
begin
habilitarCampos;
butEditar.Enabled := true;
butExcluir.Enabled := true;
butImprimir.Enabled := true;
butGerarCodigo.Enabled := true;

dm.query_produtos.Edit;

dm.fb_produtos.Edit;

edNome.Text := dm.query_produtos.FieldByName('nome').Value;

edValor.Text := dm.query_produtos.FieldByName('valor').Value;

edDescricao.Text := dm.query_produtos.FieldByName('descricao').Value;

edCodigo.Text := dm.query_produtos.FieldByName('codigo').Value;

cbUnd.Text := dm.query_produtos.FieldByName('und').Value;

GerarCodigo(edCodigo.Text, imgCod.Canvas);

id := dm.query_produtos.FieldByName('id').Value;

codigoProduto := dm.query_produtos.FieldByName('codigo').Value;

if dm.query_produtos.FieldByName('imagem').Value <> null then
ExibeFoto(dm.query_produtos, 'imagem',  Image2);


end;

procedure TfrmProdutos.DBGrid1DblClick(Sender: TObject);
begin
if chamada = 'Prod' then
begin
  idProduto := dm.query_produtos.FieldByName('id').Value;
  nomeProduto := dm.query_produtos.FieldByName('nome').Value;
  estoqueProduto := dm.query_produtos.FieldByName('estoque').Value;
  Close;
  chamada := '';
end;
end;

procedure TfrmProdutos.desabilitarCampos;
begin
     edCodigo.Enabled := false;
     edNome.Enabled := false;
     edDescricao.Enabled := false;
     edValor.Enabled := false;
     cbUnd.Enabled := false;
     butAdd.Enabled := false;
     butGerarCodigo.Enabled;
     imgCod.Visible := false;
end;

procedure TfrmProdutos.edCodigoChange(Sender: TObject);
begin
if edCodigo.Text = '_____________' then
begin
butGerarCodigo.Enabled := false;
  end
  else
  begin
  butGerarCodigo.Enabled := true;
end;
end;

procedure TfrmProdutos.FormShow(Sender: TObject);
begin
carregarImgPadrao;
desabilitarCampos;
dm.fb_produtos.Active := true;
listar;
dialog.FileName := GetCurrentDir + '\img\sem-foto.jpg';
buscarNome.Checked := true;
txtBuscarCodigo.Visible := false;
end;

procedure TfrmProdutos.GerarCodigo(codigo: string; Canvas: TCanvas);
const
digitos : array['0'..'9'] of string[5]= ('00110', '10001', '01001', '11000',
'00101', '10100', '01100', '00011', '10010', '01010');
var s : string;
i, j, x, t : Integer;
begin

try

// Gerar o valor para desenhar o código de barras
// Caracter de início
s := '0000';
for i := 1 to length(codigo) div 2 do
for j := 1 to 5 do
s := s + Copy(Digitos[codigo[i * 2 - 1]], j, 1) + Copy(Digitos[codigo[i * 2]], j, 1);
// Caracter de fim
s := s + '100';
// Desenhar em um objeto canvas
// Configurar os parâmetros iniciais
x := 0;
// Pintar o fundo do código de branco
Canvas.Brush.Color := clWhite;
Canvas.Pen.Color := clWhite;
Canvas.Rectangle(0,0, 300, 49);
// Definir as cores da caneta
Canvas.Brush.Color := clBlack;
Canvas.Pen.Color := clBlack;
// Escrever o código de barras no canvas
for i := 1 to length(s) do
begin
// Definir a espessura da barra
t := strToInt(s[i]) * 2 + 1;
// Imprimir apenas barra sim barra não (preto/branco - intercalado);
if i mod 2 = 1 then
Canvas.Rectangle(x, 0, x + t, 79);
// Passar para a próxima barra
x := x + t;
end;
except
        MessageDlg('Preencha todo o Campo.', mtInformation, mbOKCancel, 0);

        dm.fb_produtos.Active := true;
        dm.fb_produtos.Insert;
        listar;
        end;
end;

procedure TfrmProdutos.habilitarCampos;
begin

     edCodigo.Enabled := true;
     edNome.Enabled := true;
     edDescricao.Enabled := true;
     edValor.Enabled := true;
     cbUnd.Enabled := true;
     butAdd.Enabled := true;
     imgCod.Visible := true;

end;

procedure TfrmProdutos.limpar;
begin
      edCodigo.Text := '';
      edNome.Text := '';
      edDescricao.Text := '';
      cbUnd.Text := '';
      edValor.Text := '';
      cbUnd.Text := '';
      carregarImgPadrao;
end;

procedure TfrmProdutos.listar;
begin

     dm.query_produtos.Close;
     dm.query_produtos.SQL.Clear;
     dm.query_produtos.SQL.Add('SELECT * from produtos order by nome asc');
     dm.query_produtos.Open;
end;
procedure TfrmProdutos.salvarFoto;
begin
if dialog.FileName <> '' then
begin

  img := TPicture.Create;
  img.LoadFromFile(dialog.Filename);
  dm.fb_produtos.FieldByName('imagem').Assign(img);
  img.Free;
  dialog.Filename := GetCurrentDir + '\img\sem-foto.jpg';
  alterou := false;
end
else
begin
 dm.fb_produtos.FieldByName('imagem').Value := GetCurrentDir + '\img\sem-foto.jpg';

end;

end;

procedure TfrmProdutos.txtBuscarCodigoChange(Sender: TObject);
begin
buscarCodigo1;
end;

procedure TfrmProdutos.txtBuscarProdutoChange(Sender: TObject);
begin
buscarNome1;
end;

end.
