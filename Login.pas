unit Login;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.Imaging.pngimage;

type
  TFrmLogin = class(TForm)
    butSair: TSpeedButton;
    butEntrar: TSpeedButton;
    butSenha: TEdit;
    butLogin: TEdit;
    Label1: TLabel;
    Image1: TImage;
    procedure butEntrarClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure butSairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure login;
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.dfm}

uses Menu, Modulo, Caixa;

procedure TFrmLogin.butEntrarClick(Sender: TObject);
begin
     if Trim(butLogin.Text) = '' then
     begin
         MessageDlg('Preencha o Usuário!', mtInformation, mbOKCancel, 0);
         butLogin.SetFocus;
         exit;
     end;

     if Trim(butSenha.Text) = '' then
     begin
         MessageDlg('Preencha o Senha!', mtInformation, mbOKCancel, 0);
         butSenha.SetFocus;
         exit;
     end;

     login;
end;


procedure TFrmLogin.butSairClick(Sender: TObject);
begin
frmLogin.Close;
end;

procedure TFrmLogin.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = 13 then
login;
end;

procedure TFrmLogin.FormShow(Sender: TObject);
begin
butLogin.SetFocus;
end;

procedure TFrmLogin.login;
begin
//aqui virá o código de loguin
     dm.query_usuarios.Close;
     dm.query_usuarios.SQL.Clear;
     dm.query_usuarios.SQL.Add('SELECT * from usuarios where usuario = :usuario and senha = :senha');
     dm.query_usuarios.ParamByName('usuario').Value := butLogin.Text;
     dm.query_usuarios.ParamByName('senha').Value := butSenha.Text;
     dm.query_usuarios.Open;

     if not dm.query_usuarios.isEmpty then
     begin
        nomeUsuario := dm.query_usuarios['nome'];
        cargoUsuario := dm.query_usuarios['cargo'];

        if cargoUsuario = 'Operador' then
        begin
          frmCaixa := TfrmCaixa.Create(Self);
          butSenha.Text := '';
          statusCaixa := 'Abertura';
          frmCaixa.ShowModal;
          exit;
        end;




        frmMenu := TfrmMenu.Create(Self);
        butSenha.Text := '';
        frmMenu.ShowModal;

        end
        else
        begin
        MessageDlg('Os dados estão Incorretos!', mtInformation, mbOKCancel, 0);
        butLogin.Text := '';
        butSenha.Text := '';
        butLogin.SetFocus;
     end;


end;

end.
