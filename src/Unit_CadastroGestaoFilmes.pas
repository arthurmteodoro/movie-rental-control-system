unit Unit_CadastroGestaoFilmes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Grids, Unit_Biblioteca;

type
  TFrm_Filmes = class(TFrame)
    Pnl_TituloFilmes: TPanel;
    Btn_Voltar: TBitBtn;
    PControl_Filmes: TPageControl;
    Cadastrar: TTabSheet;
    Mostrar: TTabSheet;
    Editar: TTabSheet;
    Edt_Codigo: TLabeledEdit;
    Edt_Descricao: TLabeledEdit;
    Edt_exemplares: TLabeledEdit;
    Edt_CodCategoria: TLabeledEdit;
    CBox_Lingua: TComboBox;
    lbl_Lingua: TLabel;
    Btn_Cadastrar: TBitBtn;
    Btn_Limpar: TBitBtn;
    Btn_Cancelar: TBitBtn;
    StrGrid_Filmes: TStringGrid;
    Edt_CodigoEditar: TLabeledEdit;
    Edt_ExemplaresEditar: TLabeledEdit;
    Edt_descricaoEditar: TLabeledEdit;
    Edt_CodCatEditar: TLabeledEdit;
    CBox_LinguaEditar: TComboBox;
    Lbl_LinguaEditar: TLabel;
    Btn_EditarExcluir: TBitBtn;
    Btn_LimparEditar: TBitBtn;
    Btn_CancelarEditar: TBitBtn;
    Label1: TLabel;
    CBox_EditarExcluir: TComboBox;
    Btn_Novo: TBitBtn;
    procedure Btn_VoltarClick(Sender: TObject);
    procedure Btn_CancelarClick(Sender: TObject);
    procedure Btn_LimparClick(Sender: TObject);
    procedure SetaTabelaFilmes;
    procedure MostrarPaineis(habilita : boolean);
    procedure CBox_EditarExcluirChange(Sender: TObject);
    procedure PControl_FilmesChange(Sender: TObject);
    procedure IniciaElementos(enable : boolean);
    procedure Btn_NovoClick(Sender: TObject);
    procedure Btn_CadastrarClick(Sender: TObject);
    procedure Btn_LimparEditarClick(Sender: TObject);
    procedure LerFilme(var film : filme);
    procedure Limpar(descricao,exemplares,codcat,focus:TLabeledEdit;lingua:TComboBox);
    procedure EscreveGrid;
    procedure StrGrid_FilmesDblClick(Sender: TObject);
    procedure Btn_EditarExcluirClick(Sender: TObject);
    procedure LerEditar(var film : filme);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Filmes : TFrm_Filmes;

implementation

{$R *.dfm}

uses Unit_Cadastro, Unit_Principal, Unit_CadastroGestaoCliente,
  Unit_CadastroGestaoLocadora;

procedure TFrm_Filmes.Btn_CadastrarClick(Sender: TObject);
var
  existe : boolean;
  i : integer;
begin
  if length(categorias) = 0
    then Application.MessageBox('Nenhuma categoria cadastrada','Aviso',MB_ICONERROR+mb_ok)
    else begin
           existe := false;
           for i := 0 to length(categorias)-1 do
             begin
               if Edt_CodCategoria.Text =  categorias[i].codigo
                 then begin
                        existe := true;
                      end;
             end;
           if not(existe)
             then begin
                    Application.MessageBox('Categoria Inexistente','Aviso',MB_ICONERROR+mb_ok);
                    edt_codCategoria.Clear;
                  end
              else begin
                     //AbreArquivoGravacao;
                     //le o que ta escrito
                     LerFilme(film);
                     //grava no vetor
                     GravaFilmeVetor(film);
                     //grava no arquivo
                     //GravaFilme(film);
                     EditaNoArquivo;
                     //escreve no grid
                     EscreveGrid;
                     Limpar(Edt_Descricao,Edt_exemplares,Edt_CodCategoria,Edt_Descricao,Cbox_Lingua);
                     IniciaElementos(false);
                     Btn_Novo.Enabled := true;
                     Application.MessageBox('Filme Cadastrado com sucesso','Filme',MB_ICONINFORMATION+mb_ok);
                     //CloseFile(Arquivo);
                   end;
         end;
end;

procedure TFrm_Filmes.Btn_CancelarClick(Sender: TObject);
begin
  if Application.MessageBox('Você deseja mesmo sair?','Aviso',MB_ICONEXCLAMATION+MB_YESNO) = IDYes
    then begin
           Frm_Cadastro := TFrm_Cadastro.Create(Frm_Principal.pnl_main);
           Frm_Cadastro.Parent := Frm_Principal.pnl_main;
           Frm_Principal.lbl_caminho.Caption := 'Menu/Cadastro e Gestão de Dados';
           Frm_Filmes.Destroy;
         end;
end;

procedure TFrm_Filmes.Btn_EditarExcluirClick(Sender: TObject);
begin
  if CBox_EditarExcluir.Text = 'Editar'
    then begin
           if Application.MessageBox('Você deseja mesmo editar este cliente?','Aviso',MB_ICONWARNING+mb_YesNo) = IDYEs
             then begin
                    LerEditar(film);
                    EditarFilmes(linha,film);
                    EditaNoArquivo;
                    Application.MessageBox('Cliente Editado com sucesso','Editado',MB_ICONINFORMATION+mb_ok);
                    EscreveGrid;
                  end;
         end
    else if Cbox_EditarExcluir.Text  = 'Excluir'
           then begin
                  if Application.MessageBox(Pchar('Você deseja mesmo excluir o filme '+film.codigo+''),'Aviso',MB_ICONSTOP+mb_YESNO)=IdYes
                    then begin
                           ExcluiFilme(linha);
                           EscreveGrid;
                           Application.MessageBox('Filme Excluido com sucesso','Exclusão',MB_ICONINFORMATION+mb_ok);
                         end;
                end;
end;

procedure TFrm_Filmes.Btn_LimparEditarClick(Sender: TObject);
begin
  if Application.MessageBox('Você deseja mesmo apagar todos os campos?','Aviso',MB_YESNO+MB_ICONWARNING)= IDYes
  then begin
         Edt_CodigoEditar.Clear;
         Limpar(Edt_descricaoEditar,Edt_ExemplaresEditar,Edt_CodCatEditar,Edt_CodigoEditar,Cbox_LinguaEditar);
       end;
end;

procedure TFrm_Filmes.Btn_NovoClick(Sender: TObject);
begin
  IniciaElementos(true);
  Edt_Codigo.Text := GeraCodigoFilme;
  Edt_Descricao.SetFocus;
  Btn_Novo.Enabled := false;
end;

procedure TFrm_Filmes.Btn_VoltarClick(Sender: TObject);
begin
  Frm_Cadastro := TFrm_Cadastro.Create(Frm_Principal.pnl_main);
  Frm_Cadastro.Parent := Frm_Principal.pnl_main;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Cadastro e Gestão de Dados';
  Frm_Filmes.Destroy;
end;

procedure TFrm_Filmes.CBox_EditarExcluirChange(Sender: TObject);
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
           MostrarPaineis(true);
           Edt_CodigoEditar.SetFocus;
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

procedure Tfrm_Filmes.SetaTabelaFilmes;
begin
  StrGrid_Filmes.ColWidths[0] := 125;
  StrGrid_Filmes.Cells[0,0] := 'Código';
  StrGrid_Filmes.ColWidths[1] := 305;
  StrGrid_Filmes.Cells[1,0] := 'Descrição';
  StrGrid_Filmes.ColWidths[2] := 160;
  StrGrid_Filmes.Cells[2,0] := 'Exemplares';
  StrGrid_Filmes.ColWidths[3] := 170;
  StrGrid_Filmes.Cells[3,0] := 'Código Categoria';
  StrGrid_Filmes.ColWidths[4] := 120;
  StrGrid_Filmes.Cells[4,0] := 'Língua';
end;

procedure TFrm_Filmes.StrGrid_FilmesDblClick(Sender: TObject);
var
  str : string;
begin
  linha := StrGrid_Filmes.Row;
  str := StrGrid_filmes.Cells[0,linha];
  delete(str,1,1);
  linha := StrToInt(str);
  dec(linha);
  PControl_Filmes.ActivePageIndex := 2;
  Edt_CodigoEditar.Text := filmes[linha].codigo;
  Edt_DescricaoEditar.Text := filmes[linha].descricao;
  Edt_ExemplaresEditar.Text := filmes[linha].exemplares;
  Edt_CodCatEditar.Text := filmes[linha].codcat;
  Cbox_LinguaEditar.Text := filmes[linha].lingua;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Cadastro e Gestão de Dados/Filmes/Editar-Excluir Filmes'
end;

procedure TFrm_Filmes.MostrarPaineis(habilita : boolean);
begin
  Edt_DescricaoEditar.Visible := habilita;
  Edt_ExemplaresEditar.Visible := habilita;
  Edt_CodCatEditar.Visible := habilita;
  lbl_LinguaEditar.Visible := habilita;
  CBox_LinguaEditar.Visible := habilita;
  btn_LimparEditar.Visible := habilita;
end;

procedure TFrm_Filmes.PControl_FilmesChange(Sender: TObject);
var
  aba : integer;
begin
  aba := PControl_Filmes.ActivePageIndex;
  if aba = 0
    then begin
         IniciaElementos(false);
         Btn_Novo.Enabled := true;
         Frm_Principal.lbl_caminho.Caption := 'Menu/Cadastro e Gestão de Dados/Filmes/Cadastrar Filmes';
         end
    else if aba = 1
         then Frm_Principal.lbl_caminho.Caption := 'Menu/Cadastro e Gestão de Dados/Filmes/Mostrar Filmes'
         else if aba = 2
                then begin
                       Application.MessageBox('Escolha primeiro um filme','Aviso',MB_ICONERROR+mb_OK);
                       PControl_Filmes.TabIndex := 1;
                     end;
end;

procedure TFrm_Filmes.IniciaElementos(enable : boolean);
begin
  Edt_Descricao.Enabled := enable;
  Edt_Exemplares.Enabled := enable;
  Edt_Codigo.Enabled := enable;
  Lbl_Lingua.Enabled := enable;
  CBox_Lingua.Enabled := enable;
  Btn_Cadastrar.Enabled := enable;
  Btn_Limpar.Enabled := enable;
  Edt_CodCategoria.Enabled := enable;
end;

procedure Tfrm_filmes.Limpar(descricao,exemplares,codcat,focus:TLabeledEdit;lingua:TComboBox);
begin
  descricao.Clear;
  exemplares.Clear;
  codcat.Clear;
  lingua.Text := '';
  focus.SetFocus;
end;

procedure TFrm_Filmes.Btn_LimparClick(Sender: TObject);
begin
  if Application.MessageBox('Você deseja mesmo apagar todos os campos?','Aviso',MB_YESNO+MB_ICONWARNING)= IDYes
  then begin
         Limpar(Edt_Descricao,Edt_exemplares,Edt_CodCategoria,Edt_Descricao,Cbox_Lingua);
       end;
end;

procedure Tfrm_Filmes.LerFilme(var film : filme);
begin
  film.codigo := Edt_Codigo.Text;
  film.descricao := Edt_Descricao.Text;
  film.exemplares := Edt_Exemplares.Text;
  film.codcat := Edt_CodCategoria.Text;
  film.lingua := CBox_Lingua.Text;
  film.ativo := false;
  film.preco := '0';
  film.vezes := 0;
end;

procedure Tfrm_Filmes.EscreveGrid;
var
  i : integer;
begin
  StrGrid_Filmes.RowCount := 1;
  for i := 0 to length(filmes)-1 do
    begin
      if filmes[i].ativo = false
        then begin
               StrGrid_Filmes.RowCount := StrGrid_Filmes.RowCount + 1;
               StrGrid_Filmes.Cells[0,StrGrid_Filmes.RowCount-1] := filmes[i].codigo;
               StrGrid_Filmes.Cells[1,StrGrid_Filmes.RowCount-1] := filmes[i].descricao;
               StrGrid_Filmes.Cells[2,StrGrid_Filmes.RowCount-1] := filmes[i].exemplares;
               StrGrid_Filmes.Cells[3,StrGrid_Filmes.RowCount-1] := filmes[i].codcat;
               StrGrid_Filmes.Cells[4,StrGrid_Filmes.RowCount-1] := filmes[i].lingua;
             end;
    end;
end;

procedure Tfrm_Filmes.LerEditar(var film : filme);
begin
  film.codigo := Edt_CodigoEditar.Text;
  film.descricao := Edt_DescricaoEditar.Text;
  film.exemplares := Edt_ExemplaresEditar.Text;
  film.codcat := Edt_CodCatEditar.Text;
  film.lingua := CBox_LinguaEditar.Text;
end;

end.
