unit ImprimirBarras;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

type
  TfrmImprimirbarras = class(TForm)
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Image10: TImage;
    Image11: TImage;
    Image12: TImage;
    Image13: TImage;
    Image14: TImage;
    Image15: TImage;
    Image16: TImage;
    Image17: TImage;
    Image18: TImage;
    PrintDialog1: TPrintDialog;
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    procedure GerarCodigo(codigo: string; Canvas: TCanvas);
  public
    { Public declarations }
  end;

var
  frmImprimirbarras: TfrmImprimirbarras;

implementation

{$R *.dfm}

uses Modulo;

procedure TfrmImprimirbarras.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = 13 then
begin
  if (PrintDialog1.Execute) then
   begin
     Print;
   end;
end;
end;

procedure TfrmImprimirbarras.FormShow(Sender: TObject);
begin
GerarCodigo(codigoProduto, Image1.Canvas);
GerarCodigo(codigoProduto, Image2.Canvas);
GerarCodigo(codigoProduto, Image3.Canvas);
GerarCodigo(codigoProduto, Image4.Canvas);
GerarCodigo(codigoProduto, Image5.Canvas);
GerarCodigo(codigoProduto, Image6.Canvas);
GerarCodigo(codigoProduto, Image7.Canvas);
GerarCodigo(codigoProduto, Image8.Canvas);
GerarCodigo(codigoProduto, Image9.Canvas);
GerarCodigo(codigoProduto, Image10.Canvas);
GerarCodigo(codigoProduto, Image11.Canvas);
GerarCodigo(codigoProduto, Image12.Canvas);
GerarCodigo(codigoProduto, Image13.Canvas);
GerarCodigo(codigoProduto, Image14.Canvas);
GerarCodigo(codigoProduto, Image15.Canvas);
GerarCodigo(codigoProduto, Image16.Canvas);
GerarCodigo(codigoProduto, Image17.Canvas);
GerarCodigo(codigoProduto, Image18.Canvas);
end;

procedure TfrmImprimirbarras.GerarCodigo(codigo: string; Canvas: TCanvas);
const
digitos : array['0'..'9'] of string[5]= ('00110', '10001', '01001', '11000',
'00101', '10100', '01100', '00011', '10010', '01010');
var s : string;
i, j, x, t : Integer;
begin
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
Canvas.Rectangle(15,15, 300, 49);
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
end;

end.
