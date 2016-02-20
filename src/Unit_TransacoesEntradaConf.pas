unit Unit_TransacoesEntradaConf;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Unit_Biblioteca, Unit_TransacoesEntrada,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons;

type
  TFrm_Confirmacao = class(TForm)
    lbl_Forma: TLabel;
    lbl_entrada: TLabel;
    Edt_caixa: TLabeledEdit;
    CBox_Forma: TComboBox;
    CBox_Entrada: TComboBox;
    lbl_parcelas: TLabel;
    CBox_Parcelas: TComboBox;
    Edt_Entrada: TLabeledEdit;
    Edt_total: TLabeledEdit;
    Btn_Comprar: TBitBtn;
    Btn_Limpar: TBitBtn;
    Btn_Cancelar: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CBox_FormaChange(Sender: TObject);
    procedure CBox_EntradaChange(Sender: TObject);
    procedure CalculaParcela(total:real);
    procedure Edt_EntradaChange(Sender: TObject);
    procedure Btn_ComprarClick(Sender: TObject);
    procedure Btn_CancelarClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Edt_EntradaKeyPress(Sender: TObject; var Key: Char);
    procedure EntradaImportoProduto(var imposto,frete:real);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Confirmacao: TFrm_Confirmacao;

implementation

{$R *.dfm}

uses Unit_Transacoes, Unit_Principal;

procedure TFrm_Confirmacao.CBox_EntradaChange(Sender: TObject);
begin
  if CBox_Entrada.ItemIndex = 0
    then begin
           Edt_Entrada.Enabled := true;
           lbl_parcelas.Enabled := true;
           Cbox_parcelas.Enabled := true;
         end
    else begin
           Edt_Entrada.Enabled := false;
           lbl_parcelas.Enabled := true;
           Cbox_parcelas.Enabled := true;
           CalculaParcela(total_entrada);
         end;
end;

procedure TFrm_Confirmacao.CBox_FormaChange(Sender: TObject);
begin
  if CBox_Forma.ItemIndex = 1
    then begin
           lbl_Entrada.Enabled := true;
           CBox_Entrada.Enabled := true;
           lbl_parcelas.Enabled := false;
           Cbox_parcelas.Enabled := false;
         end
    else begin
           lbl_Entrada.Enabled := false;
           CBox_Entrada.Enabled := false;
         end;
end;

procedure TFrm_Confirmacao.Edt_EntradaChange(Sender: TObject);
var
  entrada,total : real;
begin
  entrada := StrToFloat(Edt_entrada.Text);
  total := total_entrada - entrada;
  CalculaParcela(total);
end;

procedure TFrm_Confirmacao.Edt_EntradaKeyPress(Sender: TObject; var Key: Char);
begin
    if not (Key in ['0'..'9',#13,#44,#8])
    then begin
           key:=#0;
           messagebeep(0);
         end;
end;

procedure TFrm_Confirmacao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Frm_Confirmacao.Destroy;
end;

procedure TFrm_Confirmacao.Btn_CancelarClick(Sender: TObject);
begin
  Frm_Confirmacao.Destroy;
end;

procedure TFrm_Confirmacao.Btn_ComprarClick(Sender: TObject);
var
  antcaixa, imposto, frete : real;
  quant_parcela : integer;
  parcela,fornecedor : string;
begin
  if Application.MessageBox('Você deseja mesmo comprar estes filmes?','Compra',MB_ICONQUESTION+mb_YesNo) = IDYes
    then begin
           EntradaImportoProduto(imposto,frete);
           if Cbox_Forma.ItemIndex = 0
             then begin
                    antcaixa := StrToFloat(Edt_Caixa.Text) - StrToFloat(Edt_Total.Text);
                    if antcaixa >= 0
                      then begin
                             caixa := caixa - StrToFloat(Edt_Total.Text);
                             CompraFilme(imposto,frete);
                             Application.MessageBox(Pchar('Filmes comprados com sucesso!'+#13+'Nota Fiscal Gerada'),'Compra Realizada',MB_ICONINFORMATION+Mb_ok);
                             GeraNotaFiscalEntrada(Frm_Entrada.CBox_Fornecedor.Text,Frm_Entrada.Mask_Frete.Text,Frm_Entrada.Mask_Imposto.Text,Edt_Total.Text);
                             Frm_Confirmacao.Destroy;
                             //====================
                             Frm_Transacoes := Tfrm_Transacoes.Create(Frm_Principal.pnl_main);
                             Frm_Transacoes.Parent := Frm_Principal.pnl_main;
                             Frm_Principal.lbl_caminho.Caption := 'Menu/Transações';
                             Frm_Entrada.Destroy;
                           end
                      else begin
                             Application.MessageBox(Pchar('Não é possível comprar estes filmes A Vista'+#13+'Recomenda-se fazer a compra A Prazo'),'Aviso',MB_ICONERROR+mb_OK);
                           end;
                  end
             else begin
                    if CBox_Entrada.ItemIndex = 0
                      then begin
                             caixa := caixa - StrToFloat(Edt_Entrada.Text);
                             quant_parcela := Cbox_parcelas.ItemIndex;
                             inc(quant_parcela);
                             parcela := Cbox_Parcelas.Text;
                             fornecedor := Frm_Entrada.CBox_Fornecedor.Text;
                             delete(fornecedor,10,(length(fornecedor)));
                             CompraFilme(imposto,frete);
                             ContasPagar(quant_parcela,fornecedor,parcela);
                             GeraNotaFiscalEntrada(Frm_Entrada.CBox_Fornecedor.Text,Frm_Entrada.Mask_Frete.Text,Frm_Entrada.Mask_Imposto.Text,Edt_Total.Text);
                             Application.MessageBox(Pchar('Filmes comprados com sucesso!'+#13+'Nota Fiscal Gerada'),'Compra Realizada',MB_ICONINFORMATION+Mb_ok);
                             Frm_Confirmacao.Destroy;
                             //====================
                             Frm_Transacoes := Tfrm_Transacoes.Create(Frm_Principal.pnl_main);
                             Frm_Transacoes.Parent := Frm_Principal.pnl_main;
                             Frm_Principal.lbl_caminho.Caption := 'Menu/Transações';
                             Frm_Entrada.Destroy;
                           end
                      else begin
                             quant_parcela := Cbox_parcelas.ItemIndex;
                             inc(quant_parcela);
                             parcela := Cbox_Parcelas.Text;
                             fornecedor := Frm_Entrada.CBox_Fornecedor.Text;
                             delete(fornecedor,10,length(fornecedor));
                             CompraFilme(imposto,frete);
                             ContasPagar(quant_parcela,fornecedor,parcela);
                             GeraNotaFiscalEntrada(Frm_Entrada.CBox_Fornecedor.Text,Frm_Entrada.Mask_Frete.Text,Frm_Entrada.Mask_Imposto.Text,Edt_Total.Text);
                             Application.MessageBox(Pchar('Filmes comprados com sucesso!'+#13+'Nota Fiscal Gerada'),'Compra Realizada',MB_ICONINFORMATION+Mb_ok);
                             Frm_Confirmacao.Destroy;
                             //====================
                             Frm_Transacoes := Tfrm_Transacoes.Create(Frm_Principal.pnl_main);
                             Frm_Transacoes.Parent := Frm_Principal.pnl_main;
                             Frm_Principal.lbl_caminho.Caption := 'Menu/Transações';
                             Frm_Entrada.Destroy;
                           end;
                  end;
         end
    else begin
           Application.MessageBox('Operação cancelada pelo usuário','Aviso',MB_ICONEXCLAMATION+MB_OK);
           Frm_Confirmacao.Destroy;
           //====================
           Frm_Transacoes := Tfrm_Transacoes.Create(Frm_Principal.pnl_main);
           Frm_Transacoes.Parent := Frm_Principal.pnl_main;
           Frm_Principal.lbl_caminho.Caption := 'Menu/Transações';
           Frm_Entrada.Destroy;
         end
end;

procedure TFrm_Confirmacao.Button1Click(Sender: TObject);
begin
  GeraNotaFiscalEntrada(Frm_Entrada.CBox_Fornecedor.Text,Frm_Entrada.Mask_Frete.Text,Frm_Entrada.Mask_Imposto.Text,Edt_Total.Text);
end;

procedure Tfrm_Confirmacao.CalculaParcela(total:real);
var
  i : integer;
  parcela, parcela1 : string;
begin
  parcela1 := '';
  parcela := FloatToStr(total);
  Cbox_Parcelas.Clear;
  CBox_Parcelas.Items.Add(PChar('1x '+parcela+' '));
  parcela := FloatToStr(total/2);
  CBox_Parcelas.Items.Add(PChar('2x '+parcela+' '));
  parcela := FloatToStr(total/3);
  for i := 1 to 4 do
    begin
      parcela1 := parcela1 + parcela[i];
    end;
  CBox_Parcelas.Items.Add(PChar('3x ')+parcela1+' ');
end;

procedure Tfrm_Confirmacao.EntradaImportoProduto(var imposto,frete:real);
var
  total, imp, fre : real;
begin
  total := StrToFloat(Edt_Total.Text);
  imp := StrToFloat(Frm_Entrada.Mask_Imposto.Text);
  fre := StrToFloat(Frm_Entrada.Mask_Frete.Text);
  imposto := imp/total;
  frete := fre/total;
end;

end.
