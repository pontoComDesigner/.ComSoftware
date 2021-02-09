unit Funcionários;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Buttons, Vcl.StdCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.Mask, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage;

type
  TfrmFuncionarios = class(TForm)
    txtBuscarNome: TEdit;
    butNome: TRadioButton;
    butCPF: TRadioButton;
    txtBuscarCPF: TMaskEdit;
    txtBuscar: TLabel;
    txtNomeFuncionario: TEdit;
    edEndereco: TEdit;
    edCPF: TMaskEdit;
    edTelefone: TMaskEdit;
    txtNome: TLabel;
    txtEndereco: TLabel;
    txtCPF: TLabel;
    txtTelefone: TLabel;
    txtCargo: TLabel;
    DBGrid1: TDBGrid;
    cbCargo: TComboBox;
    butNOVO: TSpeedButton;
    butSalvar: TSpeedButton;
    butEditar: TSpeedButton;
    butExcluir: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    Image1: TImage;
    procedure FormShow(Sender: TObject);
    procedure butNOVOClick(Sender: TObject);
    procedure butSalvarClick(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure butEditarClick(Sender: TObject);
    procedure butExcluirClick(Sender: TObject);
    procedure txtBuscarNomeChange(Sender: TObject);
    procedure txtBuscarCPFChange(Sender: TObject);
    procedure butNomeClick(Sender: TObject);
    procedure butCPFClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
  private
    { Private declarations }
    procedure limpar;
    procedure habilitarCampos;
    procedure desabilitarCampos;

    procedure associarCampos;
    procedure listar;

    procedure carregarComboBox;
    procedure buscarNome;
    procedure buscarCpf;


  public
    { Public declarations }
  end;

var
  frmFuncionarios: TfrmFuncionarios;
  id : string;
  cpfAntigo : string;
implementation

{$R *.dfm}

uses Modulo;

{ TfrmFuncionarios }

procedure TfrmFuncionarios.associarCampos;
begin
dm.fb_func.FieldByName('nome').Value := txtNomeFuncionario.Text;
dm.fb_func.FieldByName('cpf').Value := edCpf.Text;
dm.fb_func.FieldByName('endereco').Value := edEndereco.Text;
dm.fb_func.FieldByName('telefone').Value := edTelefone.Text;
dm.fb_func.FieldByName('cargo').Value := cbCargo.Text;
dm.fb_func.FieldByName('data').Value := DateToStr(Date);
end;

procedure TfrmFuncionarios.buscarCpf;
begin
     dm.query_func.Close;
     dm.query_func.SQL.Clear;
     dm.query_func.SQL.Add('SELECT * from funcionarios where cpf = :cpf order by nome asc');
     dm.query_func.ParamByName('cpf').Value := txtBuscarCpf.Text;
     dm.query_func.Open;
end;

procedure TfrmFuncionarios.buscarNome;
begin
     dm.query_func.Close;
     dm.query_func.SQL.Clear;
     dm.query_func.SQL.Add('SELECT * from funcionarios where nome LIKE :nome order by nome asc');
     dm.query_func.ParamByName('nome').Value := txtBuscarNome.Text + '%';
     dm.query_func.Open;
end;

procedure TfrmFuncionarios.butCPFClick(Sender: TObject);
begin
listar;
txtBuscarCPF.Visible := true;
txtBuscarNome.Visible := false;
end;

procedure TfrmFuncionarios.butEditarClick(Sender: TObject);
var
cpf : string;
begin
  if Trim(txtNomeFuncionario.Text) = '' then
     begin
         MessageDlg('Preencha o Nome!', mtInformation, mbOKCancel, 0);
         txtNomeFuncionario.SetFocus;
         exit;
     end;
      if Trim(edCpf.Text) = '' then
     begin
         MessageDlg('Preencha o CPF!', mtInformation, mbOKCancel, 0);
         edCpf.SetFocus;
         exit;
     end;


     if cpfAntigo <> edCpf.Text then
         begin
           ///Verificar se o CPF ja Existe
           dm.query_func.Close;
           dm.query_func.SQL.Clear;
           dm.query_func.SQL.Add('SELECT * from funcionarios where cpf = ' + QuotedStr(Trim(edCpf.Text)));
           dm.query_func.Open;

           if not dm.query_func.isEmpty then
           begin
              cpf := dm.query_func['cpf'];
              MessageDlg('O CPF ' + cpf + ' já está cadastrado!', mtInformation, mbOKCancel, 0);
              edCpf.Text := '';
              edCpf.SetFocus;
              exit;
           end;
     end;

     associarcampos;
     dm.query_func.Close;
     dm.query_func.SQL.Clear;
     dm.query_func.SQL.Add('UPDATE funcionarios set nome = :nome, cpf = :cpf, endereco = :endereco, telefone = :telefone, cargo = :cargo where id = :id');
     dm.query_func.ParamByName('nome').Value := txtNomeFuncionario.Text;
     dm.query_func.ParamByName('cpf').Value := edCpf.Text;
     dm.query_func.ParamByName('endereco').Value := edEndereco.Text;
     dm.query_func.ParamByName('telefone').Value := edTelefone.Text;
     dm.query_func.ParamByName('cargo').Value := cbCargo.Text;
     dm.query_func.ParamByName('id').Value := id;
     dm.query_func.ExecSQL;

     ///editar o cargo do usuario

     associarcampos;
     dm.query_usuarios.Close;
     dm.query_usuarios.SQL.Clear;
     dm.query_usuarios.SQL.Add('UPDATE usuarios set cargo = :cargo where id_funcionario = :id');
     dm.query_usuarios.ParamByName('cargo').Value := cbCargo.Text;
     dm.query_usuarios.ParamByName('id').Value := id;
     dm.query_usuarios.ExecSQL;


     listar;
     MessageDlg('Alterado com Sucesso!!', mtInformation, mbOKCancel, 0);
     butEditar.Enabled := false;
     butExcluir.Enabled := false;
     limpar;
     desabilitarCampos;
     listar;
end;

procedure TfrmFuncionarios.butExcluirClick(Sender: TObject);
begin
if MessageDlg('Deseja Excluir o Registro de Cargo?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
begin
  dm.query_func.Delete;
  MessageDlg('Deletado com Sucesso!!', mtInformation, mbOKCancel, 0);
  butEditar.Enabled := false;
  butExcluir.Enabled := false;
  txtNomeFuncionario.Text := '';
end;


///deletar tambem o usuario associado

     dm.query_usuarios.Close;
     dm.query_usuarios.SQL.Clear;
     dm.query_usuarios.SQL.Add('DELETE from usuarios where id_funcionario = :id');
     dm.query_usuarios.ParamByName('id').Value := id;
     dm.query_usuarios.Execute;

  listar;
end;

procedure TfrmFuncionarios.butNomeClick(Sender: TObject);
begin
listar;
txtBuscarCpf.Visible := false;
txtBuscarNome.Visible := true;
end;

procedure TfrmFuncionarios.butNOVOClick(Sender: TObject);
begin

habilitarCampos;
dm.fb_func.Insert;
txtNomeFuncionario.SetFocus;
butSalvar.Enabled := true;

limpar;
end;

procedure TfrmFuncionarios.butSalvarClick(Sender: TObject);
var
cpf : string;
begin
  if Trim(txtNomeFuncionario.Text) = '' then
     begin
         MessageDlg('Preencha o Nome!', mtInformation, mbOKCancel, 0);
         txtNomeFuncionario.SetFocus;
         exit;
     end;
      if Trim(edCpf.Text) = '' then
     begin
         MessageDlg('Preencha o CPF!', mtInformation, mbOKCancel, 0);
         edCpf.SetFocus;
         exit;
     end;
     ///Verificar se o CPF ja Existe
     dm.query_func.Close;
     dm.query_func.SQL.Clear;
     dm.query_func.SQL.Add('SELECT * from funcionarios where cpf = ' + QuotedStr(Trim(edCpf.Text)));
     dm.query_func.Open;

     if not dm.query_func.isEmpty then
     begin
        cpf := dm.query_func['cpf'];
        MessageDlg('O CPF ' + cpf + ' já está cadastrado!', mtInformation, mbOKCancel, 0);
        edCpf.Text := '';
        edCpf.SetFocus;
        exit;
     end;

associarcampos;
dm.fb_Func.Post;
MessageDlg('Salvo com Sucesso!', mtInformation, mbOKCancel, 0);
limpar;
desabilitarCampos;
butSalvar.Enabled := false;
listar;

end;

procedure TfrmFuncionarios.carregarComboBox;
begin
  dm.query_cargos.Close;
  dm.query_cargos.Open;


if not dm.query_cargos.isEmpty then
begin
  while not dm.query_cargos.Eof do
  begin
    cbCargo.Items.Add(dm.query_cargos.FieldByName('cargo').AsString);
    dm.query_cargos.Next;
  end;

end;

end;

procedure TfrmFuncionarios.DBGrid1CellClick(Column: TColumn);
begin
habilitarCampos;
butEditar.Enabled := true;
butExcluir.Enabled := true;

dm.query_func.Edit;

dm.fb_func.Edit;



if dm.query_func.FieldByName('nome').Value <> null then
txtNomeFuncionario.Text := dm.query_func.FieldByName('nome').Value;

edCpf.Text := dm.query_func.FieldByName('cpf').Value;

cbCargo.Text := dm.query_func.FieldByName('cargo').Value;

if dm.query_func.FieldByName('telefone').Value <> null then
edTelefone.Text := dm.query_func.FieldByName('telefone').Value;

if dm.query_func.FieldByName('endereco').Value <> null then
edEndereco.Text := dm.query_func.FieldByName('endereco').Value;

id := dm.query_func.FieldByName('id').Value;

cpfAntigo := dm.query_func.FieldByName('cpf').Value;

end;

procedure TfrmFuncionarios.DBGrid1DblClick(Sender: TObject);
begin
if chamada = 'Func' then
begin
  idFunc := dm.query_func.FieldByName('id').Value;
  nomeFunc := dm.query_func.FieldByName('nome').Value;
  cargoFunc := dm.query_func.FieldByName('cargo').Value;
  Close;
  chamada := '';
end;

end;

procedure TfrmFuncionarios.desabilitarCampos;
begin
txtNomeFuncionario.Enabled := false;
edEndereco.Enabled := false;
edCpf.Enabled := false;
edTelefone.Enabled := false;
cbCargo.Enabled := false;
end;

procedure TfrmFuncionarios.FormShow(Sender: TObject);
begin
desabilitarCampos;
dm.fb_func.Active := true;
listar;
carregarComboBox;
cbCargo.ItemIndex := 0;
txtBuscarCpf.Visible := false;
butNome.Checked := true;
end;

procedure TfrmFuncionarios.habilitarCampos;
begin
txtNomeFuncionario.Enabled := true;
edEndereco.Enabled := true;
edCpf.Enabled := true;
edTelefone.Enabled := true;
cbCargo.Enabled := true;
end;

procedure TfrmFuncionarios.limpar;
begin
txtNomeFuncionario.Text := '';
edEndereco.Text := '';
edCpf.Text := '';
edTelefone.Text := '';

end;

procedure TfrmFuncionarios.listar;
begin
     dm.query_func.Close;
     dm.query_func.SQL.Clear;
     dm.query_func.SQL.Add('SELECT * from funcionarios order by nome asc');
     dm.query_func.Open;
end;

procedure TfrmFuncionarios.txtBuscarCPFChange(Sender: TObject);
begin
buscarCPF;
end;

procedure TfrmFuncionarios.txtBuscarNomeChange(Sender: TObject);
begin
buscarNome;
end;

end.
