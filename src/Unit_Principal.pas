unit Unit_Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.Menus, Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls, Vcl.ActnMenus,Vcl.HtmlHelpViewer,
  Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.Buttons, Unit_Biblioteca;

type
  Tfrm_Principal = class(TForm)
    Pnl_Header: TPanel;
    lbl_hora: TLabel;
    lbl_relogio_hora: TLabel;
    lbl_data: TLabel;
    lbl_relogio_data: TLabel;
    btn_exit: TSpeedButton;
    pnl_main: TPanel;
    pnl_caminho: TPanel;
    lbl_caminho: TLabel;
    pnl_bottom: TPanel;
    relogio: TTimer;
    procedure btn_exitClick(Sender: TObject);
    procedure IniciaCodigo;
    procedure FormCreate(Sender: TObject);
    procedure relogioTimer(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_Principal: Tfrm_Principal;
  textos, text1, text2,tags1 : string;


implementation

{$R *.dfm}

uses Unit_Menu, Unit_Cadastro, Unit_CadastroGestaoLocadora,
  Unit_CadastroGestaoCliente, Unit_TransacoesCaixa, Unit_TransacoesDevolucao;

procedure Tfrm_Principal.btn_exitClick(Sender: TObject);
begin
  Close;
end;

procedure Tfrm_Principal.FormCreate(Sender: TObject);
var
  localizacao : string;
  posi : integer;
begin
  {
  Funçao em que verifica se o arquivo existe e que lê os dados do mesmo
}
  localizacao := GetCurrentDir;
  posi := pos('\Win32\Debug',localizacao);
  delete(localizacao,posi,length(localizacao));
  //adição do arquivo de help
  Application.HelpFile := localizacao+'\help.chm';
  AssignFile(Arquivo,localizacao+'\Arquivo.xml');
  {$I-}
  Reset(Arquivo);//abre o arquivo para leitura
  {$I+}
  if ioresult = 2
    then Rewrite(Arquivo);//se o arquivo n�o existe cria um
  CloseFile(Arquivo);
  MemoriaLocadora;
  MemoriaCliente;
  MemoriaFilme;
  MemoriaCategoria;
  MemoriaFuncionario;
  MemoriaFornecedores;
  MemoriaContasReceber;
  MemoriaDevolver;
  MemoriaPagar;
  IniciaCodigo;
end;

procedure Tfrm_Principal.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_F1 then
  begin
    Application.HelpContext(0);
  end;
end;

procedure TFrm_Principal.IniciaCodigo;
begin
  {
  Carrega configurações dos paineis com nomes e endereços da locadora
}
  Frm_Principal.Pnl_Header.Caption := loc.Nome;
  Frm_Principal.Caption := loc.Nome;
  Frm_Principal.pnl_bottom.Caption := loc.endereco;
  Frm_Menu := TFrm_Menu.Create(pnl_main);
  Frm_Menu.parent := pnl_main;
  lbl_hora.Caption := formatdatetime('hh:mm:ss',now);
  lbl_data.Caption := formatdatetime('dd/mm/yy',now);
end;

procedure Tfrm_Principal.relogioTimer(Sender: TObject);
begin
  lbl_hora.Caption := formatdatetime('hh:mm:ss',now);
  lbl_data.Caption := formatdatetime('dd/mm/yy',now);
end;

end.
