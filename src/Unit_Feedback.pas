unit Unit_Feedback;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Unit_Biblioteca, Vcl.Menus;

type
  TFrm_FeedBack = class(TFrame)
    Pnl_FeedBack: TPanel;
    Btn_Menu: TBitBtn;
    Btn_Relatorio: TBitBtn;
    Btn_Grafico: TBitBtn;
    pnl_Relatorios: TPanel;
    Btn_Clientes: TBitBtn;
    Btn_ContasReceber: TBitBtn;
    Btn_Filmes: TBitBtn;
    Btn_ContasPagar: TBitBtn;
    Btn_Caixa: TBitBtn;
    Btn_FilmePague: TBitBtn;
    Btn_Locacoes: TBitBtn;
    Pnl_Grafico: TPanel;
    Btn_Pizza: TBitBtn;
    Btn_Linha: TBitBtn;
    procedure Btn_MenuClick(Sender: TObject);
    procedure Btn_RelatorioClick(Sender: TObject);
    procedure Btn_GraficoClick(Sender: TObject);
    procedure Btn_PizzaClick(Sender: TObject);
    procedure Btn_LinhaClick(Sender: TObject);
    procedure Btn_FilmesClick(Sender: TObject);
    procedure Btn_ClientesClick(Sender: TObject);
    procedure Btn_LocacoesClick(Sender: TObject);
    procedure Btn_ContasReceberClick(Sender: TObject);
    procedure Btn_ContasPagarClick(Sender: TObject);
    procedure Btn_CaixaClick(Sender: TObject);
    procedure Btn_FilmePagueClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  var
    Frm_Feedback : TFrm_FeedBack;

implementation

{$R *.dfm}

uses Unit_Menu, Unit_Principal, Unit_FeedbackLocacaoFuncionario, Unit_FeedbackLocacaoDia,
  Unit_FeedbackListagemFilmes, Unit_FeedbackListagemClientes,
  Unit_FeedbackListagemLocacoes, Unit_FeedbackListagemContasReceber,
  Unit_FeedbackListagemContasPagar, Unit_FeedbackListagemMovimentacao,
  Unit_FeedbackListagemFilmesPagar;

procedure TFrm_FeedBack.Btn_CaixaClick(Sender: TObject);
begin
  Frm_ListagemMovimentacao := TFrm_ListagemMovimentacao.Create(Frm_Principal.pnl_main);
  Frm_ListagemMovimentacao.parent := Frm_Principal.Pnl_main;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Feedback/Movimentação do Caixa';
  Frm_ListagemMovimentacao.PassaMovimentacaoCDS;
  Frm_Feedback.Destroy;
end;

procedure TFrm_FeedBack.Btn_ClientesClick(Sender: TObject);
begin
  Frm_ListagemClientes := TFrm_ListagemClientes.Create(Frm_Principal.pnl_main);
  Frm_ListagemClientes.parent := Frm_Principal.Pnl_main;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Feedback/Listagem de Clientes';
  Frm_ListagemClientes.PassaVetorCDS;
  Frm_ListagemClientes.PassaCodCBox;
  Frm_Feedback.Destroy;
end;

procedure TFrm_FeedBack.Btn_ContasPagarClick(Sender: TObject);
begin
  Frm_ListagemContasPagar := TFrm_ListagemContasPagar.Create(Frm_Principal.pnl_main);
  Frm_ListagemContasPagar.parent := Frm_Principal.Pnl_main;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Feedback/Listagem de Contas a Pagar';
  Frm_ListagemContasPagar.PassaVetorPagarCDS;
  Frm_listagemContasPagar.PassaCodFuncCbox;
  Frm_Feedback.Destroy;
end;

procedure TFrm_FeedBack.Btn_ContasReceberClick(Sender: TObject);
begin
  Frm_ListagemContasReceber := TFrm_ListagemContasReceber.Create(Frm_Principal.pnl_main);
  Frm_ListagemContasReceber.parent := Frm_Principal.Pnl_main;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Feedback/Listagem de Contas a Receber';
  Frm_ListagemContasReceber.PassaVetorContasReceberCDS;
  Frm_ListagemContasReceber.PassaCodClienteCbox;
  Frm_Feedback.Destroy;
end;

procedure TFrm_FeedBack.Btn_FilmePagueClick(Sender: TObject);
begin
  Frm_ListagemFilmePagar := TFrm_ListagemFilmePagar.Create(Frm_Principal.pnl_main);
  Frm_ListagemFilmePagar.parent := Frm_Principal.Pnl_main;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Feedback/Quantidade para se Pagar';
  Frm_ListagemFilmePagar.PassaProCDS;
  Frm_ListagemFilmePagar.PassaCodCbox;
  Frm_Feedback.Destroy;
end;

procedure TFrm_FeedBack.Btn_FilmesClick(Sender: TObject);
begin
  Frm_ListagemFilmes := TFrm_ListagemFilmes.Create(Frm_Principal.pnl_main);
  Frm_ListagemFilmes.parent := Frm_Principal.Pnl_main;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Feedback/Listagem de Filmes';
  Frm_ListagemFilmes.PassaVetorFilmesCDS;
  Frm_listagemFilmes.PassaFuncCbox;
  Frm_Feedback.Destroy;
end;

procedure TFrm_FeedBack.Btn_GraficoClick(Sender: TObject);
begin
  if Pnl_Grafico.Visible
    then Pnl_Grafico.Visible := false
    else Pnl_Grafico.Visible := true;
end;

procedure TFrm_FeedBack.Btn_LinhaClick(Sender: TObject);
begin
  Frm_LocacoesDia := TFrm_LocacoesDia.Create(Frm_Principal.pnl_main);
  Frm_LocacoesDia.parent := Frm_Principal.Pnl_main;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Feedback/Locações por Dia';
  Frm_LocacoesDia.PassaProVetor(vetor_LocacoesDia);
  Frm_LocacoesDia.DesenhaGrafico(vetor_LocacoesDia);
  Frm_Feedback.Destroy;
end;

procedure TFrm_FeedBack.Btn_LocacoesClick(Sender: TObject);
begin
  Frm_ListagemLocacoes:= TFrm_ListagemLocacoes.Create(Frm_Principal.pnl_main);
  Frm_ListagemLocacoes.parent := Frm_Principal.Pnl_main;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Feedback/Listagem de Locações';
  Frm_ListagemLocacoes.PassaVetorCDS;
  Frm_ListagemLocacoes.PassaFuncionariosCbox;
  Frm_Feedback.Destroy;
end;

procedure TFrm_FeedBack.Btn_MenuClick(Sender: TObject);
begin
  Frm_menu := TFrm_menu.Create(Frm_Principal.pnl_main);
  Frm_menu.Parent := Frm_Principal.pnl_main;
  Frm_Feedback.Destroy;
  Frm_Principal.lbl_caminho.Caption := 'Menu';
end;

procedure TFrm_FeedBack.Btn_PizzaClick(Sender: TObject);
begin
  Frm_LocacaoFuncionario := TFrm_LocacaoFuncionario.Create(Frm_Principal.pnl_main);
  Frm_LocacaoFuncionario.parent := Frm_Principal.Pnl_main;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Feedback/Locação por Funcionário';
  Frm_LocacaoFuncionario.Passavetor;
  Frm_LocacaoFuncionario.EscreveGrafico(vetor_ord);
  Frm_Feedback.Destroy;
end;

procedure TFrm_FeedBack.Btn_RelatorioClick(Sender: TObject);
begin
  if Pnl_Relatorios.Visible
    then Pnl_Relatorios.Visible := false
    else Pnl_Relatorios.Visible := true;
end;

end.
