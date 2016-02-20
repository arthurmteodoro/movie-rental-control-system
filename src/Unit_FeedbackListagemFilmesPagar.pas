unit Unit_FeedbackListagemFilmesPagar;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.Grids, Vcl.DBGrids, Data.DB, Datasnap.DBClient, Unit_Biblioteca,
  RpCon, RpConDS, RpDefine, RpRave;

type
  TFrm_ListagemFilmePagar = class(TFrame)
    pnl_top: TPanel;
    pnl_pesquisa: TPanel;
    pnl_exportar: TPanel;
    btn_voltar: TBitBtn;
    DS_FilmePagar: TDataSource;
    CDS_FilmePagar: TClientDataSet;
    CDS_FilmePagarCodFilme: TStringField;
    CDS_FilmePagardescricao: TStringField;
    CDS_FilmePagarexemplares: TStringField;
    CDS_FilmePagarcategoria: TStringField;
    CDS_FilmePagarlingua: TStringField;
    CDS_FilmePagarquantidade: TStringField;
    DBGrid1: TDBGrid;
    lbl_filtro: TLabel;
    CBox_Filtros: TComboBox;
    pnl_cod: TPanel;
    Cbox_Inicial: TComboBox;
    CBOx_Final: TComboBox;
    lbl_codinc: TLabel;
    lbl_coddec: TLabel;
    btn_pesquisar: TBitBtn;
    btn_gerar: TBitBtn;
    Rv_FilmePagar: TRvProject;
    DSC_FilmePagar: TRvDataSetConnection;
    procedure btn_voltarClick(Sender: TObject);
    procedure PassaProCDS;
    procedure PassaCodCbox;
    procedure btn_pesquisarClick(Sender: TObject);
    procedure CBox_FiltrosChange(Sender: TObject);
    procedure btn_gerarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_ListagemFilmePagar : TFrm_ListagemFilmePagar;

implementation

{$R *.dfm}

uses Unit_Feedback, Unit_Principal;

procedure TFrm_ListagemFilmePagar.btn_gerarClick(Sender: TObject);
var
  localizacao : string;
  posi : integer;
begin
  localizacao := ExtractFilePath(Application.ExeName);
  posi := pos('\Win32\Debug',localizacao);
  delete(localizacao,posi,length(localizacao));
  localizacao := localizacao + '\modelos relatorios\filmespagar.rav';
  RV_FilmePagar.ProjectFile := localizacao;
  RV_FilmePagar.Execute;
end;

procedure TFrm_ListagemFilmePagar.btn_pesquisarClick(Sender: TObject);
var
  filtro : string;
begin
  filtro := 'CodFilme >= ' + chr(39);
  filtro := filtro + Cbox_Inicial.Text;
  filtro := filtro + chr(39) + ' and CodFilme <= ' + chr(39);
  filtro := filtro + cbox_Final.Text + chr(39);
  CDS_FilmePagar.Filter := filtro;
  CDS_FilmePagar.Filtered := true;
end;

procedure TFrm_ListagemFilmePagar.btn_voltarClick(Sender: TObject);
begin
  Frm_Feedback := TFrm_Feedback.Create(Frm_Principal.pnl_main);
  Frm_Feedback.parent := Frm_Principal.Pnl_main;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Feedback';
  Frm_ListagemFilmePagar.Destroy;
end;

procedure TFrm_ListagemFilmePagar.CBox_FiltrosChange(Sender: TObject);
begin
  case CBox_Filtros.ItemIndex of
    0 : begin
          pnl_cod.Visible := true;
          CDS_FilmePagar.Filtered := false;
        end;
    1 : begin
          pnl_cod.Visible := false;
          CDS_FilmePagar.Filtered := false;
        end;
  end;
end;

procedure TFrm_ListagemFilmePagar.PassaProCDS;
var
  i, vezes, catVet, quant : integer;
  quantidade, precoCat, precoFilme : real;
  catstr : string;
begin
  CDS_FilmePagar.Open;
  for i := length(filmes)-1 downto 0 do
    begin
      if not(filmes[i].ativo)
        then begin
               CDS_FilmePagar.Insert;
               CDS_FilmePagar.Fields[0].Value := filmes[i].codigo;
               CDS_filmePagar.Fields[1].Value := filmes[i].descricao;
               CDS_FilmePagar.Fields[2].Value := filmes[i].exemplares;
               CDS_FilmePagar.Fields[3].Value := filmes[i].codcat;
               CDS_FilmePagar.Fields[4].Value := filmes[i].lingua;
               catstr := filmes[i].codcat;
               delete(catstr,1,3);
               catvet := StrToInt(catstr);
               dec(catvet);
               precoCat := StrToFloat(categorias[catvet].valor);
               precofilme := StrToFloat(filmes[i].preco);
               vezes := filmes[i].vezes;
               if precoFilme = 0
                 then CDS_FilmePagar.Fields[5].Value := 'Filme não Comprado'
                 else begin
                        vezes := filmes[i].vezes;
                        quantidade := (precoFilme/precoCat)-vezes;
                        quant := trunc(quantidade);
                        inc(quant);
                        if quantidade <= 0
                          then CDS_FilmePagar.Fields[5].Value := 'Filme Já Pago'
                          else CDS_FilmePagar.Fields[5].Value := IntToStr(quant);
                      end;
               CDS_FilmePagar.Post;
             end;
    end;
end;

procedure TFrm_ListagemFilmePagar.PassaCodCbox;
var
  i: Integer;
begin
  for i := 0 to length(filmes)-1 do
    begin
      Cbox_Inicial.Items.Add(filmes[i].codigo);
      Cbox_Final.Items.Add(filmes[i].codigo);
    end;
end;

end.
