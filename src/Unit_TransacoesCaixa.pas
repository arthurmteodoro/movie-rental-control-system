unit Unit_TransacoesCaixa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls;

type
  TFrm_Caixa = class(TFrame)
    Pnl_Header: TPanel;
    btn_voltar: TBitBtn;
    Edt_quantia: TLabeledEdit;
    procedure btn_voltarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Caixa : TFrm_Caixa;

implementation

{$R *.dfm}

uses Unit_Transacoes, Unit_Principal, Unit_TransacoesLocacao;

procedure TFrm_Caixa.btn_voltarClick(Sender: TObject);
begin
  Frm_Transacoes := Tfrm_Transacoes.Create(Frm_Principal.pnl_main);
  Frm_Transacoes.Parent := Frm_Principal.pnl_main;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Transações';
  Frm_Caixa.Destroy;
end;

end.
