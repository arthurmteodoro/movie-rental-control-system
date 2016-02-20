unit Unit_FeedbackListagemLocacoes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Data.DB, Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids, Unit_biblioteca,
  RpCon, RpConDS, RpDefine, RpRave;

type
  TFrm_ListagemLocacoes = class(TFrame)
    pnl_top: TPanel;
    pnl_pesquisa: TPanel;
    pnl_relatorio: TPanel;
    btn_voltar: TBitBtn;
    CBox_Tipos: TComboBox;
    lbl_tipo: TLabel;
    pnl_forma: TPanel;
    CBox_Forma: TComboBox;
    lbl_forma: TLabel;
    Btn_Pagamento: TBitBtn;
    DBGrid1: TDBGrid;
    CDS_Devolucao: TClientDataSet;
    DS_Devolucao: TDataSource;
    CDS_Devolucaocodcliente: TStringField;
    CDS_Devolucaocodfilme: TStringField;
    CDS_Devolucaodatalocacao: TStringField;
    CDS_Devolucaodatadevolucao: TStringField;
    CDS_Devolucaotipo: TStringField;
    CDS_Devolucaocodfuncionario: TStringField;
    pnl_vendedor: TPanel;
    CBox_CodFuncionario: TComboBox;
    Label1: TLabel;
    btn_funcionario: TBitBtn;
    Btn_Relatorio: TBitBtn;
    RvProject1: TRvProject;
    DSC_Devolucao: TRvDataSetConnection;
    procedure btn_voltarClick(Sender: TObject);
    procedure PassaVetorCDS;
    procedure Btn_PagamentoClick(Sender: TObject);
    procedure PassaFuncionariosCbox;
    procedure btn_funcionarioClick(Sender: TObject);
    procedure CBox_TiposChange(Sender: TObject);
    procedure Btn_RelatorioClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_ListagemLocacoes : TFrm_ListagemLocacoes;

implementation

{$R *.dfm}

uses Unit_Feedback, Unit_Principal;

procedure TFrm_ListagemLocacoes.btn_funcionarioClick(Sender: TObject);
var
  filtro : string;
begin
  filtro := 'codfuncionario = '+chr(39);
  filtro := filtro + CBox_CodFuncionario.Text+chr(39);
  CDS_Devolucao.Filter := filtro;
  CDS_Devolucao.Filtered := true;
end;

procedure TFrm_ListagemLocacoes.Btn_PagamentoClick(Sender: TObject);
var
  filtro : string;
begin
  filtro := 'tipo = '+chr(39);
  filtro := filtro + Cbox_Forma.Text+chr(39);
  CDS_Devolucao.Filter := filtro;
  CDS_Devolucao.Filtered := true;
end;

procedure TFrm_ListagemLocacoes.Btn_RelatorioClick(Sender: TObject);
var
  localizacao : string;
  posi : integer;
begin
  localizacao := ExtractFilePath(Application.ExeName);
  posi := pos('\Win32\Debug',localizacao);
  delete(localizacao,posi,length(localizacao));
  localizacao := localizacao + '\modelos relatorios\devolucoes.rav';
  RVProject1.ProjectFile := localizacao;
  RVProject1.Execute;
end;

procedure TFrm_ListagemLocacoes.btn_voltarClick(Sender: TObject);
begin
  Frm_Feedback := TFrm_Feedback.Create(Frm_Principal.pnl_main);
  Frm_Feedback.parent := Frm_Principal.Pnl_main;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Feedback';
  Frm_ListagemLocacoes.Destroy;
end;

procedure TFrm_ListagemLocacoes.CBox_TiposChange(Sender: TObject);
begin
  case Cbox_Tipos.ItemIndex of
    0 : begin
          pnl_forma.Visible := true;
          pnl_vendedor.Visible := false;
        end;
    1 : begin
          pnl_forma.Visible := false;
          pnl_vendedor.Visible := true;
        end;
    2 : begin
          pnl_forma.Visible := false;
          pnl_vendedor.Visible := false;
          CDS_Devolucao.Filtered := false;
        end;
  end;
end;

procedure TFrm_ListagemLocacoes.PassaVetorCDS;
var
  i : integer;
begin
  CDS_Devolucao.Open;
  for i := length(filmes_devolver)-1 downto 0 do
    begin
      CDS_Devolucao.Insert;
      CDS_Devolucao.Fields[0].Value := filmes_devolver[i].CodCliente;
      CDS_Devolucao.Fields[1].Value := filmes_devolver[i].codFilmes;
      CDS_Devolucao.Fields[2].Value := filmes_devolver[i].dataLoc;
      CDS_Devolucao.Fields[3].Value := filmes_devolver[i].DataDev;
      CDS_Devolucao.Fields[4].Value := filmes_devolver[i].tipo;
      CDS_Devolucao.Fields[5].Value := filmes_devolver[i].funcionario;
      CDS_Devolucao.Post;
    end;
end;

procedure TFrm_ListagemLocacoes.PassaFuncionariosCbox;
var
  i: Integer;
begin
  for i := 0 to length(funcionarios)-1 do
    begin
      if not(funcionarios[i].ativo)
        then begin
               Cbox_CodFuncionario.Items.Add(funcionarios[i].codigo);
             end;
    end;
end;

end.
