unit Unit_TransacoesDevolucao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Grids, Unit_Biblioteca, Vcl.Mask;

type
  TFrm_Devolucao = class(TFrame)
    Pnl_title: TPanel;
    Btn_Voltar: TBitBtn;
    PgControl_Devolucao: TPageControl;
    Pg_Tabela: TTabSheet;
    Pg_Devolver: TTabSheet;
    StrGrid_Devolucao: TStringGrid;
    Edt_CodigoFilme: TLabeledEdit;
    Edt_CodigoCliente: TLabeledEdit;
    Edt_DataDevolucao: TLabeledEdit;
    Edt_DataLocacao: TLabeledEdit;
    Btn_Devolver: TBitBtn;
    Btn_Limpar: TBitBtn;
    Btn_Cancelar: TBitBtn;
    Edt_Devolvido: TLabeledEdit;
    Edt_ValorMulta: TLabeledEdit;
    pnl_pesquisar: TPanel;
    lbl_pesquisar: TLabel;
    Btn_Pesquisa: TBitBtn;
    Mask_PesquisaCliente: TEdit;
    procedure Btn_VoltarClick(Sender: TObject);
    procedure SetaGrid;
    procedure EscreveGrid;
    procedure PassaProEdit;
    procedure StrGrid_DevolucaoDblClick(Sender: TObject);
    procedure LeEdt(var dev:devolver);
    procedure Btn_DevolverClick(Sender: TObject);
    procedure Btn_PesquisaClick(Sender: TObject);
    procedure EscreveGridPesquisa(cliente:string);
    procedure LimpaComponentes;
    procedure StrGrid_DevolucaoDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure Btn_LimparClick(Sender: TObject);
    procedure Btn_CancelarClick(Sender: TObject);
    procedure PgControl_DevolucaoChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Devolucao: TFrm_Devolucao;

implementation

{$R *.dfm}

uses Unit_Transacoes, Unit_Principal, Unit_TransacoesLocacao;

procedure TFrm_Devolucao.Btn_CancelarClick(Sender: TObject);
begin
  if Application.MessageBox('Você deseja mesmo sair?','Aviso',MB_ICONWARNING+MB_YesNo) = IDYEs
    then begin
             Frm_Transacoes := Tfrm_Transacoes.Create(Frm_Principal.pnl_main);
             Frm_Transacoes.Parent := Frm_Principal.pnl_main;
             Frm_Principal.lbl_caminho.Caption := 'Menu/Transações';
             Frm_Devolucao.Destroy;
         end;
end;

procedure TFrm_Devolucao.Btn_DevolverClick(Sender: TObject);
var
  pos_vetor : integer;
  total_multa : real;
begin
  if Edt_Devolvido.Text = 'Devolvido'
    then begin
           Application.MessageBox('Filme já devolvido!','Devolvido',MB_ICONWARNING+mb_ok);
           LimpaComponentes;
           PgControl_Devolucao.ActivePageIndex := 0;
         end
    else begin
           LeEdt(dev);
           total_multa := StrToFloat(Edt_ValorMulta.Text);
           pos_vetor := BuscaDevolucao(dev);
           RealizaDevolucao(dev,pos_vetor,total_multa);
           EscreveGrid;
           Application.MessageBox('Filme devolvido com sucesso','Devolvido',MB_ICONWARNING+mb_ok);
           LimpaComponentes;
           PgControl_Devolucao.ActivePageIndex := 0;
         end;
end;

procedure TFrm_Devolucao.Btn_LimparClick(Sender: TObject);
begin
  LimpaComponentes;
end;

procedure TFrm_Devolucao.Btn_PesquisaClick(Sender: TObject);
var
  cod_cliente : string;
begin
  cod_cliente := Mask_PesquisaCliente.Text;
  if cod_cliente <> ''
    then EscreveGridPesquisa(cod_cliente)
    else EscreveGrid;
end;

procedure Tfrm_Devolucao.EscreveGridPesquisa(cliente:string);
var
  i : integer;
  cod_cliente, cod : string;
begin
  cod := copy(cliente,1,3);
  if cod <> 'C00'
    then begin
           for i := 0 to length(clientes)-1 do
             begin
               if cliente = clientes[i].nome
                 then begin
                        cod_cliente := clientes[i].codigo;
                        break;
                      end;
             end;
         end
    else begin
           cod_cliente := cliente;
         end;
  StrGrid_Devolucao.RowCount := 1;
  for i := 0 to length(Filmes_Devolver)-1 do
    begin
      if cod_cliente = filmes_devolver[i].CodCliente
        then begin
               StrGrid_Devolucao.RowCount := StrGrid_Devolucao.RowCount + 1;
               StrGrid_Devolucao.Cells[0,(StrGrid_Devolucao.RowCount)-1] := Filmes_Devolver[i].CodCliente;
               StrGrid_Devolucao.Cells[1,(StrGrid_Devolucao.RowCount)-1] := Filmes_Devolver[i].codFilmes;
               StrGrid_Devolucao.Cells[2,(StrGrid_Devolucao.RowCount)-1] := Filmes_Devolver[i].dataLoc;
               StrGrid_Devolucao.Cells[3,(StrGrid_Devolucao.RowCount)-1] := Filmes_Devolver[i].DataDev;
               if Filmes_Devolver[i].devolvido
                 then StrGrid_Devolucao.Cells[4,(StrGrid_Devolucao.RowCount)-1] := 'Devolvido'
                 else StrGrid_Devolucao.Cells[4,(StrGrid_Devolucao.RowCount)-1] := 'Não Devolvido';
             end;
    end;
end;

procedure TFrm_Devolucao.Btn_VoltarClick(Sender: TObject);
begin
  Frm_Transacoes := Tfrm_Transacoes.Create(Frm_Principal.pnl_main);
  Frm_Transacoes.Parent := Frm_Principal.pnl_main;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Transações';
  Frm_Devolucao.Destroy;
end;

procedure Tfrm_Devolucao.SetaGrid;
var
  i: Integer;
begin
  for i := 0 to 4 do
    begin
      StrGrid_Devolucao.ColWidths[i] := 177;
    end;
  StrGrid_Devolucao.Cells[0,0] := 'Código do Cliente';
  StrGrid_Devolucao.Cells[1,0] := 'Código do Filme';
  StrGrid_Devolucao.Cells[2,0] := 'Data de Locação';
  StrGrid_Devolucao.Cells[3,0] := 'Data de Devolução';
  StrGrid_Devolucao.Cells[4,0] := 'Devolvido';
end;

procedure TFrm_Devolucao.StrGrid_DevolucaoDblClick(Sender: TObject);
begin
  PassaProEdit;
end;

procedure TFrm_Devolucao.StrGrid_DevolucaoDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
const
  clPaleGreen = TColor($009BFF9B);
  clPaleRed =   TColor($009DABF9);
begin
  if ARow = 0
    then StrGrid_Devolucao.Canvas.Brush.Color := clSilver
    else if StrGrid_Devolucao.Cells[4,ARow] = 'Devolvido'
           then StrGrid_Devolucao.Canvas.Brush.Color := clPaleGreen
           else if StrGrid_Devolucao.Cells[4,ARow] = 'Não Devolvido'
                  then StrGrid_Devolucao.Canvas.Brush.Color := clPaleRed;
  StrGrid_Devolucao.Canvas.Font.Size := 10;
  StrGrid_Devolucao.Canvas.fillRect(Rect);
  StrGrid_Devolucao.Canvas.TextOut(Rect.Left,Rect.Top,StrGrid_Devolucao.Cells[ACol,ARow]);
end;

procedure Tfrm_Devolucao.EscreveGrid;
var
  i : integer;
begin
  StrGrid_Devolucao.RowCount := 1;
  for i := 0 to length(Filmes_Devolver)-1 do
    begin
      StrGrid_Devolucao.RowCount := StrGrid_Devolucao.RowCount + 1;
      StrGrid_Devolucao.Cells[0,(StrGrid_Devolucao.RowCount)-1] := Filmes_Devolver[i].CodCliente;
      StrGrid_Devolucao.Cells[1,(StrGrid_Devolucao.RowCount)-1] := Filmes_Devolver[i].codFilmes;
      StrGrid_Devolucao.Cells[2,(StrGrid_Devolucao.RowCount)-1] := Filmes_Devolver[i].dataLoc;
      StrGrid_Devolucao.Cells[3,(StrGrid_Devolucao.RowCount)-1] := Filmes_Devolver[i].DataDev;
      if Filmes_Devolver[i].devolvido
        then StrGrid_Devolucao.Cells[4,(StrGrid_Devolucao.RowCount)-1] := 'Devolvido'
        else StrGrid_Devolucao.Cells[4,(StrGrid_Devolucao.RowCount)-1] := 'Não Devolvido';
    end;
end;

procedure Tfrm_devolucao.PassaProEdit;
var
  linha : integer;
begin
  linha := StrGrid_devolucao.Row;
  Edt_codigoCliente.Text := StrGrid_devolucao.Cells[0,linha];
  Edt_codigoFilme.Text := StrGrid_devolucao.Cells[1,linha];
  Edt_DataLocacao.Text := StrGrid_devolucao.Cells[2,linha];
  Edt_dataDevolucao.Text := StrGrid_Devolucao.Cells[3,linha];
  Edt_Devolvido.Text := StrGrid_Devolucao.Cells[4,linha];
  PgControl_Devolucao.ActivePageIndex := 1;
  //calcula a multa
  dev.dataLoc := Edt_dataLocacao.Text;
  dev.DataDev := Edt_dataDevolucao.Text;
  Edt_ValorMulta.Text := FloatToStr(VerificaMulta(dev)*StrToFloat(loc.multa));
end;

procedure TFrm_Devolucao.PgControl_DevolucaoChange(Sender: TObject);
begin
  if PgControl_Devolucao.ActivePageIndex = 1
    then begin
           PgControl_Devolucao.ActivePageIndex := 0;
           Application.MessageBox('Escolha primeiramente um filme a ser devolvido na tabela','Aviso',MB_ICONERROR+MB_OK);
         end;
end;

procedure Tfrm_Devolucao.LeEdt(var dev:devolver);
begin
  dev.dataLoc := Edt_dataLocacao.Text;
  dev.DataDev := Edt_DataDevolucao.Text;
  dev.codFilmes := Edt_CodigoFilme.Text;
  dev.CodCliente := Edt_CodigoCliente.Text;
  if Edt_Devolvido.Text =  'Não Devolvido'
    then dev.devolvido := false
    else dev.devolvido := true;
end;

procedure Tfrm_Devolucao.LimpaComponentes;
begin
  Edt_CodigoFilme.Clear;
  Edt_CodigoCliente.Clear;
  Edt_dataDevolucao.Clear;
  Edt_DataLocacao.Clear;
  Edt_Devolvido.Clear;
  Edt_ValorMulta.Clear;
end;

end.
