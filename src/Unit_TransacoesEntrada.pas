unit Unit_TransacoesEntrada;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Unit_Biblioteca, Vcl.Grids, Vcl.Mask, Vcl.Menus;

type
  TFrm_Entrada = class(TFrame)
    Pnl_Top: TPanel;
    Btn_Voltar: TBitBtn;
    Lbl_Fornecedor: TLabel;
    CBox_Fornecedor: TComboBox;
    Mask_Frete: TMaskEdit;
    Mask_Imposto: TMaskEdit;
    StrGrid_Mostrar: TStringGrid;
    Edt_Descricao: TLabeledEdit;
    Btn_Dec: TBitBtn;
    Btn_Inc: TBitBtn;
    Edt_Quant: TEdit;
    Cbox_CodCat: TComboBox;
    CBox_Lingua: TComboBox;
    BitBtn3: TBitBtn;
    Edt_Limpar: TBitBtn;
    BitBtn5: TBitBtn;
    Lbl_Frete: TLabel;
    Lbl_Imposto: TLabel;
    lbl_preco: TLabel;
    Lbl_CodCat: TLabel;
    Lbl_Lingua: TLabel;
    Mask_Preco: TMaskEdit;
    Btn_EntraGrid: TBitBtn;
    PM_Grid: TPopupMenu;
    ExcluirFilmedaLista1: TMenuItem;
    procedure Btn_VoltarClick(Sender: TObject);
    procedure Btn_IncClick(Sender: TObject);
    procedure Btn_DecClick(Sender: TObject);
    procedure CompletaCBox;
    procedure SetaGrid;
    procedure LeEdt(var comp:comprar);
    procedure Btn_EntraGridClick(Sender: TObject);
    procedure EscreveGrid;
    procedure LimpaComponentes;
    procedure Edt_LimparClick(Sender: TObject);
    procedure ExcluirFilmedaLista1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure CBox_LinguaKeyPress(Sender: TObject; var Key: Char);
    procedure BitBtn5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Entrada : TFrm_Entrada;
  quant : integer;
  total_entrada : real;

implementation

{$R *.dfm}

uses Unit_Transacoes, Unit_Principal, Unit_TransacoesEntradaConf;

procedure TFrm_Entrada.BitBtn3Click(Sender: TObject);
var
  imp, frete : real;
begin
  if StrGrid_Mostrar.RowCount > 1
    then begin
           imp := StrToFloat(Mask_Imposto.Text);
           frete := StrToFloat(Mask_Imposto.Text);
           total_entrada := total_entrada + imp + frete;
           Application.CreateForm(TFrm_Confirmacao, Frm_Confirmacao);
           Frm_Confirmacao.Show;
           Frm_Confirmacao.Edt_total.Text := FloatToStr(total_entrada);
           Frm_Confirmacao.Edt_caixa.Text := FloatToStr(caixa);
         end
    else begin
           Application.MessageBox('Cadastre Primeiro um Filme!','Aviso',MB_ICONHAND+mb_OK);
         end;
end;

procedure TFrm_Entrada.BitBtn5Click(Sender: TObject);
begin
  if Application.MessageBox('Você deseja mesmo sair?','Aviso',MB_ICONWARNING+MB_YesNo) = IDYes
    then begin
             Frm_Transacoes := Tfrm_Transacoes.Create(Frm_Principal.pnl_main);
             Frm_Transacoes.Parent := Frm_Principal.pnl_main;
             Frm_Principal.lbl_caminho.Caption := 'Menu/Transações';
             SetLength(Filme_comprar,0);
             Frm_Entrada.Destroy;
         end;
end;

procedure TFrm_Entrada.Btn_DecClick(Sender: TObject);
begin
  quant := StrToInt(Edt_Quant.Text);
  if quant <> 0
    then begin
           dec(Quant);
           Edt_Quant.Text := IntToStr(quant);
         end;
end;

procedure TFrm_Entrada.Btn_EntraGridClick(Sender: TObject);
begin
  LeEdt(comp);
  if (comp.descricao <> '')and(comp.preco <> 0)and(comp.quant <> 0)
  and(comp.codcat <> '')and(comp.lingua <> '')
    then begin
           PassaVetorComprar(comp);
           EscreveGrid;
           LimpaComponentes;
           Edt_descricao.SetFocus;
         end
    else begin
           Application.MessageBox('Complete todos os campos antes de adicionar os filmes!','Aviso',MB_ICONERROR+MB_OK);
         end;
end;

procedure TFrm_Entrada.Btn_IncClick(Sender: TObject);
begin
  quant := StrToInt(Edt_Quant.Text);
  inc(quant);
  Edt_Quant.Text := IntToStr(quant);
end;

procedure TFrm_Entrada.Btn_VoltarClick(Sender: TObject);
begin
  Frm_Transacoes := Tfrm_Transacoes.Create(Frm_Principal.pnl_main);
  Frm_Transacoes.Parent := Frm_Principal.pnl_main;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Transações';
  SetLength(Filme_comprar,0);
  Frm_Entrada.Destroy;
end;

procedure TFrm_Entrada.CBox_LinguaKeyPress(Sender: TObject; var Key: Char);
begin
 if key = #13
   then Btn_EntraGridClick(sender);
end;

procedure TFrm_Entrada.CompletaCBox;
var
  i: Integer;
begin
  for i := 0 to length(fornecedores)-1 do
    begin
      Cbox_Fornecedor.Items.Add(fornecedores[i].codigo+' - '+fornecedores[i].nome);
    end;
  for i := 0 to length(categorias)-1 do
    begin
      Cbox_CodCat.Items.Add(categorias[i].codigo+' - '+categorias[i].descricao);
    end;
end;

procedure Tfrm_Entrada.SetaGrid;
var
  i: Integer;
begin
  for i := 0 to 5 do
    StrGrid_Mostrar.ColWidths[i] := 142;
  StrGrid_Mostrar.Cells[0,0] := 'Descrição';
  StrGrid_Mostrar.Cells[1,0] := 'Preço de Custo(R$)';
  StrGrid_Mostrar.Cells[2,0] := 'Quantidade(R$)';
  StrGrid_Mostrar.Cells[3,0] := 'Total';
  StrGrid_Mostrar.Cells[4,0] := 'Código da Categoria';
  StrGrid_Mostrar.Cells[5,0] := 'Língua';
end;

procedure Tfrm_Entrada.LeEdt(var comp:comprar);
var
  preco : string;
begin
  comp.descricao := Edt_Descricao.text;
  preco := Mask_Preco.Text;
  delete(preco,1,2);
  comp.preco := StrToFloat(preco);
  comp.quant := StrToInt(Edt_Quant.Text);
  comp.codcat := CBox_CodCat.Text;
  comp.lingua := Cbox_Lingua.Text;
end;

procedure TFrm_Entrada.Edt_LimparClick(Sender: TObject);
begin
  if Application.MessageBox('Você deseja mesmo limpar os filmes a ser comprados?','Aviso',MB_ICONHAND+Mb_YesNo) = IDYes
    then begin
           LimpaComponentes;
           StrGrid_Mostrar.RowCount := 1;
           SetLength(filme_comprar,0);
         end;
end;

procedure Tfrm_Entrada.EscreveGrid;
var
  i : integer;
begin
  StrGrid_mostrar.RowCount := 1;
  total_Entrada := 0;
  for i := 0 to length(Filme_comprar)-1 do
    begin
      StrGrid_mostrar.RowCount := StrGrid_mostrar.RowCount + 1;
      StrGrid_mostrar.Cells[0,StrGrid_mostrar.RowCount-1] := filme_comprar[i].descricao;
      StrGrid_mostrar.Cells[1,StrGrid_mostrar.RowCount-1] := FloatToStr(filme_comprar[i].preco);
      StrGrid_mostrar.Cells[2,StrGrid_mostrar.RowCount-1] := IntToStr(filme_comprar[i].quant);
      StrGrid_mostrar.Cells[3,StrGrid_mostrar.RowCount-1] := FloatToStr(filme_comprar[i].total);
      StrGrid_mostrar.Cells[4,StrGrid_mostrar.RowCount-1] := filme_comprar[i].codcat;
      StrGrid_mostrar.Cells[5,StrGrid_mostrar.RowCount-1] := filme_comprar[i].lingua;
      total_Entrada := total_Entrada + filme_comprar[i].total;
    end;
end;

procedure TFrm_Entrada.ExcluirFilmedaLista1Click(Sender: TObject);
var
  linha : integer;
begin
  linha := StrGrid_Mostrar.Row;
  if Application.MessageBox('Você deseja mesmo excluir este filme da lista?','Aviso',MB_ICONHAND+mb_YesNo) = IDYes
    then begin
           if length(filme_comprar) <> 0
             then begin
                    DeletaFilmeCompra(linha);
                    Application.MessageBox('Filme deletado com Sucesso!','Delete',MB_ICONINFORMATION+mb_ok);
                    EscreveGrid;
                  end
             else Application.MessageBox('Não existe nenhum filme a ser deletado','Delete',MB_ICONINFORMATION+mb_ok);
         end;
end;

procedure TFrm_Entrada.LimpaComponentes;
begin
  Edt_Descricao.Clear;
  Mask_preco.Text := 'R$    ,  ';
  Edt_quant.text := '0';
  CBox_CodCat.ItemIndex := -1;
  Cbox_lingua.ItemIndex := -1;
end;

end.
