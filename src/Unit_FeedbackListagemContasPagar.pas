unit Unit_FeedbackListagemContasPagar;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Data.DB, Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids, Unit_Biblioteca,
  Vcl.ComCtrls, RpCon, RpConDS, RpDefine, RpRave;

type
  TFrm_ListagemContasPagar = class(TFrame)
    pnl_top: TPanel;
    pnl_pesquisa: TPanel;
    pnl_exportar: TPanel;
    btn_voltar: TBitBtn;
    CDS_ContasPagar: TClientDataSet;
    DS_ContasPagar: TDataSource;
    CDS_ContasPagarCodFornecedor: TStringField;
    CDS_ContasPagarDataCompra: TStringField;
    CDS_ContasPagarValorParcela: TStringField;
    CDS_ContasPagarSituacao: TStringField;
    CDS_ContasPagarVencimento: TStringField;
    CDS_ContasPagarDataPagamento: TStringField;
    CDS_ContasPagarVencimentoInverso: TStringField;
    DBGrid1: TDBGrid;
    CBox_Tipos: TComboBox;
    lbl_filtro: TLabel;
    pnl_cod: TPanel;
    CBox_CodInicial: TComboBox;
    Cbox_CodFinal: TComboBox;
    lbl_inicial: TLabel;
    lbl_final: TLabel;
    Btn_PesquisaCod: TBitBtn;
    pnl_data: TPanel;
    lbl_datainc: TLabel;
    lbl_datadec: TLabel;
    DTP_Inicial: TDateTimePicker;
    DTP_Final: TDateTimePicker;
    Btn_pesquisaData: TBitBtn;
    Btn_Gerar: TBitBtn;
    RV_ContasPagar: TRvProject;
    DSC_ContasPagar: TRvDataSetConnection;
    procedure btn_voltarClick(Sender: TObject);
    procedure PassaVetorPagarCDS;
    procedure PassaCodFuncCbox;
    procedure Btn_PesquisaCodClick(Sender: TObject);
    procedure Btn_pesquisaDataClick(Sender: TObject);
    procedure CBox_TiposChange(Sender: TObject);
    procedure Btn_GerarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_ListagemContasPagar : TFrm_ListagemContasPagar;

implementation

{$R *.dfm}

uses Unit_Feedback, Unit_Principal;

procedure TFrm_ListagemContasPagar.Btn_GerarClick(Sender: TObject);
var
  localizacao : string;
  posi : integer;
begin
  localizacao := ExtractFilePath(Application.ExeName);
  posi := pos('\Win32\Debug',localizacao);
  delete(localizacao,posi,length(localizacao));
  localizacao := localizacao + '\modelos relatorios\ContasPagar.rav';
  RV_ContasPagar.ProjectFile := localizacao;
  RV_ContasPagar.Execute;
end;

procedure TFrm_ListagemContasPagar.Btn_PesquisaCodClick(Sender: TObject);
var
  filtro : string;
begin
  filtro := 'CodFornecedor >= '+chr(39);
  filtro := filtro + Cbox_CodInicial.Text+chr(39);
  filtro := filtro + ' and CodFornecedor <= '+chr(39);
  filtro := filtro + Cbox_CodFinal.Text+chr(39);
  CDS_ContasPagar.Filter := filtro;
  CDS_ContasPagar.Filtered := true;
end;

procedure TFrm_ListagemContasPagar.Btn_pesquisaDataClick(Sender: TObject);
var
  filtro, Data1, data2 : string;
begin
  data1 := formatdatetime('yyyy/mm/dd',DTP_Inicial.Date);
  data2 := formatdatetime('yyyy/mm/dd',DTP_Final.Date);
  filtro := 'VencimentoInverso >= '+chr(39);
  filtro := filtro + data1+chr(39);
  filtro := filtro + ' and VencimentoInverso <= '+chr(39);
  filtro := filtro + data2+chr(39);
  Cds_ContasPagar.Filter := filtro;
  CDS_ContasPagar.Filtered := true;
end;

procedure TFrm_ListagemContasPagar.btn_voltarClick(Sender: TObject);
begin
  Frm_Feedback := TFrm_Feedback.Create(Frm_Principal.pnl_main);
  Frm_Feedback.parent := Frm_Principal.Pnl_main;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Feedback';
  Frm_ListagemContasPagar.Destroy;
end;

procedure TFrm_ListagemContasPagar.CBox_TiposChange(Sender: TObject);
begin
  case CBox_Tipos.ItemIndex of
    0 : begin
          Pnl_cod.Visible := true;
          pnl_data.Visible := false;
          CDS_ContasPagar.Filtered := false;
        end;
    1 : begin
          Pnl_cod.Visible := false;
          pnl_data.Visible := true;
          CDS_ContasPagar.Filtered := false;
        end;
    2 : begin
          Pnl_cod.Visible := false;
          pnl_data.Visible := false;
          CDS_ContasPagar.Filtered := false;
        end;
  end;
end;

procedure Tfrm_ListagemContasPagar.PassaVetorPagarCDS;
var
  i: Integer;
  date : TDAte;
begin
  CDS_ContasPagar.Open;
  for i := length(contas_pagar)-1 downto 0 do
    begin
      CDS_ContasPagar.Insert;
      CDS_ContasPagar.Fields[0].Value := contas_pagar[i].cod_forn;
      CDS_ContasPagar.Fields[1].Value := contas_pagar[i].data_compra;
      CDS_ContasPagar.Fields[2].Value := contas_pagar[i].valor;
      if contas_pagar[i].paga
        then CDS_ContasPagar.Fields[3].Value := 'PAGA'
        else CDS_ContasPagar.Fields[3].Value := 'NÃO PAGA';
      CDS_ContasPagar.Fields[4].Value := contas_pagar[i].data_venc;
      CDS_ContasPagar.Fields[5].Value := contas_pagar[i].data_pag;
      date := StrTodate(contas_pagar[i].data_venc);
      CDS_ContasPagar.Fields[6].Value := formatdatetime('yyyy/mm/dd',date);
      CDS_ContasPagar.Post;
    end;
end;

procedure Tfrm_ListagemContasPagar.PassaCodFuncCbox;
var
  i: Integer;
begin
  for i := 0 to length(fornecedores)-1 do
    begin
      Cbox_CodInicial.Items.Add(fornecedores[i].codigo);
      Cbox_CodFinal.Items.Add(fornecedores[i].codigo);
    end;
end;

end.
