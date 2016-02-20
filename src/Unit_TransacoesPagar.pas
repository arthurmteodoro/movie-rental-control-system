unit Unit_TransacoesPagar;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls, Unit_Biblioteca;

type
  TFrm_Pagar = class(TFrame)
    Pnl_Header: TPanel;
    Btn_Voltar: TBitBtn;
    PGControl_Pagar: TPageControl;
    Tabela: TTabSheet;
    Pagar: TTabSheet;
    StrGrid_Mostrar: TStringGrid;
    Edt_Fornecedor: TLabeledEdit;
    Edt_DataCompra: TLabeledEdit;
    Edt_Valor: TLabeledEdit;
    Edt_Situacao: TLabeledEdit;
    Edt_Vencimento: TLabeledEdit;
    Edt_DataPagamento: TLabeledEdit;
    Btn_Pagar: TBitBtn;
    Btn_Limpar: TBitBtn;
    Btn_Cancelar: TBitBtn;
    procedure Btn_VoltarClick(Sender: TObject);
    procedure SetaGrid;
    procedure StrGrid_MostrarDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure EscreveGrid;
    procedure StrGrid_MostrarDblClick(Sender: TObject);
    procedure Limpar;
    procedure Btn_LimparClick(Sender: TObject);
    procedure Btn_CancelarClick(Sender: TObject);
    procedure PassaEdt(posicao:integer);
    procedure Btn_PagarClick(Sender: TObject);
    procedure PGControl_PagarChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  var
    Frm_Pagar : TFrm_Pagar;

implementation

{$R *.dfm}

uses Unit_Transacoes, Unit_Principal;

procedure TFrm_Pagar.Btn_CancelarClick(Sender: TObject);
begin
  if Application.MessageBox('Você deseja mesmo cancelar a operação?','Aviso',MB_ICONWARNING+MB_YESNO) = IDYes
    then begin
           Limpar;
           PGControl_Pagar.ActivePageIndex := 0;
         end;
end;

procedure TFrm_Pagar.Btn_LimparClick(Sender: TObject);
begin
  if Application.MessageBox('Você deseja mesmo limpar os campos?','Limpar',MB_ICONHAND+MB_YesNo) = IDYes
    then begin
           Limpar;
         end;
end;

procedure TFrm_Pagar.Btn_PagarClick(Sender: TObject);
var
  linha : integer;
begin
  if Edt_Situacao.Text = 'Pago'
    then begin
           Application.MessageBox('Parcela já paga!','Erro',MB_ICONASTERISK+MB_OK);
         end
    else begin
           if Application.MessageBox('Você deseja pagar a parcela?','Pagar',MB_ICONHAND+MB_YESNO) = IDYes
             then begin
                    linha := StrGrid_Mostrar.Row;
                    dec(linha);
                    PagarParcela(linha);
                    EscreveGrid;
                    Limpar;
                    PGControl_Pagar.ActivePageIndex := 0;
                  end;
         end;
end;

procedure TFrm_Pagar.Btn_VoltarClick(Sender: TObject);
begin
  Frm_Transacoes := Tfrm_Transacoes.Create(Frm_Principal.pnl_main);
  Frm_Transacoes.Parent := Frm_Principal.pnl_main;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Transações';
  Frm_Pagar.Destroy;
end;

procedure TFrm_Pagar.SetaGrid;
var
  i : integer;
begin
  for i := 0 to StrGrid_mostrar.ColCount-1 do
    begin
      StrGrid_Mostrar.ColWidths[i] := 147;
    end;
  StrGrid_Mostrar.Cells[0,0] := 'Fornecedor';
  StrGrid_Mostrar.Cells[1,0] := 'Data da Compra';
  StrGrid_Mostrar.Cells[2,0] := 'Valor da Parcela';
  StrGrid_Mostrar.Cells[3,0] := 'Situação da Parcela';
  StrGrid_Mostrar.Cells[4,0] := 'Data do Vencimento';
  StrGrid_Mostrar.Cells[5,0] := 'Data do Pagamento';
end;

procedure TFrm_Pagar.StrGrid_MostrarDblClick(Sender: TObject);
var
  linhaGrid : integer;
begin
  linhaGrid := StrGrid_Mostrar.Row;
  dec(linhaGrid);
  PassaEdt(linhaGrid);
  PGControl_Pagar.ActivePageIndex := 1;
end;

procedure TFrm_Pagar.StrGrid_MostrarDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
const
  clPaleGreen = TColor($009BFF9B);
  clPaleRed =   TColor($009DABF9);
begin
  if ARow = 0
    then StrGrid_Mostrar.Canvas.Brush.Color := clSilver
    else if StrGrid_Mostrar.Cells[3,ARow] = 'Pago'
           then StrGrid_Mostrar.Canvas.Brush.Color := clPaleGreen
           else if StrGrid_Mostrar.Cells[3,ARow] = 'Não Pago'
                  then StrGrid_Mostrar.Canvas.Brush.Color := clPaleRed;
  StrGrid_Mostrar.Canvas.Font.Size := 10;
  StrGrid_Mostrar.Canvas.fillRect(Rect);
  StrGrid_Mostrar.Canvas.TextOut(Rect.Left,Rect.Top,StrGrid_Mostrar.Cells[ACol,ARow]);
end;

procedure TFrm_Pagar.EscreveGrid;
var
  i : integer;
begin
  StrGrid_Mostrar.RowCount := 1;
  for i := 0 to length(contas_pagar)-1 do
    begin
      StrGrid_Mostrar.RowCount := StrGrid_Mostrar.RowCount + 1;
      StrGrid_mostrar.Cells[0,StrGrid_Mostrar.RowCount-1] := contas_pagar[i].cod_forn;
      StrGrid_mostrar.Cells[1,StrGrid_Mostrar.RowCount-1] := contas_pagar[i].data_compra;
      StrGrid_mostrar.Cells[2,StrGrid_Mostrar.RowCount-1] := contas_pagar[i].valor;
      if contas_pagar[i].paga
        then StrGrid_mostrar.Cells[3,StrGrid_Mostrar.RowCount-1] := 'Pago'
        else StrGrid_mostrar.Cells[3,StrGrid_Mostrar.RowCount-1] := 'Não Pago';
      StrGrid_mostrar.Cells[4,StrGrid_Mostrar.RowCount-1] := contas_pagar[i].data_venc;
      StrGrid_mostrar.Cells[5,StrGrid_Mostrar.RowCount-1] := contas_pagar[i].data_pag;
    end;
end;

procedure TFrm_Pagar.Limpar;
begin
  Edt_Fornecedor.Clear;
  Edt_DataCompra.Clear;
  Edt_Valor.Clear;
  Edt_Situacao.Clear;
  Edt_Vencimento.Clear;
  Edt_DataPagamento.Clear;
end;

procedure TFrm_Pagar.PassaEdt(posicao:integer);
begin
  Edt_Fornecedor.Text := contas_pagar[posicao].cod_forn;
  Edt_DataCompra.Text := contas_pagar[posicao].data_compra;
  Edt_Valor.Text := contas_pagar[posicao].valor;
  if contas_pagar[posicao].paga
    then Edt_Situacao.Text := 'Pago'
    else Edt_Situacao.Text := 'Não Pago';
  Edt_Vencimento.Text := contas_pagar[posicao].data_venc;
  Edt_DataPagamento.Text := contas_pagar[posicao].data_pag;
end;

procedure TFrm_Pagar.PGControl_PagarChange(Sender: TObject);
begin
    if PGControl_Pagar.ActivePageIndex = 1
    then begin
           PGControl_Pagar.ActivePageIndex := 0;
           Application.MessageBox('Escolha primeiro uma conta na tabela!','Erro',MB_ICONERROR+mb_OK);
         end;
end;

end.
