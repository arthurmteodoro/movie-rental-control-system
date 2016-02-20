unit Unit_CadastroGestaoCategoria;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls, Vcl.Grids, Unit_Biblioteca;

type
  TFrm_Categoria = class(TFrame)
    Pnl_titulo: TPanel;
    Btn_Voltar: TBitBtn;
    Page_Categoria: TPageControl;
    Cadastrar: TTabSheet;
    Mostrar: TTabSheet;
    EditarExcluir: TTabSheet;
    Edt_Codigo: TLabeledEdit;
    Edt_Valor: TLabeledEdit;
    Edt_descricao: TLabeledEdit;
    Btn_Cadastrar: TBitBtn;
    Btn_Limpar: TBitBtn;
    Brn_Cancelar: TBitBtn;
    StrGrid_Categoria: TStringGrid;
    Edt_CodigoEditar: TLabeledEdit;
    Edt_ValorEditar: TLabeledEdit;
    Edt_DescricaoEditar: TLabeledEdit;
    btn_EditarExcluir: TBitBtn;
    Btn_LimparEditar: TBitBtn;
    Btn_CancelarEditar: TBitBtn;
    CBox_EditarExcluir: TComboBox;
    lbl_EditarExcluir: TLabel;
    Btn_Novo: TBitBtn;
    procedure Btn_VoltarClick(Sender: TObject);
    procedure Page_CategoriaChange(Sender: TObject);
    procedure SetaGrid;
    procedure Elementos(habilita : boolean);
    procedure CBox_EditarExcluirChange(Sender: TObject);
    procedure IniciaElementos(enable:boolean);
    procedure Btn_NovoClick(Sender: TObject);
    procedure Brn_CancelarClick(Sender: TObject);
    procedure Btn_CadastrarClick(Sender: TObject);
    procedure Btn_LimparClick(Sender: TObject);
    procedure Btn_LimparEditarClick(Sender: TObject);
    procedure LimparCategoria(valor,descricao, focus : TlabeledEdit);
    procedure LerInformacoes(var cat:categoria);
    procedure EscreveGrid;
    procedure StrGrid_CategoriaDblClick(Sender: TObject);
    procedure btn_EditarExcluirClick(Sender: TObject);
    procedure LerEditar(var cat : categoria);
    procedure Btn_CancelarEditarClick(Sender: TObject);
    procedure Edt_ValorKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Categoria : TFrm_Categoria;
  linha : integer;

implementation

{$R *.dfm}

uses Unit_Cadastro, Unit_Principal, Unit_CadastroGestaoFilmes;

procedure TFrm_Categoria.Brn_CancelarClick(Sender: TObject);
begin
  if Application.MessageBox('Você deseja mesmo sair?','Aviso',MB_ICONEXCLAMATION+MB_YESNO) = IDYes
    then begin
           Frm_Cadastro := TFrm_Cadastro.Create(Frm_Principal.pnl_main);
           Frm_Cadastro.Parent := Frm_Principal.pnl_main;
           Frm_Categoria.Destroy;
           Frm_Principal.lbl_caminho.Caption := 'Menu/Cadastro e Gestão de Dados'
         end;
end;

procedure TFrm_Categoria.Btn_CadastrarClick(Sender: TObject);
begin
  {
  função onde é feita o cados dos dados de categoria
}
  //le os dados
  LerInformacoes(cat);
  //grava no vetor
  GravaCategoriaVetor(cat);
  //grava no arquivo
  EditaNoArquivo;
  //escreve o grid
  EscreveGrid;
  //faz a limpeza dos edits
  LimparCategoria(Edt_Valor,Edt_Descricao,Edt_Codigo);
  IniciaElementos(false);
  Btn_Novo.Enabled := true;
  Application.MessageBox('Categoria Cadastrado com sucesso','Categoria',MB_ICONINFORMATION+mb_ok);;
end;

procedure TFrm_Categoria.Btn_CancelarEditarClick(Sender: TObject);
begin
  if Application.MessageBox('Você deseja mesmo sair?','Aviso',MB_ICONEXCLAMATION+MB_YESNO) = IDYes
    then begin
           Frm_Cadastro := TFrm_Cadastro.Create(Frm_Principal.pnl_main);
           Frm_Cadastro.Parent := Frm_Principal.pnl_main;
           Frm_Categoria.Destroy;
           Frm_Principal.lbl_caminho.Caption := 'Menu/Cadastro e Gestão de Dados'
         end;
end;

procedure TFrm_Categoria.btn_EditarExcluirClick(Sender: TObject);
begin
  if Cbox_EditarExcluir.Text = 'Editar'
   then begin
          if Application.MessageBox('Você deseja mesmo editar esta categoria?','Aviso',MB_ICONWARNING+mb_YesNo)=IDYes
            then begin
                   //caso deseje alterar os dados le os edits
                   LerEditar(cat);
                   //faz a edicao no vetor
                   EditarCategoria(linha,cat);
                   //salva no arquivo as alterações
                   EditaNoArquivo;
                   Application.MessageBox('Categoria Editado com sucesso','Categoria',MB_ICONINFORMATION+mb_ok);
                   //escreve o grid para carregar as alterações
                   EscreveGrid;
                 end;
        end
   else begin
          if Application.MessageBox(PChar('Você deseja mesmo excluir a categoria '+Edt_CodigoEditar.Text+' ?'),'Excluir',MB_ICONERROR+mb_yesNO)=IDYEs
            then begin
                   //caso deseja excluir a categoria
                   ExcluiCategoria(linha);
                   EscreveGrid;
                   Application.MessageBox('Categoria Excluida com Sucesso','Exclus�o',MB_ICONINFORMATION+mb_ok);
                 end;
        end;
end;

procedure TFrm_Categoria.Btn_LimparClick(Sender: TObject);
begin
  if Application.MessageBox('Você deseja mesmo apagar todos os campos?','Aviso',MB_YESNO+MB_ICONWARNING)= IDYes
  then LimparCategoria(Edt_Valor,Edt_Descricao,Edt_Valor);
end;

procedure TFrm_Categoria.Btn_LimparEditarClick(Sender: TObject);
begin
  if Application.MessageBox('Você deseja mesmo apagar todos os campos?','Aviso',MB_YESNO+MB_ICONWARNING)= IDYes
  then begin
         Edt_CodigoEditar.Clear;
         LimparCategoria(Edt_ValorEditar,Edt_DescricaoEditar,Edt_CodigoEditar);
       end;
end;

procedure TFrm_Categoria.Btn_NovoClick(Sender: TObject);
begin
  IniciaElementos(true);
  Edt_Valor.SetFocus;
  Edt_Codigo.Text := GeraCodigoCategoria;
  Btn_Novo.Enabled := false;
end;

procedure TFrm_Categoria.Btn_VoltarClick(Sender: TObject);
begin
  Frm_Cadastro := TFrm_Cadastro.Create(Frm_Principal.pnl_main);
  Frm_Cadastro.Parent := Frm_Principal.pnl_main;
  Frm_Categoria.Destroy;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Cadastro e Gestão de Dados';
end;

procedure TFrm_Categoria.CBox_EditarExcluirChange(Sender: TObject);
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
           Btn_EditarExcluir.Enabled := true;
           Elementos(true);
           Edt_CodigoEditar.SetFocus;
         end
    else begin
           Btn_EditarExcluir.Caption := 'Excluir';
           Btn_EditarExcluir.Glyph.LoadFromFile(localizacao+'Delete.bmp');
           Edt_CodigoEditar.Enabled := true;
           Elementos(false);
           Btn_EditarExcluir.Enabled := true;
           Edt_CodigoEditar.SetFocus;
         end;
end;

procedure TFrm_Categoria.Page_CategoriaChange(Sender: TObject);
var
  aba : integer;
begin
  aba := Page_Categoria.ActivePageIndex;
  if aba = 0
    then begin
           Frm_Principal.lbl_caminho.Caption := 'Menu/Cadastro e Gestão de Dados/Categoria/Cadastrar Categoria';
           iniciaElementos(false);
           Btn_Novo.Enabled := true;
         end
    else if aba = 1
         then Frm_Principal.lbl_caminho.Caption := 'Menu/Cadastro e Gestão de Dados/Categoria/Mostrar Categoria'
         else if aba = 2
                then begin
                       Application.MessageBox('Escolha primeiro uma categoria','Aviso',MB_ICONERROR+mb_OK);
                       Page_Categoria.TabIndex := 1;
                     end;
end;

procedure TFrm_Categoria.SetaGrid;
begin
  StrGrid_Categoria.ColWidths[0] := 200;
  StrGrid_Categoria.Cells[0,0] := 'Código';
  StrGrid_Categoria.ColWidths[1] := 400;
  StrGrid_Categoria.Cells[1,0] := 'Descrição';
  StrGrid_Categoria.ColWidths[2] := 300;
  StrGrid_Categoria.Cells[2,0] := 'Valor locação';
end;

procedure TFrm_Categoria.StrGrid_CategoriaDblClick(Sender: TObject);
var
  str : string;
begin
  linha := StrGrid_Categoria.Row;
  str := StrGrid_Categoria.Cells[0,linha];
  delete(str,1,3);
  linha := StrToInt(str);
  dec(linha);
  Edt_codigoEditar.Text := categorias[linha].codigo;
  Page_Categoria.ActivePageIndex := 2;
  Edt_DescricaoEditar.Text := categorias[linha].descricao;
  Edt_valorEditar.Text := categorias[linha].valor;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Cadastro e Gestão de Dados/Categoria/Editar-Excluir Categoria';
end;

procedure TFrm_Categoria.Edt_ValorKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9',#13,#44,#8])
    then begin
           key:=#0;
           messagebeep(0);
         end;
end;

procedure Tfrm_Categoria.Elementos(habilita : boolean);
begin
  Edt_ValorEditar.Visible := habilita;
  Edt_DescricaoEditar.Visible := habilita;
  Btn_LimparEditar.Visible := habilita;
end;

procedure TFrm_Categoria.IniciaElementos(enable:boolean);
begin
  Edt_Codigo.Enabled := enable;
  Edt_Valor.Enabled := enable;
  Edt_Descricao.Enabled := enable;
  Btn_Cadastrar.Enabled := enable;
  Btn_limpar.Enabled := enable;
end;

procedure Tfrm_categoria.LimparCategoria(valor,descricao, focus : TlabeledEdit);
begin
  valor.Clear;
  descricao.clear;
  focus.SetFocus;
end;

procedure Tfrm_categoria.LerInformacoes(var cat:categoria);
begin
  cat.codigo := Edt_Codigo.Text;
  cat.valor := Edt_Valor.Text;
  cat.descricao := Edt_Descricao.Text;
end;

procedure Tfrm_Categoria.EscreveGrid;
var
  i: Integer;
begin
  StrGrid_Categoria.RowCount := 1;
  for i := 0 to length(categorias)-1 do
    begin
      if not(categorias[i].ativo)
        then begin
               StrGrid_Categoria.RowCount := StrGrid_Categoria.RowCount + 1;
               StrGrid_Categoria.Cells[0,StrGrid_Categoria.RowCount-1] := Categorias[i].codigo;
               StrGrid_Categoria.Cells[1,StrGrid_Categoria.RowCount-1] := categorias[i].valor;
               StrGrid_Categoria.Cells[2,StrGrid_Categoria.RowCount-1] := categorias[i].descricao;
             end;
    end;
end;

procedure Tfrm_Categoria.LerEditar(var cat : categoria);
begin
  cat.codigo := Edt_CodigoEditar.Text;
  cat.valor := Edt_ValorEditar.Text;
  cat.descricao := Edt_DescricaoEditar.Text;
end;

end.
