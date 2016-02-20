unit Unit_Transacoes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Unit_Biblioteca;

type
  TFrm_Transacoes = class(TFrame)
    Pnl_titulo_Transacoes: TPanel;
    Btn_Voltar: TBitBtn;
    Btn_Locacao: TBitBtn;
    Btn_Devolucao: TBitBtn;
    Btn_Caixa: TBitBtn;
    Btn_ContasReceber: TBitBtn;
    Btn_entrada: TBitBtn;
    Btn_ContasPagar: TBitBtn;
    procedure Btn_VoltarClick(Sender: TObject);
    procedure Btn_LocacaoClick(Sender: TObject);
    procedure Btn_CaixaClick(Sender: TObject);
    procedure Btn_DevolucaoClick(Sender: TObject);
    procedure Btn_ContasReceberClick(Sender: TObject);
    procedure Btn_entradaClick(Sender: TObject);
    procedure Btn_ContasPagarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Transacoes : TFrm_Transacoes;

implementation

{$R *.dfm}

uses Unit_Menu, Unit_Principal, Unit_TransacoesLocacao, Unit_TransacoesCaixa,
  Unit_TransacoesDevolucao, Unit_TransacoesReceber, Unit_TransacoesEntrada,
  Unit_TransacoesPagar;

procedure TFrm_Transacoes.Btn_CaixaClick(Sender: TObject);
begin
  Frm_Caixa := Tfrm_Caixa.Create(Frm_Principal.pnl_main);
  Frm_Caixa.Parent := Frm_Principal.pnl_main;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Transações/Caixa';
  Frm_Caixa.Edt_quantia.Text := FloatToStr(Caixa);
  Frm_Transacoes.Destroy;
end;

procedure TFrm_Transacoes.Btn_ContasPagarClick(Sender: TObject);
begin
  Frm_Pagar := TFrm_Pagar.Create(Frm_Principal.pnl_main);
  Frm_Pagar.Parent := Frm_Principal.pnl_main;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Transações/Contas a Pagar';
  Frm_Pagar.SetaGrid;
  Frm_pagar.EscreveGrid;
  Frm_Transacoes.Destroy;
end;

procedure TFrm_Transacoes.Btn_ContasReceberClick(Sender: TObject);
begin
  Frm_Receber := Tfrm_Receber.Create(Frm_Principal.pnl_main);
  Frm_Receber.Parent := Frm_Principal.pnl_main;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Transações/Contas a Receber';
  Frm_Receber.SetaGrid;
  Frm_Receber.EscreveGrid;
  Frm_Transacoes.Destroy;
end;

procedure TFrm_Transacoes.Btn_DevolucaoClick(Sender: TObject);
begin
  Frm_Devolucao := Tfrm_Devolucao.Create(Frm_Principal.pnl_main);
  Frm_Devolucao.Parent := Frm_Principal.pnl_main;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Transações/Devoluções';
  Frm_Devolucao.SetaGrid;
  Frm_Devolucao.EscreveGrid;
  Frm_Transacoes.Destroy;
end;

procedure TFrm_Transacoes.Btn_entradaClick(Sender: TObject);
begin
  Frm_Entrada := TFrm_Entrada.Create(Frm_Principal.pnl_main);
  Frm_Entrada.Parent := Frm_Principal.pnl_main;
  Frm_Transacoes.Destroy;
  Frm_Entrada.CompletaCBox;
  Frm_Entrada.SetaGrid;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Transações/Entrada de Filmes';
end;

procedure TFrm_Transacoes.Btn_LocacaoClick(Sender: TObject);
begin
  Frm_Locacao := Tfrm_Locacao.Create(Frm_Principal.pnl_main);
  Frm_Locacao.Parent := Frm_Principal.pnl_main;
  Frm_Locacao.SetaGrid;
  Frm_Locacao.AtualizaCBox;
  Frm_Locacao.Habilita(false);
  Frm_Principal.lbl_caminho.Caption := 'Menu/Transações/Locação de Filmes';
  Frm_Transacoes.Destroy;
end;

procedure TFrm_Transacoes.Btn_VoltarClick(Sender: TObject);
begin
  Frm_menu := TFrm_menu.Create(Frm_Principal.pnl_main);
  Frm_menu.Parent := Frm_Principal.pnl_main;
  Frm_Transacoes.Destroy;
  Frm_Principal.lbl_caminho.Caption := 'Menu';
end;

end.
