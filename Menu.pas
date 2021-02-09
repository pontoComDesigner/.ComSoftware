unit Menu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, ACBrUtil,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Data.DB, Vcl.Imaging.jpeg, Vcl.StdCtrls,
  Vcl.Grids, Vcl.DBGrids, ShellApi;

type
  TfrmMenu = class(TForm)
    frmMenu: TMainMenu;
    CADASTRO1: TMenuItem;
    FORNECEDORES1: TMenuItem;
    PRODUTOS1: TMenuItem;
    FINANCEIRO1: TMenuItem;
    ENTRADA: TMenuItem;
    SADA1: TMenuItem;
    OPERACIONAL1: TMenuItem;
    CAIXAS1: TMenuItem;
    OPERAÇÕES: TMenuItem;
    MOVIMENTAO1: TMenuItem;
    SAIR1: TMenuItem;
    SAIR2: TMenuItem;
    USARIOS1: TMenuItem;
    Funcionrios1: TMenuItem;
    CARGOS1: TMenuItem;
    NIVELBAIXO: TMenuItem;
    Gastos1: TMenuItem;
    ListadeVendas1: TMenuItem;
    CertificadoDIGITAL1: TMenuItem;
    FluxodeCaixa1: TMenuItem;
    FluxodeCaixa2: TMenuItem;
    Movimentao2: TMenuItem;
    Produtos2: TMenuItem;
    Pesquisa1: TMenuItem;
    Cliente1: TMenuItem;
    Pedidos1: TMenuItem;
    Ferramentas1: TMenuItem;
    BackupdoBanco1: TMenuItem;
    ExcluirDadosdaVenda1: TMenuItem;
    Excluirdados1: TMenuItem;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    Timer1: TTimer;
    ExcluirdadosdeMovimentaes1: TMenuItem;
    Timer2: TTimer;
    pnlEstoque: TPanel;
    lblEstoque: TLabel;
    lblCaixaAberto: TLabel;
    Label8: TLabel;
    lblSaldo: TLabel;
    Label7: TLabel;
    lblSaidas: TLabel;
    Label6: TLabel;
    lblEntradas: TLabel;
    Image3: TImage;
    Label4: TLabel;
    lblCargo: TLabel;
    lblUsuario: TLabel;
    Label3: TLabel;
    Image2: TImage;
    lblData: TLabel;
    Image1: TImage;
    lblHora: TLabel;
    Image4: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Image10: TImage;
    Image11: TImage;
    Image12: TImage;
    Image13: TImage;
    Image14: TImage;
    Label1: TLabel;
    Image5: TImage;
    Image6: TImage;
    procedure USARIOS1Click(Sender: TObject);
    procedure Funcionrios1Click(Sender: TObject);
    procedure CARGOS1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FORNECEDORES1Click(Sender: TObject);
    procedure SAIR2Click(Sender: TObject);
    procedure PRODUTOS1Click(Sender: TObject);
    procedure ENTRADAClick(Sender: TObject);
    procedure SADA1Click(Sender: TObject);
    procedure NIVELBAIXOClick(Sender: TObject);
    procedure CAIXAS1Click(Sender: TObject);
    procedure OPERAÇÕESClick(Sender: TObject);
    procedure Gastos1Click(Sender: TObject);
    procedure ListadeVendas1Click(Sender: TObject);
    procedure CertificadoDIGITAL1Click(Sender: TObject);
    procedure FluxodeCaixa1Click(Sender: TObject);
    procedure CAIXA1Click(Sender: TObject);
    procedure FluxodeCaixa2Click(Sender: TObject);
    procedure Movimentao2Click(Sender: TObject);
    procedure Produtos2Click(Sender: TObject);
    procedure Pesquisa1Click(Sender: TObject);
    procedure Cliente1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure pnlEstoqueClick(Sender: TObject);
    procedure lblEstoqueClick(Sender: TObject);
    procedure ExcluirDadosdaVenda1Click(Sender: TObject);
    procedure Excluirdados1Click(Sender: TObject);
    procedure ExcluirdadosdeMovimentaes1Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure BackupdoBanco1Click(Sender: TObject);
    procedure Conexo1Click(Sender: TObject);
    procedure Image7Click(Sender: TObject);
    procedure Image8Click(Sender: TObject);
    procedure Image9Click(Sender: TObject);
    procedure Image10Click(Sender: TObject);
    procedure Image11Click(Sender: TObject);
    procedure Image12Click(Sender: TObject);
    procedure Image13Click(Sender: TObject);
    procedure Image14Click(Sender: TObject);
  private
    { Private declarations }
    procedure totalizarEntradas;
      procedure totalizarSaidas;
       procedure totalizar;
       procedure totalizarCaixas;
       procedure verificarEstoque;
       procedure listarVendas;
       procedure listarCaixa;
  public
    { Public declarations }
  end;

var
  frmMenu: TfrmMenu;
  TotEntradas: double;
  TotSaida: double;
  TotCaixas: integer;
  backup_db : boolean;

implementation

{$R *.dfm}

uses Usuários, Funcionários, Cargos, Modulo, Fornecedores, Produtos, Entrada,
  Saida, EstoqueBaixo, Vendas, Movimentacoes, Gastos, ListadeVendas,
  CertiDigital, FluxoCaixa, FiltroRelatorio, PesquisaProdutos, CadastroCliente,
  ExcluirVendas;

function ConverterRGB(r, g, b : byte) : TColor;
begin
  result := RGB(r, g, b);
end;



procedure TfrmMenu.BackupdoBanco1Click(Sender: TObject);
var
caminhodb : string;
caminhoDump : string;
nome : string;

begin
backup_db := true;

nome := FormatDateTime('dd-mm-yyy', Now);

caminhodb := GetCurrentDir + '\db\';
caminhoDump := GetCurrentDir + '\db\mysqldump.exe';
caminhodb := caminhodb + nome + '.sql';

//EXECUTAVEL PARA SERVIDOR LOCAL
ShellExecute(handle,'open', 'cmd.exe',Pchar('/c ' + caminhoDump + ' pdv -u root -hlocalhost -p --opt -v> '+ caminhodb),nil, SW_SHOW );


//EXECUTAVEL PARA SERVIDOR HOSPEDADO PAGO
//ShellExecute(handle,'open', 'cmd.exe',Pchar('/c ' + caminhoDump + ' pdvpontocom -u sistema_pontocom -hmysql741.umbler.com:41890 --opt -v> '+ caminhodb),nil, SW_SHOW );
end;

procedure TfrmMenu.CAIXA1Click(Sender: TObject);
begin
rel := 'Movimentacoes';
frmRelGeral := TfrmRelGeral.Create(self);
frmRelGeral.ShowModal;
end;


procedure TfrmMenu.CAIXAS1Click(Sender: TObject);
begin
frmVendas := TfrmVendas.Create(self);
frmVendas.ShowModal;
end;

procedure TfrmMenu.CARGOS1Click(Sender: TObject);
begin
frmCargos := TfrmCargos.Create(self);
frmCargos.ShowModal;
end;

procedure TFrmMenu.CertificadoDigital1Click(Sender: TObject);
var
addLinha: boolean;
i: integer;
serie: string;
caminhoNFCE: string;
begin

FrmCertificadoDigital := TFrmCertificadoDigital.Create(self);

try

  //APONTANDO PARA A PASTA ONDE ESTAO OS COMPONENTES NFCE
  caminhoNFCE := ExtractFilePath(Application.ExeName) + 'nfe\';
  FrmVendas.nfce.Configuracoes.Arquivos.PathSchemas := caminhoNFCE;

  FrmVendas.nfce.SSL.LerCertificadosStore;


  addLinha := true;

  with FrmCertificadoDigital.StringGrid1 do
  begin
     ColWidths[0] := 220;
     ColWidths[1] := 250;
     ColWidths[2] := 120;
     ColWidths[3] := 80;
     ColWidths[4] := 150;

     Cells[0,0] := 'Num Série';
     Cells[1,0] := 'Razão Social';
     Cells[2,0] := 'CNPJ';
     Cells[3,0] := 'Validade';
     Cells[4,0] := 'Certificadora';

  end;

  for i := 0 to FrmVendas.nfce.SSL.ListaCertificados.Count -1 do
  begin

  with FrmVendas.nfce.SSL.ListaCertificados[i] do
  begin
  serie := NumeroSerie;


  with FrmCertificadoDigital.StringGrid1 do
  begin

  if addLinha then
  begin

     RowCount := RowCount + 1;


     Cells[0, RowCount - 1] := NumeroSerie;
     Cells[1, RowCount - 1] := RazaoSocial;
     Cells[2, RowCount - 1] := CNPJ;
     Cells[3, RowCount - 1] := FormatDateBr(DataVenc);
     Cells[4, RowCount - 1] := Certificadora;
     addLinha := true;

  end;




  end;


  end;
end;

FrmCertificadoDigital.ShowModal;
if FrmCertificadoDigital.ModalResult = mrOk then
begin
  certificadoDig := FrmCertificadoDigital.StringGrid1.Cells[0, FrmCertificadoDigital.StringGrid1.Row];

end;

 FrmVendas.nfce.Configuracoes.Certificados.NumeroSerie := certificadoDig;

  FrmVendas.nfce.WebServices.StatusServico.Executar;
  ShowMessage(certificadoDig);
  ShowMessage(FrmVendas.nfce.WebServices.StatusServico.Msg);




finally
FrmCertificadoDigital.Free;
end;

end;

procedure TfrmMenu.Cliente1Click(Sender: TObject);
begin
frmPedidoCliente := TfrmPedidoCliente.Create(self);
frmPedidoCliente.ShowModal;
end;

procedure TfrmMenu.Conexo1Click(Sender: TObject);
begin
FrmEntradaProdutos := TFrmEntradaProdutos.Create(self);
FrmEntradaProdutos.ShowModal;
end;

procedure TfrmMenu.ENTRADAClick(Sender: TObject);
begin
FrmEntradaProdutos := TFrmEntradaProdutos.Create(self);
FrmEntradaProdutos.ShowModal;
end;

procedure TfrmMenu.Excluirdados1Click(Sender: TObject);
begin
if backup_db = true then
begin
ferramenta := 'caixas';
frmExcluirVendas := TfrmExcluirVendas.Create(self);
frmExcluirVendas.ShowModal;
end
else
begin
MessageDlg('Faça primeiro o Backup do Banco de Dados!!!', mtInformation, mbOKCancel, 0);
end;
end;

procedure TfrmMenu.ExcluirDadosdaVenda1Click(Sender: TObject);
begin
if backup_db = true then
begin
ferramenta := 'excluirvenda';
frmExcluirVendas := TfrmExcluirVendas.Create(self);
frmExcluirVendas.ShowModal;
end
else
begin
MessageDlg('Faça primeiro o Backup do Banco de Dados!!!', mtInformation, mbOKCancel, 0);
end;

end;

procedure TfrmMenu.ExcluirdadosdeMovimentaes1Click(Sender: TObject);
begin
if backup_db = true then
begin
ferramenta := 'movimentacao';
frmExcluirVendas := TfrmExcluirVendas.Create(self);
frmExcluirVendas.ShowModal;
end
else
begin
MessageDlg('Faça primeiro o Backup do Banco de Dados!!!', mtInformation, mbOKCancel, 0);
end;

end;

procedure TfrmMenu.FluxodeCaixa1Click(Sender: TObject);
begin
frmFluxoCaixa := TfrmFluxoCaixa.Create(self);
frmFluxoCaixa.ShowModal;
end;

procedure TfrmMenu.FluxodeCaixa2Click(Sender: TObject);
begin
rel := 'Caixa';
frmRelGeral := TfrmRelGeral.Create(self);
frmRelGeral.ShowModal;
end;


procedure TfrmMenu.FormActivate(Sender: TObject);
begin
totalizarEntradas;
totalizarSaidas;
totalizar;
totalizarCaixas;
verificarEstoque;
listarVendas;
listarCaixa;
end;

procedure TfrmMenu.FormShow(Sender: TObject);
begin
if (cargoUsuario = 'Admin') or (cargoUsuario = 'Gerente') then
begin
  USARIOS1.Enabled := true;
end;

if (cargoUsuario = 'Admin') then
begin
  ExcluirDadosdaVenda1.Enabled := true;
  Excluirdados1.Enabled := true;
  ExcluirdadosdeMovimentaes1.Enabled := true;
end;

lblUsuario.Caption := nomeUsuario;
lblCargo.Caption := cargoUsuario;
lblHora.Caption := TimeToStr(Time);
lblData.Caption := DateToStr(Date);



end;

procedure TfrmMenu.FORNECEDORES1Click(Sender: TObject);
begin
frmFornec := TfrmFornec.Create(self);
frmFornec.ShowModal;
end;

procedure TfrmMenu.Funcionrios1Click(Sender: TObject);
begin
FrmFuncionarios := TFrmFuncionarios.Create(self);
FrmFuncionarios.ShowModal;
end;

procedure TfrmMenu.Gastos1Click(Sender: TObject);
begin
FrmGastos := TFrmGastos.Create(self);
FrmGastos.Show;
end;

procedure TfrmMenu.Image10Click(Sender: TObject);
begin
frmFuncionarios := TfrmFuncionarios.Create(self);
frmFuncionarios.Show;
end;

procedure TfrmMenu.Image11Click(Sender: TObject);
begin
FrmFornec := TFrmFornec.Create(self);
FrmFornec.Show;
end;

procedure TfrmMenu.Image12Click(Sender: TObject);
var
caminhodb : string;
caminhoDump : string;
nome : string;

begin
backup_db := true;

nome := FormatDateTime('dd-mm-yyy', Now);

caminhodb := GetCurrentDir + '\db\';
caminhoDump := GetCurrentDir + '\db\mysqldump.exe';
caminhodb := caminhodb + nome + '.sql';

//EXECUTAVEL PARA SERVIDOR LOCAL
ShellExecute(handle,'open', 'cmd.exe',Pchar('/c ' + caminhoDump + ' pdv -u root -hlocalhost -p --opt -v> '+ caminhodb),nil, SW_SHOW );


//EXECUTAVEL PARA SERVIDOR HOSPEDADO PAGO
//ShellExecute(handle,'open', 'cmd.exe',Pchar('/c ' + caminhoDump + ' pdvpontocom -u sistema_pontocom -hmysql741.umbler.com:41890 --opt -v> '+ caminhodb),nil, SW_SHOW );
end;

procedure TfrmMenu.Image13Click(Sender: TObject);
begin
FrmGastos := TFrmGastos.Create(self);
FrmGastos.Show;
end;

procedure TfrmMenu.Image14Click(Sender: TObject);
begin
ShellExecute(Handle,'open','https://whats.link/pontocomsolucoes','','',1)
end;

procedure TfrmMenu.Image7Click(Sender: TObject);
begin
FrmMovimentacoes := TFrmMovimentacoes.Create(self);
FrmMovimentacoes.Show;
end;

procedure TfrmMenu.Image8Click(Sender: TObject);
begin
frmPedidoCliente := TfrmPedidoCliente.Create(self);
frmPedidoCliente.Show;
end;

procedure TfrmMenu.Image9Click(Sender: TObject);
begin
frmProdutos := TfrmProdutos.Create(self);
frmProdutos.Show;
end;

procedure TfrmMenu.lblEstoqueClick(Sender: TObject);
begin
FrmEstoqueBaixo := TFrmEstoqueBaixo.Create(self);
FrmEstoqueBaixo.Show;
end;

procedure TfrmMenu.ListadeVendas1Click(Sender: TObject);
begin
frmListaVenda := TfrmListaVenda.Create(self);
frmListaVenda.ShowModal;
end;

procedure TfrmMenu.listarCaixa;
begin
      dm.query_caixacoringa.Close;
      dm.query_caixacoringa.SQL.Clear;
      dm.query_caixacoringa.SQL.Add('select * from caixa where data_abertura = curDate() order by num_caixa asc limit 10 ');
      dm.query_caixacoringa.Open;
end;

procedure TfrmMenu.listarVendas;
begin
      dm.query_coringavendas.Close;
      dm.query_coringavendas.SQL.Clear;
      dm.query_coringavendas.SQL.Add('select * from vendas where data = curDate() order by id desc limit 10');
      dm.query_coringavendas.Open;
end;

procedure TfrmMenu.Movimentao2Click(Sender: TObject);
begin
rel := 'Movimentacao1';
frmRelGeral := TfrmRelGeral.Create(self);
frmRelGeral.ShowModal;
end;

procedure TfrmMenu.NIVELBAIXOClick(Sender: TObject);
begin
FrmEstoqueBaixo := TFrmEstoqueBaixo.Create(self);
FrmEstoqueBaixo.Show;
end;

procedure TfrmMenu.OPERAÇÕESClick(Sender: TObject);
begin
frmMovimentacoes := TfrmMovimentacoes.Create(self);
frmMovimentacoes.ShowModal;
end;

procedure TfrmMenu.Pesquisa1Click(Sender: TObject);
begin
frmPesquisa:= TfrmPesquisa.Create(self);
frmPesquisa.ShowModal;
end;

procedure TfrmMenu.pnlEstoqueClick(Sender: TObject);
begin
FrmEstoqueBaixo := TFrmEstoqueBaixo.Create(self);
FrmEstoqueBaixo.Show;
end;

procedure TfrmMenu.PRODUTOS1Click(Sender: TObject);
begin
frmProdutos := TfrmProdutos.Create(self);
frmProdutos.ShowModal;
end;

procedure TfrmMenu.Produtos2Click(Sender: TObject);
begin

       dm.query_produtos.Close;
       dm.query_produtos.SQL.Clear;
       dm.query_produtos.SQL.Add('SELECT * from produtos order by nome asc');
       dm.query_produtos.Open;


 dm.rel_produtos.LoadFromFile(GetCurrentDir + '\rel\produtos.fr3');
 dm.rel_produtos.ShowReport();

end;

procedure TfrmMenu.SADA1Click(Sender: TObject);
begin
FrmSaidaProdutos := TFrmSaidaProdutos.Create(self);
FrmSaidaProdutos.ShowModal;
end;

procedure TfrmMenu.SAIR2Click(Sender: TObject);
begin
close;
end;

procedure TfrmMenu.Timer1Timer(Sender: TObject);
begin
lblHora.Caption := TimeToStr(Time);
end;

procedure TfrmMenu.Timer2Timer(Sender: TObject);
begin
totalizarEntradas;
totalizarSaidas;
totalizar;
totalizarCaixas;
verificarEstoque;
listarVendas;
listarCaixa;
end;

procedure TfrmMenu.totalizar;
var
tot: real;
begin
tot := TotEntradas - TotSaidas;
if tot >= 0 then
begin
  lblSaldo.Font.Color := clLime;
  end
  else
  begin
  lblSaldo.Font.Color := ConverterRGB(247, 179, 179);
end;

lblSaldo.Caption := FormatFloat('R$ #,,,,0.00', tot);


end;

procedure TfrmMenu.totalizarCaixas;
begin
       dm.query_coringa_caixa.Close;
       dm.query_coringa_caixa.SQL.Clear;
       dm.query_coringa_caixa.SQL.Add('SELECT * FROM caixa where data_abertura = curDate() and status = "Aberto"');
       //dm.query_coringa_caixa.ParamByName('data').Value := FormatDateTime('yyyy/mm/dd' ,dataBuscar.Date);
       dm.query_coringa_caixa.Open;
       TotCaixas := dm.query_coringa_caixa.RecordCount;
       lblCaixaAberto.Caption := InttoStr(TotCaixas);
end;

procedure TfrmMenu.totalizarEntradas;
var
tot: real;
begin
dm.query_coringa_mov.Close;
dm.query_coringa_mov.SQL.Clear;
dm.query_coringa_mov.SQL.Add('select sum(valor) as total from movimentacao where data = curDate() and tipo = "Entrada" ') ;
dm.query_coringa_mov.Prepare;
dm.query_coringa_mov.Open;
tot := dm.query_coringa_mov.FieldByName('total').AsFloat;
TotEntradas := tot;
lblEntradas.Caption := FormatFloat('R$ #,,,,0.00', tot);



end;

procedure TfrmMenu.totalizarSaidas;
var
tot: real;
begin
dm.query_coringa_mov.Close;
dm.query_coringa_mov.SQL.Clear;
dm.query_coringa_mov.SQL.Add('select sum(valor) as total from movimentacao where data = curDate() and tipo = "Saída"') ;
dm.query_coringa_mov.Prepare;
dm.query_coringa_mov.Open;
tot := dm.query_coringa_mov.FieldByName('total').AsFloat;
TotSaidas := tot;
lblSaidas.Caption := FormatFloat('R$ #,,,,0.00', tot);



end;

procedure TfrmMenu.USARIOS1Click(Sender: TObject);
begin
frmUsuarios := TfrmUsuarios.Create(self);
frmUsuarios.ShowModal;
end;

procedure TfrmMenu.verificarEstoque;
begin
       dm.query_coringa_produtos.Close;
       dm.query_coringa_produtos.SQL.Clear;
       dm.query_coringa_produtos.SQL.Add('SELECT * from produtos where estoque <= 10');
       dm.query_coringa_produtos.Open;

       if dm.query_coringa_produtos.recordCount > 0 then
       begin
         pnlEstoque.Color := ConverterRGB(234, 139, 139);
         pnlEstoque.Caption := '';
       end
       else
       begin
         pnlEstoque.Color := ConverterRGB(142, 234, 139);
         pnlEstoque.Caption := '';
       end;
end;

end.
