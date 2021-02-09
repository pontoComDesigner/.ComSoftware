unit PesquisaProdutos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids;

type
  TfrmPesquisa = class(TForm)
    DBGrid1: TDBGrid;
    txtBuscar: TEdit;
    procedure txtBuscarChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    procedure buscarProduto;
    procedure listar;


  public
    { Public declarations }
  end;

var
  frmPesquisa: TfrmPesquisa;

implementation

{$R *.dfm}

uses Modulo;

{ TfrmPesquisa }

procedure TfrmPesquisa.buscarProduto;
begin
dm.query_produtos.Close;
dm.query_produtos.SQL.Clear;
dm.query_produtos.SQL.Add('SELECT * from produtos where nome LIKE :nome or codigo LIKE :codigo order by nome asc');
dm.query_produtos.ParamByName('nome').Value := txtBuscar.Text + '%';
dm.query_produtos.ParamByName('codigo').Value := txtBuscar.Text + '%';
dm.query_produtos.Open;
end;

procedure TfrmPesquisa.DBGrid1DblClick(Sender: TObject);
begin
if chamada = 'Pesq' then
begin
  codigoProduto := dm.query_produtos.FieldByName('codigo').Value;
  chamada := '';
  Close;
  codigoProduto := '';
  exit;
end;
end;

procedure TfrmPesquisa.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
///fechar formulario
if key = VK_ESCAPE then
close;
///buscar no grid
if key = VK_TAB then
DBGrid1.SetFocus;
///voltar para buscar
if key = VK_INSERT then
txtBuscar.SetFocus;

end;

procedure TfrmPesquisa.FormShow(Sender: TObject);
begin
txtBuscar.SetFocus;
listar;
end;

procedure TfrmPesquisa.listar;
begin
     dm.query_produtos.Close;
     dm.query_produtos.SQL.Clear;
     dm.query_produtos.SQL.Add('SELECT * from produtos order by nome asc');
     dm.query_produtos.Open;
end;

procedure TfrmPesquisa.txtBuscarChange(Sender: TObject);
begin
buscarProduto;
end;
end.
