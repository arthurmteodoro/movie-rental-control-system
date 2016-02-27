unit Unit_FeedbackListagemContasReceber;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Unit_Biblioteca, Vcl.Grids, Vcl.DBGrids, Data.DB,
  Datasnap.DBClient, Vcl.ComCtrls, RpCon, RpConDS, RpDefine, RpRave;

type
  TFrm_ListagemContasReceber = class(TFrame)
    pnl_top: TPanel;
    pnl_pesquisa: TPanel;
    pnl_exportar: TPanel;
    btn_voltar: TBitBtn;
    lbl_opcoes: TLabel;
    CBox_Opcoes: TComboBox;
    pnl_cod: TPanel;
    Cbox_CodInicial: TComboBox;
    Cbox_CodFinal: TComboBox;
    lbl_Inicial: TLabel;
    lbl_codfinal: TLabel;
    Btn_PesquisaCod: TBitBtn;
    pnl_data: TPanel;
    lbl_dataInc: TLabel;
    lbl_dataDec: TLabel;
    DTP_Inicial: TDateTimePicker;
    DTP_Final: TDateTimePicker;
    Btn_PesquisaData: TBitBtn;
    CDS_ContasReceber: TClientDataSet;
    DS_ContasReceber: TDataSource;
    CDS_ContasReceberCodCliente: TStringField;
    CDS_ContasReceberValor: TStringField;
    CDS_ContasReceberDataVencimento: TStringField;
    CDS_ContasReceberSituacao: TStringField;
    CDS_ContasReceberDataPagamento: TStringField;
    CDS_ContasReceberDataInversa: TStringField;
    DBGrid1: TDBGrid;
    Btn_relatorio: TBitBtn;
    RV_ContasReceber: TRvProject;
    DSC_ContasReceber: TRvDataSetConnection;
    procedure btn_voltarClick(Sender: TObject);
    procedure PassaVetorContasReceberCDS;
    procedure PassaCodClienteCbox;
    procedure Btn_PesquisaCodClick(Sender: TObject);
    procedure Btn_PesquisaDataClick(Sender: TObject);
    procedure CBox_OpcoesChange(Sender: TObject);
    procedure Btn_relatorioClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_ListagemContasReceber : TFrm_ListagemContasReceber;

implementation

{$R *.dfm}

uses Unit_Feedback, Unit_Principal;

procedure TFrm_ListagemContasReceber.Btn_PesquisaCodClick(Sender: TObject);
var
  filtro : string;
begin
  filtro := 'CodCliente >= '+chr(39);
  filtro := filtro + Cbox_CodInicial.Text+chr(39);
  filtro := filtro + ' and CodCliente <= '+chr(39);
  filtro := filtro + Cbox_CodFinal.Text+chr(39);
  CDS_ContasReceber.Filter := filtro;
  CDS_ContasReceber.Filtered := true;
end;

procedure TFrm_ListagemContasReceber.Btn_PesquisaDataClick(Sender: TObject);
var
  filtro, Data1, data2 : string;
begin
  data1 := formatdatetime('yyyy/mm/dd',DTP_Inicial.Date);
  data2 := formatdatetime('yyyy/mm/dd',DTP_Final.Date);
  filtro := 'DataInversa >= '+chr(39);
  filtro := filtro + data1+chr(39);
  filtro := filtro + ' and DataInversa <= '+chr(39);
  filtro := filtro + data2+chr(39);
  Cds_ContasReceber.Filter := filtro;
  CDS_ContasReceber.Filtered := true;
end;

procedure TFrm_ListagemContasReceber.Btn_relatorioClick(Sender: TObject);
var
  localizacao : string;
  posi : integer;
begin
  localizacao := ExtractFilePath(Application.ExeName);
  posi := pos('\Win32\Debug',localizacao);
  delete(localizacao,posi,length(localizacao));
  localizacao := localizacao + '\modelos relatorios\ContasReceber.rav';
  RV_ContasReceber.ProjectFile := localizacao;
  RV_ContasReceber.Execute;
end;

procedure TFrm_ListagemContasReceber.btn_voltarClick(Sender: TObject);
begin
  Frm_Feedback := TFrm_Feedback.Create(Frm_Principal.pnl_main);
  Frm_Feedback.parent := Frm_Principal.Pnl_main;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Feedback';
  Frm_ListagemContasReceber.Destroy;
end;

procedure TFrm_ListagemContasReceber.CBox_OpcoesChange(Sender: TObject);
begin
  case CBox_Opcoes.ItemIndex of
    0 : begin
          pnl_cod.Visible := true;
          pnl_data.Visible := false;
        end;
    1 : begin
          pnl_cod.Visible := false;
          pnl_data.Visible := true;
        end;
    2 : begin
          pnl_cod.Visible := false;
          pnl_data.Visible := false;
          CDS_ContasReceber.Filtered := false;
        end;
  end;
end;

procedure Tfrm_ListagemContasReceber.PassaVetorContasReceberCDS;
var
  i: Integer;
  date : TDate;
begin
  CDS_ContasReceber.Open;
  for i := length(contas_receber)-1 downto 0 do
    begin
      CDS_ContasReceber.Insert;
      CDS_ContasReceber.Fields[0].Value := contas_receber[i].Cod_Cliente;
      CDS_ContasReceber.Fields[1].Value := contas_receber[i].parcela;
      CDS_ContasReceber.Fields[2].Value := contas_receber[i].data;
      if contas_receber[i].pago
        then CDS_ContasReceber.Fields[3].Value := 'PAGO'
        else CDS_ContasReceber.Fields[3].Value := 'NÃO PAGO';
      CDS_ContasReceber.Fields[4].Value := contas_receber[i].pagamento;
      date := StrToDate(contas_receber[i].data);
      CDS_ContasReceber.Fields[5].Value := formatdatetime('yyyy/mm/dd',date);
      CDS_ContasReceber.Post;
    end;
end;

procedure Tfrm_ListagemContasReceber.PassaCodClienteCbox;
var
  i: Integer;
begin
  for i := 0 to length(clientes)-1 do
    begin
      Cbox_CodInicial.Items.Add(clientes[i].codigo);
      Cbox_CodFinal.Items.Add(clientes[i].codigo);
    end;
end;

end.
