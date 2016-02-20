unit Unit_TransacoesReceber;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Unit_Biblioteca, Vcl.ComCtrls, Vcl.Grids;

type
  TFrm_Receber = class(TFrame)
    Pnl_Top: TPanel;
    Btn_Voltar: TBitBtn;
    PGControl_Receber: TPageControl;
    Tabela: TTabSheet;
    Pagar: TTabSheet;
    pnl_Pesquisa: TPanel;
    StrGrid_Receber: TStringGrid;
    lbl_pesquisa: TLabel;
    Edt_Pesquisa: TEdit;
    Btn_Pesquisa: TBitBtn;
    Edt_CodCliente: TLabeledEdit;
    Edt_Parcela: TLabeledEdit;
    Edt_dataVencimento: TLabeledEdit;
    Edt_Situacao: TLabeledEdit;
    Btn_Receber: TBitBtn;
    Btn_Limpar: TBitBtn;
    Btn_Cancelar: TBitBtn;
    procedure Btn_VoltarClick(Sender: TObject);
    procedure SetaGrid;
    procedure EscreveGrid;
    procedure StrGrid_ReceberDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure PassaProEdt(lin:integer);
    procedure StrGrid_ReceberDblClick(Sender: TObject);
    procedure Btn_ReceberClick(Sender: TObject);
    procedure LimparEdt;
    procedure Btn_LimparClick(Sender: TObject);
    procedure Btn_CancelarClick(Sender: TObject);
    procedure PesquisaPeloCod(cod_cliente:string);
    procedure Btn_PesquisaClick(Sender: TObject);
    procedure PGControl_ReceberChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Receber : TFrm_Receber;

implementation

{$R *.dfm}

uses Unit_Transacoes, Unit_Principal;

procedure TFrm_Receber.Btn_CancelarClick(Sender: TObject);
begin
  LimparEdt;
  PGControl_Receber.ActivePageIndex := 0;
end;

procedure TFrm_Receber.Btn_LimparClick(Sender: TObject);
begin
  LimparEdt;
end;

procedure TFrm_Receber.Btn_PesquisaClick(Sender: TObject);
var
  cod_cliente : string;
begin
  cod_cliente := Edt_Pesquisa.Text;
  if cod_cliente <> ''
    then PesquisaPeloCod(cod_cliente)
    else begin
           StrGrid_Receber.RowCount := 1;
           EscreveGrid;
         end;
end;

procedure TFrm_Receber.Btn_ReceberClick(Sender: TObject);
var
  lin : integer;
begin
  if Edt_Situacao.Text <> 'Pago'
    then begin
           lin := StrGrid_Receber.Row;
           dec(lin);
           rec.Cod_Cliente := Edt_CodCliente.Text;
           rec.parcela := Edt_parcela.Text;
           if Edt_Situacao.Text = 'Pago'
             then rec.pago := true
             else rec.pago := false;
           rec.data := Edt_DataVencimento.Text;
           RealizaPagamento(rec,lin);
           Application.MessageBox('Conta paga com Sucesso!','Contas Receber',MB_ICONINFORMATION+mb_ok);
           SetaGrid;
           EscreveGrid;
           PGControl_Receber.ActivePageIndex := 0;
         end
    else begin
           Application.MessageBox('Conta já paga!','Contas Receber',MB_ICONERROR+mb_OK);
           PGControl_Receber.ActivePageIndex := 0;
         end;
end;

procedure TFrm_Receber.Btn_VoltarClick(Sender: TObject);
begin
  Frm_Transacoes := Tfrm_Transacoes.Create(Frm_Principal.pnl_main);
  Frm_Transacoes.Parent := Frm_Principal.pnl_main;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Transações';
  Frm_Receber.Destroy;
end;

procedure Tfrm_receber.SetaGrid;
var
  i: Integer;
begin
  StrGrid_Receber.RowCount := 1;
  for i := 0 to 4 do
    StrGrid_Receber.ColWidths[i] := 177;
  StrGrid_Receber.Cells[0,0] := 'Código Cliente';
  StrGrid_Receber.Cells[1,0] := 'Valor da Parcela';
  StrGrid_Receber.Cells[2,0] := 'Data de Vencimento';
  StrGrid_Receber.Cells[3,0] := 'Situação da Parcela';
  StrGrid_Receber.Cells[4,0] := 'Data de Pagamento';
end;

procedure TFrm_Receber.StrGrid_ReceberDblClick(Sender: TObject);
var
  lin : integer;
begin
  lin := StrGrid_Receber.Row;
  PassaProEdt(lin);
  PGControl_receber.ActivePageIndex := 1;
end;

procedure TFrm_Receber.StrGrid_ReceberDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
const
  clPaleGreen = TColor($009BFF9B);
  clPaleRed =   TColor($009DABF9);
begin
  if ARow = 0
    then StrGrid_receber.Canvas.Brush.Color := clSilver
    else if StrGrid_Receber.Cells[3,ARow] = 'Pago'
           then StrGrid_Receber.Canvas.Brush.Color := clPaleGreen
           else if StrGrid_Receber.Cells[3,ARow] = 'Não Pago'
                  then StrGrid_Receber.Canvas.Brush.Color := clPaleRed;
  StrGrid_receber.Canvas.Font.Size := 10;
  StrGrid_Receber.Canvas.fillRect(Rect);
  StrGrid_receber.Canvas.TextOut(Rect.Left,Rect.Top,StrGrid_Receber.Cells[ACol,ARow]);
end;

procedure Tfrm_Receber.EscreveGrid;
var
  i : integer;
begin
  for i := 0 to length(contas_receber)-1 do
    begin
      StrGrid_receber.RowCount := StrGrid_receber.RowCount + 1;
      StrGrid_Receber.Cells[0,StrGrid_receber.RowCount-1] := contas_receber[i].Cod_Cliente;
      StrGrid_Receber.Cells[1,StrGrid_Receber.RowCount-1] := contas_receber[i].parcela;
      StrGrid_Receber.Cells[2,StrGrid_Receber.RowCount-1] := contas_receber[i].data;
      if contas_receber[i].pago
        then StrGrid_Receber.Cells[3,StrGrid_receber.RowCount-1] := 'Pago'
        else StrGrid_Receber.Cells[3,StrGrid_receber.RowCount-1] := 'Não Pago';
      StrGrid_Receber.Cells[4,StrGrid_Receber.RowCount-1] := contas_receber[i].pagamento;
    end;
end;

procedure Tfrm_Receber.PassaProEdt(lin:integer);
begin
  Edt_CodCliente.Text := StrGrid_Receber.Cells[0,lin];
  Edt_Parcela.Text := StrGrid_Receber.Cells[1,lin];
  Edt_DataVencimento.Text := StrGrid_Receber.Cells[2,lin];
  Edt_Situacao.Text := StrGrid_Receber.Cells[3,lin];
end;

procedure TFrm_Receber.LimparEdt;
begin
  Edt_CodCliente.Clear;
  Edt_parcela.Clear;
  Edt_DataVencimento.Clear;
  Edt_Situacao.Clear;
end;

procedure Tfrm_receber.PesquisaPeloCod(cod_cliente:string);
var
  i : integer;
  cliente, cod : string;
begin
  cod := copy(cod_cliente,1,2);
  if cod <> 'C0'
    then begin
           for i := 0 to length(clientes)-1 do
             begin
               if clientes[i].nome = cod_cliente
                 then begin
                        cliente := clientes[i].codigo;
                        break;
                      end;
             end;
         end
    else begin
           cliente := cod_cliente;
         end;
  StrGrid_Receber.RowCount := 1;
  for i := 0 to length(contas_receber)-1 do
    begin
      if contas_receber[i].Cod_Cliente = cliente
        then begin
               StrGrid_receber.RowCount := StrGrid_receber.RowCount + 1;
               StrGrid_Receber.Cells[0,StrGrid_receber.RowCount-1] := contas_receber[i].Cod_Cliente;
               StrGrid_Receber.Cells[1,StrGrid_Receber.RowCount-1] := contas_receber[i].parcela;
               StrGrid_Receber.Cells[2,StrGrid_Receber.RowCount-1] := contas_receber[i].data;
               if contas_receber[i].pago
                 then StrGrid_Receber.Cells[3,StrGrid_receber.RowCount-1] := 'Pago'
                 else StrGrid_Receber.Cells[3,StrGrid_receber.RowCount-1] := 'Não Pago';
               StrGrid_Receber.Cells[4,StrGrid_Receber.RowCount-1] := contas_receber[i].pagamento;
             end;
    end;
end;

procedure TFrm_Receber.PGControl_ReceberChange(Sender: TObject);
begin
  if PGControl_Receber.ActivePageIndex = 1
    then begin
           PGControl_Receber.ActivePageIndex := 0;
           Application.MessageBox('Escolha primeiro uma conta na tabela!','Erro',MB_ICONERROR+mb_OK);
         end;
end;

end.
