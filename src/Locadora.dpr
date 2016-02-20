program Locadora;

uses
  Vcl.Forms,
  Unit_Principal in 'Unit_Principal.pas' {frm_Principal},
  Unit_Menu in 'Unit_Menu.pas' {Frm_Menu: TFrame},
  Unit_Biblioteca in 'Unit_Biblioteca.pas',
  Unit_Cadastro in 'Unit_Cadastro.pas' {Frm_Cadastro: TFrame},
  Unit_CadastroGestaoLocadora in 'Unit_CadastroGestaoLocadora.pas' {Frm_Locadora: TFrame},
  Unit_CadastroGestaoCliente in 'Unit_CadastroGestaoCliente.pas' {Frm_Cliente: TFrame},
  Unit_CadastroGestaoFilmes in 'Unit_CadastroGestaoFilmes.pas' {Frm_Filmes: TFrame},
  Unit_CadastroGestaoCategoria in 'Unit_CadastroGestaoCategoria.pas' {Frm_Categoria: TFrame},
  Unit_CadastroGestaoFuncionarios in 'Unit_CadastroGestaoFuncionarios.pas' {Frm_Funcionarios: TFrame},
  Unit_CadastroGestaoFornecedores in 'Unit_CadastroGestaoFornecedores.pas' {Frm_Fornecedores: TFrame},
  Unit_Transacoes in 'Unit_Transacoes.pas' {Frm_Transacoes: TFrame},
  Unit_TransacoesLocacao in 'Unit_TransacoesLocacao.pas' {Frm_Locacao: TFrame},
  Unit_TransacoesCaixa in 'Unit_TransacoesCaixa.pas' {Frm_Caixa: TFrame},
  Unit_TransacoesDevolucao in 'Unit_TransacoesDevolucao.pas' {Frm_Devolucao: TFrame},
  Unit_TransacoesReceber in 'Unit_TransacoesReceber.pas' {Frm_Receber: TFrame},
  Unit_TransacoesEntrada in 'Unit_TransacoesEntrada.pas' {Frm_Entrada: TFrame},
  Unit_TransacoesEntradaConf in 'Unit_TransacoesEntradaConf.pas' {Frm_Confirmacao},
  Unit_TransacoesPagar in 'Unit_TransacoesPagar.pas' {Frm_Pagar: TFrame},
  Unit_Feedback in 'Unit_Feedback.pas' {Frm_FeedBack: TFrame},
  Unit_FeedbackLocacaoFuncionario in 'Unit_FeedbackLocacaoFuncionario.pas' {Frm_LocacaoFuncionario: TFrame},
  Unit_FeedbackLocacaoDia in 'Unit_FeedbackLocacaoDia.pas' {Frm_LocacoesDia: TFrame},
  Unit_ImpExp in 'Unit_ImpExp.pas' {Frm_ImpExp: TFrame},
  Unit_FeedbackListagemFilmes in 'Unit_FeedbackListagemFilmes.pas' {Frm_ListagemFilmes: TFrame},
  Unit_FeedbackListagemClientes in 'Unit_FeedbackListagemClientes.pas' {Frm_ListagemClientes: TFrame},
  Unit_FeedbackListagemLocacoes in 'Unit_FeedbackListagemLocacoes.pas' {Frm_ListagemLocacoes: TFrame},
  Unit_FeedbackListagemContasReceber in 'Unit_FeedbackListagemContasReceber.pas' {Frm_ListagemContasReceber: TFrame},
  Unit_FeedbackListagemContasPagar in 'Unit_FeedbackListagemContasPagar.pas' {Frm_ListagemContasPagar: TFrame},
  Unit_FeedbackListagemMovimentacao in 'Unit_FeedbackListagemMovimentacao.pas' {Frm_ListagemMovimentacao: TFrame},
  Unit_FeedbackListagemFilmesPagar in 'Unit_FeedbackListagemFilmesPagar.pas' {Frm_ListagemFilmePagar: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.HelpFile := '';
  Application.CreateForm(TFrm_Principal, Frm_Principal);
  //Application.CreateForm(TFrm_Confirmacao, Frm_Confirmacao);
  Application.Run;
end.
