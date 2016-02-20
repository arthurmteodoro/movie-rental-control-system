unit Unit_Cadastro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Unit_Biblioteca;

type
  TFrm_Cadastro = class(TFrame)
    pnl_titulo_cadastro: TPanel;
    btn_Voltarmenu: TBitBtn;
    btn_Locadora: TBitBtn;
    Btn_Clientes: TBitBtn;
    Btn_Filmes: TBitBtn;
    Btn_Categoria: TBitBtn;
    Btn_Funcionarios: TBitBtn;
    Btn_Fornecedores: TBitBtn;
    procedure btn_VoltarmenuClick(Sender: TObject);
    procedure btn_LocadoraClick(Sender: TObject);
    procedure Btn_ClientesClick(Sender: TObject);
    procedure Btn_FilmesClick(Sender: TObject);
    procedure Btn_CategoriaClick(Sender: TObject);
    procedure Btn_FuncionariosClick(Sender: TObject);
    procedure Btn_FornecedoresClick(Sender: TObject);
    procedure EscreveInformacoes;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Cadastro : TFrm_Cadastro;

implementation

{$R *.dfm}

uses Unit_Menu, Unit_Principal, Unit_CadastroGestaoLocadora,
  Unit_CadastroGestaoCliente, Unit_CadastroGestaoFilmes,
  Unit_CadastroGestaoCategoria, Unit_CadastroGestaoFuncionarios,
  Unit_CadastroGestaoFornecedores;

procedure TFrm_Cadastro.Btn_CategoriaClick(Sender: TObject);
begin
  {
    função responsável por abrir o frame categorias no painel main no Formulário Frm_Principal
  }
  Frm_Categoria := TFrm_Categoria.Create(Frm_Principal.pnl_main);
  Frm_Categoria.Parent := Frm_Principal.pnl_main;
  Frm_Categoria.SetaGrid;
  Frm_Categoria.EscreveGrid;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Cadastro e Gestão de Dados/Categoria/Cadastrar Categoria';
  Frm_Cadastro.Destroy;
end;

procedure TFrm_Cadastro.Btn_ClientesClick(Sender: TObject);
begin
  {
    função responsável por abrir o frame cliente no painel main no Formulário Frm_Principal
  }
  Frm_Cliente := TFrm_Cliente.Create(Frm_Principal.pnl_main);
  Frm_Cliente.Parent := Frm_Principal.pnl_main;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Cadastro e Gestão de Dados/Cliente/Cadastrar Cliente';
  Frm_Cliente.StrGrid_Clientes.RowCount := 0;
  Frm_Cliente.SetaGrid;
  Frm_Cliente.EscreveGrid;
  Frm_Cadastro.Destroy;
end;

procedure TFrm_Cadastro.Btn_FilmesClick(Sender: TObject);
begin
  {
    função responsável por abrir o frame filmes no painel main no Formulário Frm_Principal
  }
  Frm_Filmes := TFrm_Filmes.Create(Frm_Principal.pnl_main);
  Frm_Filmes.Parent := Frm_Principal.pnl_main;
  Frm_Filmes.SetaTabelaFilmes;
  Frm_Filmes.EscreveGrid;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Cadastro e Gestão de Dados/Filmes/Cadastrar Filmes';
  Frm_Cadastro.Destroy;
end;

procedure TFrm_Cadastro.Btn_FornecedoresClick(Sender: TObject);
begin
  {
    função responsável por abrir o frame fornecedores no painel main no Formulário Frm_Principal
  }
  Frm_Fornecedores := TFrm_Fornecedores.Create(Frm_Principal.pnl_main);
  Frm_FOrnecedores.Parent := Frm_Principal.pnl_main;
  Frm_Fornecedores.Setgrid;
  Frm_fornecedores.EscreveGrid;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Cadastro e Gestão de Dados/Fornecedores/Cadastrar Fornecedores';
  Frm_Cadastro.Destroy;
end;

procedure TFrm_Cadastro.Btn_FuncionariosClick(Sender: TObject);
begin
  {
    função responsável por abrir o frame funcionario no painel main no Formulário Frm_Principal
  }
  Frm_Funcionarios := TFrm_Funcionarios.Create(Frm_Principal.pnl_main);
  Frm_Funcionarios.Parent := Frm_Principal.pnl_main;
  Frm_Funcionarios.Seta_grid;
  Frm_funcionarios.EscreveGrid;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Cadastro e Gestão de Dados/Funcionários/Cadastrar Funcionários';
  Frm_Cadastro.Destroy;
end;

procedure TFrm_Cadastro.btn_LocadoraClick(Sender: TObject);
begin
  {
    função responsável por abrir o frame categorias no painel main no Formulário Frm_Principal
  }
  Frm_Locadora := TFrm_Locadora.Create(Frm_Principal.pnl_main);
  Frm_Locadora.Parent := Frm_Principal.pnl_main;
  EscreveInformacoes;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Cadastro e Gestão de Dados/Locadora/Cadastrar Locadora';
  Frm_Cadastro.Destroy;
end;

procedure TFrm_Cadastro.btn_VoltarmenuClick(Sender: TObject);
begin
  {
    função responsável por sair do menu de cadastro e voltar ao menu
  }
  Frm_menu := TFrm_menu.Create(Frm_Principal.pnl_main);
  Frm_menu.Parent := Frm_Principal.pnl_main;
  Frm_Principal.lbl_caminho.Caption := 'Menu';
  Frm_Cadastro.Destroy;
end;

procedure Tfrm_Cadastro.EscreveInformacoes;
begin
  {
  Função que escreve os dados armazanados na variável loc para os edits do fornulário locadora 
  }
  Frm_Locadora.edt_NomeFantasia.Text := loc.Nome;
  Frm_Locadora.edt_RazaoSocial.Text := loc.Razao;
  Frm_Locadora.Edt_Inscricao.Text := loc.Incricao;
  Frm_Locadora.MaskCNPJ.Text := loc.CNPJ;
  Frm_Locadora.Edt_Endereco.Text := loc.endereco;
  Frm_Locadora.MaskTelefone.Text := loc.telefone;
  Frm_Locadora.edt_Email.Text := loc.email;
  Frm_Locadora.edt_multa.Text := loc.multa;
  Frm_Locadora.Edt_NomeResponsavel.Text := loc.NomeResponsavel;
  Frm_Locadora.Mask_TelefoneResponsavel.Text := loc.TelefoneResponsavel;
end;

end.
