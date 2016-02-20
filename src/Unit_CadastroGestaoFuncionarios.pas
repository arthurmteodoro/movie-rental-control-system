unit Unit_CadastroGestaoFuncionarios;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Mask, Vcl.Grids, Unit_Biblioteca;

type
  TFrm_Funcionarios = class(TFrame)
    Pnl_TituloFincionario: TPanel;
    Btn_Voltar: TBitBtn;
    PControl_Funcionarios: TPageControl;
    Cadastro: TTabSheet;
    Mostrar: TTabSheet;
    EditarExcluir: TTabSheet;
    Edt_Codigo: TLabeledEdit;
    Edt_nome: TLabeledEdit;
    Edt_cargo: TLabeledEdit;
    Edt_email: TLabeledEdit;
    Mask_Telefone: TMaskEdit;
    Edt_endereco: TLabeledEdit;
    Lbl_Telefone: TLabel;
    Btn_Novo: TBitBtn;
    btn_Cadastrar: TBitBtn;
    Btn_Limpar: TBitBtn;
    Btn_Cancelar: TBitBtn;
    StrGrid_Funcionarios: TStringGrid;
    Edt_CodigoNovo: TLabeledEdit;
    Edt_NomeEditar: TLabeledEdit;
    Edt_EmailEditar: TLabeledEdit;
    Edt_CargoEditar: TLabeledEdit;
    Edt_EnderecoEditar: TLabeledEdit;
    Mask_TelefoneEditar: TMaskEdit;
    Lbl_TelefoneEditar: TLabel;
    Btn_EditarExcluir: TBitBtn;
    Btn_LimparEditar: TBitBtn;
    Btn_CancelarEditar: TBitBtn;
    CBox_EditarExcluir: TComboBox;
    Lbl_Editar: TLabel;
    procedure PControl_FuncionariosChange(Sender: TObject);
    procedure Btn_VoltarClick(Sender: TObject);
    procedure IniciaElementos(habilita : boolean);
    procedure Btn_NovoClick(Sender: TObject);
    procedure Seta_grid;
    procedure CBox_EditarExcluirChange(Sender: TObject);
    procedure Elementos(habilita:boolean);
    procedure Btn_CancelarClick(Sender: TObject);
    procedure btn_CadastrarClick(Sender: TObject);
    procedure Btn_LimparClick(Sender: TObject);
    procedure Btn_LimparEditarClick(Sender: TObject);
    procedure LerElementos(var func : funcionario);
    procedure EscreveGrid;
    procedure LimparFuncionario(nome,cargo,email,endereco,focus:TLabeledEdit; telefone:TMaskEdit);
    procedure StrGrid_FuncionariosDblClick(Sender: TObject);
    procedure LerEditarFuncionario(var func:funcionario);
    procedure Btn_EditarExcluirClick(Sender: TObject);
    procedure Btn_CancelarEditarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Funcionarios : TFrm_Funcionarios;
  linha : integer;

implementation

{$R *.dfm}

uses Unit_Principal, Unit_Cadastro, Unit_CadastroGestaoCategoria;

procedure TFrm_Funcionarios.btn_CadastrarClick(Sender: TObject);
begin
  //AbreArquivoGravacao;
  LerElementos(func);
  //GravaFuncionario(func);
  GravaFuncionarioVetor(func);
  EditaNoArquivo;
  EscreveGrid;
  LimparFuncionario(Edt_nome,Edt_Cargo,Edt_Email,Edt_Email,Edt_Nome,Mask_Telefone);
  IniciaElementos(false);
  Btn_Novo.Enabled := true;
  Application.MessageBox('Funcionário Cadastrado com sucesso','Funcionário',MB_ICONINFORMATION+mb_ok);
  //CloseFile(Arquivo);
end;

procedure TFrm_Funcionarios.Btn_CancelarClick(Sender: TObject);
begin
  if Application.MessageBox('Você deseja mesmo sair?','Aviso',MB_ICONEXCLAMATION+MB_YESNO) = IDYes
    then begin
           Frm_Cadastro := TFrm_Cadastro.Create(Frm_Principal.pnl_main);
           Frm_Cadastro.Parent := Frm_Principal.pnl_main;
           Frm_Principal.lbl_caminho.Caption := 'Menu/Cadastro e Gestão de Dados';
           Frm_Funcionarios.Destroy;
         end;
end;

procedure TFrm_Funcionarios.Btn_CancelarEditarClick(Sender: TObject);
begin
  if Application.MessageBox('Você deseja mesmo sair?','Aviso',MB_ICONEXCLAMATION+MB_YESNO) = IDYes
    then begin
           Frm_Cadastro := TFrm_Cadastro.Create(Frm_Principal.pnl_main);
           Frm_Cadastro.Parent := Frm_Principal.pnl_main;
           Frm_Principal.lbl_caminho.Caption := 'Menu/Cadastro e Gestão de Dados';
           Frm_Funcionarios.Destroy;
         end;
end;

procedure TFrm_Funcionarios.Btn_EditarExcluirClick(Sender: TObject);
begin
  if CBox_EditarExcluir.Text = 'Editar'
   then begin
          if Application.MessageBox('Você deseja mesmo editar este funcionário','Aviso',MB_ICONWARNING+mb_YesNo)=IDYes
            then begin
                   LerEditarFuncionario(func);
                   EditarFuncionario(linha,func);
                   EditaNoArquivo;
                   Application.MessageBox('Funcionário editado com sucesso!','Editado',MB_ICONINFORMATION+mb_OK);
                   EscreveGrid;
                  end;
        end
   else begin
          if Application.MessageBox('Você deseja mesmo excluir este funcionário?','Exclusão',MB_ICONERROR+mb_YesNo)=IDYes
            then begin
                   ExcluiFuncionario(linha);
                   EditaNoArquivo;
                   EscreveGrid;
                   Application.MessageBox('Funcionário excluído com sucesso','Exclusão',MB_ICONINFORMATION+MB_OK);
                 end;
        end;
end;

procedure TFrm_Funcionarios.Btn_LimparClick(Sender: TObject);
begin
  if Application.MessageBox('Você deseja mesmo apagar todos os campos?','Aviso',MB_YESNO+MB_ICONWARNING)= IDYes
  then begin
         LimparFuncionario(Edt_nome,Edt_Cargo,Edt_Email,Edt_Email,Edt_Nome,Mask_Telefone);
         Edt_Nome.SetFocus;
       end;
end;

procedure TFrm_Funcionarios.Btn_LimparEditarClick(Sender: TObject);
begin
  if Application.MessageBox('Você deseja mesmo apagar todos os campos?','Aviso',MB_YESNO+MB_ICONWARNING)= IDYes
    then begin
           Edt_CodigoNovo.Clear;
           LimparFuncionario(Edt_NomeEditar,Edt_CargoEditar,Edt_EmailEditar,Edt_EnderecoEditar,Edt_CodigoNovo,Mask_TelefoneEditar);
         end;
end;

procedure TFrm_Funcionarios.Btn_NovoClick(Sender: TObject);
begin
  IniciaElementos(true);
  Edt_Nome.SetFocus;
  Btn_Novo.Enabled := false;
  edt_Codigo.Text := GeraCodigoFuncionario;
end;

procedure TFrm_Funcionarios.Btn_VoltarClick(Sender: TObject);
begin
  Frm_Cadastro := TFrm_Cadastro.Create(Frm_Principal.pnl_main);
  Frm_Cadastro.Parent := Frm_Principal.pnl_main;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Cadastro e Gestão de Dados';
  Frm_Funcionarios.Destroy;
end;

procedure TFrm_Funcionarios.CBox_EditarExcluirChange(Sender: TObject);
var
  localizacao : string;
  posi : integer;
begin
  localizacao := ExtractFilePath(Application.ExeName);
  posi := pos('\Win32\Debug',localizacao);
  delete(localizacao,posi,length(localizacao));
  localizacao := localizacao + '\imagens\botao\';
  if CBox_EditarExcluir.Text = 'Editar'
    then begin
           Btn_EditarExcluir.Caption := 'Editar';
           Btn_EditarExcluir.Glyph.LoadFromFile(localizacao+'Accept.bmp');
           Edt_CodigoNovo.Enabled := true;
           Btn_EditarExcluir.Enabled := true;
           Elementos(true);
           Edt_CodigoNovo.SetFocus;
         end
    else begin
           Btn_EditarExcluir.Caption := 'Excluir';
           Btn_EditarExcluir.Glyph.LoadFromFile(localizacao+'Delete.bmp');
           Edt_CodigoNovo.Enabled := true;
           Elementos(false);
           Btn_EditarExcluir.Enabled := true;
           Edt_Codigonovo.SetFocus;
         end;
end;

procedure TFrm_Funcionarios.PControl_FuncionariosChange(Sender: TObject);
var
  aba : integer;
begin
  aba := PControl_Funcionarios.ActivePageIndex;
  if aba = 0
    then begin
           Frm_Principal.lbl_caminho.Caption := 'Menu/Cadastro e Gestão de Dados/Funcionários/Cadastrar Funcionários';
           IniciaElementos(false);
           Btn_Novo.Enabled := true;
         end
    else if aba = 1
         then Frm_Principal.lbl_caminho.Caption := 'Menu/Cadastro e Gestão de Dados/Funcionários/Mostrar Funcionários'
         else if aba = 2
                then begin
                       Application.MessageBox('Escolha primeiro um Funcionário','Aviso',MB_ICONERROR+mb_OK);
                       PControl_Funcionarios.TabIndex := 1;
                     end;
end;

procedure Tfrm_Funcionarios.IniciaElementos(habilita : boolean);
begin
  Edt_Codigo.Enabled := habilita;
  Edt_nome.Enabled := habilita;
  Edt_Cargo.Enabled := habilita;
  Edt_email.Enabled := habilita;
  Edt_Endereco.Enabled := habilita;
  Lbl_Telefone.Enabled := habilita;
  Mask_Telefone.Enabled := habilita;
  Btn_Cadastrar.Enabled := habilita;
  Btn_Limpar.Enabled := habilita;
end;

procedure TFrm_Funcionarios.Seta_grid;
begin
  StrGrid_Funcionarios.ColWidths[0] := 100;
  StrGrid_Funcionarios.Cells[0,0] := 'Código';
  StrGrid_Funcionarios.ColWidths[1] := 150;
  StrGrid_Funcionarios.Cells[1,0] := 'Nome';
  StrGrid_Funcionarios.ColWidths[2] := 100;
  StrGrid_Funcionarios.Cells[2,0] := 'Cargo';
  StrGrid_Funcionarios.ColWidths[3] := 200;
  StrGrid_Funcionarios.Cells[3,0] := 'E-Mail';
  StrGrid_Funcionarios.ColWidths[4] := 200;
  StrGrid_Funcionarios.Cells[4,0] := 'Endereço';
  StrGrid_Funcionarios.ColWidths[5] := 150;
  StrGrid_Funcionarios.Cells[5,0] := 'Telefone';
end;

procedure TFrm_Funcionarios.StrGrid_FuncionariosDblClick(Sender: TObject);
var
  str : string;
begin
  linha := StrGrid_Funcionarios.Row;
  str := StrGrid_Funcionarios.Cells[0,linha];
  delete(str,1,3);
  linha := StrToInt(str);
  dec(linha);
  PControl_Funcionarios.ActivePageIndex := 2;
  Edt_CodigoNovo.Text := funcionarios[linha].codigo;
  Edt_NomeEditar.Text := funcionarios[linha].nome;
  Edt_CargoEditar.Text := funcionarios[linha].cargo;
  Edt_EmailEditar.Text := funcionarios[linha].email;
  Edt_enderecoEditar.Text := funcionarios[linha].endereco;
  Mask_TelefoneEditar.Text := funcionarios[linha].telefone;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Cadastro e Gestão de Dados/Funcionários/Editar-Excluir Funcionários';
end;

procedure TFrm_Funcionarios.Elementos(habilita:boolean);
begin
  Edt_NomeEditar.Visible := habilita;
  Edt_CargoEditar.Visible := habilita;
  Edt_EmailEditar.Visible := habilita;
  Edt_EnderecoEditar.Visible := habilita;
  Lbl_TelefoneEditar.Visible := habilita;
  Mask_TelefoneEditar.Visible := habilita;
  Btn_LimparEditar.Visible := habilita;
end;

procedure TFrm_Funcionarios.LimparFuncionario(nome,cargo,email,endereco,focus:TLabeledEdit; telefone:TMaskEdit);
begin
  nome.Clear;
  cargo.Clear;
  email.Clear;
  endereco.Clear;
  telefone.Clear;
  focus.SetFocus;
end;

procedure Tfrm_Funcionarios.LerElementos(var func : funcionario);
begin
  func.codigo := Edt_Codigo.Text;
  func.nome := Edt_nome.Text;
  func.cargo := Edt_cargo.Text;
  func.email := Edt_Email.Text;
  func.endereco := Edt_endereco.Text;
  func.telefone := Mask_telefone.Text;
end;

procedure Tfrm_funcionarios.EscreveGrid;
var
  i : integer;
begin
  Strgrid_funcionarios.RowCount := 1;
  for i := 0 to length(funcionarios)-1 do
    begin
      if funcionarios[i].ativo = false
        then begin
               Strgrid_funcionarios.RowCount := Strgrid_funcionarios.RowCount + 1;
               StrGrid_funcionarios.Cells[0,Strgrid_funcionarios.RowCount-1] := Funcionarios[i].codigo;
               StrGrid_funcionarios.Cells[1,Strgrid_funcionarios.RowCount-1] := Funcionarios[i].nome;
               StrGrid_funcionarios.Cells[2,Strgrid_funcionarios.RowCount-1] := Funcionarios[i].cargo;
               StrGrid_funcionarios.Cells[3,Strgrid_funcionarios.RowCount-1] := Funcionarios[i].email;
               StrGrid_funcionarios.Cells[4,Strgrid_funcionarios.RowCount-1] := Funcionarios[i].endereco;
               StrGrid_funcionarios.Cells[5,Strgrid_funcionarios.RowCount-1] := Funcionarios[i].telefone;
             end;
    end;
end;

procedure Tfrm_Funcionarios.LerEditarFuncionario(var func:funcionario);
begin
  func.codigo := Edt_CodigoNovo.Text;
  func.nome := Edt_NomeEditar.Text;
  func.cargo := Edt_CargoEditar.Text;
  func.email := Edt_EmailEditar.Text;
  func.endereco := Edt_EnderecoEditar.Text;
  func.telefone := Mask_TelefoneEditar.Text;
end;

end.
