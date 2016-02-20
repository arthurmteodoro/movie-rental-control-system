unit Unit_CadastroGestaoLocadora;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Vcl.Mask, Vcl.ComCtrls, Unit_Biblioteca;

type
  TFrm_Locadora = class(TFrame)
    pnl_Titulo_Locadora: TPanel;
    Btn_Voltar: TBitBtn;
    Page_Locadora: TPageControl;
    Cadastrar: TTabSheet;
    Editar_Excluir: TTabSheet;
    edt_NomeFantasia: TLabeledEdit;
    edt_RazaoSocial: TLabeledEdit;
    Edt_Inscricao: TLabeledEdit;
    MaskCNPJ: TMaskEdit;
    Edt_NomeResponsavel: TLabeledEdit;
    MaskTelefone: TMaskEdit;
    Edt_Endereco: TLabeledEdit;
    Edt_email: TLabeledEdit;
    Mask_TelefoneResponsavel: TMaskEdit;
    lbl_CNPJ: TLabel;
    lbl_Telefone: TLabel;
    lbl_telefoneResponsavel: TLabel;
    btn_Cadastrar: TBitBtn;
    btn_limpar: TBitBtn;
    Btn_Sair: TBitBtn;
    Btn_LimparEditar: TBitBtn;
    Mask_TelefoneResponsavelEditar: TMaskEdit;
    lbl_TelefoneResponsavelEditar: TLabel;
    Edt_emailEditar: TLabeledEdit;
    Edt_RazaoSocialEditar: TLabeledEdit;
    lbl_CNPJEditar: TLabel;
    Edt_InscricaoEditar: TLabeledEdit;
    Edt_NomeResponsavelEditar: TLabeledEdit;
    Edt_Endereco_Editar: TLabeledEdit;
    lbl_TelefoneEditar: TLabel;
    Btn_SairEditar: TBitBtn;
    Mask_CNPJEditar: TMaskEdit;
    Edt_NomeFantasilEditar: TLabeledEdit;
    Mask_TelefoneEditar: TMaskEdit;
    Btn_Editar: TBitBtn;
    edt_multa: TLabeledEdit;
    Edt_MultaEditar: TLabeledEdit;
    procedure Btn_VoltarClick(Sender: TObject);
    procedure btn_CadastrarClick(Sender: TObject);
    procedure btn_limparClick(Sender: TObject);
    procedure Btn_SairClick(Sender: TObject);
    procedure Page_LocadoraChange(Sender: TObject);
    procedure LeDados(var loc : locadora);
    procedure Limpar(nome,razao,inscricao,endereco,email,nomeresponsavel,multa:TLabeledEdit;cnpj,telefone,TelefoneResponsavel:TMaskEdit);
    procedure Btn_EditarClick(Sender: TObject);
    procedure LerEditar(var loc : locadora);
    procedure edt_multaKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Locadora : TFrm_Locadora;

implementation

{$R *.dfm}

uses Unit_Principal, Unit_Cadastro;

procedure TFrm_Locadora.btn_CadastrarClick(Sender: TObject);
begin
  //AbreArquivoGravacao;
  Frm_Principal.Pnl_Header.Caption := Edt_Nomefantasia.Text;
  Frm_Principal.Caption := Edt_Nomefantasia.Text;
  Frm_Principal.pnl_bottom.Caption := Edt_Endereco.Text;
  //lê os dados
  Ledados(loc);
  //faz o cadastro dos dados
  EditaNoArquivo;
//  GravaLocadora(loc);
  //limpa a tela
  Limpar(Edt_NomeFantasia,Edt_RazaoSocial,Edt_Inscricao,Edt_Endereco,Edt_Email,Edt_NomeResponsavel,Edt_Multa,MaskCNPJ,MaskTelefone,Mask_TelefoneResponsavel);
  //mostra a mensagem de cadastrado
  Application.MessageBox(Pchar('Locadora '+loc.Nome+' cadastrada com sucesso!'),'Cadastro',MB_ICONINFORMATION+mb_ok);
  //CloseFile(Arquivo);
end;

procedure TFrm_Locadora.Btn_EditarClick(Sender: TObject);
begin
  IniciaArquivoEditar;
  Frm_Principal.Pnl_Header.Caption := Edt_NomefantasilEditar.Text;
  Frm_Principal.Caption := Edt_NomefantasilEditar.Text;
  Frm_Principal.pnl_bottom.Caption := Edt_Endereco_Editar.Text;
  LerEditar(loc);
  EditaNoArquivo;
  Application.MessageBox('Locadora editado com sucesso','Editar',MB_ICONINFORMATION+mb_ok);
  Frm_Locadora.Destroy;
  Frm_Principal.IniciaCodigo;
  CloseFile(Arquivo);
end;

procedure TFrm_Locadora.btn_limparClick(Sender: TObject);
begin
  if Application.MessageBox('Você deseja mesmo apagar todos os campos?','Aviso',MB_ICONWARNING+MB_YESNO) = IDYes
    then begin
           Limpar(Edt_NomeFantasia,Edt_RazaoSocial,Edt_Inscricao,Edt_Endereco,Edt_Email,Edt_NomeResponsavel,Edt_Multa,MaskCNPJ,MaskTelefone,Mask_TelefoneResponsavel);
         end;
end;

procedure TFrm_Locadora.Btn_SairClick(Sender: TObject);
begin
  if Application.MessageBox('Você deseja mesmo sair?','Aviso',MB_ICONEXCLAMATION+MB_YESNO) = IDYes
    then begin
           Frm_Cadastro := TFrm_Cadastro.Create(Frm_Principal.pnl_main);
           Frm_Cadastro.Parent := Frm_Principal.pnl_main;
           Limpar(Edt_NomeFantasia,Edt_RazaoSocial,Edt_Inscricao,Edt_Endereco,Edt_Email,Edt_NomeResponsavel,Edt_Multa,MaskCNPJ,MaskTelefone,Mask_TelefoneResponsavel);
           Frm_Locadora.Destroy;
           Frm_Principal.lbl_caminho.Caption := 'Menu/Cadastro e Gestão de Dados'
         end;
end;

procedure TFrm_Locadora.Btn_VoltarClick(Sender: TObject);
begin
  Frm_Cadastro := TFrm_Cadastro.Create(Frm_Principal.pnl_main);
  Frm_Cadastro.Parent := Frm_Principal.pnl_main;
  Frm_Locadora.Destroy;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Cadastro e Gestão de Dados';
end;

procedure TFrm_Locadora.edt_multaKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9',#13,#44,#8])
    then begin
           key:=#0;
           messagebeep(0);
         end;
end;

procedure TFrm_Locadora.Limpar(nome,razao,inscricao,endereco,email,nomeresponsavel,multa:TLabeledEdit;cnpj,telefone,TelefoneResponsavel:TMaskEdit);
begin
  nome.Clear;
  razao.Clear;
  inscricao.Clear;
  endereco.Clear;
  email.Clear;
  nomeresponsavel.Clear;
  multa.Clear;
  cnpj.Clear;
  telefone.Clear;
  TelefoneResponsavel.Clear;
end;

procedure TFrm_Locadora.Page_LocadoraChange(Sender: TObject);
  var
    aba : integer;
begin
  aba := Page_Locadora.ActivePageIndex;
  if aba = 0
    then Frm_Principal.lbl_caminho.Caption := 'Menu/Cadastro e Gestão de Dados/Locadora/Cadastrar Locadora'
    else if aba = 1
         then Frm_Principal.lbl_caminho.Caption := 'Menu/Cadastro e Gestão de Dados/Locadora/Editar Locadora';
end;

procedure Tfrm_Locadora.LeDados(var loc : locadora);
begin
  loc.Nome := Edt_nomeFantasia.Text;
  loc.Razao := Edt_RazaoSocial.Text;
  loc.Incricao := Edt_Inscricao.Text;
  loc.CNPJ := Edt_Endereco.Text;
  loc.email := Edt_Email.Text;
  loc.NomeResponsavel := Edt_NomeResponsavel.Text;
  loc.multa := Edt_Multa.Text;
  loc.CNPJ := MaskCnpj.Text;
  loc.telefone := MaskTelefone.Text;
  loc.TelefoneResponsavel := Mask_TelefoneResponsavel.Text;
  loc.endereco := Edt_Endereco.Text;
end;

procedure Tfrm_Locadora.LerEditar(var loc : locadora);
begin
  loc.Nome := Edt_NomeFantasilEditar.Text;
  loc.Razao := Edt_RazaoSocialEditar.Text;
  loc.Incricao := Edt_InscricaoEditar.Text;
  loc.CNPJ := Mask_CNPJEditar.Text;
  loc.endereco := Edt_Endereco_Editar.Text;
  loc.telefone := Mask_TelefoneEditar.Text;
  loc.email := Edt_EmailEditar.Text;
  loc.multa := Edt_MultaEditar.Text;
  loc.NomeResponsavel := Edt_NomeResponsavelEditar.Text;
  loc.TelefoneResponsavel := Mask_TelefoneResponsavel.Text;
end;

end.
