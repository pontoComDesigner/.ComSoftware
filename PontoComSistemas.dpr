program PontoComSistemas;

uses
  Vcl.Forms,
  Login in 'Login.pas' {FrmLogin},
  Menu in 'Menu.pas' {frmMenu},
  Usuários in 'Cadastro\Usuários.pas' {frmUsuarios},
  Funcionários in 'Cadastro\Funcionários.pas' {frmFuncionarios},
  Cargos in 'Cadastro\Cargos.pas' {frmCargos},
  Modulo in 'Modulo.pas' {dm: TDataModule},
  Fornecedores in 'Cadastro\Fornecedores.pas' {frmFornec},
  Produtos in 'Cadastro\Produtos.pas' {frmProdutos},
  ImprimirBarras in 'Cadastro\ImprimirBarras.pas' {frmImprimirbarras},
  Entrada in 'Estoque\Entrada.pas' {frmEntradaProdutos},
  Saida in 'Estoque\Saida.pas' {frmSaidaProdutos},
  EstoqueBaixo in 'Estoque\EstoqueBaixo.pas' {frmEstoqueBaixo},
  Vendas in 'Movimentações\Vendas.pas' {frmVendas},
  CancelarVenda in 'Movimentações\CancelarVenda.pas' {frmCancelarVenda},
  Movimentacoes in 'Movimentações\Movimentacoes.pas' {frmMovimentacoes},
  DescontoVenda in 'Movimentações\DescontoVenda.pas' {frmDesconto},
  Gastos in 'Movimentações\Gastos.pas' {frmGastos},
  ListadeVendas in 'Movimentações\ListadeVendas.pas' {frmListaVenda},
  CertiDigital in 'Movimentações\CertiDigital.pas' {frmCertificadoDigital},
  Caixa in 'Movimentações\Caixa.pas' {frmCaixa},
  FluxoCaixa in 'Movimentações\FluxoCaixa.pas' {frmFluxoCaixa},
  FiltroRelatorio in 'Relatório\FiltroRelatorio.pas' {frmRelGeral},
  PesquisaProdutos in 'Cadastro\PesquisaProdutos.pas' {frmPesquisa},
  CadastroCliente in 'Pedidos\CadastroCliente.pas' {frmPedidoCliente},
  ExcluirVendas in 'Ferramentas\ExcluirVendas.pas' {frmExcluirVendas};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmLogin, FrmLogin);
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TfrmFornec, frmFornec);
  Application.CreateForm(TfrmProdutos, frmProdutos);
  Application.CreateForm(TfrmImprimirbarras, frmImprimirbarras);
  Application.CreateForm(TfrmEntradaProdutos, frmEntradaProdutos);
  Application.CreateForm(TfrmSaidaProdutos, frmSaidaProdutos);
  Application.CreateForm(TfrmEstoqueBaixo, frmEstoqueBaixo);
  Application.CreateForm(TfrmVendas, frmVendas);
  Application.CreateForm(TfrmCancelarVenda, frmCancelarVenda);
  Application.CreateForm(TfrmMovimentacoes, frmMovimentacoes);
  Application.CreateForm(TfrmDesconto, frmDesconto);
  Application.CreateForm(TfrmGastos, frmGastos);
  Application.CreateForm(TfrmListaVenda, frmListaVenda);
  Application.CreateForm(TfrmCertificadoDigital, frmCertificadoDigital);
  Application.CreateForm(TfrmCaixa, frmCaixa);
  Application.CreateForm(TfrmFluxoCaixa, frmFluxoCaixa);
  Application.CreateForm(TfrmRelGeral, frmRelGeral);
  Application.CreateForm(TfrmPesquisa, frmPesquisa);
  Application.CreateForm(TfrmPedidoCliente, frmPedidoCliente);
  Application.CreateForm(TfrmExcluirVendas, frmExcluirVendas);
  Application.Run;
end.
