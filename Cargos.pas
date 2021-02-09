unit Cargos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Buttons, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls, Vcl.Imaging.pngimage, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls;

type
  TfrmCargos = class(TForm)
    txtoNome: TEdit;
    txtNome: TLabel;
    grid: TDBGrid;
    butEditar: TSpeedButton;
    butNOVO: TSpeedButton;
    butSalvar: TSpeedButton;
    butExcluir: TSpeedButton;
    Image1: TImage;
    procedure butNOVOClick(Sender: TObject);
    procedure butSalvarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure gridCellClick(Column: TColumn);
    procedure butEditarClick(Sender: TObject);
    procedure butExcluirClick(Sender: TObject);
  private
    { Private declarations }
    procedure associarcampos;
    procedure listar;
  public
    { Public declarations }
  end;

var
  frmCargos: TfrmCargos;
  id : string;

implementation

{$R *.dfm}

uses Modulo;

procedure TfrmCargos.associarcampos;
begin
dm.fb_Cargoscargo.FieldByName('cargo').Value := txtoNome.Text;
end;

procedure TfrmCargos.butEditarClick(Sender: TObject);
var
cargo : string;
begin
  if Trim(txtoNome.Text) = '' then
     begin
         MessageDlg('Preencha o Cargo!', mtInformation, mbOKCancel, 0);
         txtoNome.SetFocus;
         exit;
     end;

     ///Verificar se o Cadastro ja Existe
     dm.query_cargos.Close;
     dm.query_cargos.SQL.Clear;
     dm.query_cargos.SQL.Add('SELECT * from cargos where cargo = ' + QuotedStr(Trim(txtoNome.Text)));
     dm.query_cargos.Open;

     if not dm.query_cargos.isEmpty then
     begin
        cargo := dm.query_cargos['cargo'];
        MessageDlg('Após editar o Cargo ' + cargo + ' clique em Editar.', mtInformation, mbOKCancel, 0);
        txtoNome.Text := '';
        txtoNome.SetFocus;
        exit;
     end;

     associarcampos;
     dm.query_cargos.Close;
     dm.query_cargos.SQL.Clear;
     dm.query_cargos.SQL.Add('UPDATE cargos set cargo = :cargo where id = :id');
     dm.query_cargos.ParamByName('cargo').Value := txtoNome.Text;
     dm.query_cargos.ParamByName('id').Value := id;
     dm.query_cargos.ExecSQL;

     listar;
     MessageDlg('Alterado com Sucesso!!', mtInformation, mbOKCancel, 0);
     butEditar.Enabled := false;
     butExcluir.Enabled := false;
     txtoNome.Text := '';

end;

procedure TfrmCargos.butExcluirClick(Sender: TObject);
begin
if MessageDlg('Deseja Excluir o Registro de Cargo?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
begin
  dm.query_cargos.Delete;
  MessageDlg('Deletado com Sucesso!!', mtInformation, mbOKCancel, 0);

  listar;

  butEditar.Enabled := false;
  butExcluir.Enabled := false;
  txtoNome.Text := '';
end;

end;

procedure TfrmCargos.butNOVOClick(Sender: TObject);
begin
butSalvar.Enabled := true;
txtoNome.Enabled := true;
txtoNome.Text := '';
txtoNome.SetFocus;

dm.fb_Cargoscargo.Insert;
end;

procedure TfrmCargos.butSalvarClick(Sender: TObject);
var
cargo : string;
begin
  if Trim(txtoNome.Text) = '' then
     begin
         MessageDlg('Preencha o Cargo!', mtInformation, mbOKCancel, 0);
         txtoNome.SetFocus;
         exit;
     end;
     ///Verificar se o Cadastro ja Existe
     dm.query_cargos.Close;
     dm.query_cargos.SQL.Clear;
     dm.query_cargos.SQL.Add('SELECT * from cargos where cargo = ' + QuotedStr(Trim(txtoNome.Text)));
     dm.query_cargos.Open;

     if not dm.query_cargos.isEmpty then
     begin
        cargo := dm.query_cargos['cargo'];
        MessageDlg('O cargo ' + cargo + ' já está cadastrado!', mtInformation, mbOKCancel, 0);
        txtoNome.Text := '';
        txtoNome.SetFocus;
        exit;
     end;

associarcampos;
dm.fb_Cargoscargo.Post;
MessageDlg('Salvo com Sucesso!', mtInformation, mbOKCancel, 0);
txtoNome.Text := '';
txtoNome.Enabled := false;
butSalvar.Enabled := false;
listar;
end;

procedure TfrmCargos.FormCreate(Sender: TObject);
begin
dm.fb_Cargoscargo.Active := true;
listar;
end;

procedure TfrmCargos.gridCellClick(Column: TColumn);
begin
txtoNome.Enabled := true;
butEditar.Enabled := true;
butExcluir.Enabled := true;

dm.query_cargos.Edit;

dm.fb_Cargoscargo.Edit;

if dm.query_cargos.FieldByName('cargo').Value <> null then
txtoNome.Text := dm.query_cargos.FieldByName('cargo').Value;

id := dm.query_cargos.FieldByName('id').Value;

end;

procedure TfrmCargos.listar;
begin
     dm.query_cargos.Close;
     dm.query_cargos.SQL.Clear;
     dm.query_cargos.SQL.Add('SELECT * from cargos order by cargo asc');
     dm.query_cargos.Open;
end;

end.
