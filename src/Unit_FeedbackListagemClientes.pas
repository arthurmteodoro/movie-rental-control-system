unit Unit_FeedbackListagemClientes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.DBGrids,
  Data.DB, RpCon, RpConDS, RpDefine, RpRave, Vcl.StdCtrls, Vcl.Buttons,
  Datasnap.DBClient, Vcl.ExtCtrls, Unit_Biblioteca;

type
  TFrm_ListagemClientes = class(TFrame)
    pnl_top: TPanel;
    pnl_Pesquisa: TPanel;
    pnl_exportar: TPanel;
    Btn_Voltar: TBitBtn;
    Btn_Exportar: TBitBtn;
    RvProject1: TRvProject;
    DSC_Clientes: TRvDataSetConnection;
    CBox_Filtro: TComboBox;
    lbl_tipo: TLabel;
    pnl_cod: TPanel;
    CBox_Inicial: TComboBox;
    CBox_Final: TComboBox;
    Btn_PesquisaCod: TBitBtn;
    lbl_codIni: TLabel;
    lbl_codFin: TLabel;
    pnl_sexo: TPanel;
    CBox_Sexo: TComboBox;
    lbl_sexo: TLabel;
    Btn_Sexo: TBitBtn;
    DS_Cliente: TDataSource;
    CDS_Cliente: TClientDataSet;
    CDS_Clientecodigo: TStringField;
    CDS_Clientenome: TStringField;
    CDS_Clienteendereco: TStringField;
    CDS_Clientecpf: TStringField;
    CDS_Clientetelefone: TStringField;
    CDS_Clienteemail: TStringField;
    CDS_Clientesexo: TStringField;
    CDS_Clienteestado: TStringField;
    CDS_Clientenascimento: TStringField;
    DBGrid1: TDBGrid;
    procedure PassaVetorCDS;
    procedure Btn_VoltarClick(Sender: TObject);
    procedure Btn_SexoClick(Sender: TObject);
    procedure PassaCodCBox;
    procedure Btn_PesquisaCodClick(Sender: TObject);
    procedure CBox_FiltroChange(Sender: TObject);
    procedure Btn_ExportarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_ListagemClientes : TFrm_ListagemClientes;

implementation

{$R *.dfm}

uses Unit_Feedback, Unit_Principal;

procedure TFrm_ListagemClientes.Btn_ExportarClick(Sender: TObject);
var
  localizacao : string;
  posi : integer;
begin
  localizacao := ExtractFilePath(Application.ExeName);
  posi := pos('\Win32\Debug',localizacao);
  delete(localizacao,posi,length(localizacao));
  localizacao := localizacao + '\modelos relatorios\clientes.rav';
  RVProject1.ProjectFile := localizacao;
  RVProject1.Execute;
end;

procedure TFrm_ListagemClientes.Btn_PesquisaCodClick(Sender: TObject);
var
  filtro : string;
begin
  filtro := 'codigo >= ' + chr(39);
  filtro := filtro + Cbox_Inicial.Text;
  filtro := filtro + chr(39) + ' and codigo <= ' + chr(39);
  filtro := filtro + cbox_Final.Text + chr(39);
  CDS_Cliente.Filter := filtro;
  CDS_Cliente.Filtered := true;
end;

procedure TFrm_ListagemClientes.Btn_SexoClick(Sender: TObject);
var
  filtro : string;
begin
  filtro := 'sexo = ';
  filtro := filtro + chr(39);
  filtro := filtro + Cbox_Sexo.Text;
  filtro := filtro + chr(39);
  CDS_Cliente.Filter := filtro;
  CDS_Cliente.Filtered := true;
end;

procedure Tfrm_ListagemClientes.PassaCodCBox;
var
  i: Integer;
begin
  for i := 0 to length(clientes)-1 do
    begin
      CBox_Inicial.Items.Add(clientes[i].codigo);
      CBox_Final.Items.Add(clientes[i].codigo);
    end;
end;

procedure TFrm_ListagemClientes.Btn_VoltarClick(Sender: TObject);
begin
  Frm_Feedback := TFrm_Feedback.Create(Frm_Principal.pnl_main);
  Frm_Feedback.parent := Frm_Principal.Pnl_main;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Feedback';
  Frm_ListagemClientes.Destroy;
end;

procedure TFrm_ListagemClientes.CBox_FiltroChange(Sender: TObject);
begin
  if Cbox_Filtro.ItemIndex = 0
    then begin
           pnl_cod.Visible := true;
           pnl_sexo.Visible := false;
         end
    else if CBox_Filtro.ItemIndex = 1
           then begin
                  pnl_cod.Visible := false;
                  pnl_sexo.Visible := true;
                end
           else begin
                  CDS_Cliente.Filtered := false;
                  pnl_cod.Visible := false;
                  pnl_sexo.Visible := false;
                end;
end;

procedure TFrm_ListagemClientes.PassaVetorCDS;
var
  i: Integer;
begin
  CDS_Cliente.Open;
  for i := length(clientes)-1 downto 0 do
    begin
      if not(clientes[i].ativo)
        then begin
               CDS_Cliente.Insert;
               CDS_Cliente.FieldValues['codigo'] := clientes[i].codigo;
               CDS_Cliente.FieldValues['nome'] := clientes[i].nome;
               CDS_Cliente.FieldValues['endereco'] := clientes[i].endereco;
               CDS_Cliente.FieldValues['cpf'] := clientes[i].cpf;
               CDS_Cliente.FieldValues['telefone'] := clientes[i].telefone;
               CDS_Cliente.FieldValues['email'] := clientes[i].email;
               CDS_Cliente.FieldValues['sexo'] := clientes[i].sexo;
               CDS_Cliente.FieldValues['estado'] := clientes[i].estado;
               CDS_Cliente.FieldValues['nascimento'] := clientes[i].nascimento;
               CDS_Cliente.Post;
             end;
    end;
end;

end.
