unit Unit_FeedbackLocacaoFuncionario;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Unit_Biblioteca, Vcl.ComCtrls, VCLTee.TeEngine, VCLTee.Series,
  VCLTee.TeeProcs, VCLTee.Chart;

type vet1 = record
              codigo : string;
              total : integer;
            end;

type
  vet = array of vet1;

type
  TFrm_LocacaoFuncionario = class(TFrame)
    Pnl_Header: TPanel;
    Btn_Voltar: TBitBtn;
    Pnl_Pesquisa: TPanel;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    lbl_Data1: TLabel;
    lbl_Data2: TLabel;
    Btn_Pesquisa: TBitBtn;
    Grafico_funcionario: TChart;
    Graf_Func: TPieSeries;
    procedure Btn_VoltarClick(Sender: TObject);
    procedure EscreveGrafico(vetor:vet);
    procedure Ordena(var vetor_ord:vet);
    procedure passaVetor;
    procedure vetorPesquisa(data1,data2:TDate);
    procedure Btn_PesquisaClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  var
    Frm_LocacaoFuncionario : TFrm_LocacaoFuncionario;
    vetor_ord : vet;
    vetor_quant : vet;

implementation

{$R *.dfm}

uses Unit_Feedback, Unit_Principal;

procedure TFrm_LocacaoFuncionario.Btn_PesquisaClick(Sender: TObject);
var
  data1, data2 : TDate;
begin
  data1 := DateTimePicker1.Date;
  data2 := DateTimePicker2.Date;
  vetorPesquisa(data1,data2);
end;

procedure TFrm_LocacaoFuncionario.Btn_VoltarClick(Sender: TObject);
begin
  Frm_Feedback := TFrm_Feedback.Create(Frm_Principal.pnl_main);
  Frm_Feedback.parent := Frm_Principal.Pnl_main;
  Frm_Principal.lbl_caminho.Caption := 'Menu/Feedback';
  SetLength(vetor_ord,0);
  Frm_LocacaoFuncionario.Destroy;
end;

procedure TFrm_LocacaoFuncionario.EscreveGrafico(vetor:vet);
var
  i: Integer;
  cor : TColor;
  red, green, blue : byte;
begin
  Randomize;
  Graf_Func.Clear;
  for i := 0 to length(vetor)-1 do
    begin
      red := Random(255);
      green := Random(255);
      blue := Random(255);
      Cor := TColor(RGB(red,green,blue));
      Graf_Func.AddY(vetor[i].total,vetor[i].codigo,cor);
    end;
end;

procedure Tfrm_LocacaoFuncionario.Ordena(var vetor_ord:vet);
var
  i,j : integer;
  aux : vet1;
begin
  for i := 0 to length(vetor_ord)-1 do
    begin
      for j := 0 to length(vetor_ord)-1 do
        begin
          if vetor_ord[i].total > vetor_ord[j].total
            then begin
                   aux := vetor_ord[i];
                   vetor_ord[i] := vetor_ord[j];
                   vetor_ord[j] := aux;
                 end;
        end;
    end;
end;

procedure Tfrm_LocacaoFuncionario.passaVetor;
var
  i : integer;
begin
  for i := 0 to length(funcionarios)-1 do
    begin
      SetLength(vetor_ord,length(vetor_ord)+1);
      vetor_ord[i].codigo := funcionarios[i].codigo;
      vetor_ord[i].total := funcionarios[i].total;
    end;
  Ordena(vetor_ord);
end;

procedure Tfrm_LocacaoFuncionario.vetorPesquisa(data1,data2:TDate);
var
  i, cod_func : integer;
  date, date1, date2, funci : string;
  data : TDate;
begin
  //coloca o vetor de quantidade no tamanho dos de funcionarios
  SetLength(vetor_quant,0);
  for i := 0 to length(funcionarios)-1 do
    begin
      SetLength(vetor_quant,length(vetor_quant)+1);
      vetor_quant[length(vetor_quant)-1].codigo := funcionarios[i].codigo;
      vetor_quant[length(vetor_quant)-1].total := 0;
    end;
  //transforma as datas em strings ao contrário
  //para verificação
  date1 := formatdatetime('yyyy/mm/dd',data1);
  date2 := formatdatetime('yyyy/mm/dd',data2);
  for i := 0 to length(Filmes_Devolver)-1 do
    begin
      data := StrToDate(filmes_devolver[i].dataLoc);
      date := formatdatetime('yyyy/mm/dd',data);
      if (date >= date1)and(date <= date2)
        then begin
               funci := filmes_devolver[i].funcionario;
               delete(funci,1,3);
               cod_func := StrToInt(funci);
               dec(cod_func);
               vetor_quant[cod_func].total := vetor_quant[cod_func].total + 1;
             end;
    end;
  EscreveGrafico(vetor_quant);
end;

end.
