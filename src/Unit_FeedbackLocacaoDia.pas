unit Unit_FeedbackLocacaoDia;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VCLTee.TeEngine,
  VCLTee.Series, VCLTee.TeeProcs, VCLTee.Chart, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Unit_Biblioteca, Vcl.ComCtrls;

type locacao = record
                 data : string;
                 quant : integer;
               end;

type vetor = array of locacao;

type
  TFrm_LocacoesDia = class(TFrame)
    pnl_top: TPanel;
    Btn_Voltar: TBitBtn;
    pnl_pesquisa: TPanel;
    Chart1: TChart;
    Locacoes: TLineSeries;
    DataIncial: TDateTimePicker;
    DataFinal: TDateTimePicker;
    btn_Pesquisar: TBitBtn;
    lbl_dataInicial: TLabel;
    lbl_dataFinal: TLabel;
    procedure Btn_VoltarClick(Sender: TObject);
    procedure PassaProVetor(var vet:vetor);
    procedure DesenhaGrafico(vet:vetor);
    procedure PesquisaDia(data1,data2:TDate;var vet:vetor);
    procedure btn_PesquisarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  var
    Frm_LocacoesDia : TFrm_LocacoesDia;
    vetor_locacoesDia : vetor;

implementation

{$R *.dfm}

uses Unit_Feedback, Unit_Principal;

procedure TFrm_LocacoesDia.btn_PesquisarClick(Sender: TObject);
var
  data1, data2 : TDate;
begin
  data1 := DataIncial.Date;
  data2 := DataFinal.Date;
  PesquisaDia(data1,data2,vetor_LocacoesDia);
end;

procedure TFrm_LocacoesDia.Btn_VoltarClick(Sender: TObject);
begin
  Frm_Feedback := TFrm_Feedback.Create(Frm_Principal.pnl_main);
  Frm_Feedback.parent := Frm_Principal.Pnl_main;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Feedback';
  Frm_LocacoesDia.Destroy;
end;

procedure TFrm_LocacoesDia.PassaProVetor(var vet:vetor);
var
  i,j,pos: Integer;
  date : string;
  existe : boolean;
begin
  SetLength(vet,0);
  for i := 0 to length(Filmes_Devolver)-1 do
    begin
      date := filmes_devolver[i].dataLoc;
      pos := 0;
      existe := false;
      if length(vet) = 0
        then existe := false
        else begin
               for j := 0 to length(vet)-1 do //for para verificar se a data existe
                 begin
                   if vet[j].data = date
                     then begin
                            existe := true;
                            pos := j;
                            break;
                          end
                     else existe := false;
                 end;
             end;
      if not(existe)
        then begin
               SetLength(vet,length(vet)+1);
               vet[length(vet)-1].data := date;
               vet[length(vet)-1].quant := vet[length(vet)-1].quant + 1;
             end
        else begin
               vet[pos].quant := vet[pos].quant + 1;
             end;
    end;
end;

procedure Tfrm_LocacoesDia.DesenhaGrafico(vet:vetor);
var
  i : integer;
begin
  Locacoes.Clear;
  for i := 0 to length(vet)-1 do
    begin
      Locacoes.AddY(vet[i].quant,vet[i].data,clBlack);
    end;
end;

procedure TFrm_LocacoesDia.PesquisaDia(data1,data2:TDate;var vet:vetor);
var
  temp : vetor;
  date, date1, date2 : string;
  i : integer;
  data : TDate;
begin
  SetLength(temp,0);
  for i := 0 to length(vet)-1 do
    begin
      SetLength(temp,length(temp)+1);
      temp[length(temp)-1] := vet[i];
    end;
  SetLength(vet,0);
  date1 := formatDateTime('yyyy/mm/dd',data1);
  date2 := FormatDateTime('yyyy/mm/dd',data2);
  for i := 0 to length(temp)-1 do
    begin
      data := StrToDate(temp[i].data);
      date := FormatDateTime('yyyy/mm/dd',data);
      if (date >= date1)and(date <= date2)
        then begin
               SetLength(vet,length(vet)+1);
               vet[length(vet)-1] := temp[i];
             end;
    end;
  DesenhaGrafico(vet);
end;

end.
