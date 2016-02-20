unit Unit_ImpExp;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Unit_Biblioteca, Vcl.CheckLst, Vcl.ExtDlgs;

type
  TFrm_ImpExp = class(TFrame)
    pnl_top: TPanel;
    PgControl_ImpExp: TPageControl;
    btn_voltar: TBitBtn;
    Importacao: TTabSheet;
    Exportacao: TTabSheet;
    RG_Opcoes: TRadioGroup;
    GroupBox1: TGroupBox;
    Edt_caminhoExp: TLabeledEdit;
    Btn_exp: TBitBtn;
    Save_Exp: TSaveTextFileDialog;
    memo_preExp: TMemo;
    RG_OpcoesImp: TRadioGroup;
    Memo_Pre_Imp: TMemo;
    Btn_AbrirArq: TBitBtn;
    Btn_Importar: TBitBtn;
    Edt_caminhoImp: TLabeledEdit;
    Open_Imp: TOpenTextFileDialog;
    GroupBox2: TGroupBox;
    procedure btn_voltarClick(Sender: TObject);
    procedure RG_OpcoesClick(Sender: TObject);
    //procedure ExportaDados(opcao:integer;caminho:string);
    procedure Btn_expClick(Sender: TObject);
    procedure Btn_AbrirArqClick(Sender: TObject);
    procedure RG_OpcoesImpClick(Sender: TObject);
    procedure Btn_ImportarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_ImpExp : TFrm_ImpExp;
  op, op_imp : integer;
  caminho_imp : string;
implementation

{$R *.dfm}

uses Unit_Menu, Unit_Principal;

procedure TFrm_ImpExp.Btn_AbrirArqClick(Sender: TObject);
begin
  if Open_Imp.Execute
    then begin
           caminho_imp := Open_Imp.FileName;
           Edt_caminhoImp.Text := caminho_imp;
           Memo_Pre_Imp.Lines.LoadFromFile(caminho_imp);
         end;
end;

procedure TFrm_ImpExp.Btn_expClick(Sender: TObject);
var
  caminho : string;
begin
  if Save_Exp.Execute
    then begin
           caminho := Save_Exp.FileName;
           Edt_CaminhoExp.Text := caminho;
           ExportaDados(op,caminho);
           Memo_PreExp.Lines.LoadFromFile(caminho);
         end;
end;

procedure TFrm_ImpExp.Btn_ImportarClick(Sender: TObject);
begin
  case op_imp of
    0 : begin
          if Application.MessageBox('Você deseja mesmo importar estes dados?','Aviso',MB_ICONHAND+MB_YesNo) = IDYes
            then begin
                   ImportaLocadora(caminho_imp);
                   Frm_Principal.Pnl_Header.Caption := loc.Nome;
                   Frm_Principal.Caption := loc.Nome;
                   Frm_Principal.pnl_bottom.Caption := loc.endereco;
                   EditaNoArquivo;
                   Application.MessageBox('Dados Importados com sucesso!','Concluído',MB_ICONINFORMATION+mb_OK);
                 end;
        end;
    1 : begin
          if Application.MessageBox('Você deseja mesmo importar estes dados?','Aviso',MB_ICONHAND+MB_YesNo) = IDYes
            then begin
                   ImportaCliente(caminho_imp);
                   Application.MessageBox('Dados Importados com sucesso!','Concluído',MB_ICONINFORMATION+mb_OK);
                 end;
        end;
    2 : begin
          if Application.MessageBox('Você deseja mesmo importar estes dados?','Aviso',MB_ICONHAND+MB_YesNo) = IDYes
            then begin
                   ImportaFilmes(caminho_imp);
                   Application.MessageBox('Dados Importados com sucesso!','Concluído',MB_ICONINFORMATION+mb_OK);
                 end;
        end;
    3 : begin
          if Application.MessageBox('Você deseja mesmo importar estes dados?','Aviso',MB_ICONHAND+MB_YesNo) = IDYes
            then begin
                   ImportaCategorias(caminho_imp);
                   Application.MessageBox('Dados Importados com sucesso!','Concluído',MB_ICONINFORMATION+mb_OK);
                 end;
        end;
    4 : begin
          if Application.MessageBox('Você deseja mesmo importar estes dados?','Aviso',MB_ICONHAND+MB_YesNo) = IDYes
            then begin
                   ImportaFuncionarios(caminho_imp);
                   Application.MessageBox('Dados Importados com sucesso!','Concluído',MB_ICONINFORMATION+mb_OK);
                 end;
        end;
    5 : begin
          if Application.MessageBox('Você deseja mesmo importar estes dados?','Aviso',MB_ICONHAND+MB_YesNo) = IDYes
            then begin
                   ImportaFornecedores(caminho_imp);
                   Application.MessageBox('Dados Importados com sucesso!','Concluído',MB_ICONINFORMATION+mb_OK);
                 end;
        end;
    6 : begin
          if Application.MessageBox('Você deseja mesmo importar estes dados?','Aviso',MB_ICONHAND+MB_YesNo) = IDYes
            then begin
                   ImportaContasReceber(caminho_imp);
                   Application.MessageBox('Dados Importados com sucesso!','Concluído',MB_ICONINFORMATION+mb_OK);
                 end;
        end;
    7 : begin
          if Application.MessageBox('Você deseja mesmo importar estes dados?','Aviso',MB_ICONHAND+MB_YesNo) = IDYes
            then begin
                   ImportaDevolucoes(caminho_imp);
                   Application.MessageBox('Dados Importados com sucesso!','Concluído',MB_ICONINFORMATION+mb_OK);
                 end;
        end;
    8 : begin
          if Application.MessageBox('Você deseja mesmo importar estes dados?','Aviso',MB_ICONHAND+MB_YesNo) = IDYes
            then begin
                   ImportaContasPagar(caminho_imp);
                   Application.MessageBox('Dados Importados com sucesso!','Concluído',MB_ICONINFORMATION+mb_OK);
                 end;
        end;
  end;
end;

procedure TFrm_ImpExp.btn_voltarClick(Sender: TObject);
begin
  Frm_menu := TFrm_menu.Create(Frm_Principal.pnl_main);
  Frm_menu.Parent := Frm_Principal.pnl_main;
  Frm_ImpExp.Destroy;
  Frm_Principal.lbl_caminho.Caption := 'Menu';
end;

procedure TFrm_ImpExp.RG_OpcoesClick(Sender: TObject);
begin
  op := RG_opcoes.ItemIndex;
end;

procedure TFrm_ImpExp.RG_OpcoesImpClick(Sender: TObject);
begin
  op_imp := RG_OpcoesImp.ItemIndex;
end;

end.
