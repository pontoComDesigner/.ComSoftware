unit Fornecedores;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.Mask, Vcl.Buttons, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage;

type
  TfrmFornec = class(TForm)
    txtBuscar: TLabel;
    txtNome: TLabel;
    txtEndereco: TLabel;
    txtCPF: TLabel;
    txtTelefone: TLabel;
    txtCargo: TLabel;
    butNOVO: TSpeedButton;
    butSalvar: TSpeedButton;
    butEditar: TSpeedButton;
    butExcluir: TSpeedButton;
    txtBuscarNome: TEdit;
    edEmpresa: TEdit;
    edEndereco: TEdit;
    edTelefone: TMaskEdit;
    cbProduto: TEdit;
    DBGrid1: TDBGrid;
    edCpf: TEdit;
    Image1: TImage;
    procedure butNOVOClick(Sender: TObject);
    procedure butSalvarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure butEditarClick(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure butExcluirClick(Sender: TObject);
    procedure txtBuscarNomeChange(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
  private
    { Private declarations }
    procedure limpar;
    procedure habilitarCampos;
    procedure desabilitarCampos;

    procedure associarCampos;
    procedure listar;

    procedure buscarNome;
  public
    { Public declarations }
  end;

var
  frmFornec: TfrmFornec;

  id : string;

implementation

{$R *.dfm}

uses Modulo;

procedure TfrmFornec.associarCampos;
begin
dm.fb_fornecedores.FieldByName('nome').Value := edEmpresa.Text;
dm.fb_fornecedores.FieldByName('produto').Value := cbProduto.Text;
dm.fb_fornecedores.FieldByName('email').Value := edEndereco.Text;
dm.fb_fornecedores.FieldByName('telefone').Value := edTelefone.Text;
dm.fb_fornecedores.FieldByName('cpf').Value := edCpf.Text;
dm.fb_fornecedores.FieldByName('data').Value := DateToStr(Date);
end;

procedure TfrmFornec.buscarNome;
begin
     dm.query_fornecedores.Close;
     dm.query_fornecedores.SQL.Clear;
     dm.query_fornecedores.SQL.Add('SELECT * from fornecedores where nome LIKE :nome order by nome asc');
     dm.query_fornecedores.ParamByName('nome').Value := txtBuscarNome.Text + '%';
     dm.query_fornecedores.Open;
end;

procedure TfrmFornec.butEditarClick(Sender: TObject);
begin
     if Trim(edEmpresa.Text) = '' then
     begin
         MessageDlg('Preencha o Nome da Empresa!', mtInformation, mbOKCancel, 0);
         EdEmpresa.SetFocus;
         exit;
     end;
      if Trim(edCpf.Text) = '' then
     begin
         MessageDlg('Preencha o CPF ou CNPJ!', mtInformation, mbOKCancel, 0);
         edCpf.SetFocus;
         exit;
     end;
      if Trim(edTelefone.Text) = '' then
     begin
         MessageDlg('Preencha o Contato!', mtInformation, mbOKCancel, 0);
         edTelefone.SetFocus;
         exit;
     end;

     associarcampos;
     dm.query_fornecedores.Close;
     dm.query_fornecedores.SQL.Clear;
     dm.query_fornecedores.SQL.Add('UPDATE fornecedores set nome = :nome, produto = :produto, email = :email, telefone = :telefone, cpf = :cpf where id = :id');
     dm.query_fornecedores.ParamByName('nome').Value := edEmpresa.Text;
     dm.query_fornecedores.ParamByName('cpf').Value := edCpf.Text;
     dm.query_fornecedores.ParamByName('email').Value := edEndereco.Text;
     dm.query_fornecedores.ParamByName('telefone').Value := edTelefone.Text;
     dm.query_fornecedores.ParamByName('produto').Value := cbProduto.Text;
     dm.query_fornecedores.ParamByName('id').Value := id;
     dm.query_fornecedores.ExecSQL;

     listar;
     MessageDlg('Alterado com Sucesso!!', mtInformation, mbOKCancel, 0);
     butEditar.Enabled := false;
     butExcluir.Enabled := false;
     desabilitarCampos;
     listar;


end;

procedure TfrmFornec.butExcluirClick(Sender: TObject);
begin
if MessageDlg('Deseja Excluir o Registro de Cargo?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
begin
  dm.query_fornecedores.Delete;
  MessageDlg('Deletado com Sucesso!!', mtInformation, mbOKCancel, 0);

  butEditar.Enabled := false;
  butExcluir.Enabled := false;
  edEmpresa.Text := '';
  listar;
end;
end;

procedure TfrmFornec.butNOVOClick(Sender: TObject);
begin
habilitarCampos;
dm.fb_fornecedores.Insert;
butSalvar.Enabled := true;
edEmpresa.SetFocus;
      edEmpresa.Text := '';
      edEndereco.Text := '';
      edCpf.Text := '';
      edTelefone.Text := '';
      cbProduto.Text := '';

end;

procedure TfrmFornec.butSalvarClick(Sender: TObject);
begin
      if Trim(edEmpresa.Text) = '' then
     begin
         MessageDlg('Preencha o Nome da Empresa!', mtInformation, mbOKCancel, 0);
         EdEmpresa.SetFocus;
         exit;
     end;
      if Trim(edCpf.Text) = '' then
     begin
         MessageDlg('Preencha o CPF ou CNPJ!', mtInformation, mbOKCancel, 0);
         edCpf.SetFocus;
         exit;
     end;
      if Trim(edTelefone.Text) = '' then
     begin
         MessageDlg('Preencha o Contato!', mtInformation, mbOKCancel, 0);
         edTelefone.SetFocus;
         exit;
     end;

      associarcampos;
      dm.fb_fornecedores.Post;
      MessageDlg('Salvo com Sucesso!', mtInformation, mbOKCancel, 0);
      limpar;
      desabilitarCampos;
      butSalvar.Enabled := false;
      listar;
end;

procedure TfrmFornec.DBGrid1CellClick(Column: TColumn);
begin
habilitarCampos;
butEditar.Enabled := true;
butExcluir.Enabled := true;

dm.query_fornecedores.Edit;

dm.fb_fornecedores.Edit;

id := dm.query_fornecedores.FieldByName('id').Value;

edEmpresa.Text := dm.query_fornecedores.FieldByName('nome').Value;

edCpf.Text := dm.query_fornecedores.FieldByName('cpf').Value;

cbProduto.Text := dm.query_fornecedores.FieldByName('produto').Value;

if dm.query_fornecedores.FieldByName('telefone').Value <> null then
edTelefone.Text := dm.query_fornecedores.FieldByName('telefone').Value;

if dm.query_fornecedores.FieldByName('email').Value <> null then
edEndereco.Text := dm.query_fornecedores.FieldByName('email').Value;

end;

procedure TfrmFornec.DBGrid1DblClick(Sender: TObject);
begin
if chamada = 'Forn' then
begin
  idFornecedor := dm.query_fornecedores.FieldByName('id').Value;
  nomeFornecedor := dm.query_fornecedores.FieldByName('nome').Value;

  Close;
  chamada := '';
end;
end;

procedure TfrmFornec.desabilitarCampos;
begin
     edEmpresa.Enabled := false;
     edEndereco.Enabled := false;
     edCpf.Enabled := false;
     edTelefone.Enabled := false;
     cbProduto.Enabled := false;
end;


procedure TfrmFornec.FormDblClick(Sender: TObject);
begin
if chamada = 'Prod' then
begin
  idFornecedor := dm.query_fornecedores.FieldByName('id').Value;
  nomeFornecedor := dm.query_fornecedores.FieldByName('nome').Value;
  Close;
  chamada := '';
end;
end;

procedure TfrmFornec.FormShow(Sender: TObject);
begin
desabilitarCampos;
dm.fb_fornecedores.Active := true;
listar;
end;

procedure TfrmFornec.habilitarCampos;
begin
      edEmpresa.Enabled := true;
      edEndereco.Enabled := true;
      edCpf.Enabled := true;
      edTelefone.Enabled := true;
      cbProduto.Enabled := true;
end;

procedure TfrmFornec.limpar;
begin
      edEmpresa.Text := '';
      edEndereco.Text := '';
      edCpf.Text := '';
      edTelefone.Text := '';
      cbProduto.Text := '';
end;

procedure TfrmFornec.listar;
begin
     dm.query_fornecedores.Close;
     dm.query_fornecedores.SQL.Clear;
     dm.query_fornecedores.SQL.Add('SELECT * from fornecedores order by nome asc');
     dm.query_fornecedores.Open;
end;

procedure TfrmFornec.txtBuscarNomeChange(Sender: TObject);
begin
buscarNome;
end;

end.
