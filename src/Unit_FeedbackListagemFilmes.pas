unit Unit_FeedbackListagemFilmes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Unit_Biblioteca, RpCon, RpConDS, RpDefine, RpRave, Data.DB,
  Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids, Vcl.DBCtrls;

type
  TFrm_ListagemFilmes = class(TFrame)
    pnl_top: TPanel;
    Btn_voltar: TBitBtn;
    CDS_Filmes: TClientDataSet;
    DS_Filmes: TDataSource;
    CDS_Filmescodigo: TStringField;
    CDS_Filmesdescricao: TStringField;
    CDS_Filmesexemplares: TStringField;
    CDS_Filmescodcat: TStringField;
    CDS_Filmeslingua: TStringField;
    pnl_filtro: TPanel;
    pnl_exportar: TPanel;
    btn_gerar: TBitBtn;
    RvProject1: TRvProject;
    RvDataSetConnection1: TRvDataSetConnection;
    DBGrid1: TDBGrid;
    CDS_Locadora: TClientDataSet;
    DS_Locadora: TDataSource;
    CDS_Locadoranome: TStringField;
    CDS_Locadorainscricao: TStringField;
    CDS_Locadoracnpj: TStringField;
    CDS_Locadoraendereco: TStringField;
    CDS_Locadoratelefone: TStringField;
    RvDataSetConnection2: TRvDataSetConnection;
    Label1: TLabel;
    Label2: TLabel;
    CBox_Incial: TComboBox;
    CBox_Final: TComboBox;
    Btn_Pesquisar: TBitBtn;
    procedure Btn_voltarClick(Sender: TObject);
    procedure PassaVetorFilmesCDS;
    procedure btn_gerarClick(Sender: TObject);
    procedure PassaFuncCbox;
    procedure PesquisaFilmes(codinc,codfin:integer);
    procedure Btn_PesquisarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_ListagemFilmes : TFrm_ListagemFilmes;
  quant_Filmes : integer;

implementation

{$R *.dfm}

uses Unit_Feedback, Unit_Principal;

procedure TFrm_ListagemFilmes.btn_gerarClick(Sender: TObject);
var
  localizacao : string;
  posi : integer;
begin
  localizacao := ExtractFilePath(Application.ExeName);
  posi := pos('\Win32\Debug',localizacao);
  delete(localizacao,posi,length(localizacao));
  localizacao := localizacao + '\modelos relatorios\filmes.rav';
  RVProject1.ProjectFile := localizacao;
  RVProject1.Execute;
end;

procedure TFrm_ListagemFilmes.Btn_PesquisarClick(Sender: TObject);
var
  codinc, codfin : integer;
  codi, codf : string;
begin
  codi := CBox_Incial.Text;
  codf := Cbox_Final.Text;
  delete(codi,1,1);
  delete(codf,1,1);
  codinc := StrToInt(codi);
  codfin := StrToInt(codf);
  dec(codinc);
  dec(codfin);
  PesquisaFilmes(codinc,codfin);
end;

procedure TFrm_ListagemFilmes.Btn_voltarClick(Sender: TObject);
begin
  Frm_Feedback := TFrm_Feedback.Create(Frm_Principal.pnl_main);
  Frm_Feedback.parent := Frm_Principal.Pnl_main;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Feedback';
  Frm_ListagemFilmes.Destroy;
end;

procedure Tfrm_ListagemFilmes.PassaVetorFilmesCDS;
var
  i : integer;
begin
  quant_Filmes := 0;
  CDS_Filmes.Open;
  for i := length(filmes)-1 downto 0 do
    begin
      if not(filmes[i].ativo)
        then begin
               CDS_filmes.Insert;
               CDS_Filmes.Fields[0].Value := filmes[i].codigo;
               CDS_Filmes.Fields[1].Value := filmes[i].descricao;
               CDS_Filmes.Fields[2].Value := filmes[i].exemplares;
               CDS_Filmes.Fields[3].Value := filmes[i].codcat;
               CDS_Filmes.Fields[4].Value := filmes[i].lingua;
               CDS_Filmes.Post;
               inc(quant_Filmes);
             end;
    end;
  CDS_Locadora.Open;
  CDS_Locadora.Insert;
  CDS_Locadora.Fields[0].Value := loc.Nome;
  CDS_Locadora.Fields[1].Value := loc.Incricao;
  CDS_Locadora.Fields[2].Value := loc.CNPJ;
  CDS_Locadora.Fields[3].Value := loc.endereco;
  CDS_Locadora.Fields[4].Value := loc.telefone;
  CDS_Locadora.Post;
end;

procedure TFrm_ListagemFilmes.PassaFuncCbox;
var
  i : integer;
begin
  for i := 0 to length(filmes)-1 do
    begin
      Cbox_Incial.Items.Add(filmes[i].codigo);
      Cbox_Final.Items.Add(filmes[i].codigo);
    end;
end;

procedure TFrm_ListagemFilmes.PesquisaFilmes(codinc,codfin:integer);
var
  i : integer;
  temp : array of filme;
begin
  SetLength(temp,0);
  for i := codinc to codfin do
    begin
      if not(filmes[i].ativo)
        then begin
               SetLength(temp,length(temp)+1);
               temp[length(temp)-1].codigo := filmes[i].codigo;
               temp[length(temp)-1].descricao := filmes[i].descricao;
               temp[length(temp)-1].exemplares := filmes[i].exemplares;
               temp[length(temp)-1].codcat := filmes[i].codcat;
               temp[length(temp)-1].lingua := filmes[i].lingua;
            end;
    end;
  for i := 0 to quant_filmes-1 do
    begin
      CDS_Filmes.Delete;
    end;
  Quant_filmes := 0;
  for i := 0 to length(temp)-1 do
    begin
      CDS_Filmes.Insert;
      CDS_Filmes.Fields[0].Value := temp[i].codigo;
      CDS_Filmes.Fields[1].Value := temp[i].descricao;
      CDS_Filmes.Fields[2].Value := temp[i].exemplares;
      CDS_Filmes.Fields[3].Value := temp[i].codcat;
      CDS_Filmes.Fields[4].Value := temp[i].lingua;
      CDS_Filmes.Post;
      inc(Quant_filmes);
    end;
end;

end.
