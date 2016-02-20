unit Unit_CadastroGestaoFornecedores;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Mask, Vcl.Grids, Unit_Biblioteca;

type
  TFrm_Fornecedores = class(TFrame)
    Pnl_TituloFornecedores: TPanel;
    Btn_Voltar: TBitBtn;
    PControl_Fornecedores: TPageControl;
    Cadastro: TTabSheet;
    Mostrar: TTabSheet;
    EditarExcluir: TTabSheet;
    Edt_Codigo: TLabeledEdit;
    Edt_Nome: TLabeledEdit;
    Edt_Razao: TLabeledEdit;
    Edt_Inscricao: TLabeledEdit;
    Edt_Endereco: TLabeledEdit;
    Edt_email: TLabeledEdit;
    Mask_CNPJ: TMaskEdit;
    Mask_Telefone: TMaskEdit;
    Lbl_cnpj: TLabel;
    Lbl_telefone: TLabel;
    Btn_Novo: TBitBtn;
    Btn_Cadastrar: TBitBtn;
    Btn_Limpar: TBitBtn;
    Btn_Cancelar: TBitBtn;
    StrGrid_Fornecedores: TStringGrid;
    Edt_CodigoEditar: TLabeledEdit;
    Edt_nomeEditar: TLabeledEdit;
    Edt_razaoEditar: TLabeledEdit;
    Edt_InscricaoEditar: TLabeledEdit;
    Mask_CnpjEditar: TMaskEdit;
    Lbl_CNPJEditar: TLabel;
    Edt_EmailEditar: TLabeledEdit;
    Edt_EnderecoEditar: TLabeledEdit;
    Mask_TelefoneEditar: TMaskEdit;
    Lbl_telefoneEditar: TLabel;
    Btn_editarExcluir: TBitBtn;
    Btn_LimparEditar: TBitBtn;
    Btn_CancelarEditar: TBitBtn;
    lbl_Editar: TLabel;
    CBox_Editar: TComboBox;
    procedure Btn_VoltarClick(Sender: TObject);
    procedure PControl_FornecedoresChange(Sender: TObject);
    procedure Btn_CancelarClick(Sender: TObject);
    procedure ElementosEnable(enable:boolean);
    procedure Btn_NovoClick(Sender: TObject);
    procedure Btn_CadastrarClick(Sender: TObject);
    procedure Btn_LimparEditarClick(Sender: TObject);
    procedure Setgrid;
    procedure EscreveGrid;
    procedure MostrarElementos(visible:boolean);
    procedure Btn_LimparClick(Sender: TObject);
    procedure CBox_EditarChange(Sender: TObject);
    procedure LerInformacoes(var forn : fornecedor);
    procedure LimparFornecedores(nome,razao,inscricao,email,endereco,focus:TLabeledEdit;cnpj,telefone:TMaskEdit);
    procedure StrGrid_FornecedoresDblClick(Sender: TObject);
    procedure Btn_editarExcluirClick(Sender: TObject);
    procedure LerDadosFornecedores(var forn:fornecedor);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Fornecedores : TFrm_Fornecedores;
  linha : integer;

implementation

{$R *.dfm}

uses Unit_Cadastro, Unit_Principal;

procedure TFrm_Fornecedores.Btn_CadastrarClick(Sender: TObject);
begin
  //AbreArquivoGravacao;
  LerInformacoes(forn);
  //GravaFornecedor(forn);
  GravaFornecedorVetor(forn);
  EditaNoArquivo;
  Btn_Novo.Enabled := true;
  EScreveGrid;
  LimparFornecedores(Edt_Nome,Edt_Razao,Edt_Inscricao,Edt_email,Edt_Endereco,Edt_codigo,Mask_CNPJ,Mask_Telefone);
  ElementosEnable(false);
  Application.MessageBox('Fornecedor Gravado com Sucesso','Fornecedor',MB_ICONINFORMATION+MB_OK);
  //CloseFile(Arquivo);
end;

procedure TFrm_Fornecedores.Btn_CancelarClick(Sender: TObject);
begin
  if Application.MessageBox('Você deseja mesmo sair?','Aviso',MB_ICONEXCLAMATION+MB_YESNO) = IDYes
    then begin
           Frm_Cadastro := TFrm_Cadastro.Create(Frm_Principal.pnl_main);
           Frm_Cadastro.Parent := Frm_Principal.pnl_main;
           Frm_Fornecedores.Destroy;
           Frm_Principal.lbl_caminho.Caption := 'Menu/Cadastro e Gestão de Dados'
         end;
end;

procedure TFrm_Fornecedores.Btn_editarExcluirClick(Sender: TObject);
begin
  if CBox_Editar.Text = 'Editar'
   then begin
           if Application.MessageBox('Você deseja mesmo editar este fornecedor','Aviso',MB_ICONWARNING+mb_YesNo)=IDYes
             then begin
                    LerDadosFornecedores(forn);
                    EditarFornecedor(linha,forn);
                    EditaNoArquivo;
                    Application.MessageBox('Fornecedor editado com sucesso!','Editado',MB_ICONINFORMATION+mb_OK);
                    EscreveGrid;
                    MostrarElementos(false);
                  end;
        end
   else begin
          if Application.MessageBox('Você deseja mesmo excluir este fornecedor?','Aviso',MB_ICONERROR+MB_yesno)=IDYEs
            then begin
                   ExcluiFornecedor(linha);
                   EscreveGrid;
                   Application.MessageBox('Fornecedor excluído com sucesso','Exclusão',MB_ICONINFORMATION+Mb_OK);
                 end;
        end;
end;

procedure TFrm_Fornecedores.Btn_LimparEditarClick(Sender: TObject);
begin
  if Application.MessageBox('Você deseja mesmo apagar todos os campos?','Aviso',MB_YESNO+MB_ICONWARNING)= IDYes
  then begin
       LimparFornecedores(Edt_NomeEditar,Edt_RazaoEditar,Edt_InscricaoEditar,Edt_emailEditar,Edt_EnderecoEditar,Edt_codigoEditar,Mask_CNPJEditar,Mask_TelefoneEditar);
       Edt_codigoEditar.Clear;
       end;
end;

procedure TFrm_Fornecedores.Btn_NovoClick(Sender: TObject);
begin
  ElementosEnable(true);
  Edt_Nome.SetFocus;
  Btn_Novo.Enabled := false;
  edt_Codigo.Text := GeraCodigoFornecedores;
end;

procedure TFrm_Fornecedores.Btn_VoltarClick(Sender: TObject);
begin
  Frm_Cadastro := TFrm_Cadastro.Create(Frm_Principal.pnl_main);
  Frm_Cadastro.Parent := Frm_Principal.pnl_main;
  Frm_Fornecedores.Destroy;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Cadastro e Gestão de Dados';
end;

procedure TFrm_Fornecedores.CBox_EditarChange(Sender: TObject);
var
  localizacao : string;
  posi : integer;
begin
  localizacao := ExtractFilePath(Application.ExeName);
  posi := pos('\Win32\Debug',localizacao);
  delete(localizacao,posi,length(localizacao));
  localizacao := localizacao + '\imagens\botao\';
  if CBox_Editar.Text = 'Editar'
    then begin
           Btn_EditarExcluir.Caption := 'Editar';
           Btn_EditarExcluir.Glyph.LoadFromFile(localizacao+'Accept.bmp');
           Edt_CodigoEditar.Enabled := true;
           Btn_EditarExcluir.Enabled := true;
           MostrarElementos(true);
           Edt_CodigoEditar.SetFocus;
         end
    else begin
           Btn_EditarExcluir.Caption := 'Excluir';
           Btn_EditarExcluir.Glyph.LoadFromFile(localizacao+'Delete.bmp');
           Edt_Codigoeditar.Enabled := true;
           MostrarElementos(false);
           Btn_EditarExcluir.Enabled := true;
           Edt_CodigoEditar.SetFocus;
         end;
end;

procedure TFrm_Fornecedores.PControl_FornecedoresChange(Sender: TObject);
var
  aba : integer;
begin
  aba := PControl_Fornecedores.ActivePageIndex;
  if aba = 0
    then begin
           Frm_Principal.lbl_caminho.Caption := 'Menu/Cadastro e Gestão de Dados/Fornecedores/Cadastrar Fornecedores';
           ElementosEnable(false);
           Btn_Novo.Enabled := true;
         end
    else if aba = 1
         then Frm_Principal.lbl_caminho.Caption := 'Menu/Cadastro e Gestão de Dados/Fornecedores/Mostrar Fornecedores'
         else if aba = 2
                then begin
                       Application.MessageBox('Escolha primeiro um Fornecedor','Aviso',MB_ICONERROR+mb_OK);
                       PControl_Fornecedores.TabIndex := 1;
                     end;
end;

procedure TFrm_Fornecedores.ElementosEnable(enable:boolean);
begin
  Edt_Codigo.Enabled := enable;
  Edt_Nome.Enabled := enable;
  Edt_Razao.Enabled := enable;
  Edt_Inscricao.Enabled := enable;
  lbl_cnpj.Enabled := enable;
  Mask_cnpj.Enabled := enable;
  Edt_email.Enabled := enable;
  Edt_Endereco.Enabled := enable;
  Lbl_Telefone.Enabled := enable;
  Mask_Telefone.Enabled := enable;
  Btn_Cadastrar.Enabled := enable;
  Btn_Limpar.Enabled := enable;
end;

procedure Tfrm_Fornecedores.Setgrid;
begin
  StrGrid_Fornecedores.ColWidths[0] := 100;
  StrGrid_Fornecedores.Cells[0,0] := 'Código';
  StrGrid_Fornecedores.ColWidths[1] := 150;
  StrGrid_Fornecedores.Cells[1,0] := 'Nome Fantasia';
  StrGrid_Fornecedores.ColWidths[2] := 150;
  StrGrid_Fornecedores.Cells[2,0] := 'Razão Social';
  StrGrid_Fornecedores.ColWidths[3] := 150;
  StrGrid_Fornecedores.Cells[3,0] := 'Inscrição Social';
  StrGrid_Fornecedores.ColWidths[4] := 150;
  Strgrid_Fornecedores.Cells[4,0] := 'CNPJ';
  StrGrid_Fornecedores.ColWidths[5] := 220;
  StrGrid_Fornecedores.Cells[5,0] := 'Endereço';
  StrGrid_Fornecedores.ColWidths[6] := 150;
  StrGrid_Fornecedores.Cells[6,0] := 'Telefone';
  StrGrid_Fornecedores.ColWidths[7] := 150;
  StrGrid_Fornecedores.Cells[7,0] := 'E-mail';
end;

procedure TFrm_Fornecedores.StrGrid_FornecedoresDblClick(Sender: TObject);
var
  str : string;
begin
  linha := StrGrid_Fornecedores.Row;
  str := StrGrid_Fornecedores.Cells[0,linha];
  delete(str,1,3);
  linha := StrToInt(str);
  dec(linha);
  PControl_Fornecedores.ActivePageIndex := 2;
  Edt_CodigoEditar.Text := fornecedores[linha].codigo;
  Edt_NomeEditar.Text := fornecedores[linha].nome;
  Edt_razaoEditar.Text := fornecedores[linha].razao;
  Edt_InscricaoEditar.Text := fornecedores[linha].inscricao;
  Mask_CNPJEditar.Text := fornecedores[linha].cnpj;
  Edt_EmailEditar.Text := fornecedores[linha].email;
  Edt_EnderecoEditar.Text := fornecedores[linha].endereco;
  Mask_TelefoneEditar.Text := fornecedores[linha].telefone;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Cadastro e Gestão de Dados/Fornecedores/Editar-Excluir Fornecedores';
end;

procedure TFrm_Fornecedores.Btn_LimparClick(Sender: TObject);
begin
  if Application.MessageBox('Você deseja mesmo apagar todos os campos?','Aviso',MB_YESNO+MB_ICONWARNING)= IDYes
  then LimparFornecedores(Edt_Nome,Edt_Razao,Edt_Inscricao,Edt_email,Edt_Endereco,Edt_Nome,Mask_CNPJ,Mask_Telefone);
end;

procedure Tfrm_Fornecedores.MostrarElementos(visible:boolean);
begin
  Edt_nomeEditar.Visible := visible;
  Edt_RazaoEditar.Visible := visible;
  Edt_InscricaoEditar.Visible := visible;
  Lbl_cnpjEditar.Visible := visible;
  Mask_cnpjEditar.Visible := visible;
  Edt_emailEditar.Visible := visible;
  Edt_enderecoEditar.Visible := visible;
  lbl_telefoneeditar.Visible := visible;
  Mask_TelefoneEditar.Visible := visible;
  Btn_LimparEditar.Visible := visible;
end;

procedure Tfrm_Fornecedores.LimparFornecedores(nome,razao,inscricao,email,endereco,focus:TLabeledEdit;cnpj,telefone:TMaskEdit);
begin
  nome.Clear;
  razao.Clear;
  inscricao.Clear;
  email.Clear;
  endereco.Clear;
  cnpj.Clear;
  telefone.Clear;
  focus.SetFocus;
end;

procedure Tfrm_Fornecedores.LerInformacoes(var forn : fornecedor);
begin
  forn.codigo := Edt_Codigo.Text;
  forn.nome := Edt_Nome.Text;
  forn.razao := Edt_razao.Text;
  forn.inscricao := Edt_Inscricao.Text;
  forn.cnpj := Mask_CNPJ.Text;
  forn.email := Edt_Email.Text;
  forn.endereco := Edt_Endereco.Text;
  forn.telefone := Mask_Telefone.Text;
end;

procedure Tfrm_Fornecedores.EscreveGrid;
var
  i : integer;
begin
  StrGrid_Fornecedores.RowCount := 1;
  for i := 0 to length(fornecedores)-1 do
    begin
      if fornecedores[i].ativo = false
        then begin
               StrGrid_Fornecedores.RowCount := StrGrid_Fornecedores.RowCount + 1;
               StrGrid_Fornecedores.Cells[0,StrGrid_Fornecedores.RowCount-1] := fornecedores[i].codigo;
               StrGrid_Fornecedores.Cells[1,StrGrid_Fornecedores.RowCount-1] := fornecedores[i].nome;
               StrGrid_Fornecedores.Cells[2,StrGrid_Fornecedores.RowCount-1] := fornecedores[i].razao;
               StrGrid_Fornecedores.Cells[3,StrGrid_Fornecedores.RowCount-1] := fornecedores[i].inscricao;
               StrGrid_Fornecedores.Cells[4,StrGrid_Fornecedores.RowCount-1] := fornecedores[i].cnpj;
               StrGrid_Fornecedores.Cells[5,StrGrid_Fornecedores.RowCount-1] := fornecedores[i].email;
               StrGrid_Fornecedores.Cells[6,StrGrid_Fornecedores.RowCount-1] := fornecedores[i].endereco;
               StrGrid_Fornecedores.Cells[7,StrGrid_Fornecedores.RowCount-1] := fornecedores[i].telefone;
             end;
    end;
end;

procedure TFrm_fornecedores.LerDadosFornecedores(var forn:fornecedor);
begin
  forn.codigo := Edt_CodigoEditar.Text;
  forn.nome := Edt_NomeEditar.Text;
  forn.razao := Edt_RazaoEditar.Text;
  forn.inscricao := Edt_InscricaoEditar.Text;
  forn.cnpj := Mask_CNPJEditar.Text;
  forn.email := Edt_EmailEditar.Text;
  forn.endereco := Edt_EnderecoEditar.Text;
  forn.telefone := Mask_TelefoneEditar.Text;
end;

end.
