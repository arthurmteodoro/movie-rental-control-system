unit Unit_TransacoesLocacao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Grids, Unit_biblioteca, Vcl.Menus;

type
  TFrm_Locacao = class(TFrame)
    Pnl_TituloLocacao: TPanel;
    Btn_voltar: TBitBtn;
    StrGrid_Mostrar: TStringGrid;
    Edt_CodFilmes: TLabeledEdit;
    Edt_Total: TLabeledEdit;
    CBox_FormaPagamento: TComboBox;
    lbl_FormaPagamento: TLabel;
    CBox_Entrada: TComboBox;
    Lbl_Entrada: TLabel;
    Edt_ValorEntrada: TLabeledEdit;
    CBox_ValorParcela: TComboBox;
    Lbl_ValorParcela: TLabel;
    Btn_Novo: TBitBtn;
    Btn_Concluir: TBitBtn;
    Btn_Limpar: TBitBtn;
    Btn_Cancelar: TBitBtn;
    Edt_CodCliente: TComboBox;
    Lbl_CodCliente: TLabel;
    Edt_CodFuncionario: TComboBox;
    lbl_CodFuncionario: TLabel;
    procedure Btn_voltarClick(Sender: TObject);
    procedure Habilita(enable : boolean);
    procedure Btn_NovoClick(Sender: TObject);
    procedure CBox_FormaPagamentoChange(Sender: TObject);
    procedure CBox_EntradaChange(Sender: TObject);
    procedure Edt_ValorEntradaChange(Sender: TObject);
    procedure CalculaParcela;
    procedure Btn_CancelarClick(Sender: TObject);
    procedure SetaGrid;
    procedure Escreve;
    procedure Edt_CodFilmesChange(Sender: TObject);
    procedure LerInformacoes(var total,cliente,funcionario,pagamento,entrada,pagamentoEntrada,ValorParcela:string;var totalParcela:integer);
    procedure Btn_ConcluirClick(Sender: TObject);
    procedure AtualizaCBox;
    procedure Limpar;
    procedure Btn_LimparClick(Sender: TObject);
    procedure Edt_TotalKeyPress(Sender: TObject; var Key: Char);
    procedure Edt_ValorEntradaKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
  Frm_Locacao : TFrm_Locacao;
  entrada, total : real;
  parcela, parcela1, codigoFilme : string;
  totalstr,cliente,funcionario,pagamento,entradastr,pagamentoEntrada,ValorParcela:string;
  TotalParcela : integer;

implementation

{$R *.dfm}

uses Unit_Transacoes, Unit_Principal;

procedure TFrm_Locacao.Btn_CancelarClick(Sender: TObject);
begin
  Habilita(false);
  StrGrid_Mostrar.RowCount := 1;
  Edt_Total.Text := '0';
  Btn_Novo.Enabled := true;
end;

procedure TFrm_Locacao.Btn_ConcluirClick(Sender: TObject);
var
  quant_locado, quant_parcelas : integer;
  cod_filme : string;
  i: Integer;
  ok : boolean;
begin
  if Edt_Total.Text <> '0,00'
    then begin
           LerInformacoes(totalstr,cliente,funcionario,pagamento,entradastr,pagamentoEntrada,ValorParcela,TotalParcela);//:string
           for i := 1 to strGrid_Mostrar.RowCount-1 do
             begin
               cod_filme := StrGrid_mostrar.Cells[0,i];
               Ok := PodeAlugarFilme(cod_filme);
             end;
           if not(ok)
             then begin
                    Quant_locado := StrGrid_mostrar.RowCount - 1;
                    RealizaLocacao(totalstr,cliente,funcionario,pagamento,entradastr,pagamentoEntrada,ValorParcela,TotalParcela,quant_locado);
                    for i := 1 to StrGrid_mostrar.RowCount-1 do
                      begin
                        cod_filme := StrGrid_Mostrar.Cells[0,i];
                        Devolver_Filme(cod_filme,cliente,pagamento,funcionario);
                        Habilita(false);
                        Limpar;
                      end;
                    EditaNoArquivo;
                    Application.MessageBox('Locação feita com sucesso','Aviso',MB_ICONWARNING+mb_ok);
                    Btn_Novo.Enabled := true;
                    lbl_CodCliente.Enabled := false;
                    Lbl_CodFuncionario.Enabled := false;
                  end
             else Application.MessageBox('Filme sem exemplares no estoque','Aviso',MB_ICONEXCLAMATION+mb_ok);
         end
    else begin
           Application.MessageBox('Nenhum filme entrado no sistema','Aviso',MB_ICONERROR+mb_ok);
         end;
end;

procedure TFrm_Locacao.Btn_LimparClick(Sender: TObject);
begin
  Limpar;
end;

procedure TFrm_Locacao.Btn_NovoClick(Sender: TObject);
begin
  Habilita(true);
  Lbl_Entrada.Enabled := false;
  CBox_Entrada.Enabled := false;
  Lbl_ValorParcela.Enabled := false;
  CBox_ValorParcela.Enabled := false;
  Edt_ValorEntrada.Enabled := false;
  Btn_Novo.Enabled := false;
  lbl_CodCliente.Enabled := true;
  Lbl_CodFuncionario.Enabled := true;
end;

procedure TFrm_Locacao.Btn_voltarClick(Sender: TObject);
begin
  Frm_Transacoes := Tfrm_Transacoes.Create(Frm_Principal.pnl_main);
  Frm_Transacoes.Parent := Frm_Principal.pnl_main;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Transações';
  Frm_Locacao.Destroy;
end;

procedure TFrm_Locacao.CBox_EntradaChange(Sender: TObject);
begin
   Lbl_ValorParcela.Enabled := true;
   CBox_ValorParcela.Enabled := true;
   if CBox_Entrada.Text = 'Não Existe Entrada'
     then begin
            total := StrToFloat(Edt_total.Text);
            CalculaParcela;
          end
     else begin
            Edt_ValorEntrada.Enabled := true;
          end;
end;

procedure TFrm_Locacao.CBox_FormaPagamentoChange(Sender: TObject);
begin
  if CBox_FormaPagamento.Text = 'A Prazo'
    then begin
           Lbl_Entrada.Enabled := true;
           CBox_Entrada.Enabled := true;
         end
  else if CBox_FormaPagamento.Text = 'A vista'
         then begin
                Lbl_ValorParcela.Enabled := false;
                CBox_ValorParcela.Enabled := False;
                Lbl_Entrada.Enabled := False;
                CBox_Entrada.Enabled := False;
              end;
end;

procedure TFrm_Locacao.Edt_CodFilmesChange(Sender: TObject);
begin
  codigoFilme := Edt_CodFilmes.Text;
  Escreve;
end;

procedure TFrm_Locacao.Edt_TotalKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9',#13,#44,#8])
    then begin
           key:=#0;
           messagebeep(0);
         end;
end;

procedure TFrm_Locacao.Edt_ValorEntradaChange(Sender: TObject);
begin
  total := StrToFloat(Edt_total.Text);
  entrada := StrToFloat(Edt_valorEntrada.Text);
  total := total - entrada;
  Calculaparcela;
end;

procedure TFrm_Locacao.Edt_ValorEntradaKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9',#13,#44,#8])
    then begin
           key:=#0;
           messagebeep(0);
         end;
end;

procedure TFrm_Locacao.Habilita(enable : boolean);
begin
  StrGrid_Mostrar.Enabled := enable;
  Edt_CodFilmes.Enabled := enable;
  Edt_Total.Enabled := enable;
  Lbl_FormaPagamento.Enabled := enable;
  CBox_FormaPagamento.Enabled := enable;
  Lbl_Entrada.Enabled := enable;
  CBox_entrada.Enabled := enable;
  Edt_ValorEntrada.Enabled := enable;
  Lbl_ValorParcela.Enabled := enable;
  CBox_ValorParcela.Enabled := enable;
  Edt_CodCliente.Enabled := enable;
  Edt_CodFuncionario.Enabled := enable;
  Btn_Concluir.Enabled := enable;
  Btn_Limpar.Enabled := enable;
  if enable
    then Edt_CodFilmes.SetFocus;
end;

procedure Tfrm_Locacao.CalculaParcela;
var
  i : integer;
begin
  parcela1 := '';
  parcela := FloatToStr(total);
  Cbox_ValorParcela.Clear;
  CBox_ValorParcela.Items.Add(PChar('1x '+parcela+' '));
  parcela := FloatToStr(total/2);
  CBox_ValorParcela.Items.Add(PChar('2x '+parcela+' '));
  parcela := FloatToStr(total/3);
  for i := 1 to 4 do
    begin
      parcela1 := parcela1 + parcela[i];
    end;
  CBox_ValorParcela.Items.Add(PChar('3x ')+parcela1+' ');
end;

procedure Tfrm_Locacao.SetaGrid;
begin
  StrGrid_Mostrar.RowCount := 1;
  StrGrid_Mostrar.ColWidths[0] := 90;
  StrGrid_Mostrar.Cells[0,0] := 'Código';
  StrGrid_Mostrar.ColWidths[1] := 207;
  StrGrid_mostrar.Cells[1,0] := 'Descrição';
  StrGrid_Mostrar.ColWidths[2] := 120;
  StrGrid_Mostrar.Cells[2,0] := 'Valor Locação'
end;

procedure Tfrm_Locacao.Escreve;
var
  achou : boolean;
  i, iden : integer;
  valor : real;
  total : string;
begin
  if Length(codigoFilme) = 7
    then begin
           Achou := false;
           for i := 0 to length(Filmes)-1 do
             begin
               if (filmes[i].codigo = codigoFilme)and(filmes[i].ativo=false)
                 then begin
                        achou := true;
                        iden := i;
                      end;
             end;
           if achou
             then begin
                    for i := 0 to length(categorias)-1 do
                      begin
                        if filmes[iden].codcat = categorias[i].codigo
                          then begin
                                 valor := StrToFloat(categorias[i].valor);
                               end;
                      end;
                    StrGrid_Mostrar.RowCount := StrGrid_Mostrar.RowCount + 1;
                    StrGrid_Mostrar.Cells[0,StrGrid_Mostrar.RowCount-1] := filmes[iden].codigo;
                    StrGrid_Mostrar.Cells[1,StrGrid_Mostrar.RowCount-1] := filmes[iden].descricao;
                    StrGrid_Mostrar.Cells[2,StrGrid_Mostrar.RowCount-1] := FloatToStr(valor);
                    total := FloatToStr(valor + StrToFloat(Edt_Total.Text));
                    Edt_total.Text := total;
                    Edt_CodFilmes.Clear;
                  end
             else ShowMessage('Filme não encontrado');
         end;
end;

procedure Tfrm_Locacao.LerInformacoes(var total,cliente,funcionario,pagamento,entrada,pagamentoEntrada,ValorParcela:string;var totalParcela:integer);
begin
  total := Edt_Total.Text;
  cliente := copy(Edt_CodCliente.Text,1,7);
  funcionario := copy(Edt_CodFuncionario.Text,1,9);
  pagamento := CBox_FormaPagamento.Text;
  entrada := CBox_Entrada.Text;
  pagamentoEntrada := Edt_ValorEntrada.Text;
  ValorParcela := Cbox_valorParcela.Text;
  TotalParcela := Cbox_ValorParcela.ItemIndex + 1;
end;

procedure Tfrm_Locacao.AtualizaCBox;
var
  i: Integer;
begin
  for i := 0 to length(clientes)-1 do
    begin
      if clientes[i].ativo = false
        then begin
               Edt_CodCliente.Items.Add(clientes[i].codigo + ' - '+clientes[i].nome);
             end;
    end;
  for i := 0 to length(funcionarios)-1 do
    begin
      if funcionarios[i].ativo = false
        then begin
               Edt_CodFuncionario.Items.Add(funcionarios[i].codigo + ' - '+funcionarios[i].nome);
             end;
    end;
end;

procedure Tfrm_Locacao.Limpar;
begin
  SetaGrid;
  Edt_CodFilmes.Clear;
  Edt_Total.Text := '0,00';
  Cbox_formaPagamento.ItemIndex := -1;
  Cbox_Entrada.ItemIndex := -1;
  Edt_ValorEntrada.Text := '0,00';
  Cbox_ValorParcela.ItemIndex := -1;
  Edt_CodCliente.Clear;
  Edt_CodFuncionario.Clear;
  AtualizaCbox;
end;

end.
