unit Unit_Menu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,Unit_Biblioteca;

type
  TFrm_Menu = class(TFrame)
    btn_cadastros: TBitBtn;
    btn_transacao: TBitBtn;
    btn_feedback: TBitBtn;
    btn_importacao: TBitBtn;
    procedure btn_cadastrosClick(Sender: TObject);
    procedure btn_transacaoClick(Sender: TObject);
    procedure btn_feedbackClick(Sender: TObject);
    procedure btn_importacaoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Menu : TFrm_Menu;

implementation

{$R *.dfm}

uses Unit_Cadastro, Unit_Principal, Unit_Transacoes, Unit_Feedback, Unit_ImpExp;

procedure TFrm_Menu.btn_cadastrosClick(Sender: TObject);
begin
  {
  Função que abre o cadastro e gestao de dados
}
  Frm_Cadastro := TFrm_Cadastro.Create(Frm_Principal.pnl_main);
  Frm_Cadastro.parent := Frm_Principal.Pnl_main;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Cadastro e Gestão de Dados';
  Frm_Menu.Destroy;
end;

procedure TFrm_Menu.btn_feedbackClick(Sender: TObject);
begin
  {
  Abre O modo de Feedback
}
  Frm_Feedback := TFrm_Feedback.Create(Frm_Principal.pnl_main);
  Frm_Feedback.parent := Frm_Principal.Pnl_main;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Feedback';
  Frm_Menu.Destroy;
end;

procedure TFrm_Menu.btn_importacaoClick(Sender: TObject);
begin
  {
  Abre o modo de importação e Exportação
}
  Frm_ImpExp := TFrm_ImpExp.Create(Frm_Principal.pnl_main);
  Frm_ImpExp.parent := Frm_Principal.Pnl_main;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Importação e Exportação';
  Frm_Menu.Destroy;
end;

procedure TFrm_Menu.btn_transacaoClick(Sender: TObject);
begin
  {
  Abre a Tela de Transações
}
  Frm_Transacoes := TFrm_transacoes.Create(Frm_Principal.pnl_main);
  Frm_Transacoes.parent := Frm_Principal.Pnl_main;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Transações';
  Frm_Menu.Destroy;
end;

end.
