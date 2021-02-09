unit Modulo;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.Client, Data.DB,
  FireDAC.Comp.DataSet, frxClass, frxDBSet;

type
  Tdm = class(TDataModule)
    fd: TFDConnection;
    drive: TFDPhysMySQLDriverLink;
    fb_Cargoscargo: TFDTable;
    query_cargos: TFDQuery;
    query_cargosid: TFDAutoIncField;
    query_cargosCargo: TStringField;
    DSCargo: TDataSource;
    fb_func: TFDTable;
    query_func: TFDQuery;
    DSFuncionario: TDataSource;
    query_funcid: TFDAutoIncField;
    query_funcnome: TStringField;
    query_funccpf: TStringField;
    query_funcendereco: TStringField;
    query_functelefone: TStringField;
    query_funccargo: TStringField;
    query_funcdata: TDateField;
    fb_usuarios: TFDTable;
    query_usuarios: TFDQuery;
    query_usuariosid: TFDAutoIncField;
    query_usuariosnome: TStringField;
    query_usuariosusuario: TStringField;
    query_usuariossenha: TStringField;
    query_usuarioscargo: TStringField;
    query_usuariosid_funcionario: TStringField;
    DSUsuarios: TDataSource;
    fb_fornecedores: TFDTable;
    query_fornecedores: TFDQuery;
    DSFornecedores: TDataSource;
    query_fornecedoresid: TFDAutoIncField;
    query_fornecedoresnome: TStringField;
    query_fornecedorescpf: TStringField;
    query_fornecedoresemail: TStringField;
    query_fornecedorestelefone: TStringField;
    query_fornecedoresdata: TDateField;
    query_fornecedoresproduto: TStringField;
    query_produtos: TFDQuery;
    fb_produtos: TFDTable;
    DSProdutos: TDataSource;
    query_produtosid: TFDAutoIncField;
    query_produtoscodigo: TStringField;
    query_produtosnome: TStringField;
    query_produtosdescricao: TStringField;
    query_produtosvalor: TFMTBCDField;
    query_produtosestoque: TIntegerField;
    query_produtosdata: TDateTimeField;
    query_produtosimagem: TBlobField;
    query_produtosund: TStringField;
    query_coringa: TFDQuery;
    query_entrada: TFDQuery;
    fb_entrada: TFDTable;
    DSEntrada: TDataSource;
    query_produtosultimacompra: TDateField;
    fb_saida: TFDTable;
    query_saida: TFDQuery;
    DSSaida: TDataSource;
    query_saidaid: TFDAutoIncField;
    query_saidaquantidade: TIntegerField;
    query_saidamotivo: TStringField;
    query_saidadata: TDateField;
    query_saidaid_produto: TIntegerField;
    query_saidaproduto: TStringField;
    fb_vendas: TFDTable;
    query_vendas: TFDQuery;
    DSVendas: TDataSource;
    query_vendasid: TFDAutoIncField;
    query_vendasvalor: TBCDField;
    query_vendasfuncionario: TStringField;
    fb_detalhes_vendas: TFDTable;
    query_detalhes_vendas: TFDQuery;
    DSDetVendas: TDataSource;
    query_detalhes_vendasid: TFDAutoIncField;
    query_detalhes_vendasid_venda: TIntegerField;
    query_detalhes_vendasproduto: TStringField;
    query_detalhes_vendasquantidade: TIntegerField;
    query_detalhes_vendastotal: TBCDField;
    query_detalhes_vendasid_produto: TIntegerField;
    query_detalhes_vendasfuncionario: TStringField;
    query_detalhes_vendasvalor: TBCDField;
    fb_movi: TFDTable;
    DSMovi: TDataSource;
    query_mov: TFDQuery;
    fb_gastos: TFDTable;
    query_gastos: TFDQuery;
    DSGastos: TDataSource;
    query_gastosid: TFDAutoIncField;
    query_gastosmotivo: TStringField;
    query_gastosvalor: TBCDField;
    query_gastosfuncionario: TStringField;
    query_gastosdata: TDateField;
    query_vendasdesconto: TBCDField;
    query_vendasvalor_recebido: TBCDField;
    query_vendastroco: TBCDField;
    query_vendasstatus: TStringField;
    query_vendashora: TTimeField;
    query_vendasdata: TDateField;
    rel_comprovante: TfrxReport;
    DS_vendas: TfrxDBDataset;
    rel_det_vendas: TfrxDBDataset;
    fb_caixa: TFDTable;
    query_caixa: TFDQuery;
    DS_Caixa: TDataSource;
    rel_caixa: TfrxReport;
    DS_caixas: TfrxDBDataset;
    rel_movi: TfrxReport;
    DS_movi: TfrxDBDataset;
    query_tot_entrada: TFDQuery;
    query_tot_saida: TFDQuery;
    rel_produtos: TfrxReport;
    DS_protudos: TfrxDBDataset;
    fb_pedidos: TFDTable;
    query_cliente: TFDQuery;
    DSCadCliente: TDataSource;
    query_clienteid: TFDAutoIncField;
    query_clientenome: TStringField;
    query_clienteendereco: TStringField;
    query_clientetelefone: TStringField;
    query_clientedata: TDateField;
    query_clientecpf: TStringField;
    query_clientecnpj: TStringField;
    DS_Cliente: TfrxDBDataset;
    rel_entrega: TfrxReport;
    query_coringavendas: TFDQuery;
    DS_coringavendas: TDataSource;
    query_coringavendasid: TFDAutoIncField;
    query_coringavendasvalor: TBCDField;
    query_coringavendasdata: TDateField;
    query_coringavendashora: TTimeField;
    query_coringavendasfuncionario: TStringField;
    query_coringavendasdesconto: TBCDField;
    query_coringavendasvalor_recebido: TBCDField;
    query_coringavendastroco: TBCDField;
    query_coringavendasstatus: TStringField;
    query_caixacoringa: TFDQuery;
    DS_caixacoringa: TDataSource;
    rel_Vendas: TfrxReport;
    query_detalhes_vendasdata: TDateField;
    query_coringa_mov: TFDQuery;
    rel_fechamento: TfrxReport;
    DS_Gastos: TfrxDBDataset;
    query_coringa1: TFDQuery;
    query_caixacoringaid: TFDAutoIncField;
    query_caixacoringadata_abertura: TDateField;
    query_caixacoringahora_abertura: TTimeField;
    query_caixacoringavalor_abertura: TBCDField;
    query_caixacoringafuncionario_abertura: TStringField;
    query_caixacoringadata_fec: TDateField;
    query_caixacoringahora_fec: TTimeField;
    query_caixacoringavalor_fec: TBCDField;
    query_caixacoringavalor_vendido: TBCDField;
    query_caixacoringavalor_quebra: TBCDField;
    query_caixacoringafuncionario_fec: TStringField;
    query_caixacoringanum_caixa: TIntegerField;
    query_caixacoringaoperador: TStringField;
    query_caixacoringastatus: TStringField;
    query_caixacoringavalor_gasto: TBCDField;
    query_caixaid: TFDAutoIncField;
    query_caixadata_abertura: TDateField;
    query_caixahora_abertura: TTimeField;
    query_caixavalor_abertura: TBCDField;
    query_caixafuncionario_abertura: TStringField;
    query_caixadata_fec: TDateField;
    query_caixahora_fec: TTimeField;
    query_caixavalor_fec: TBCDField;
    query_caixavalor_vendido: TBCDField;
    query_caixavalor_quebra: TBCDField;
    query_caixafuncionario_fec: TStringField;
    query_caixanum_caixa: TIntegerField;
    query_caixaoperador: TStringField;
    query_caixastatus: TStringField;
    query_caixavalor_gasto: TBCDField;
    query_vendasid_caixa: TIntegerField;
    query_coringavendasid_caixa: TIntegerField;
    query_gastosid_caixa: TIntegerField;
    rel_retirada: TfrxReport;
    query_coringa_venda: TFDQuery;
    query_coringa_caixa: TFDQuery;
    query_coringa_produtos: TFDQuery;
    query_entradaid: TFDAutoIncField;
    query_entradaproduto: TStringField;
    query_entradaquantidade: TIntegerField;
    query_entradavalor: TBCDField;
    query_entradatotal: TBCDField;
    query_entradadata: TDateField;
    query_entradaid_produto: TIntegerField;
    query_entradafornecedor: TIntegerField;
    procedure driveDriverCreated(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure fdBeforeConnect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dm: Tdm;
  ///DECLARAÇÃOES DAS VARIAVEIS GLOBAIS
  idFunc : string;
  nomeFunc : string;
  cargoFunc : string;

  idCliente : string;
  nomeClientes : string;
  enderecoClientes : string;
  telefoneClientes : string;

  idCaixa : string;
  idCaixa2 : string;

  idCaixaDet : string;
  idVendasDet : string;

  cpfClientes : string;
  cnpjClientes : string;

  chamada : string;
  senhaDesconto : string;
  nomeUsuario : string;
  cargoUsuario : string;
  codigoProduto : string;
  certificadoDig : string;

  idFornecedor : string;

  nomeFornecedor : string;
  nomeProduto : string;
  estoqueProduto : double;
  idProduto : string;
  totalProdutos : double;
  statusCaixa : string;
  numeroCaixa : string;

  totalmov : double;

  rel: string;
  ferramenta: string;
implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure Tdm.DataModuleCreate(Sender: TObject);
begin
dm.fd.Connected := true;
end;

procedure Tdm.DataModuleDestroy(Sender: TObject);
begin
dm.fd.Connected := false;
end;

procedure Tdm.driveDriverCreated(Sender: TObject);
var
caminho : string;
begin
caminho := GetCurrentDir + '\db\libmysql.dll';
drive.VendorLib := caminho;
end;

procedure Tdm.fdBeforeConnect(Sender: TObject);
begin

fb_Cargoscargo.TableName := 'cargos';
fb_func.TableName := 'funcionarios';
fb_fornecedores.TableName := 'fornecedores';
fb_vendas.TableName := 'vendas';
fb_Produtos.TableName := 'cargos';
fb_caixa.TableName := 'caixa';
fb_detalhes_vendas.TableName := 'detalhes_vendas';
fb_entrada.TableName := 'entrada_produtos';
fb_gastos.TableName := 'gastos';
fb_saida.TableName := 'saida_produtos';
fb_usuarios.TableName := 'usuarios';
fb_movi.TableName := 'movimentacao';
fb_pedidos.TableName := 'cadastro_cliente';

end;

end.
