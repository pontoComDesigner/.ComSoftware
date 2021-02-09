unit Usuários;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Buttons, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage;

type
  TfrmUsuarios = class(TForm)
    txtBuscar: TLabel;
    txtBuscarNome: TEdit;
    txtNomeFuncionario: TEdit;
    txtNome: TLabel;
    DBGrid1: TDBGrid;
    butNOVO: TSpeedButton;
    butSalvar: TSpeedButton;
    butEditar: TSpeedButton;
    butExcluir: TSpeedButton;
    edUsuario: TEdit;
    Label1: TLabel;
    edSenha: TEdit;
    Label2: TLabel;
    TSpeedButton: TSpeedButton;
    Image1: TImage;
    procedure TSpeedButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure butSalvarClick(Sender: TObject);
    procedure butNOVOClick(Sender: TObject);
    procedure txtBuscarNomeChange(Sender: TObject);
    procedure butEditarClick(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure butExcluirClick(Sender: TObject);
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
  frmUsuarios: TfrmUsuarios;
  usuarioAntigo : string;
implementation

{$R *.dfm}

uses Funcionários, Modulo;

procedure TfrmUsuarios.associarCampos;
begin
  dm.fb_usuarios.FieldByName('nome').Value := txtNomeFuncionario.Text;
  dm.fb_usuarios.FieldByName('usuario').Value := edUsuario.Text;
  dm.fb_usuarios.FieldByName('senha').Value := edSenha.Text;
  dm.fb_usuarios.FieldByName('cargo').Value := cargoFunc;
  dm.fb_usuarios.FieldByName('id_funcionario').Value := idFunc;
end;

procedure TfrmUsuarios.buscarNome;
begin
     dm.query_usuarios.Close;
     dm.query_usuarios.SQL.Clear;
     dm.query_usuarios.SQL.Add('SELECT * from usuarios where nome LIKE :nome and cargo <> :cargo order by nome asc');
     dm.query_usuarios.ParamByName('nome').Value := txtBuscarNome.Text + '%';
     dm.query_usuarios.ParamByName('cargo').Value := 'admin';
     dm.query_usuarios.Open;
end;

procedure TfrmUsuarios.butEditarClick(Sender: TObject);
var
usuario : string;
begin
  if Trim(txtNomeFuncionario.Text) = '' then
     begin
         MessageDlg('Preencha o Nome!', mtInformation, mbOKCancel, 0);
         txtNomeFuncionario.SetFocus;
         exit;
     end;
       if Trim(edUsuario.Text) = '' then
     begin
         MessageDlg('Preencha o Usuário!', mtInformation, mbOKCancel, 0);
         edUsuario.SetFocus;
         exit;
     end;
       if Trim(edSenha.Text) = '' then
     begin
         MessageDlg('Preencha a Senha!', mtInformation, mbOKCancel, 0);
         edSenha.SetFocus;
         exit;
     end;

     if usuarioAntigo <> edUsuario.Text then
        begin
         ///Verificar se o CPF ja Existe
         dm.query_usuarios.Close;
         dm.query_usuarios.SQL.Clear;
         dm.query_usuarios.SQL.Add('SELECT * from usuarios where usuario = ' + QuotedStr(Trim(edUsuario.Text)));
         dm.query_usuarios.Open;

         if not dm.query_usuarios.isEmpty then
         begin
            usuario := dm.query_usuarios['usuario'];
            MessageDlg('O Usuário ' + usuario + ' já está cadastrado!', mtInformation, mbOKCancel, 0);
            edUsuario.Text := '';
            edUsuario.SetFocus;
            exit;
          end;
        end;

     ///associarcampos;
     dm.query_usuarios.Close;
     dm.query_usuarios.SQL.Clear;
     dm.query_usuarios.SQL.Add('UPDATE usuarios set nome = :nome, usuario = :usuario, senha = :senha where id = :id');
     dm.query_usuarios.ParamByName('nome').Value := txtNomeFuncionario.Text;
     dm.query_usuarios.ParamByName('usuario').Value := edUsuario.Text;
     dm.query_usuarios.ParamByName('senha').Value := edSenha.Text;

     dm.query_usuarios.ParamByName('id').Value := id;
     dm.query_usuarios.ExecSQL;

     listar;
     MessageDlg('Alterado com Sucesso!!', mtInformation, mbOKCancel, 0);
     butEditar.Enabled := false;
     butExcluir.Enabled := false;
     limpar;
     desabilitarCampos;

end;

procedure TfrmUsuarios.butExcluirClick(Sender: TObject);
begin
if MessageDlg('Deseja Excluir o Registro de Cargo?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
begin
  dm.query_usuarios.Delete;
  MessageDlg('Deletado com Sucesso!!', mtInformation, mbOKCancel, 0);

  listar;

  butEditar.Enabled := false;
  butExcluir.Enabled := false;
  txtNomeFuncionario.Text := '';

end;
end;

procedure TfrmUsuarios.butNOVOClick(Sender: TObject);
begin
habilitarCampos;
dm.fb_usuarios.Insert;
butSalvar.Enabled := true;
end;

procedure TfrmUsuarios.butSalvarClick(Sender: TObject);
var
usuario : string;
begin
       if Trim(txtNomeFuncionario.Text) = '' then
     begin
         MessageDlg('Preencha o Nome!', mtInformation, mbOKCancel, 0);
         txtNomeFuncionario.SetFocus;
         exit;
     end;
       if Trim(edUsuario.Text) = '' then
     begin
         MessageDlg('Preencha o Usuário!', mtInformation, mbOKCancel, 0);
         edUsuario.SetFocus;
         exit;
     end;
       if Trim(edSenha.Text) = '' then
     begin
         MessageDlg('Preencha a Senha!', mtInformation, mbOKCancel, 0);
         edSenha.SetFocus;
         exit;
     end;


     ///Verificar se o CPF ja Existe
       dm.query_usuarios.Close;
       dm.query_usuarios.SQL.Clear;
       dm.query_usuarios.SQL.Add('SELECT * from usuarios where usuario = ' + QuotedStr(Trim(edUsuario.Text)));
       dm.query_usuarios.Open;

       if not dm.query_usuarios.isEmpty then
       begin
          usuario := dm.query_usuarios['usuario'];
          MessageDlg('O Usuário ' + usuario + ' já está cadastrado!', mtInformation, mbOKCancel, 0);
          edUsuario.Text := '';
          edUsuario.SetFocus;
          exit;
       end;


associarcampos;
dm.fb_usuarios.Post;
MessageDlg('Salvo com Sucesso!', mtInformation, mbOKCancel, 0);
limpar;
desabilitarCampos;
butSalvar.Enabled := false;
listar;

end;

procedure TfrmUsuarios.DBGrid1CellClick(Column: TColumn);
begin
  habilitarCampos;
  butEditar.Enabled := true;
  butExcluir.Enabled := true;

  dm.query_usuarios.Edit;

  dm.fb_usuarios.Edit;

  txtNomeFuncionario.Text := dm.query_usuarios.FieldByName('nome').Value;

  edUsuario.Text := dm.query_usuarios.FieldByName('usuario').Value;

  edSenha.Text := dm.query_usuarios.FieldByName('senha').Value;

  id := dm.query_usuarios.FieldByName('id').Value;

  usuarioAntigo := dm.query_usuarios.FieldByName('usuario').Value;
end;

procedure TfrmUsuarios.desabilitarCampos;
begin
 txtNomeFuncionario.Enabled := false;
 edUsuario.Enabled := false;
 edSenha.Enabled := false;
 TSpeedButton.Enabled := false;
end;

procedure TfrmUsuarios.FormActivate(Sender: TObject);
begin
txtNomeFuncionario.Text := nomeFunc;
end;

procedure TfrmUsuarios.FormShow(Sender: TObject);
begin
desabilitarCampos;
dm.fb_usuarios.Active := true;
listar;
end;

procedure TfrmUsuarios.habilitarCampos;
begin

 edUsuario.Enabled := true;
 edSenha.Enabled := true;
 TSpeedButton.Enabled := true;
end;

procedure TfrmUsuarios.limpar;
begin
 txtNomeFuncionario.Text := '';
 edUsuario.Text := '';
 edSenha.Text := '';
end;

procedure TfrmUsuarios.listar;
begin
     dm.query_usuarios.Close;
     dm.query_usuarios.SQL.Clear;
     dm.query_usuarios.SQL.Add('SELECT * from usuarios where cargo <> :cargo order by nome asc');
     dm.query_usuarios.ParamByName('cargo').Value := 'admin';
     dm.query_usuarios.Open;
end;

procedure TfrmUsuarios.TSpeedButtonClick(Sender: TObject);
begin
chamada := 'Func';
frmFuncionarios := TfrmFuncionarios.Create(self);
frmFuncionarios.Show;
end;

procedure TfrmUsuarios.txtBuscarNomeChange(Sender: TObject);
begin
buscarNome;
end;

end.
