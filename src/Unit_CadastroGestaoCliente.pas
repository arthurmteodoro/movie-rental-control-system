unit Unit_CadastroGestaoCliente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls, Vcl.Mask, Unit_Biblioteca;

type
  TFrm_Cliente = class(TFrame)
    Pnl_TitleCliente: TPanel;
    Btn_Voltar: TBitBtn;
    Page_Cliente: TPageControl;
    Cadastrar: TTabSheet;
    Mostrar: TTabSheet;
    Editar_Excluir: TTabSheet;
    StrGrid_Clientes: TStringGrid;
    Edt_codigo: TLabeledEdit;
    Edt_Nome: TLabeledEdit;
    Edt_Endereco: TLabeledEdit;
    Mask_CPF: TMaskEdit;
    Mask_Telefone: TMaskEdit;
    Edt_email: TLabeledEdit;
    CBox_Sexo: TComboBox;
    CBox_EstadoCivil: TComboBox;
    Mask_Data: TMaskEdit;
    lbl_CPF: TLabel;
    lbl_Telefone: TLabel;
    lbl_sexo: TLabel;
    lbl_EstadoCivil: TLabel;
    lbl_Data: TLabel;
    Btn_Cadastrar: TBitBtn;
    Btn_Cancelar: TBitBtn;
    Btn_Limpar: TBitBtn;
    Mask_CPFEditar: TMaskEdit;
    Edt_EnderecoEditar: TLabeledEdit;
    Mask_TelefoneEditar: TMaskEdit;
    Lbl_TelefoneEditar: TLabel;
    Edt_NomeEditar: TLabeledEdit;
    Edt_EmailEditar: TLabeledEdit;
    CBox_SexoEditar: TComboBox;
    lbl_SexoEditar: TLabel;
    CBox_EstadoEditar: TComboBox;
    lbl_estadoEditar: TLabel;
    Mask_DataNascimento: TMaskEdit;
    lbl_DataEditar: TLabel;
    lbl_CPFEditar: TLabel;
    CBox_EditarExcluir: TComboBox;
    lbl_EditarExcluir: TLabel;
    Btn_EditarExcluir: TBitBtn;
    btn_LimparEditar: TBitBtn;
    Btn_SairEditar: TBitBtn;
    Edt_CodigoEditar: TLabeledEdit;
    Btn_Novo: TBitBtn;
    procedure Btn_VoltarClick(Sender: TObject);
    procedure SetaGrid;
    procedure Btn_LimparClick(Sender: TObject);
    procedure Btn_CancelarClick(Sender: TObject);
    procedure CBox_EditarExcluirChange(Sender: TObject);
    procedure MostrarPaineis(habilita:boolean);
    procedure Page_ClienteChange(Sender: TObject);
    procedure Btn_NovoClick(Sender: TObject);
    procedure IniciaElementos(enable : boolean);
    procedure Btn_CadastrarClick(Sender: TObject);
    procedure btn_LimparEditarClick(Sender: TObject);
    procedure EscreveGrid;
    procedure LerInformacoes(var cli : cliente);
    procedure LimparCliente(nome,endereco,email,focus:TLabeledEdit;cpf,telefone,data:TMaskEdit;sexo,estado:TComboBox);
    procedure StrGrid_ClientesDblClick(Sender: TObject);
    procedure LerEditar(var cli : cliente);
    procedure Btn_EditarExcluirClick(Sender: TObject);
    procedure EscreveEditar;
    procedure Btn_SairEditarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Cliente : TFrm_Cliente;
  codigo,nome,endereco,cpf,telefone,email,sexo,estado,nascimento : string;
  linha : integer;

implementation

{$R *.dfm}

uses Unit_Cadastro, Unit_Principal, Unit_CadastroGestaoLocadora;

procedure TFrm_Cliente.Btn_CadastrarClick(Sender: TObject);
begin
  //AbreArquivoGravacao;
  //le as informaçoes dos edts
  LerInformacoes(cli);
  //grava o cliente no arquivo
  //GravaCliente(cli);
  //escreve no vetor
  GravaClienteVetor(cli);
  //limpa os campos
  EditaNoArquivo;
  LimparCliente(Edt_nome,Edt_Endereco,Edt_Email,Edt_nome,Mask_CPF,MAsk_Telefone,Mask_Data,CBox_Sexo,Cbox_EstadoCivil);
  //desabilita os componentes
  IniciaElementos(false);
  //habilita o botao de novo
  Btn_Novo.Enabled := true;
  //escreve o grid
  EscreveGrid;
  Application.MessageBox('Cliente Cadastrado com sucesso','Cliente',MB_ICONINFORMATION+mb_ok);
  //CloseFile(Arquivo);
end;

procedure TFrm_Cliente.Btn_CancelarClick(Sender: TObject);
begin
  if Application.MessageBox('Você deseja mesmo sair?','Aviso',MB_ICONEXCLAMATION+MB_YESNO) = IDYes
    then begin
           Frm_Cadastro := TFrm_Cadastro.Create(Frm_Principal.pnl_main);
           Frm_Cadastro.Parent := Frm_Principal.pnl_main;
           Frm_Cliente.Destroy;
           Frm_Principal.lbl_caminho.Caption := 'Menu/Cadastro e Gestão de Dados';
         end;
end;

procedure TFrm_Cliente.Btn_EditarExcluirClick(Sender: TObject);
begin
  if CBox_editarExcluir.Text = 'Editar'
    then begin
           LerEditar(cli);
           EditaVetorCliente(linha,cli);
           EditaNoArquivo;
           Application.MessageBox('Cliente Editado com Sucesso!','Cliente',MB_ICONINFORMATION+mb_ok);
           EscreveGrid;
         end
    else if CBox_EditarExcluir.Text = 'Excluir'
           then begin
                  if Application.MessageBox('Você deseja mesmo excluir este cliente?','Excluir',MB_ICONSTOP+mb_YesNO)=IdYes
                    then begin
                           ExcluiCliente(linha);
                           EscreveGrid;
                         end;
                end;
end;

procedure TFrm_Cliente.Btn_LimparClick(Sender: TObject);
begin
  if Application.MessageBox('Você deseja mesmo apagar todos os campos?','Aviso',MB_YESNO+MB_ICONWARNING)= IDYes
    then begin
           LimparCliente(Edt_nome,Edt_Endereco,Edt_Email,Edt_nome,Mask_CPF,MAsk_Telefone,Mask_Data,CBox_Sexo,Cbox_EstadoCivil);
           Edt_nome.Enabled := true;
         end;
end;

procedure TFrm_Cliente.btn_LimparEditarClick(Sender: TObject);
begin
  if Application.MessageBox('Você deseja mesmo apagar todos os campos?','Aviso',MB_YESNO+MB_ICONWARNING)= IDYes
    then begin
           Edt_CodigoEditar.Clear;
           LimparCliente(Edt_nomeEditar,Edt_EnderecoEditar,Edt_EmailEditar,Edt_CodigoEditar,Mask_CPFEditar,MAsk_TelefoneEditar,Mask_DataNAscimento,CBox_SexoEditar,Cbox_EstadoEditar);
         end;
end;

procedure TFrm_Cliente.Btn_NovoClick(Sender: TObject);
begin
  IniciaElementos(true);
  Edt_Nome.SetFocus;
  Btn_Novo.Enabled := false;
  Edt_codigo.Text := GeraCodigoCliente;
end;

procedure TFrm_Cliente.Btn_SairEditarClick(Sender: TObject);
begin
  if Application.MessageBox('Você deseja mesmo sair?','Aviso',MB_ICONEXCLAMATION+MB_YESNO) = IDYes
    then begin
           Frm_Cadastro := TFrm_Cadastro.Create(Frm_Principal.pnl_main);
           Frm_Cadastro.Parent := Frm_Principal.pnl_main;
           Frm_Cliente.Destroy;
           Frm_Principal.lbl_caminho.Caption := 'Menu/Cadastro e Gestão de Dados';
         end;
end;

procedure Tfrm_Cliente.IniciaElementos(enable : boolean);
begin
  Edt_Codigo.Enabled := enable;
  Edt_Nome.Enabled := enable;
  Edt_Endereco.Enabled := enable;
  Lbl_CPF.Enabled := enable;
  Mask_CPF.Enabled := enable;
  lbl_Telefone.Enabled := enable;
  Mask_Telefone.Enabled := enable;
  Edt_Email.Enabled := enable;
  Lbl_Sexo.Enabled := enable;
  CBox_Sexo.Enabled := enable;
  Lbl_EstadoCivil.Enabled := enable;
  CBox_EstadoCivil.Enabled := enable;
  Lbl_Data.Enabled := enable;
  Mask_Data.Enabled := enable;
  Btn_Cadastrar.Enabled := enable;
  Btn_Limpar.Enabled := enable;
end;

procedure TFrm_Cliente.Btn_VoltarClick(Sender: TObject);
begin
  Frm_Cadastro := TFrm_Cadastro.Create(Frm_Principal.pnl_main);
  Frm_Cadastro.Parent := Frm_Principal.pnl_main;
  Frm_Cliente.Destroy;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Cadastro e Gestão de Dados';
end;

procedure TFrm_Cliente.CBox_EditarExcluirChange(Sender: TObject);
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
           Edt_CodigoEditar.Enabled := true;
           MostrarPaineis(true);
           Edt_NomeEditar.SetFocus;
           EscreveEditar;
         end
    else begin
           Btn_EditarExcluir.Caption := 'Excluir';
           Btn_EditarExcluir.Glyph.LoadFromFile(localizacao+'Delete.bmp');
           Edt_CodigoEditar.Enabled := true;
           MostrarPaineis(false);
           Btn_EditarExcluir.Enabled := true;
           Edt_CodigoEditar.SetFocus;
         end;
end;

procedure Tfrm_Cliente.LimparCliente(nome,endereco,email,focus:TLabeledEdit;cpf,telefone,data:TMaskEdit;sexo,estado:TComboBox);
begin
  nome.Clear;
  endereco.Clear;
  email.Clear;
  focus.SetFocus;
  cpf.Clear;
  telefone.Clear;
  data.Clear;
  Sexo.Text := '';
  estado.text := '';
end;

procedure TFrm_Cliente.SetaGrid;
begin
  StrGrid_Clientes.ColWidths[0] := 60;
  StrGrid_Clientes.Cells[0,0] := 'Código';
  StrGrid_Clientes.ColWidths[1] := 100;
  StrGrid_Clientes.Cells[1,0] := 'Nome';
  StrGrid_Clientes.ColWidths[2] := 180;
  StrGrid_Clientes.Cells[2,0] := 'Endereço';
  StrGrid_Clientes.ColWidths[3] := 100;
  StrGrid_Clientes.Cells[3,0] := 'CPF';
  StrGrid_Clientes.ColWidths[4] := 100;
  StrGrid_Clientes.Cells[4,0] := 'Telefone';
  StrGrid_Clientes.ColWidths[5] := 180;
  StrGrid_Clientes.Cells[5,0] := 'E-mail';
  StrGrid_Clientes.ColWidths[6] := 70;
  StrGrid_Clientes.Cells[6,0] := 'Sexo';
  StrGrid_Clientes.ColWidths[7] := 120;
  StrGrid_Clientes.Cells[7,0] := 'Estado Civil';
  StrGrid_Clientes.ColWidths[8] := 100;
  StrGrid_Clientes.Cells[8,0] := 'Data Nascimento';
end;

procedure TFrm_Cliente.StrGrid_ClientesDblClick(Sender: TObject);
var
  str : string;
begin
  linha := StrGrid_Clientes.Row;
  str := StrGrid_Clientes.Cells[0,linha];
  delete(str,1,1);
  linha := StrToInt(str);
  dec(linha);
  Page_Cliente.ActivePageIndex := 2;
  Edt_codigoEditar.Enabled := true;
  Edt_CodigoEditar.Text := Clientes[linha].codigo;
  Edt_CodigoEditar.Enabled := false;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Cadastro e Gestão de Dados/Cliente/Editar-Excluir Cliente'
end;

procedure TFrm_Cliente.MostrarPaineis(habilita:boolean);
begin
  Edt_EnderecoEditar.Visible := habilita;
  Edt_NomeEditar.Visible := habilita;
  Lbl_TelefoneEditar.Visible := habilita;
  Mask_TelefoneEditar.Visible := habilita;
  Lbl_CPFEditar.Visible := habilita;
  Mask_CPFEditar.Visible := habilita;
  Lbl_SexoEditar.Visible := habilita;
  CBox_SexoEditar.Visible := habilita;
  Edt_EmailEditar.Visible := habilita;
  Lbl_DataEditar.Visible := habilita;
  Mask_DataNascimento.Visible := habilita;
  Lbl_EstadoEditar.Visible := habilita;
  CBox_EstadoEditar.Visible := habilita;
  Btn_EditarExcluir.Enabled := habilita;
  Btn_LimparEditar.Visible := habilita;
end;


procedure TFrm_Cliente.Page_ClienteChange(Sender: TObject);
var
  aba : integer;
begin
  aba := Page_Cliente.ActivePageIndex;
  if aba = 0
    then begin
           Frm_Principal.lbl_caminho.Caption := 'Menu/Cadastro e Gestão de Dados/Cliente/Cadastrar Cliente';
           IniciaElementos(false);
           Btn_Novo.Enabled := true;
         end
    else if aba = 1
         then Frm_Principal.lbl_caminho.Caption := 'Menu/Cadastro e Gestão de Dados/Cliente/Mostrar Cliente'
         else if aba = 2
                then begin
                       Application.MessageBox('Escolha primeiro um cliente','Aviso',MB_ICONERROR+mb_OK);
                       Page_Cliente.TabIndex := 1;
                     end;
end;

procedure Tfrm_Cliente.LerInformacoes(var cli : cliente);
begin
  cli.codigo := Edt_Codigo.Text;
  cli.nome := Edt_Nome.Text;
  cli.endereco := Edt_Endereco.Text;
  cli.cpf := Mask_CPF.Text;
  cli.telefone := Mask_Telefone.Text;
  cli.email := Edt_Email.Text;
  cli.sexo := CBox_Sexo.Text;
  cli.estado := CBox_EstadoCivil.Text;
  cli.nascimento := Mask_Data.Text;
  cli.ativo := false;
end;

procedure TFrm_Cliente.EscreveGrid;
var
  i : Integer;
begin
  StrGrid_clientes.RowCount := 1;
  for i := 0 to length(clientes)-1 do
    begin
      if clientes[i].ativo = false
        then begin
               StrGrid_Clientes.RowCount := StrGrid_Clientes.RowCount + 1;
               StrGrid_Clientes.Cells[0,StrGrid_Clientes.RowCount-1] := clientes[i].codigo;
               StrGrid_Clientes.Cells[1,StrGrid_Clientes.RowCount-1] := clientes[i].nome;
               StrGrid_Clientes.Cells[2,StrGrid_Clientes.RowCount-1] := clientes[i].endereco;
               StrGrid_Clientes.Cells[3,StrGrid_Clientes.RowCount-1] := clientes[i].cpf;
               StrGrid_Clientes.Cells[4,StrGrid_Clientes.RowCount-1] := clientes[i].telefone;
               StrGrid_Clientes.Cells[5,StrGrid_Clientes.RowCount-1] := clientes[i].email;
               StrGrid_Clientes.Cells[6,StrGrid_Clientes.RowCount-1] := clientes[i].sexo;
               StrGrid_Clientes.Cells[7,StrGrid_Clientes.RowCount-1] := clientes[i].estado;
               StrGrid_Clientes.Cells[8,StrGrid_Clientes.RowCount-1] := clientes[i].nascimento;
             end;
    end;
end;

procedure Tfrm_Cliente.LerEditar(var cli : cliente);
begin
  cli.codigo := Edt_CodigoEditar.Text;
  cli.nome := Edt_NomeEditar.Text;
  cli.endereco := Edt_EnderecoEditar.Text;
  cli.cpf := Mask_CPFEditar.Text;
  cli.telefone := Mask_TelefoneEditar.Text;
  cli.email := Edt_emailEditar.Text;
  cli.sexo := CBox_SexoEditar.Text;
  cli.estado := Cbox_EstadoEditar.Text;
  cli.nascimento := Mask_DataNascimento.Text;
end;

procedure Tfrm_Cliente.EscreveEditar;
begin
  Edt_NomeEditar.Text := Clientes[linha].nome;
  Edt_EnderecoEditar.Text := Clientes[linha].endereco;
  Mask_CPFEditar.Text := Clientes[linha].cpf;
  Mask_TelefoneEditar.Text := Clientes[linha].telefone;
  Edt_emailEditar.Text := Clientes[linha].email;
  CBox_SexoEditar.Text := Clientes[linha].sexo;
  Cbox_EstadoEditar.Text := Clientes[linha].estado;
  Mask_DataNascimento.Text := Clientes[linha].nascimento;
end;

end.
