unit Unit_FeedbackListagemMovimentacao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Data.DB, Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids, Unit_Biblioteca,
  Vcl.ComCtrls, RpCon, RpConDS, RpDefine, RpRave;

type
  TFrm_ListagemMovimentacao = class(TFrame)
    pnl_top: TPanel;
    pnl_pesquisa: TPanel;
    pnl_exportar: TPanel;
    btn_voltar: TBitBtn;
    DBGrid1: TDBGrid;
    DS_Movimentacao: TDataSource;
    CDS_Movimentacao: TClientDataSet;
    CDS_MovimentacaocodCliente: TStringField;
    CDS_MovimentacaocodFilme: TStringField;
    CDS_MovimentacaoDatalocacao: TStringField;
    CDS_MovimentacaodataDevolucao: TStringField;
    CDS_MovimentacaoTipo: TStringField;
    CDS_MovimentacaoCodFuncionario: TStringField;
    CDS_MovimentacaoDevolvido: TStringField;
    CDS_MovimentacaoDataLocacaoInversa: TStringField;
    lbl_filtro: TLabel;
    CBox_Filtro: TComboBox;
    pnl_data: TPanel;
    lbl_dataInc: TLabel;
    lbl_datadec: TLabel;
    DTP_DataInicial: TDateTimePicker;
    DTP_DataFinal: TDateTimePicker;
    btn_pesquisa: TBitBtn;
    Btn_relatorio: TBitBtn;
    RV_Movimentacao: TRvProject;
    DSC_Movimentacao: TRvDataSetConnection;
    procedure btn_voltarClick(Sender: TObject);
    procedure PassaMovimentacaoCDS;
    procedure btn_pesquisaClick(Sender: TObject);
    procedure CBox_FiltroChange(Sender: TObject);
    procedure Btn_relatorioClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_ListagemMovimentacao : TFrm_ListagemMovimentacao;

implementation

{$R *.dfm}

uses Unit_Feedback, Unit_Principal;

procedure TFrm_ListagemMovimentacao.btn_pesquisaClick(Sender: TObject);
var
  data1, data2, filtro : string;
begin
  data1 := formatdatetime('yyyy/mm/dd',DTP_DataInicial.Date);
  data2 := formatdatetime('yyyy/mm/dd',DTP_DataFinal.Date);
  filtro := 'DataLocacaoInversa >= '+chr(39);
  filtro := filtro + data1+chr(39);
  filtro := filtro + ' and DataLocacaoInversa <= '+chr(39);
  filtro := filtro + data2+chr(39);
  Cds_Movimentacao.Filter := filtro;
  CDS_Movimentacao.Filtered := true;
end;

procedure TFrm_ListagemMovimentacao.Btn_relatorioClick(Sender: TObject);
var
  localizacao : string;
  posi : integer;
begin
  localizacao := ExtractFilePath(Application.ExeName);
  posi := pos('\Win32\Debug',localizacao);
  delete(localizacao,posi,length(localizacao));
  localizacao := localizacao + '\modelos relatorios\devolucoes.rav';
  RV_Movimentacao.ProjectFile := localizacao;
  RV_Movimentacao.Execute;
end;

procedure TFrm_ListagemMovimentacao.btn_voltarClick(Sender: TObject);
begin
  Frm_Feedback := TFrm_Feedback.Create(Frm_Principal.pnl_main);
  Frm_Feedback.parent := Frm_Principal.Pnl_main;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Feedback';
  Frm_ListagemMovimentacao.Destroy;
end;

procedure TFrm_ListagemMovimentacao.CBox_FiltroChange(Sender: TObject);
begin
  case CBox_Filtro.ItemIndex of
    0 : begin
          pnl_data.Visible := true;
          CDS_Movimentacao.Filtered := false;
        end;
    1 : begin
          pnl_data.Visible := false;
          CDS_Movimentacao.Filtered := false;
        end;
  end;
end;

procedure TFrm_ListagemMovimentacao.PassaMovimentacaoCDS;
var
  i: Integer;
  data : TDate;
begin
  CDS_Movimentacao.Open;
  for i := length(filmes_devolver)-1 downto 0 do
    begin
      CDS_Movimentacao.Insert;
      CDS_Movimentacao.Fields[0].Value := filmes_devolver[i].CodCliente;
      CDS_Movimentacao.Fields[1].Value := filmes_devolver[i].codFilmes;
      CDS_Movimentacao.Fields[2].Value := filmes_devolver[i].dataLoc;
      CDS_Movimentacao.Fields[3].Value := filmes_devolver[i].DataDev;
      CDS_Movimentacao.Fields[4].Value := filmes_devolver[i].tipo;
      CDS_Movimentacao.Fields[5].Value := filmes_devolver[i].funcionario;
      if filmes_devolver[i].devolvido
      then CDS_Movimentacao.Fields[6].Value := 'DEVOLVIDO'
      else CDS_Movimentacao.Fields[6].Value := 'NÃO DEVOLVIDO';
      data := StrToDate(filmes_devolver[i].dataLoc);
      CDS_Movimentacao.Fields[7].Value := formatdatetime('yyyy/mm/dd',data);
      CDS_Movimentacao.Post;
    end;
end;

end.
