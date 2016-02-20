unit Unit_Biblioteca;

interface

//biliotecas usadas
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.Menus, Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls, Vcl.ActnMenus, Vcl.ExtDlgs,
  Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.Buttons, StrUtils, DateUtils, Vcl.Grids;

//registros criados

type locadora = record
                  Nome, Razao, Incricao, CNPJ : string;
                  endereco, telefone, email, multa : string;
                  NomeResponsavel, TelefoneResponsavel : string;
                end;

type cliente = record
                 codigo, nome, endereco, cpf : string;
                 telefone, email,sexo, estado, nascimento : string;
                 ativo : boolean;
               end;

type filme = record
               codigo,descricao,exemplares,codcat,lingua, preco : string;
               ativo : boolean;
               vezes : integer;
             end;


type categoria = record
                   codigo, valor, descricao : string;
                   ativo : boolean;
                 end;

type funcionario = record
                     codigo,nome,cargo,email,endereco,telefone:string;
                     ativo : boolean;
                     total : integer;
                   end;

type fornecedor = record
                    codigo,nome,razao,inscricao,cnpj,email,endereco,telefone : string;
                    ativo : boolean;
                  end;

type devolver = record
                  dataLoc, DataDev, codFilmes, CodCliente, tipo, funcionario : string;
                  devolvido : boolean;
                end;

type receber = record
                 Cod_Cliente : string;
                 parcela : string;
                 pago : boolean;
                 data : string;
                 pagamento : string;
               end;

type comprar = record
                 descricao : string;
                 preco : real;
                 quant : integer;
                 total : real;
                 codcat : string;
                 lingua  :string;
               end;

type pagar = record
               cod_forn : string;
               data_compra : string;
               valor : string;
               paga : boolean;
               data_venc : string;
               data_pag : string;
             end;

//sub-rotinas
procedure AbreArquivoLeitura;
procedure AbreArquivoGravacao;
procedure MemoriaLocadora;
procedure MemoriaCliente;
procedure MemoriaFilme;
procedure MemoriaCategoria;
procedure MemoriaFuncionario;
procedure MemoriaFornecedores;
procedure MemoriaPagar;
function LerDados(texto:string):string;
function LerTag(texto:string):string;
function GeraCodigoCliente:string;
function GeraCodigoFilme:string;
function GeraCodigoCategoria:string;
function GeraCodigoFuncionario:string;
function GeraCodigoFornecedores:string;
procedure GravaCliente(cli : cliente);
procedure GravaLocadora(loc : locadora);
procedure GravaClienteVetor(cli : cliente);
procedure GravaFilme(film : filme);
procedure GravaFilmeVetor(film : filme);
procedure GravarCategoria(cat : categoria);
procedure GravaCategoriaVetor(cat : categoria);
procedure GravaFuncionarioVetor(func:funcionario);
procedure GravaFuncionario(func:funcionario);
procedure GravaFornecedorVetor(forn:fornecedor);
procedure GravaFornecedor(forn:fornecedor);
procedure GravaContasPagar(pag:pagar);
procedure GravaContasPagarVetor(pag:pagar);
procedure RealizaLocacao(total,cliente,funcionario,pagamento,entrada,pagamentoEntrada,ValorParcela:string;quant_Parcelas,quant_Locado:integer);
procedure EditaNoArquivo;
procedure EditaVetorCliente(linha:integer;cli:cliente);
procedure IniciaArquivoEditar;
procedure EditarFilmes(linha:integer;film:filme);
procedure EditarCategoria(linha:integer;cat:categoria);
procedure EditarFuncionario(linha:integer;func:funcionario);
procedure EditarFornecedor(linha:integer;forn:fornecedor);
procedure ExcluiCliente(linha:integer);
procedure ExcluiFilme(linha:integer);
procedure ExcluiCategoria(linha:integer);
procedure ExcluiFuncionario(linha:integer);
procedure ExcluiFornecedor(linha:integer);
procedure Locacao1(quant_Parcelas,pos:integer;valorParcela:string);
procedure IncQuantLocadoFunc(pos,quant_locado:integer);
procedure Devolver_Filme(cod_filme,cod_cliente,tipo,funcionario:string);
function Busca_filme(cod_filme:string):integer;
function PodeAlugarFilme(cod_filme:string):boolean;
procedure MemoriaContasReceber;
procedure MemoriaDevolver;
function BuscaDevolucao(dev:devolver):integer;
procedure RealizaDevolucao(dev:devolver;pos_vetor:integer;var totalMulta:real);
function VerificaMulta(dev:devolver):integer;
procedure RealizaPagamento(rec:receber;pos_vetor:integer);
procedure PassaVetorComprar(comp:comprar);
procedure DeletaFilmeCompra(linha:integer);
function FilmeExiste(descricao,codcat,lingua:string):integer;
procedure CompraFilme(imp,fre:real);
procedure ContasPagar(quant:integer;fornecedor,ValorParcela:string);
procedure GeraNotaFiscalEntrada(fornece,frete,imposto,total:string);
procedure PagarParcela(posicao : integer);
procedure ExportaDados(opcao:integer;caminho:string);
procedure ImportaLocadora(caminho:string);
procedure ImportaCliente(caminho:string);
procedure ImportaFuncionarios(caminho:string);
procedure ImportaFornecedores(caminho:string);
procedure ImportaCategorias(caminho:string);
procedure ImportaFilmes(caminho:string);
procedure ImportaContasReceber(caminho:string);
procedure ImportaDevolucoes(caminho:string);
procedure ImportaContasPagar(caminho:string);

//variaaveis
var
  Arquivo, arq : TextFile;
  loc : locadora;
  film : filme;
  cli : cliente;
  cat : categoria;
  func : funcionario;
  forn : fornecedor;
  dev : devolver;
  rec : receber;
  comp : comprar;
  pag : pagar;
  filmes : array of filme;
  clientes : array of cliente;
  categorias : array of categoria;
  funcionarios : array of funcionario;
  fornecedores : array of fornecedor;
  Contas_Receber : array of receber;
  Filmes_Devolver : array of devolver;
  Filme_Comprar : array of comprar;
  Contas_Pagar : array of pagar;
  linha, texto, CodCliente : string;
  TotalLocado : integer;
  caixa : real;

implementation

procedure AbreArquivoGravacao;
var
  localizacao : string;
  posi : integer;
begin
  //localizacao := GetCurrentDir;
  localizacao := ExtractFilePath(Application.ExeName);
  posi := pos('\Win32\Debug',localizacao);
  delete(localizacao,posi,length(localizacao));
  {$I-}
  Reset(Arquivo);//abre o arquivo para leitura
  {$I+}
  if ioresult = 2
    then Rewrite(Arquivo)//se o arquivo não existe cria um
    else begin
           CloseFile(Arquivo);//se o arquivo existe fecha ele
           Append(Arquivo);//abre o arquivo para gravacao
         end;
end;

procedure AbreArquivoLeitura;
var
  localizacao : string;
  posi : integer;
begin
  localizacao := ExtractFilePath(Application.ExeName);
  posi := pos('\Win32\Debug',localizacao);
  delete(localizacao,posi,length(localizacao));
  AssignFile(Arquivo, localizacao+'\Arquivo.xml');
  {$I-}
  Reset(Arquivo);//abre o arquivo para leitura
  {$I+}
  if ioresult = 2
    then Rewrite(Arquivo)//se o arquivo não existe cria um
end;

procedure GravaLocadora(loc : locadora);
begin
  writeln(Arquivo,#9#9'<registro>');
  writeln(Arquivo,#9#9#9'<NomeFantasiaLocadora>',loc.Nome,'</NomefantasiaLocadora>');
  writeln(Arquivo,#9#9#9'<RazaoSocialLocadora>',loc.Razao,'</RazaoSocialLocadora>');
  writeln(Arquivo,#9#9#9'<IncricaoEstadualLocadora>',loc.Incricao,'</IncricaoEstadualLocadora>');
  writeln(Arquivo,#9#9#9'<CNPJLocadora>',loc.CNPJ,'</CNPJLocadora>');
  writeln(Arquivo,#9#9#9'<EnderecoLocadora>',loc.endereco,'</EnderecoLocadora>');
  writeln(Arquivo,#9#9#9'<TelefoneLocadora>',loc.telefone,'</TelefoneLocadora>');
  writeln(Arquivo,#9#9#9'<EmailLocadora>',loc.email,'</EmailLocadora>');
  writeln(Arquivo,#9#9#9'<MultaLocadora>',loc.multa,'</MultaLocadora>');
  writeln(Arquivo,#9#9#9'<NomeResponsavelLocadora>',loc.NomeResponsavel,'</NomeResponsavelLocadora>');
  writeln(Arquivo,#9#9#9'<TelefoneResponsavelLocadora>',loc.TelefoneResponsavel,'</TelefoneResponsavelLocadora>');
  writeln(Arquivo,#9#9#9'<Caixa>',caixa:0:2,'</Caixa>');
  writeln(Arquivo,#9#9#9'<TotalLocado>',totalLocado,'</TotalLocado>');
  writeln(Arquivo,#9#9'</registro>');
end;

procedure GravaCliente(cli : cliente);
begin
  writeln(Arquivo,#9#9'<registro>');
  writeln(Arquivo,#9#9#9'<CodigoCliente>',cli.codigo,'</CodigoCliente>');
  writeln(Arquivo,#9#9#9'<NomeCliente>',cli.nome,'</NomeCliente>');
  writeln(Arquivo,#9#9#9'<EnderecoCliente>',cli.endereco,'</EnderecoCliente>');
  writeln(Arquivo,#9#9#9'<CPFCliente>',cli.cpf,'</CPFCliente>');
  writeln(Arquivo,#9#9#9'<TelefoneCliente>',cli.telefone,'</TelefoneCliente>');
  writeln(Arquivo,#9#9#9'<EmailCliente>',cli.email,'</EmailCliente>');
  writeln(Arquivo,#9#9#9'<SexoCliente>',cli.sexo,'</SexoCliente>');
  writeln(Arquivo,#9#9#9'<EstadoCivilCliente>',cli.estado,'</EstadoCivilCliente>');
  writeln(Arquivo,#9#9#9'<NascimentoCliente>',cli.nascimento,'</NascimentoCliente>');
  writeln(Arquivo,#9#9#9'<DeleteCliente>',cli.ativo,'</DeleteCliente>');
  writeln(Arquivo,#9#9'</registro>');
end;

function LerDados(texto:string):string;
begin
  delete(texto,1,pos('>',texto));
  result := copy(texto,1,(pos('<',texto))-1);
end;

function LerTag(texto:string):string;
begin
  result := copy(texto,1,pos('>',texto));
end;

procedure MemoriaLocadora;
var
  PodeParar : boolean;
  tag, caixastr : string;
  posi : integer;
begin
  AbreArquivoLeitura;
  if ioresult=0
    then begin
           while not(eof(Arquivo)) do
             begin
               PodeParar := false;
               readln(Arquivo,texto);
               tag := LerTag(texto);
               if tag = #9'<tabela = locadora>'
                 then begin
                        while tag <> #9'</tabela>' do
                          begin
                            tag := LerTag(texto);
                            readln(Arquivo,texto);
                            if tag = #9#9'<registro>'
                              then begin
                                     while tag <> #9#9'</registro>' do
                                       begin
                                         tag := LerTag(texto);
                                         case AnsiIndexStr(tag,[#9#9#9'<NomeFantasiaLocadora>',#9#9#9'<RazaoSocialLocadora>',
                                         #9#9#9'<IncricaoEstadualLocadora>',#9#9#9'<CNPJLocadora>',#9#9#9'<EnderecoLocadora>',
                                         #9#9#9'<TelefoneLocadora>',#9#9#9'<EmailLocadora>',#9#9#9'<MultaLocadora>',
                                         #9#9#9'<NomeResponsavelLocadora>',#9#9#9'<TelefoneResponsavelLocadora>',#9#9#9'<Caixa>',
                                         #9#9#9'<TotalLocado>']) of
                                           0 : loc.Nome := LerDados(texto);
                                           1 : loc.Razao := LerDados(texto);
                                           2 : loc.Incricao := LerDados(texto);
                                           3 : loc.CNPJ := LerDados(texto);
                                           4 : loc.endereco := LerDados(texto);
                                           5 : loc.telefone := LerDados(texto);
                                           6 : loc.email := LerDados(texto);
                                           7 : loc.multa := LerDados(texto);
                                           8 : loc.NomeResponsavel := LerDados(texto);
                                           9 : loc.TelefoneResponsavel := LerDados(texto);
                                           10 : begin
                                                  caixastr := LerDados(texto);
                                                  posi := pos('.',caixastr);
                                                  caixastr[posi] := ',';
                                                  caixa := StrToFloat(caixastr);
                                                  //caixa := StrToFloat(LerDados(texto));
                                                end;
                                           11 : totalLocado := StrToInt(LerDados(texto));
                                         end;
                                       readln(Arquivo,texto);
                                   end;
                            end;
                          end;
                        PodeParar := true;
                      end;
               if PodeParar
                 then Break;
             end;
         end;
  CloseFile(Arquivo);
end;

procedure MemoriaCliente;
var
  pos : integer;
  tag : string;
 // i : integer;
begin
  AbreArquivoLeitura;
  if ioresult = 0
    then begin
           while not(eof(Arquivo)) do
             begin
               readln(Arquivo,texto);
               tag := LerTag(texto);
               if tag = #9'<tabela = cliente>'
                 then begin
                        while tag <> #9'</tabela>' do
                          begin
                            tag := LerTag(texto);
                            readln(Arquivo,texto);
                            if tag = #9#9'<registro>'
                              then begin
                                     SetLength(clientes,Length(clientes)+1);
                                     while tag <> #9#9'</registro>' do
                                       begin
                                         tag := LerTag(texto);
                                         pos := length(clientes) - 1;
                                         case AnsiIndexStr(tag,[#9#9#9'<CodigoCliente>',#9#9#9'<NomeCliente>',#9#9#9'<EnderecoCliente>',
                                         #9#9#9'<CPFCliente>',#9#9#9'<TelefoneCliente>',#9#9#9'<EmailCliente>',#9#9#9'<SexoCliente>',
                                         #9#9#9'<EstadoCivilCliente>',#9#9#9'<NascimentoCliente>',#9#9#9'<DeleteCliente>'//,
                                         {#9#9#9'<Locacoes>',#9#9#9'<Devoluções>'}]) of
                                           0 : clientes[pos].codigo := LerDados(texto);
                                           1 : clientes[pos].nome := LerDados(texto);
                                           2 : clientes[pos].endereco := LerDados(texto);
                                           3 : clientes[pos].cpf := LerDados(texto);
                                           4 : clientes[pos].telefone := LerDados(texto);
                                           5 : clientes[pos].email := LerDados(texto);
                                           6 : clientes[pos].sexo := LerDados(texto);
                                           7 : clientes[pos].estado := LerDados(texto);
                                           8 : clientes[pos].nascimento := LerDados(texto);
                                           9 : begin
                                                 if LerDados(texto) = 'FALSE'
                                                   then clientes[pos].ativo := false
                                                   else clientes[pos].ativo := true;
                                               end;
                                         end;
                                         readln(Arquivo,texto);
                                       end;
                               end;
                          end;
                      end;
             end;
         end;
  CloseFile(Arquivo);
end;

function GeraCodigoCliente:string;
var
  cod : integer;
begin
  cod := Length(Clientes);
  inc(cod);
  if cod < 10 then
  result := 'C00000' + IntToStr(cod)
  else if cod >= 10 then
  result := 'C0000' + IntToStr(cod)
  else if cod >= 100 then
  result := 'C000' + IntToStr(cod)
  else if cod >= 1000 then
  result := 'C00' + IntToStr(cod)
  else if cod >= 10000 then
  result := 'C0' + IntToStr(cod)
  else if cod >= 100000 then
  result := 'C' + IntToStr(cod);
end;

procedure GravaClienteVetor(cli : cliente);
begin
  SetLength(clientes, length(clientes)+1);
  clientes[length(clientes)-1].codigo := cli.codigo;
  clientes[length(clientes)-1].nome := cli.nome;
  clientes[length(clientes)-1].endereco := cli.endereco;
  clientes[length(clientes)-1].cpf := cli.cpf;
  clientes[length(clientes)-1].telefone := cli.telefone;
  clientes[length(clientes)-1].email := cli.email;
  clientes[length(clientes)-1].sexo := cli.sexo;
  clientes[length(clientes)-1].estado := cli.estado;
  clientes[length(clientes)-1].nascimento := cli.nascimento;
  clientes[length(clientes)-1].ativo := cli.ativo;
end;

procedure GravaFilme(film : filme);
begin
  writeln(Arquivo,#9#9'<registro>');
  writeln(Arquivo,#9#9#9'<CodigoFilme>',film.codigo,'</CodigoFilme>');
  writeln(Arquivo,#9#9#9'<DescricaoFilme>',film.descricao,'</DescricaoFilme>');
  writeln(Arquivo,#9#9#9'<ExemplaresFilme>',film.exemplares,'</ExemplaresFilme>');
  writeln(Arquivo,#9#9#9'<CodCatFilme>',film.CodCat,'</CodCatFilme>');
  writeln(Arquivo,#9#9#9'<LinguaFilme>',film.lingua,'</LinguaFilme>');
  writeln(Arquivo,#9#9#9'<PrecoFilme>',film.preco,'</PrecoFilme>');
  writeln(Arquivo,#9#9#9'<DeleteFilme>',film.ativo,'</DeleteFilme>');
  writeln(Arquivo,#9#9#9'<VezesFilme>',film.vezes,'</VezesFilme>');
  writeln(Arquivo,#9#9'</registro>');
end;

procedure GravaFilmeVetor(film : filme);
begin
  SetLength(filmes, length(filmes)+1);
  filmes[length(filmes)-1].codigo := film.codigo;
  filmes[length(filmes)-1].descricao := film.descricao;
  filmes[length(filmes)-1].exemplares := film.exemplares;
  filmes[length(filmes)-1].codcat := film.codcat;
  filmes[length(filmes)-1].lingua := film.lingua;
  filmes[length(filmes)-1].ativo := film.ativo;
  filmes[length(filmes)-1].preco := film.preco;
  filmes[length(filmes)-1].vezes := film.vezes;
end;

procedure MemoriaFilme;
var
  pos : integer;
  tag : string;
begin
  AbreArquivoLeitura;
  if ioresult = 0
    then begin
           while not(eof(Arquivo)) do
             begin
               readln(Arquivo,texto);
               tag := LerTag(texto);
               if tag = #9'<tabela = filme>'
                 then begin
                        while tag <> #9'</tabela>' do
                          begin
                            tag := LerTag(texto);
                            readln(Arquivo,texto);
                            if tag = #9#9'<registro>'
                              then begin
                                     SetLength(Filmes,Length(filmes)+1);
                                     while tag <> #9#9'</registro>' do
                                       begin
                                         tag := LerTag(texto);
                                         pos := Length(filmes)-1;
                                         case AnsiIndexStr(tag,[#9#9#9'<CodigoFilme>',#9#9#9'<DescricaoFilme>',
                                         #9#9#9'<ExemplaresFilme>',#9#9#9'<CodCatFilme>',#9#9#9'<LinguaFilme>',
                                         #9#9#9'<DeleteFilme>',#9#9#9'<PrecoFilme>',#9#9#9'<VezesFilme>']) of
                                           0 : filmes[pos].codigo := LerDados(texto);
                                           1 : filmes[pos].descricao := LerDados(texto);
                                           2 : filmes[pos].exemplares := LerDados(texto);
                                           3 : filmes[pos].codcat := LerDados(texto);
                                           4 : filmes[pos].lingua := LerDados(texto);
                                           5 : begin
                                                 if LerDados(texto) = 'FALSE'
                                                   then filmes[pos].ativo := false
                                                   else filmes[pos].ativo := true;
                                               end;
                                           6 : filmes[pos].preco := LerDados(texto);
                                           7 : filmes[pos].vezes := StrToInt(LerDados(texto));
                                         end;
                                         readln(Arquivo,texto);
                                   end;
                            end;
                          end;
                      end;
             end;
         end;
  CloseFile(Arquivo);
end;

function GeraCodigoFilme:string;
var
  cod : integer;
begin
  cod := Length(Filmes);
  inc(cod);
  if cod < 10 then
  result := 'F00000' + IntToStr(cod)
  else if cod >= 10 then
  result := 'F0000' + IntToStr(cod)
  else if cod >= 100 then
  result := 'F000' + IntToStr(cod)
  else if cod >= 1000 then
  result := 'F00' + IntToStr(cod)
  else if cod >= 10000 then
  result := 'F0' + IntToStr(cod)
  else if cod >= 100000 then
  result := 'F' + IntToStr(cod);
end;

procedure GravarCategoria(cat : categoria);
begin
  writeln(Arquivo,#9#9'<registro>');
  writeln(Arquivo,#9#9#9'<CodigoCategoria>',cat.codigo,'</CodigoCategoria>');
  writeln(Arquivo,#9#9#9'<ValorCategoria>',cat.valor,'</ValorCategoria>');
  writeln(Arquivo,#9#9#9'<DescricaoCategoria>',cat.descricao,'</DescricaoCategoria>');
  writeln(Arquivo,#9#9#9'<DeleteCategoria>',cat.ativo,'</DeleteCategoria>');
  writeln(Arquivo,#9#9'</registro>');
end;

procedure GravaCategoriaVetor(cat : categoria);
begin
  SetLength(Categorias,length(categorias)+1);
  categorias[length(categorias)-1].codigo := cat.codigo;
  categorias[length(categorias)-1].valor := cat.valor;
  categorias[length(categorias)-1].descricao := cat.descricao;
  categorias[length(categorias)-1].ativo := false;
end;

procedure MemoriaCategoria;
var
  tag : string;
  pos : integer;
begin
  AbreArquivoLeitura;
  if ioresult = 0
    then begin
           while not(eof(Arquivo)) do
             begin
               readln(Arquivo,texto);
               tag := LerTag(texto);
               if tag = #9'<tabela = categoria>'
                 then begin
                        while tag <> #9'</tabela>' do
                          begin
                            tag := LerTag(texto);
                            readln(Arquivo,texto);
                            if tag = #9#9'<registro>'
                              then begin
                                     SetLength(Categorias,length(categorias)+1);
                                     while tag <> #9#9'</registro>' do
                                       begin
                                         tag := LerTag(texto);
                                         pos := Length(categorias)-1;
                                         case AnsiIndexStr(tag,[#9#9#9'<CodigoCategoria>',#9#9#9'<ValorCategoria>',
                                         #9#9#9'<DescricaoCategoria>',#9#9#9'<DeleteCategoria>']) of
                                           0 : categorias[pos].codigo := LerDados(texto);
                                           1 : categorias[pos].valor := LerDados(texto);
                                           2 : categorias[pos].descricao := LerDados(texto);
                                           3 : begin
                                                 if LerDados(texto) = 'FALSE'
                                                   then categorias[pos].ativo := false
                                                   else categorias[pos].ativo := true;
                                               end;
                                         end;
                                         readln(Arquivo,texto);
                                       end;
                                   end;
                          end;
                      end;
             end;
         end;
  CloseFile(Arquivo);
end;

function GeraCodigoCategoria:string;
var
  cod : integer;
begin
  cod := Length(categorias);
  inc(cod);
  if cod < 9 then
  result := 'CAT00000' + IntToStr(cod)
  else if cod >= 10 then
  result := 'CAT0000' + IntToStr(cod)
  else if cod >= 100 then
  result := 'CAT000' + IntToStr(cod)
  else if cod >= 1000 then
  result := 'CAT00' + IntToStr(cod)
  else if cod >= 10000 then
  result := 'CAT0' + IntToStr(cod)
  else if cod  >= 100000 then
  result := 'CAT' + IntToStr(cod);
end;

procedure GravaFuncionarioVetor(func:funcionario);
begin
  setlength(funcionarios,length(funcionarios)+1);
  funcionarios[length(funcionarios)-1].codigo := func.codigo;
  funcionarios[length(funcionarios)-1].nome := func.nome;
  funcionarios[length(funcionarios)-1].cargo := func.cargo;
  funcionarios[length(funcionarios)-1].email := func.email;
  funcionarios[length(funcionarios)-1].endereco := func.endereco;
  funcionarios[length(funcionarios)-1].telefone := func.telefone;
  funcionarios[length(funcionarios)-1].ativo := false;
  funcionarios[length(funcionarios)-1].total := 0;
end;

procedure GravaFuncionario(func:funcionario);
begin
  writeln(Arquivo,#9#9'<registro>');
  writeln(Arquivo,#9#9#9'<CodigoFuncionario>',func.codigo,'</CodigoFuncionario>');
  writeln(Arquivo,#9#9#9'<NomeFuncionario>',func.nome,'</NomeFuncionario>');
  writeln(Arquivo,#9#9#9'<CargoFuncionario>',func.cargo,'</CargoFuncionario>');
  writeln(Arquivo,#9#9#9'<EmailFuncionario>',func.email,'</EmailFuncionario>');
  writeln(Arquivo,#9#9#9'<EnderecoFuncionario>',func.endereco,'</EnderecoFuncionario>');
  writeln(Arquivo,#9#9#9'<TelefoneFuncionario>',func.telefone,'</TelefoneFuncionario>');
  writeln(Arquivo,#9#9#9'<DeleleFuncionario>',func.ativo,'</DeleleFuncionario>');
  writeln(Arquivo,#9#9#9'<TotalLocado>',func.total,'</TotalLocado>');
  writeln(Arquivo,#9#9'</registro>');
end;

procedure MemoriaFuncionario;
var
  tag : string;
  pos : integer;
begin
  AbreArquivoLeitura;
  if ioresult = 0
    then begin
           while not(eof(Arquivo)) do
             begin
               readln(Arquivo,texto);
               tag := LerTag(texto);
               if tag = #9'<tabela = funcionario>'
                 then begin
                        while tag <> #9'</tabela>' do
                          begin
                            tag := LerTag(texto);
                            readln(Arquivo,texto);
                            if tag = #9#9'<registro>'
                              then begin
                                     SetLength(funcionarios,length(funcionarios)+1);
                                     while tag <> #9#9'</registro>' do
                                       begin
                                         tag := LerTag(texto);
                                         pos := Length(funcionarios)-1;
                                         case AnsiIndexStr(tag,[#9#9#9'<CodigoFuncionario>',#9#9#9'<NomeFuncionario>',
                                         #9#9#9'<CargoFuncionario>',#9#9#9'<EmailFuncionario>',#9#9#9'<EnderecoFuncionario>',
                                         #9#9#9'<TelefoneFuncionario>',#9#9#9'<DeleleFuncionario>',#9#9#9'<TotalLocado>']) of
                                           0 : Funcionarios[pos].codigo := LerDados(texto);
                                           1 : Funcionarios[pos].nome := LerDados(texto);
                                           2 : Funcionarios[pos].cargo := LerDados(texto);
                                           3 : Funcionarios[pos].email := LerDados(texto);
                                           4 : Funcionarios[pos].endereco := LerDados(texto);
                                           5 : Funcionarios[pos].telefone := LerDados(texto);
                                           6 : begin
                                                 if LerDados(texto) = 'FALSE'
                                                   then funcionarios[pos].ativo := false
                                                   else funcionarios[pos].ativo := true;
                                               end;
                                           7 : Funcionarios[pos].total := StrToInt(LerDados(texto));
                                         end;
                                         readln(arquivo,texto);
                                       end;
                                   end;
                          end;
                      end;
             end;
         end;
  CloseFile(Arquivo);
end;

function GeraCodigoFuncionario:string;
var
  cod : integer;
begin
  cod := Length(funcionarios);
  inc(cod);
  if cod < 10 then
  result := 'FUN00000' + IntToStr(cod)
  else if cod >= 10 then
  result := 'FUN0000' + IntToStr(cod)
  else if cod >= 100 then
  result := 'FUN000' + IntToStr(cod)
  else if cod >= 1000 then
  result := 'FUN00' + IntToStr(cod)
  else if cod >= 10000 then
  result := 'FUN0' + IntToStr(cod)
  else if cod >= 100000 then
  result := 'FUN' + IntToStr(cod);
end;

procedure GravaFornecedor(forn:fornecedor);
begin
  writeln(Arquivo,#9#9'<registro>');
  writeln(Arquivo,#9#9#9'<CodigoFornecedor>',forn.codigo,'</CodigoFornecedor>');
  writeln(Arquivo,#9#9#9'<NomeFornecedor>',forn.nome,'</NomeFornecedor>');
  writeln(Arquivo,#9#9#9'<RazaoFornecedor>',forn.razao,'</RazaoFornecedor>');
  writeln(Arquivo,#9#9#9'<InscricaoFornecedor>',forn.inscricao,'</InscricaoFornecedor>');
  writeln(Arquivo,#9#9#9'<CNPJFornecedor>',forn.cnpj,'</CNPJFornecedor>');
  writeln(Arquivo,#9#9#9'<EmailFornecedor>',forn.email,'</EmailFornecedor>');
  writeln(Arquivo,#9#9#9'<EnderecoFornecedor>',forn.endereco,'</EnderecoFornecedor>');
  writeln(Arquivo,#9#9#9'<TelefoneFornecedor>',forn.telefone,'</TelefoneFornecedor>');
  writeln(Arquivo,#9#9#9'<DeleteFornecedor>',forn.ativo,'</DeleteFornecedor>');
  writeln(Arquivo,#9#9'</registro>');
end;

procedure GravaFornecedorVetor(forn:fornecedor);
begin
  SetLength(Fornecedores,Length(fornecedores)+1);
  fornecedores[length(fornecedores)-1].codigo := forn.codigo;
  fornecedores[length(fornecedores)-1].nome := forn.nome;
  fornecedores[length(fornecedores)-1].razao := forn.razao;
  fornecedores[length(fornecedores)-1].inscricao := forn.inscricao;
  fornecedores[length(fornecedores)-1].cnpj := forn.cnpj;
  fornecedores[length(fornecedores)-1].email := forn.email;
  fornecedores[length(fornecedores)-1].endereco := forn.endereco;
  fornecedores[length(fornecedores)-1].telefone := forn.telefone;
  fornecedores[length(fornecedores)-1].ativo := false;
end;

procedure MemoriaFornecedores;
var
  tag : string;
  pos : integer;
begin
  AbreArquivoLeitura;
  if ioresult = 0
    then begin
           while not(eof(Arquivo)) do
             begin
               readln(Arquivo,texto);
               tag := LerTag(texto);
               if tag = #9'<tabela = fornecedor>'
                 then begin
                        while tag <> #9'</tabela>' do
                          begin
                            tag := LerTag(texto);
                            readln(Arquivo,texto);
                            if tag = #9#9'<registro>'
                              then begin
                                     SetLength(fornecedores,length(fornecedores)+1);
                                     while tag <> #9#9'</registro>' do
                                       begin
                                         tag := LerTag(texto);
                                         pos := length(fornecedores)-1;
                                         case AnsiIndexStr(tag,[#9#9#9'<CodigoFornecedor>',#9#9#9'<NomeFornecedor>',
                                         #9#9#9'<RazaoFornecedor>',#9#9#9'<InscricaoFornecedor>',#9#9#9'<CNPJFornecedor>',
                                         #9#9#9'<EmailFornecedor>',#9#9#9'<EnderecoFornecedor>',#9#9#9'<TelefoneFornecedor>',
                                         #9#9#9'<DeleteFornecedor>']) of
                                           0 : fornecedores[pos].codigo := LerDados(texto);
                                           1 : fornecedores[pos].nome := LerDados(texto);
                                           2 : fornecedores[pos].razao := LerDados(texto);
                                           3 : fornecedores[pos].inscricao := LerDados(texto);
                                           4 : fornecedores[pos].cnpj := LerDados(texto);
                                           5 : fornecedores[pos].email := LerDados(texto);
                                           6 : fornecedores[pos].endereco := LerDados(texto);
                                           7 : fornecedores[pos].telefone := LerDados(texto);
                                           8 : begin
                                                 if LerDados(texto) = 'FALSE'
                                                   then fornecedores[pos].ativo := false
                                                   else fornecedores[pos].ativo := true;
                                               end;
                                         end;
                                         readln(Arquivo,texto);
                                       end;
                                   end;
                          end;
                      end;
             end;
         end;
  CloseFile(Arquivo);
end;

function GeraCodigoFornecedores:string;
var
  cod : integer;
begin
  cod := Length(fornecedores);
  inc(cod);
  if cod < 10 then
  result := 'FOR00000' + IntToStr(cod)
  else if cod >= 10 then
  result := 'FOR0000' + IntToStr(cod)
  else if cod >= 100 then
  result := 'FOR000' + IntToStr(cod)
  else if cod >= 1000 then
  result := 'FOR00' + IntToStr(cod)
  else if cod >= 10000 then
  result := 'FOR0' + IntToStr(cod)
  else if cod >= 100000 then
  result := 'FOR' + IntToStr(cod);
end;

procedure GravaContasReceber(rec:receber);
begin
  writeln(Arquivo,#9#9'<registro>');
  writeln(Arquivo,#9#9#9'<CodigoCliente>',rec.Cod_Cliente,'</CodigoCliente>');
  writeln(Arquivo,#9#9#9'<ValorParcela>',rec.parcela,'</ValorParcela>');
  writeln(Arquivo,#9#9#9'<DataParcela>',rec.data,'</DataParcela>');
  writeln(Arquivo,#9#9#9'<PagaParcela>',rec.pago,'</PagaParcela>');
  writeln(Arquivo,#9#9#9'<DataPagamento>',rec.pagamento,'</DataPagamento>');
  writeln(Arquivo,#9#9'</registro>');
end;

procedure GravaContasReceberVetor(rec:receber);
begin
  Setlength(Contas_receber,length(contas_receber)+1);
  contas_receber[length(contas_receber)-1].Cod_Cliente := rec.Cod_Cliente;
  contas_receber[length(contas_receber)-1].parcela := rec.parcela;
  contas_receber[length(contas_receber)-1].pago := rec.pago;
  contas_receber[length(contas_receber)-1].data := rec.data;
  contas_receber[length(contas_receber)-1].pagamento := rec.pagamento
end;

procedure MemoriaContasReceber;
var
  tag : string;
  pos : integer;
begin
  AbreArquivoLeitura;
  if ioresult = 0
    then begin
           while not(eof(Arquivo)) do
             begin
               readln(Arquivo,texto);
               tag := LerTag(texto);
               if tag = #9'<tabela = contas_receber>'
                 then begin
                        while tag <> #9'</tabela>' do
                          begin
                            tag := LerTag(texto);
                            readln(Arquivo,texto);
                            if tag = #9#9'<registro>'
                              then begin
                                     SetLength(contas_receber,length(contas_receber)+1);
                                     while tag <> #9#9'</registro>' do
                                       begin
                                         tag := LerTag(texto);
                                         pos := length(contas_receber)-1;
                                         case AnsiIndexStr(tag,[#9#9#9'<CodigoCliente>',#9#9#9'<ValorParcela>',
                                         #9#9#9'<DataParcela>',#9#9#9'<PagaParcela>',#9#9#9'<DataPagamento>']) of
                                           0 : contas_receber[pos].Cod_Cliente := LerDados(texto);
                                           1 : contas_receber[pos].parcela := LerDados(texto);
                                           2 : contas_receber[pos].data := LerDados(texto);
                                           3 : begin
                                                 if LerDados(texto) = 'FALSE'
                                                   then contas_receber[pos].pago := false
                                                   else contas_receber[pos].pago := true;
                                               end;
                                           4 : begin
                                                 contas_receber[pos].pagamento := LerDados(texto);
                                               end;
                                         end;
                                         readln(Arquivo,texto);
                                       end;
                                   end;
                          end;
                      end;
             end;
         end;
  CloseFile(Arquivo);
end;

procedure RealizaLocacao(total,cliente,funcionario,pagamento,entrada,pagamentoEntrada,ValorParcela:string;quant_Parcelas,quant_Locado:integer);
var
  pos : integer;
  cli : string;
begin
  cli := cliente;
  delete(cli,1,1);
  pos := StrToInt(cli);
  dec(pos);
  if pagamento = 'A vista'
    then begin
           caixa := caixa + StrToFloat(total);
           IncQuantLocadoFunc(pos,quant_locado);
         end
    else begin
           if entrada = 'Existe Entrada'
             then begin
                    caixa := caixa + StrToFloat(pagamentoEntrada);
                    Locacao1(quant_parcelas,pos,ValorParcela);
                    IncQuantLocadoFunc(pos,quant_locado);
                  end
             else begin
                    Locacao1(quant_Parcelas,pos,ValorParcela);
                    IncQuantLocadoFunc(pos,quant_locado);
                  end;
         end;
end;

procedure Locacao1(quant_Parcelas,pos:integer;valorParcela:string);
var
  data : string;
  i: Integer;
begin
  data := formatdatetime('dd/mm/yyyy',now);
  for i := 1 to quant_Parcelas do
    begin
      SetLength(contas_receber,length(contas_receber)+1);
      contas_receber[length(contas_receber)-1].Cod_Cliente := clientes[pos].codigo;
      contas_receber[length(contas_receber)-1].parcela := Copy(ValorParcela,4,length(ValorParcela));
      contas_receber[length(contas_receber)-1].pago := false;
      contas_receber[length(contas_receber)-1].data := dateToStr(incMonth(StrToDate(data),i));
      contas_receber[length(contas_receber)-1].pagamento := '-';
    end;
end;

procedure GravaDevolucao(dev:devolver);
begin
  writeln(Arquivo,#9#9'<registro>');
  writeln(Arquivo,#9#9#9'<CodCliente>',dev.CodCliente,'</CodCliente>');
  writeln(Arquivo,#9#9#9'<CodFilme>',dev.codFilmes,'</CodFilme>');
  writeln(Arquivo,#9#9#9'<DataLocacao>',dev.dataLoc,'</DataLocacao>');
  writeln(Arquivo,#9#9#9'<DataDevolucao>',dev.DataDev,'</dataDevolucao>');
  writeln(Arquivo,#9#9#9'<TipoLocacao>',dev.tipo,'</TipoLocacao>');
  writeln(Arquivo,#9#9#9'<CodFuncionario>',dev.funcionario,'</CodFuncionario>');
  writeln(Arquivo,#9#9#9'<Devolvido>',dev.devolvido,'</Devolvido>');
  Writeln(Arquivo,#9#9'</registro>');
end;

procedure GravaDevolucaoVetor(dev:devolver);
begin
  SetLength(Filmes_Devolver,Length(Filmes_Devolver)+1);
  filmes_devolver[length(filmes_devolver)-1].CodCliente := dev.CodCliente;
  filmes_devolver[length(filmes_devolver)-1].codFilmes := dev.codFilmes;
  filmes_devolver[length(filmes_devolver)-1].dataLoc := dev.dataLoc;
  filmes_devolver[length(filmes_devolver)-1].DataDev := dev.DataDev;
  filmes_devolver[length(filmes_devolver)-1].devolvido := dev.devolvido;
  filmes_devolver[length(filmes_devolver)-1].tipo := dev.tipo;
  filmes_devolver[length(filmes_devolver)-1].funcionario := dev.funcionario;
end;

procedure Devolver_Filme(cod_filme,cod_cliente,tipo,funcionario:string);
var
  i: Integer;
  data : string;
begin
  for i := 0 to length(filmes)-1 do
    begin
      if filmes[i].codigo = cod_filme
        then begin
               break;
             end;
    end;
  //diminui um nos filmes
  filmes[i].exemplares := IntToStr(StrToInt(filmes[i].exemplares)-1);
  //aumenta um na quantidade locada
  filmes[i].vezes := filmes[i].vezes + 1;
  data := formatdatetime('dd/mm/yyyy',now);
  dev.CodCliente := cod_cliente;
  dev.codFilmes := cod_filme;
  dev.dataLoc := data;
  dev.DataDev := DateToStr(IncDay(StrToDate(data),7));
  dev.devolvido := false;
  dev.tipo := tipo;
  dev.funcionario := funcionario;
  GravaDevolucaoVetor(dev);
  //GravaDevolucao(dev);
  //EditaNoArquivo;
end;

procedure MemoriaDevolver;
var
  tag : string;
  pos : integer;
begin
  AbreArquivoLeitura;
  if ioresult = 0
    then begin
           while not(eof(Arquivo)) do
             begin
               readln(Arquivo,texto);
               tag := LerTag(texto);
               if tag = #9'<tabela = devolucao>'
                 then begin
                        while tag <> #9'</tabela>' do
                          begin
                            tag := LerTag(texto);
                            readln(Arquivo,texto);
                            if tag = #9#9'<registro>'
                              then begin
                                     SetLength(filmes_devolver,length(filmes_devolver)+1);
                                     while tag <> #9#9'</registro>' do
                                       begin
                                         tag := LerTag(texto);
                                         pos := length(filmes_devolver)-1;
                                         case AnsiIndexStr(tag,[#9#9#9'<CodCliente>',#9#9#9'<CodFilme>',
                                         #9#9#9'<DataLocacao>',#9#9#9'<DataDevolucao>',#9#9#9'<Devolvido>',
                                         #9#9#9'<TipoLocacao>',#9#9#9'<CodFuncionario>']) of
                                           0 : Filmes_devolver[pos].CodCliente := LerDados(texto);
                                           1 : Filmes_devolver[pos].codFilmes := LerDados(texto);
                                           2 : Filmes_devolver[pos].dataLoc := LerDados(texto);
                                           3 : Filmes_devolver[pos].DataDev := LerDados(texto);
                                           4 : begin
                                                 if Lerdados(texto) = 'FALSE'
                                                   then Filmes_Devolver[pos].devolvido := false
                                                   else Filmes_Devolver[pos].devolvido := true
                                               end;
                                           5 : Filmes_Devolver[pos].tipo := LerDados(texto);
                                           6 : Filmes_Devolver[pos].funcionario := LerDados(texto);
                                         end;
                                         readln(Arquivo,texto);
                                       end;
                                   end;
                          end;
                      end;
             end;
         end;
  CloseFile(Arquivo);
end;

procedure GravaContasPagar(pag:pagar);
begin
  writeln(Arquivo,#9#9'<registro>');
  writeln(Arquivo,#9#9#9'<CodigoFornecedor>',pag.cod_forn,'</CodigoFornecedor>');
  writeln(Arquivo,#9#9#9'<DataDaCompra>',pag.data_compra,'</DataDaCompra>');
  writeln(Arquivo,#9#9#9'<ValorParcela>',pag.valor,'</ValorParcela>');
  writeln(Arquivo,#9#9#9'<PagaParcela>',pag.paga,'</PagaParcela>');
  writeln(Arquivo,#9#9#9'<DataDeVencimento>',pag.data_venc,'</DataDeVencimento>');
  writeln(Arquivo,#9#9#9'<DataDePagamento>',pag.data_pag,'</DataDePagamento>');
  Writeln(Arquivo,#9#9'</registro>');
end;

procedure GravaContasPagarVetor(pag:pagar);
begin
  Setlength(contas_pagar,length(contas_pagar)+1);
  contas_pagar[length(contas_pagar)-1].cod_forn := pag.cod_forn;
  contas_pagar[length(contas_pagar)-1].data_compra := pag.data_compra;
  contas_pagar[length(contas_pagar)-1].valor := pag.valor;
  contas_pagar[length(contas_pagar)-1].paga := pag.paga;
  contas_pagar[length(contas_pagar)-1].data_venc := pag.data_venc;
  contas_pagar[length(contas_pagar)-1].data_pag := pag.data_pag;
end;

procedure MemoriaPagar;
var
  tag : string;
  pos : integer;
begin
  AbreArquivoLeitura;
  if ioresult = 0
    then begin
           while not(eof(Arquivo)) do
             begin
               readln(Arquivo,texto);
               tag := LerTag(texto);
               if tag = #9'<tabela = contas_pagar>'
                 then begin
                        while tag <> #9'</tabela>' do
                          begin
                            tag := LerTag(texto);
                            readln(Arquivo,texto);
                            if tag = #9#9'<registro>'
                              then begin
                                     SetLength(contas_Pagar,length(contas_pagar)+1);
                                     while tag <> #9#9'</registro>' do
                                       begin
                                         tag := LerTag(texto);
                                         pos := length(contas_pagar)-1;
                                         case AnsiIndexStr(tag,[#9#9#9'<CodigoFornecedor>',#9#9#9'<DataDaCompra>',
                                         #9#9#9'<ValorParcela>',#9#9#9'<PagaParcela>',#9#9#9'<DataDeVencimento>',
                                         #9#9#9'<DataDePagamento>']) of
                                           0 : contas_pagar[pos].cod_forn := LerDados(texto);
                                           1 : contas_pagar[pos].data_compra := LerDados(texto);
                                           2 : contas_pagar[pos].valor := LerDados(texto);
                                           3 : begin
                                                 if Lerdados(texto) = 'FALSE'
                                                   then contas_pagar[pos].paga := false
                                                   else contas_pagar[pos].paga := true
                                               end;
                                           4 : contas_pagar[pos].data_venc := LerDados(texto);
                                           5 : contas_pagar[pos].data_pag := LerDados(texto);
                                         end;
                                         readln(Arquivo,texto);
                                       end;
                                   end;
                          end;
                      end;
             end;
         end;
  CloseFile(Arquivo);
end;

function PodeAlugarFilme(cod_filme:string):boolean;
var
  pos : integer;
begin
  delete(cod_filme,1,1);
  pos := StrToInt(cod_filme)-1;
  if StrToInt(filmes[pos].exemplares) = 0
    then result := true
    else result := false;
end;

function Busca_filme(cod_filme:string):integer;
var
  i: Integer;
begin
  result := 0;
  for i := 0 to length(filmes)-1 do
    begin
      if cod_filme = filmes[i].codigo
        then begin
               result := i;
               break;
             end;
    end;
end;

procedure IniciaArquivoEditar;
var
  localizacao : string;
  posi : integer;
begin
  //localizacao := GetCurrentDir;
  localizacao := ExtractFilePath(Application.ExeName);
  posi := pos('\Win32\Debug',localizacao);
  delete(localizacao,posi,length(localizacao));
  localizacao := localizacao + '\Arquivo.xml';
  AssignFile(Arquivo, localizacao);//vincula o arquino numa variavel
  Rewrite(Arquivo);
end;

procedure EditaNoArquivo;
var
  I: Integer;
begin
  IniciaArquivoEditar;
  //escreve nova locadora no vetor
  writeln(Arquivo,'<dados>');
  writeln(Arquivo,#9'<tabela = locadora>');
  GravaLocadora(loc);
  writeln(Arquivo,#9'</tabela>');
  //escreve o vetor cliente
  writeln(Arquivo,#9'<tabela = cliente>');
  for I := 0 to length(clientes)-1 do
    begin
      cli.codigo := clientes[i].codigo;
      cli.nome := clientes[i].nome;
      cli.endereco := clientes[i].endereco;
      cli.cpf := clientes[i].cpf;
      cli.telefone := clientes[i].telefone;
      cli.email := clientes[i].email;
      cli.sexo := clientes[i].sexo;
      cli.estado := clientes[i].estado;
      cli.nascimento := clientes[i].nascimento;
      cli.ativo := clientes[i].ativo;
      GravaCliente(cli);
    end;
  writeln(Arquivo,#9'</tabela>');
  //escreve o vetor filmes
  writeln(Arquivo,#9'<tabela = filme>');
  for i := 0 to length(filmes)-1 do
    begin
      film.codigo := filmes[i].codigo;
      film.descricao := filmes[i].descricao;
      film.exemplares := filmes[i].exemplares;
      film.codcat := filmes[i].codcat;
      film.lingua := filmes[i].lingua;
      film.ativo := filmes[i].ativo;
      film.preco := filmes[i].preco;
      film.vezes := filmes[i].vezes;
      GravaFilme(film);
    end;
  writeln(Arquivo,#9'</tabela>');
  writeln(Arquivo,#9'<tabela = categoria>');
  for i := 0 to length(categorias)-1 do
    begin
      cat.codigo := categorias[i].codigo;
      cat.valor := categorias[i].valor;
      cat.descricao := categorias[i].descricao;
      cat.ativo := categorias[i].ativo;
      GravarCategoria(cat);
    end;
  writeln(Arquivo,#9'</tabela>');
  writeln(Arquivo,#9'<tabela = funcionario>');
  for i := 0 to length(funcionarios)-1 do
    begin
      func.codigo := funcionarios[i].codigo;
      func.nome := funcionarios[i].nome;
      func.cargo := funcionarios[i].cargo;
      func.email := funcionarios[i].email;
      func.endereco := funcionarios[i].endereco;
      func.telefone := funcionarios[i].telefone;
      func.ativo := funcionarios[i].ativo;
      func.total := funcionarios[i].total;
      GravaFuncionario(func);
    end;
  writeln(Arquivo,#9'</tabela>');
  writeln(Arquivo,#9'<tabela = fornecedor>');
  for i := 0 to length(fornecedores)-1 do
    begin
      forn.codigo := fornecedores[i].codigo;
      forn.nome := fornecedores[i].nome;
      forn.razao := fornecedores[i].razao;
      forn.inscricao := fornecedores[i].inscricao;
      forn.cnpj := fornecedores[i].cnpj;
      forn.email := fornecedores[i].email;
      forn.endereco := fornecedores[i].endereco;
      forn.telefone := fornecedores[i].telefone;
      forn.ativo := fornecedores[i].ativo;
      GravaFornecedor(forn);
    end;
  writeln(Arquivo,#9'</tabela>');
  writeln(Arquivo,#9'<tabela = contas_receber>');
  for i := 0 to length(contas_receber)-1 do
    begin
      rec.Cod_Cliente := contas_receber[i].Cod_Cliente;
      rec.parcela := contas_receber[i].parcela;
      rec.pago := contas_receber[i].pago;
      rec.data := contas_receber[i].data;
      rec.pagamento := contas_receber[i].pagamento;
      GravaContasReceber(rec)
    end;
  writeln(Arquivo,#9'</tabela>');
  writeln(Arquivo,#9'<tabela = devolucao>');
  for i := 0 to length(filmes_devolver)-1 do
    begin
      dev.CodCliente := filmes_devolver[i].CodCliente;
      dev.codFilmes := filmes_devolver[i].codFilmes;
      dev.dataLoc := filmes_devolver[i].dataLoc;
      dev.DataDev := filmes_devolver[i].DataDev;
      dev.devolvido := filmes_devolver[i].devolvido;
      dev.tipo := filmes_devolver[i].tipo;
      dev.funcionario := filmes_devolver[i].funcionario;
      GravaDevolucao(dev);
    end;
  writeln(Arquivo,#9'</tabela>');
  writeln(Arquivo,#9'<tabela = contas_pagar>');
  for i := 0 to length(contas_pagar)-1 do
    begin
      pag.cod_forn := contas_pagar[i].cod_forn;
      pag.data_compra := contas_pagar[i].data_compra;
      pag.valor := contas_pagar[i].valor;
      pag.paga := contas_pagar[i].paga;
      pag.data_venc := contas_pagar[i].data_venc;
      pag.data_pag := contas_pagar[i].data_pag;
      GravaContasPagar(pag);
    end;
  writeln(Arquivo,#9'</tabela>');
  writeln(Arquivo,'</dados>');
  CloseFile(Arquivo);
end;

procedure EditaVetorCliente(linha:integer;cli:cliente);
begin
  clientes[linha].codigo := cli.codigo;
  clientes[linha].nome := cli.nome;
  clientes[linha].endereco := cli.endereco;
  clientes[linha].cpf := cli.cpf;
  clientes[linha].telefone := cli.telefone;
  clientes[linha].email := cli.email;
  clientes[linha].sexo := cli.sexo;
  clientes[linha].estado := cli.estado;
  clientes[linha].nascimento := cli.nascimento;
end;

procedure EditarFilmes(linha:integer;film:filme);
begin
  filmes[linha].codigo := film.codigo;
  filmes[linha].descricao := film.descricao;
  filmes[linha].exemplares := film.exemplares;
  filmes[linha].codcat := film.codcat;
  filmes[linha].lingua := film.lingua;
end;

procedure EditarCategoria(linha:integer;cat:categoria);
begin
  categorias[linha].codigo := cat.codigo;
  categorias[linha].valor := cat.valor;
  categorias[linha].descricao := cat.descricao;
end;

procedure EditarFuncionario(linha:integer;func:funcionario);
begin
  funcionarios[linha].codigo := func.codigo;
  funcionarios[linha].nome := func.nome;
  funcionarios[linha].cargo := func.cargo;
  funcionarios[linha].email := func.email;
  funcionarios[linha].endereco := func.endereco;
  funcionarios[linha].telefone := func.telefone;
end;

procedure EditarFornecedor(linha:integer;forn:fornecedor);
begin
  fornecedores[linha].codigo := forn.codigo;
  fornecedores[linha].nome := forn.nome;
  fornecedores[linha].razao := forn.razao;
  fornecedores[linha].inscricao := forn.inscricao;
  fornecedores[linha].cnpj := forn.cnpj;
  fornecedores[linha].email := forn.email;
  fornecedores[linha].endereco := forn.endereco;
  fornecedores[linha].telefone := forn.telefone;
end;

procedure ExcluiCliente(linha:integer);
begin
  clientes[linha].ativo := true;
  EditaNoArquivo;
end;

procedure ExcluiFilme(linha:integer);
begin
  filmes[linha].ativo := true;
  EditaNoArquivo;
end;

procedure ExcluiCategoria(linha:integer);
begin
  categorias[linha].ativo := true;
  EditaNoArquivo;
end;

procedure ExcluiFuncionario(linha:integer);
begin
  funcionarios[linha].ativo := true;
  EditaNoArquivo;
end;

procedure ExcluiFornecedor(linha:integer);
begin
  fornecedores[linha].ativo := true;
  EditaNoArquivo;
end;

procedure IncQuantLocadoFunc(pos,quant_locado:integer);
begin
  funcionarios[pos].total := funcionarios[pos].total + quant_locado;
  totalLocado := totalLocado + quant_locado;
  EditaNoArquivo;
end;

function BuscaDevolucao(dev:devolver):integer;
var
  i: Integer;
begin
  result := 0;
  for i := 0 to length(filmes_devolver)-1 do
    begin
      if (dev.dataLoc=filmes_devolver[i].dataLoc)and(dev.DataDev=filmes_devolver[i].DataDev)and
      (dev.codFilmes=filmes_devolver[i].codFilmes)and(dev.CodCliente=filmes_devolver[i].CodCliente)and
      (dev.devolvido=filmes_Devolver[i].devolvido)
        then begin
               result := i;
               break;
             end;
    end;
end;

procedure RealizaDevolucao(dev:devolver;pos_vetor:integer;var totalMulta:real);
var
  pos_filme, quant_exemplares : integer;
begin
  //primeiro pega a posicao do vetor e poe pago
  filmes_devolver[pos_vetor].devolvido := true;
  //depois coloca mais um exemplar no vetor filmes
  delete(dev.codFilmes,1,1);
  pos_filme := StrToInt(dev.codFilmes)-1;
  quant_exemplares := StrToInt(filmes[pos_filme].exemplares);
  inc(quant_exemplares);
  filmes[pos_filme].exemplares := IntToStr(quant_exemplares);
  caixa := caixa + totalMulta;
  EditaNoArquivo;
end;

function VerificaMulta(dev:devolver):integer;
var
  data1,data2 : TdateTime;
  //dias : integer;
  data1str, data2str : string;
begin
  //dias := 0;
  data1str := dev.DataDev;
  data1 := StrToDate(data1str);
	data2 := StrToDate(formatDatetime('dd/mm/yyyy',now));
  data2str := formatDatetime('yyyy/mm/dd',now);
  data1str := formatDatetime('yyyy/mm/dd',data1);
  if data1str >= data2Str
    then result := 0
    else begin
           result := DaysBetween(data2,data1);
         end;
end;

procedure RealizaPagamento(rec:receber;pos_vetor:integer);
begin
  rec.pago := true;
  rec.pagamento := FormatDateTime('dd/mm/yyyy',now);
  contas_receber[pos_vetor].Cod_Cliente := rec.Cod_Cliente;
  contas_receber[pos_vetor].parcela := rec.parcela;
  contas_receber[pos_vetor].pago := rec.pago;
  contas_receber[pos_vetor].data := rec.data;
  contas_receber[pos_vetor].pagamento := rec.pagamento;
  caixa := caixa + StrToFloat(rec.parcela);
  EditaNoArquivo;
end;

procedure PassaVetorComprar(comp:comprar);
var
  cat : string;
begin
  cat := comp.codcat;
  comp.codcat := copy(cat,1,9);
  SetLength(Filme_Comprar,length(filme_comprar)+1);
  filme_comprar[length(filme_comprar)-1].descricao := comp.descricao;
  filme_comprar[length(filme_comprar)-1].preco := comp.preco;
  filme_comprar[length(filme_comprar)-1].quant := comp.quant;
  filme_comprar[length(filme_comprar)-1].total := comp.preco * comp.quant;
  filme_comprar[length(filme_comprar)-1].codcat := comp.codcat;
  filme_comprar[length(filme_comprar)-1].lingua := comp.lingua;
end;

procedure DeletaFilmeCompra(linha:integer);
var
  i : integer;
begin
  dec(linha);
  for i := linha to length(filme_comprar)-2 do
    begin
      filme_comprar[i] := filme_comprar[i+1];
    end;
  SetLength(filme_comprar,length(filme_comprar)-1);
end;

procedure CompraFilme(imp,fre:real);
var
  descricao, cod, codcat, lingua : string;
  i, existe : Integer;
  preco : real;
begin
  for i := 0 to length(filme_comprar)-1 do
    begin
      descricao := filme_comprar[i].descricao;
      codcat := filme_comprar[i].codcat;
      lingua := filme_comprar[i].lingua;
      preco := filme_comprar[i].total;
      preco := preco + imp + fre;
      existe := FilmeExiste(descricao,codcat,lingua);
      if existe = -1
        then begin //se o filme não existe
               cod := GeraCodigoFilme;
               film.codigo := cod;
               film.descricao := filme_comprar[i].descricao;
               film.exemplares := IntToStr(filme_comprar[i].quant);
               film.codcat := filme_comprar[i].codcat;
               film.lingua := filme_comprar[i].lingua;
               film.ativo := false;
               film.preco := FloatToStr(preco);
               film.vezes := 0;
               GravaFilmeVetor(film);
               EditaNoArquivo;
             end
        else begin
               filmes[existe].exemplares := IntToStr(StrToInt(filmes[existe].exemplares) + filme_comprar[i].quant);
               EditaNoArquivo;
             end;
    end;
end;

function FilmeExiste(descricao,codcat,lingua:string):integer;
var
  i : integer;
begin
  result := -1;
  for i := 0 to length(filmes)-1 do
    begin
      if (filmes[i].descricao = descricao)and(filmes[i].codcat = codcat)and(filmes[i].lingua = lingua)and(filmes[i].ativo = false)
        then begin
               result := i;
               break;
             end;
    end;
end;

procedure ContasPagar(quant:integer;fornecedor,ValorParcela:string);
var
  data : string;
  i: Integer;
begin
  data := formatdatetime('dd/mm/yyyy',now);
  for i := 1 to quant do
    begin
      SetLength(Contas_Pagar,length(contas_Pagar)+1);
      contas_pagar[length(contas_pagar)-1].cod_forn := fornecedor;
      contas_pagar[length(contas_pagar)-1].data_compra := data;
      contas_pagar[length(contas_pagar)-1].valor := Copy(ValorParcela,4,length(ValorParcela));
      contas_pagar[length(contas_pagar)-1].paga := false;
      contas_pagar[length(contas_pagar)-1].data_venc := DateToStr(IncMonth(StrToDate(data),i));
      contas_pagar[length(contas_pagar)-1].data_pag := '-';
    end;
  EditaNoArquivo;
end;

procedure GeraNotaFiscalEntrada(fornece,frete,imposto,total:string);
var
  Arq : TextFile;
  localizacao : string;
  posi, i : integer;
begin
  localizacao := ExtractFilePath(Application.ExeName);
  posi := pos('\Win32\Debug',localizacao);
  delete(localizacao,posi,length(localizacao));
  if Not(DirectoryExists(localizacao+'\Notas Fiscais'))
   then CreateDir(localizacao+'\Notas Fiscais');
  AssignFile(Arq,localizacao+'\Notas Fiscais\NotaFiscalEntrada.html');
  Rewrite(Arq);
  //cabecalho html
  writeln(Arq,'<html>');
  writeln(Arq,#9'<head>');
  writeln(Arq,#9#9'<meta http-equiv="content-type" content="text/html; charset=UTF-8">');
  writeln(Arq,#9#9'<title>'+dateToStr(now)+'</title>');
  writeln(Arq,#9'</head>');
  //começa o corpo
  writeln(Arq,#9'<body>');
  writeln(Arq,#9#9'<center>');
  writeln(Arq,#9#9'<table border="1">');
  writeln(Arq,#9#9#9'<tr>');
  writeln(Arq,#9#9#9#9'<td style="width:250px; text-align:center;">Fornecedor:</td>');
  writeln(Arq,#9#9#9#9'<td colspan="3">',fornece,'</td>');
  writeln(Arq,#9#9#9'</tr>');
  writeln(Arq,#9#9#9'<tr>');
  writeln(Arq,#9#9#9#9'<td style="text-align:center;">Frete:</td>');
  writeln(Arq,#9#9#9#9'<td>',frete,'</td>');
  writeln(Arq,#9#9#9#9'<td style="text-align:center;">Imposto:</td>');
  writeln(Arq,#9#9#9#9'<td>',imposto,'</td>');
  writeln(Arq,#9#9#9'</tr>');
  writeln(Arq,#9#9#9'<tr>');
  writeln(Arq,#9#9#9#9'<td colspan="4" style="text-align:center;">Filmes</td>');
  writeln(Arq,#9#9#9'</tr>');
  writeln(Arq,#9#9#9'<tr>');
  writeln(Arq,#9#9#9#9'<td style="text-align:center;">Descricao</td>');
  writeln(Arq,#9#9#9#9'<td style="text-align:center;">Preco de Custo(R$)</td>');
  writeln(Arq,#9#9#9#9'<td style="text-align:center;">Quantidade(Unid)</td>');
  writeln(Arq,#9#9#9#9'<td style="text-align:center;">Total(R$)</td>');
  writeln(Arq,#9#9#9'</tr>');
  for i := 0 to length(filme_comprar)-1 do
    begin
      writeln(Arq,#9#9#9'<tr>');
      writeln(Arq,#9#9#9#9'<td style="text-align:center;">',filme_comprar[i].descricao,'</td>');
      writeln(Arq,#9#9#9#9'<td style="text-align:center; width: 125px;">',FloatToStr(filme_comprar[i].preco),'</td>');
      writeln(Arq,#9#9#9#9'<td style="text-align:center; width: 125px;">',IntToStr(filme_comprar[i].quant),'</td>');
      writeln(Arq,#9#9#9#9'<td style="text-align:center; width: 125px;">',FloatToStr(filme_comprar[i].total),'</td>');
      writeln(Arq,#9#9#9'</tr>');
    end;
  writeln(Arq,#9#9#9'<tr>');
  writeln(Arq,#9#9#9#9'<td colspan="3" style="text-align:center;">Total da Nota (filmes + frete + impostos):</td>');
  writeln(Arq,#9#9#9#9'<td style="text-align:center;">',FloatToStr(StrToFloat(total)+StrToFloat(frete)+StrToFloat(imposto)),'</td>');
  writeln(Arq,#9#9#9'</tr>');
  writeln(Arq,#9#9'</center>');
  writeln(Arq,#9#9'</table>');
  writeln(Arq,#9'</body>');
  //termina o corpo
  writeln(Arq,'</html>');
  CloseFile(Arq);
end;

procedure PagarParcela(posicao : integer);
var
  valor : real;
begin
  contas_pagar[posicao].paga := true;
  contas_pagar[posicao].data_pag := FormatDateTime('dd/mm/yyyy',now);
  valor := StrToFloat(contas_pagar[posicao].valor);
  caixa := caixa - valor;
  EditaNoArquivo;
end;

procedure ExportaDados(opcao:integer;caminho:string);
var
  ArqExp : TextFile;
  i : integer;
begin
  AssignFile(ArqExp,caminho);
  Rewrite(ArqExp);
  writeln(ArqExp,'<dados>');
  case opcao of
    0 : begin
          writeln(ArqExp,#9'<tabela = locadora>');
          writeln(ArqExp,#9#9'<registro>');
          writeln(ArqExp,#9#9#9'<NomeFantasiaLocadora>',loc.Nome,'</NomefantasiaLocadora>');
          writeln(ArqExp,#9#9#9'<RazaoSocialLocadora>',loc.Razao,'</RazaoSocialLocadora>');
          writeln(ArqExp,#9#9#9'<IncricaoEstadualLocadora>',loc.Incricao,'</IncricaoEstadualLocadora>');
          writeln(ArqExp,#9#9#9'<CNPJLocadora>',loc.CNPJ,'</CNPJLocadora>');
          writeln(ArqExp,#9#9#9'<EnderecoLocadora>',loc.endereco,'</EnderecoLocadora>');
          writeln(ArqExp,#9#9#9'<TelefoneLocadora>',loc.telefone,'</TelefoneLocadora>');
          writeln(ArqExp,#9#9#9'<EmailLocadora>',loc.email,'</EmailLocadora>');
          writeln(ArqExp,#9#9#9'<MultaLocadora>',loc.multa,'</MultaLocadora>');
          writeln(ArqExp,#9#9#9'<NomeResponsavelLocadora>',loc.NomeResponsavel,'</NomeResponsavelLocadora>');
          writeln(ArqExp,#9#9#9'<TelefoneResponsavelLocadora>',loc.TelefoneResponsavel,'</TelefoneResponsavelLocadora>');
          writeln(ArqExp,#9#9#9'<Caixa>',caixa:0:2,'</Caixa>');
          writeln(ArqExp,#9#9#9'<TotalLocado>',totalLocado,'</TotalLocado>');
          writeln(ArqExp,#9#9'</registro>');
          writeln(ArqExp,#9'</tabela>');
        end;
    1 : begin
          writeln(ArqExp,#9'<tabela = cliente>');
          for I := 0 to length(clientes)-1 do
            begin
              cli.codigo := clientes[i].codigo;
              cli.nome := clientes[i].nome;
              cli.endereco := clientes[i].endereco;
              cli.cpf := clientes[i].cpf;
              cli.telefone := clientes[i].telefone;
              cli.email := clientes[i].email;
              cli.sexo := clientes[i].sexo;
              cli.estado := clientes[i].estado;
              cli.nascimento := clientes[i].nascimento;
              cli.ativo := clientes[i].ativo;
              writeln(ArqExp,#9#9'<registro>');
              writeln(ArqExp,#9#9#9'<CodigoCliente>',cli.codigo,'</CodigoCliente>');
              writeln(ArqExp,#9#9#9'<NomeCliente>',cli.nome,'</NomeCliente>');
              writeln(ArqExp,#9#9#9'<EnderecoCliente>',cli.endereco,'</EnderecoCliente>');
              writeln(ArqExp,#9#9#9'<CPFCliente>',cli.cpf,'</CPFCliente>');
              writeln(ArqExp,#9#9#9'<TelefoneCliente>',cli.telefone,'</TelefoneCliente>');
              writeln(ArqExp,#9#9#9'<EmailCliente>',cli.email,'</EmailCliente>');
              writeln(ArqExp,#9#9#9'<SexoCliente>',cli.sexo,'</SexoCliente>');
              writeln(ArqExp,#9#9#9'<EstadoCivilCliente>',cli.estado,'</EstadoCivilCliente>');
              writeln(ArqExp,#9#9#9'<NascimentoCliente>',cli.nascimento,'</NascimentoCliente>');
              writeln(ArqExp,#9#9#9'<DeleteCliente>',cli.ativo,'</DeleteCliente>');
              writeln(ArqExp,#9#9'</registro>');
            end;
          writeln(ArqExp,#9'</tabela>');
        end;
    2 : begin
          writeln(ArqExp,#9'<tabela = filmes>');
          for i := 0 to length(filmes)-1 do
          begin
            film.codigo := filmes[i].codigo;
            film.descricao := filmes[i].descricao;
            film.exemplares := filmes[i].exemplares;
            film.codcat := filmes[i].codcat;
            film.lingua := filmes[i].lingua;
            film.ativo := filmes[i].ativo;
            writeln(ArqExp,#9#9'<registro>');
            writeln(ArqExp,#9#9#9'<CodigoFilme>',film.codigo,'</CodigoFilme>');
            writeln(ArqExp,#9#9#9'<DescricaoFilme>',film.descricao,'</DescricaoFilme>');
            writeln(ArqExp,#9#9#9'<ExemplaresFilme>',film.exemplares,'</ExemplaresFilme>');
            writeln(ArqExp,#9#9#9'<CodCatFilme>',film.CodCat,'</CodCatFilme>');
            writeln(ArqExp,#9#9#9'<LinguaFilme>',film.lingua,'</LinguaFilme>');
            writeln(ArqExp,#9#9#9'<DeleteFilme>',film.ativo,'</DeleteFilme>');
            writeln(ArqExp,#9#9'</registro>');
          end;
          writeln(ArqExp,#9'</tabela>');
        end;
    3 : begin
          writeln(ArqExp,#9'<tabela = categorias>');
          for i := 0 to length(categorias)-1 do
          begin
            cat.codigo := categorias[i].codigo;
            cat.valor := categorias[i].valor;
            cat.descricao := categorias[i].descricao;
            cat.ativo := categorias[i].ativo;
            writeln(ArqExp,#9#9'<registro>');
            writeln(ArqExp,#9#9#9'<CodigoCategoria>',cat.codigo,'</CodigoCategoria>');
            writeln(ArqExp,#9#9#9'<ValorCategoria>',cat.valor,'</ValorCategoria>');
            writeln(ArqExp,#9#9#9'<DescricaoCategoria>',cat.descricao,'</DescricaoCategoria>');
            writeln(ArqExp,#9#9#9'<DeleteCategoria>',cat.ativo,'</DeleteCategoria>');
            writeln(ArqExp,#9#9'</registro>');
          end;
          writeln(ArqExp,#9'<tabela>');
        end;
    4 : begin
          writeln(ArqExp,#9'<tabela = funcionarios>');
          for i := 0 to length(funcionarios)-1 do
          begin
            func.codigo := funcionarios[i].codigo;
            func.nome := funcionarios[i].nome;
            func.cargo := funcionarios[i].cargo;
            func.email := funcionarios[i].email;
            func.endereco := funcionarios[i].endereco;
            func.telefone := funcionarios[i].telefone;
            func.ativo := funcionarios[i].ativo;
            func.total := funcionarios[i].total;
            writeln(ArqExp,#9#9'<registro>');
            writeln(ArqExp,#9#9#9'<CodigoFuncionario>',func.codigo,'</CodigoFuncionario>');
            writeln(ArqExp,#9#9#9'<NomeFuncionario>',func.nome,'</NomeFuncionario>');
            writeln(ArqExp,#9#9#9'<CargoFuncionario>',func.cargo,'</CargoFuncionario>');
            writeln(ArqExp,#9#9#9'<EmailFuncionario>',func.email,'</EmailFuncionario>');
            writeln(ArqExp,#9#9#9'<EnderecoFuncionario>',func.endereco,'</EnderecoFuncionario>');
            writeln(ArqExp,#9#9#9'<TelefoneFuncionario>',func.telefone,'</TelefoneFuncionario>');
            writeln(ArqExp,#9#9#9'<DeleleFuncionario>',func.ativo,'</DeleleFuncionario>');
            writeln(ArqExp,#9#9#9'<TotalLocado>',func.total,'</TotalLocado>');
            writeln(ArqExp,#9#9'</registro>');
          end;
          writeln(ArqExp,#9'</tabela>');
        end;
    5 : begin
          writeln(ArqExp,#9'<tabela = fornecedores>');
          for i := 0 to length(fornecedores)-1 do
          begin
            forn.codigo := fornecedores[i].codigo;
            forn.nome := fornecedores[i].nome;
            forn.razao := fornecedores[i].razao;
            forn.inscricao := fornecedores[i].inscricao;
            forn.cnpj := fornecedores[i].cnpj;
            forn.email := fornecedores[i].email;
            forn.endereco := fornecedores[i].endereco;
            forn.telefone := fornecedores[i].telefone;
            forn.ativo := fornecedores[i].ativo;
            writeln(ArqExp,#9#9'<registro>');
            writeln(ArqExp,#9#9#9'<CodigoFornecedor>',forn.codigo,'</CodigoFornecedor>');
            writeln(ArqExp,#9#9#9'<NomeFornecedor>',forn.nome,'</NomeFornecedor>');
            writeln(ArqExp,#9#9#9'<RazaoFornecedor>',forn.razao,'</RazaoFornecedor>');
            writeln(ArqExp,#9#9#9'<InscricaoFornecedor>',forn.inscricao,'</InscricaoFornecedor>');
            writeln(ArqExp,#9#9#9'<CNPJFornecedor>',forn.cnpj,'</CNPJFornecedor>');
            writeln(ArqExp,#9#9#9'<EmailFornecedor>',forn.email,'</EmailFornecedor>');
            writeln(ArqExp,#9#9#9'<EnderecoFornecedor>',forn.endereco,'</EnderecoFornecedor>');
            writeln(ArqExp,#9#9#9'<TelefoneFornecedor>',forn.telefone,'</TelefoneFornecedor>');
            writeln(ArqExp,#9#9#9'<DeleteFornecedor>',forn.ativo,'</DeleteFornecedor>');
            writeln(ArqExp,#9#9'</registro>');
          end;
          writeln(ArqExp,#9'</tabela>');
        end;
    6 : begin
          writeln(ArqExp,#9'<tabela = contas_receber>');
          for i := 0 to length(contas_receber)-1 do
          begin
            rec.Cod_Cliente := contas_receber[i].Cod_Cliente;
            rec.parcela := contas_receber[i].parcela;
            rec.pago := contas_receber[i].pago;
            rec.data := contas_receber[i].data;
            rec.pagamento := contas_receber[i].pagamento;
            writeln(ArqExp,#9#9'<registro>');
            writeln(ArqExp,#9#9#9'<CodigoCliente>',rec.Cod_Cliente,'</CodigoCliente>');
            writeln(ArqExp,#9#9#9'<ValorParcela>',rec.parcela,'</ValorParcela>');
            writeln(ArqExp,#9#9#9'<DataParcela>',rec.data,'</DataParcela>');
            writeln(ArqExp,#9#9#9'<PagaParcela>',rec.pago,'</PagaParcela>');
            writeln(ArqExp,#9#9#9'<DataPagamento>',rec.pagamento,'</DataPagamento>');
            writeln(ArqExp,#9#9'</registro>');
          end;
          writeln(ArqExp,#9'</tabela>');
        end;
    7 : begin
          writeln(ArqExp,#9'<tabela = devolucoes>');
          for i := 0 to length(filmes_devolver)-1 do
          begin
            dev.CodCliente := filmes_devolver[i].CodCliente;
            dev.codFilmes := filmes_devolver[i].codFilmes;
            dev.dataLoc := filmes_devolver[i].dataLoc;
            dev.DataDev := filmes_devolver[i].DataDev;
            dev.devolvido := filmes_devolver[i].devolvido;
            dev.tipo := filmes_devolver[i].tipo;
            dev.funcionario := filmes_devolver[i].funcionario;
            writeln(ArqExp,#9#9'<registro>');
            writeln(ArqExp,#9#9#9'<CodCliente>',dev.CodCliente,'</CodCliente>');
            writeln(ArqExp,#9#9#9'<CodFilme>',dev.codFilmes,'</CodFilme>');
            writeln(ArqExp,#9#9#9'<DataLocacao>',dev.dataLoc,'</DataLocacao>');
            writeln(ArqExp,#9#9#9'<DataDevolucao>',dev.DataDev,'</dataDevolucao>');
            writeln(ArqExp,#9#9#9'<TipoLocacao>',dev.tipo,'</TipoLocacao>');
            writeln(ArqExp,#9#9#9'<CodFuncionario>',dev.funcionario,'</CodFuncionario>');
            writeln(ArqExp,#9#9#9'<Devolvido>',dev.devolvido,'</Devolvido>');
            Writeln(ArqExp,#9#9'</registro>');
          end;
          writeln(ArqExp,#9'</tabela>');
        end;
    8 : begin
          writeln(ArqExp,#9'<tabela = contas_Pagar>');
          for i := 0 to length(contas_pagar)-1 do
          begin
            pag.cod_forn := contas_pagar[i].cod_forn;
            pag.data_compra := contas_pagar[i].data_compra;
            pag.valor := contas_pagar[i].valor;
            pag.paga := contas_pagar[i].paga;
            pag.data_venc := contas_pagar[i].data_venc;
            pag.data_pag := contas_pagar[i].data_pag;
            writeln(ArqExp,#9#9'<registro>');
            writeln(ArqExp,#9#9#9'<CodigoFornecedor>',pag.cod_forn,'</CodigoFornecedor>');
            writeln(ArqExp,#9#9#9'<DataDaCompra>',pag.data_compra,'</DataDaCompra>');
            writeln(ArqExp,#9#9#9'<ValorParcela>',pag.valor,'</ValorParcela>');
            writeln(ArqExp,#9#9#9'<PagaParcela>',pag.paga,'</PagaParcela>');
            writeln(ArqExp,#9#9#9'<DataDeVencimento>',pag.data_venc,'</DataDeVencimento>');
            writeln(ArqExp,#9#9#9'<DataDePagamento>',pag.data_pag,'</DataDePagamento>');
            Writeln(ArqExp,#9#9'</registro>');
          end;
          writeln(ArqExp,#9'</tabela>');
        end;
  end;
  writeln(ArqExp,'</dados>');
  CloseFile(ArqExp);
end;

procedure ImportaLocadora(caminho:string);
var
  ArqImp : TextFile;
  linha,tag,caixastr : string;
  posi : integer;
begin
  AssignFile(ArqImp,caminho);
  Reset(ArqImp);
  while not(Eof(ArqImp)) do
    begin
      readln(ArqImp,linha);
      tag := LerTag(linha);
      case AnsiIndexStr(tag,[#9#9#9'<NomeFantasiaLocadora>',#9#9#9'<RazaoSocialLocadora>',
      #9#9#9'<IncricaoEstadualLocadora>',#9#9#9'<CNPJLocadora>',#9#9#9'<EnderecoLocadora>',
      #9#9#9'<TelefoneLocadora>',#9#9#9'<EmailLocadora>',#9#9#9'<MultaLocadora>',
      #9#9#9'<NomeResponsavelLocadora>',#9#9#9'<TelefoneResponsavelLocadora>',#9#9#9'<Caixa>',
      #9#9#9'<TotalLocado>']) of
        0 : loc.Nome := LerDados(linha);
        1 : loc.Razao := LerDados(linha);
        2 : loc.Incricao := LerDados(linha);
        3 : loc.CNPJ := LerDados(linha);
        4 : loc.endereco := LerDados(linha);
        5 : loc.telefone := LerDados(linha);
        6 : loc.email := LerDados(linha);
        7 : loc.multa := LerDados(linha);
        8 : loc.NomeResponsavel := LerDados(linha);
        9 : loc.TelefoneResponsavel := LerDados(linha);
        10 : begin
               caixastr := LerDados(linha);
               posi := pos('.',caixastr);
               caixastr[posi] := ',';
               caixa := StrToFloat(caixastr);
              end;
        11 : totalLocado := StrToInt(LerDados(linha));
      end;
    end;
  CloseFile(ArqImp);
end;

procedure ImportaCliente(caminho:string);
var
  ArqImp : TextFile;
  linha, tag : string;
  posi, i, j : integer;
  new_clientes : array of cliente;
  clie : cliente;
  nao_existe : boolean;
begin
  SetLength(new_clientes,0);
  AssignFile(ArqImp,caminho);
  Reset(ArqImp);
  while not(eof(ArqImp)) do//serve para passar os dados dos arquivos para vetor temporario
    begin
      readln(ArqImp,linha);
      tag := LerTag(linha);
      if tag = #9'<tabela = cliente>'
        then begin
               while tag <> #9'</tabela>' do
                 begin
                   tag := LerTag(linha);
                   readln(ArqImp,linha);
                   if tag = #9#9'<registro>'
                     then begin
                            SetLength(new_clientes,Length(new_clientes)+1);
                            while tag <> #9#9'</registro>' do
                              begin
                                tag := LerTag(linha);
                                posi := length(new_clientes) - 1;
                                case AnsiIndexStr(tag,[#9#9#9'<CodigoCliente>',#9#9#9'<NomeCliente>',#9#9#9'<EnderecoCliente>',
                                #9#9#9'<CPFCliente>',#9#9#9'<TelefoneCliente>',#9#9#9'<EmailCliente>',#9#9#9'<SexoCliente>',
                                #9#9#9'<EstadoCivilCliente>',#9#9#9'<NascimentoCliente>',#9#9#9'<DeleteCliente>']) of
                                0 : new_clientes[posi].codigo := LerDados(linha);
                                1 : new_clientes[posi].nome := LerDados(linha);
                                2 : new_clientes[posi].endereco := LerDados(linha);
                                3 : new_clientes[posi].cpf := LerDados(linha);
                                4 : new_clientes[posi].telefone := LerDados(linha);
                                5 : new_clientes[posi].email := LerDados(linha);
                                6 : new_clientes[posi].sexo := LerDados(linha);
                                7 : new_clientes[posi].estado := LerDados(linha);
                                8 : new_clientes[posi].nascimento := LerDados(linha);
                                9 : begin
                                      if LerDados(linha) = 'FALSE'
                                        then new_clientes[posi].ativo := false
                                        else new_clientes[posi].ativo := true;
                                    end;
                                end;
                              readln(ArqImp,linha);
                          end;
                 end;
             end;
        end;
    end;
  CloseFile(ArqImp);
  nao_existe := false;
  //faz a comparação se existe cpf igual se nao cria uma nova posição do vetor clientes
  for i := 0 to length(new_clientes)-1 do
    begin
      for j := 0 to length(clientes)-1 do
        begin
          nao_existe := false;
          if new_clientes[i].cpf <> clientes[j].cpf
            then begin
                   nao_existe := true;
                 end
            else begin
                   break;
                   nao_existe := false;
                 end;
        end;
      if nao_existe
        then begin
               clie.codigo := GeraCodigoCliente;
               clie.nome := new_clientes[i].nome;
               clie.endereco := new_clientes[i].endereco;
               clie.cpf := new_clientes[i].cpf;
               clie.telefone := new_clientes[i].telefone;
               clie.email := new_clientes[i].email;
               clie.sexo := new_clientes[i].sexo;
               clie.estado := new_clientes[i].estado;
               clie.nascimento := new_clientes[i].nascimento;
               clie.ativo := new_clientes[i].ativo;
               GravaClienteVetor(clie);
             end;
    end;
  EditaNoArquivo;
end;

procedure ImportaFuncionarios(caminho:string);
var
  ArqImp : TextFile;
  linha, tag : string;
  posi, i, j : integer;
  new_funcionarios : array of funcionario;
  funci : funcionario;
  nao_existe : boolean;
begin
  SetLength(new_funcionarios,0);
  AssignFile(ArqImp,caminho);
  reset(ArqImp);
  while not(eof(ArqImp)) do
    begin
      readln(ArqImp,linha);
      tag := LerTag(linha);
      if tag = #9'<tabela = funcionarios>'
        then begin
               while tag <> #9'</tabela>' do
                 begin
                   tag := LerTag(linha);
                   readln(ArqImp,linha);
                   if tag = #9#9'<registro>'
                     then begin
                            SetLength(new_funcionarios,length(new_funcionarios)+1);
                            while tag <> #9#9'</registro>' do
                              begin
                                tag := LerTag(linha);
                                posi := Length(new_funcionarios)-1;
                                case AnsiIndexStr(tag,[#9#9#9'<CodigoFuncionario>',#9#9#9'<NomeFuncionario>',
                                #9#9#9'<CargoFuncionario>',#9#9#9'<EmailFuncionario>',#9#9#9'<EnderecoFuncionario>',
                                #9#9#9'<TelefoneFuncionario>',#9#9#9'<DeleleFuncionario>',#9#9#9'<TotalLocado>']) of
                                  0 : new_Funcionarios[posi].codigo := LerDados(linha);
                                  1 : new_Funcionarios[posi].nome := LerDados(linha);
                                  2 : new_Funcionarios[posi].cargo := LerDados(linha);
                                  3 : new_Funcionarios[posi].email := LerDados(linha);
                                  4 : new_Funcionarios[posi].endereco := LerDados(linha);
                                  5 : new_Funcionarios[posi].telefone := LerDados(linha);
                                  6 : begin
                                        if LerDados(linha) = 'FALSE'
                                          then new_funcionarios[posi].ativo := false
                                          else new_funcionarios[posi].ativo := true;
                                      end;
                                  7 : new_Funcionarios[posi].total := StrToInt(LerDados(linha));
                                end;
                                readln(ArqImp,linha);
                              end;
                          end;
                 end;
             end;
   end;
  CloseFile(ArqImp);
  nao_existe := false;
  for i := 0 to length(new_funcionarios)-1 do
    begin
      for j := 0 to length(funcionarios)-1 do
        begin
          nao_existe := false;
          if new_funcionarios[i].nome <> funcionarios[j].nome
            then begin
                   nao_existe := true;
                 end
            else begin
                   break;
                   nao_existe := false;
                 end;
        end;
      if nao_existe
        then begin
               funci.codigo := GeraCodigoFuncionario;
               funci.nome := new_funcionarios[i].nome;
               funci.cargo := new_funcionarios[i].cargo;
               funci.email := new_funcionarios[i].email;
               funci.endereco := new_funcionarios[i].endereco;
               funci.telefone := new_funcionarios[i].telefone;
               funci.ativo := new_funcionarios[i].ativo;
               funci.total := new_funcionarios[i].total;
               GravaFuncionarioVetor(funci);
             end;
    end;
  EditaNoArquivo;
end;

procedure ImportaFornecedores(caminho:string);
var
  ArqImp : TextFile;
  linha, tag : string;
  posi, i, j : integer;
  new_fornecedores : array of fornecedor;
  forne : fornecedor;
  nao_existe : boolean;
begin
  SetLength(new_fornecedores,0);
  AssignFile(ArqImp,caminho);
  reset(ArqImp);
  while not(eof(ArqImp)) do
    begin
      readln(ArqImp,linha);
      tag := LerTag(linha);
      if tag = #9'<tabela = fornecedores>'
        then begin
               while tag <> #9'</tabela>' do
                 begin
                   tag := LerTag(linha);
                   readln(ArqImp,linha);
                   if tag = #9#9'<registro>'
                     then begin
                            SetLength(new_fornecedores,length(new_fornecedores)+1);
                            while tag <> #9#9'</registro>' do
                              begin
                                tag := LerTag(linha);
                                posi := length(new_fornecedores)-1;
                                case AnsiIndexStr(tag,[#9#9#9'<CodigoFornecedor>',#9#9#9'<NomeFornecedor>',
                                #9#9#9'<RazaoFornecedor>',#9#9#9'<InscricaoFornecedor>',#9#9#9'<CNPJFornecedor>',
                                #9#9#9'<EmailFornecedor>',#9#9#9'<EnderecoFornecedor>',#9#9#9'<TelefoneFornecedor>',
                                #9#9#9'<DeleteFornecedor>']) of
                                  0 : new_fornecedores[posi].codigo := LerDados(linha);
                                  1 : new_fornecedores[posi].nome := LerDados(linha);
                                  2 : new_fornecedores[posi].razao := LerDados(linha);
                                  3 : new_fornecedores[posi].inscricao := LerDados(linha);
                                  4 : new_fornecedores[posi].cnpj := LerDados(linha);
                                  5 : new_fornecedores[posi].email := LerDados(linha);
                                  6 : new_fornecedores[posi].endereco := LerDados(linha);
                                  7 : new_fornecedores[posi].telefone := LerDados(linha);
                                  8 : begin
                                        if LerDados(linha) = 'FALSE'
                                          then new_fornecedores[posi].ativo := false
                                          else new_fornecedores[posi].ativo := true;
                                      end;
                                end;
                                readln(ArqImp,linha);
                              end;
                          end;
                 end;
             end;
   end;
  CloseFile(ArqImp);
  nao_existe := false;
  for i := 0 to length(new_fornecedores)-1 do
    begin
      for j := 0 to length(fornecedores)-1 do
        begin
          nao_existe := false;
          if new_fornecedores[i].cnpj <> fornecedores[j].cnpj
            then begin
                   nao_existe := true;
                 end
            else begin
                   break;
                   nao_existe := false;
                 end;
        end;
      if nao_existe
        then begin
               forne.codigo := GeraCodigoFornecedores;
               forne.nome := new_fornecedores[i].nome;
               forne.razao := new_fornecedores[i].razao;
               forne.inscricao := new_fornecedores[i].inscricao;
               forne.cnpj := new_fornecedores[i].cnpj;
               forne.email := new_fornecedores[i].email;
               forne.endereco := new_fornecedores[i].endereco;
               forne.telefone := new_fornecedores[i].telefone;
               forne.ativo := new_fornecedores[i].ativo;
               GravaFornecedorVetor(forne);
             end;
    end;
  EditaNoArquivo;
end;

procedure ImportaCategorias(caminho:string);
var
  ArqImp : TextFile;
  linha, tag : string;
  posi, i, j : integer;
  new_categoria : array of categoria;
  cate : categoria;
  nao_existe : boolean;
begin
  SetLength(new_categoria,0);
  AssignFile(ArqImp,caminho);
  Reset(ArqImp);
  while not(eof(ArqImp)) do
    begin
      readln(ArqImp,linha);
      tag := LerTag(linha);
      if tag = #9'<tabela = categorias>'
        then begin
               while tag <> #9'</tabela>' do
                 begin
                   tag := LerTag(linha);
                   readln(ArqImp,linha);
                   if tag = #9#9'<registro>'
                     then begin
                            SetLength(new_categoria,length(new_categoria)+1);
                            while tag <> #9#9'</registro>' do
                              begin
                                tag := LerTag(linha);
                                posi := Length(new_categoria)-1;
                                case AnsiIndexStr(tag,[#9#9#9'<CodigoCategoria>',#9#9#9'<ValorCategoria>',
                                #9#9#9'<DescricaoCategoria>',#9#9#9'<DeleteCategoria>']) of
                                  0 : new_categoria[posi].codigo := LerDados(linha);
                                  1 : new_categoria[posi].valor := LerDados(linha);
                                  2 : new_categoria[posi].descricao := LerDados(linha);
                                  3 : begin
                                        if LerDados(linha) = 'FALSE'
                                          then new_categoria[posi].ativo := false
                                          else new_categoria[posi].ativo := true;
                                      end;
                                end;
                                readln(ArqImp,linha);
                              end;
                          end;
                 end;
             end;
   end;
  CloseFile(ArqImp);
  nao_existe := false;
  for i := 0 to length(new_categoria)-1 do
    begin
      for j := 0 to length(categorias)-1 do
        begin
          nao_existe := false;
          if new_categoria[i].descricao <> categorias[j].descricao
            then begin
                   nao_existe := true;
                 end
            else begin
                   break;
                   nao_existe := false;
                 end;
        end;
      if nao_existe
        then begin
               cate.codigo := GeraCodigoCategoria;
               cate.valor := new_categoria[i].valor;
               cate.descricao := new_categoria[i].descricao;
               cate.ativo := new_categoria[i].ativo;
               GravaCategoriaVetor(cate);
             end;
    end;
  EditaNoArquivo;
end;

procedure ImportaFilmes(caminho:string);
var
  ArqImp : TextFile;
  linha, tag : string;
  posi, i, j : integer;
  new_filmes: array of filme;
  films : filme;
  nao_existe : boolean;
begin
  SetLength(new_filmes,0);
  AssignFile(ArqImp,caminho);
  Reset(ArqImp);
  while not(eof(ArqImp)) do
    begin
      readln(ArqImp,linha);
      tag := LerTag(linha);
      if tag = #9'<tabela = filmes>'
        then begin
               while tag <> #9'</tabela>' do
                 begin
                   tag := LerTag(linha);
                   readln(ArqImp,linha);
                   if tag = #9#9'<registro>'
                     then begin
                            SetLength(new_filmes,Length(new_filmes)+1);
                            while tag <> #9#9'</registro>' do
                              begin
                                tag := LerTag(linha);
                                posi := Length(new_filmes)-1;
                                case AnsiIndexStr(tag,[#9#9#9'<CodigoFilme>',#9#9#9'<DescricaoFilme>',
                                #9#9#9'<ExemplaresFilme>',#9#9#9'<CodCatFilme>',#9#9#9'<LinguaFilme>',
                                #9#9#9'<DeleteFilme>']) of
                                  0 : new_filmes[posi].codigo := LerDados(linha);
                                  1 : new_filmes[posi].descricao := LerDados(linha);
                                  2 : new_filmes[posi].exemplares := LerDados(linha);
                                  3 : new_filmes[posi].codcat := LerDados(linha);
                                  4 : new_filmes[posi].lingua := LerDados(linha);
                                  5 : begin
                                        if LerDados(linha) = 'FALSE'
                                          then new_filmes[posi].ativo := false
                                          else new_filmes[posi].ativo := true;
                                      end;
                                end;
                                readln(ArqImp,linha);
                          end;
                   end;
                 end;
             end;
    end;
  CloseFile(ArqImp);
  nao_existe := false;
  for i := 0 to length(new_filmes)-1 do
    begin
      for j := 0 to length(categorias)-1 do
        begin
          nao_existe := false;
          if (new_filmes[i].descricao<>filmes[j].descricao)or(new_filmes[i].codcat<>filmes[j].codcat)or(new_filmes[i].lingua<>filmes[j].lingua)
            then begin
                   nao_existe := true;
                 end
            else begin
                   break;
                   nao_existe := false;
                 end;
        end;
      if nao_existe
        then begin
               films.codigo := GeraCodigoFilme;
               films.descricao := new_filmes[i].descricao;
               films.exemplares := new_filmes[i].exemplares;
               films.codcat := new_filmes[i].codcat;
               films.lingua := new_filmes[i].lingua;
               films.ativo := new_filmes[i].ativo;
               GravaFilmeVetor(films);
             end;
    end;
  EditaNoArquivo;
end;

procedure ImportaContasReceber(caminho:string);
var
  ArqImp : TextFile;
  linha, tag : string;
  posi, i, j : integer;
  new_contasreceber: array of receber;
  rece : receber;
  nao_existe : boolean;
begin
  SetLength(new_contasReceber,0);
  AssignFile(ArqImp,caminho);
  Reset(ArqImp);
  while not(eof(ArqImp)) do
    begin
      readln(ArqImp,linha);
      tag := LerTag(linha);
      if tag = #9'<tabela = contas_receber>'
        then begin
               while tag <> #9'</tabela>' do
                 begin
                   tag := LerTag(linha);
                   readln(ArqImp,linha);
                   if tag = #9#9'<registro>'
                     then begin
                            SetLength(new_contasreceber,length(new_contasreceber)+1);
                            while tag <> #9#9'</registro>' do
                              begin
                                tag := LerTag(linha);
                                posi := length(new_contasreceber)-1;
                                case AnsiIndexStr(tag,[#9#9#9'<CodigoCliente>',#9#9#9'<ValorParcela>',
                                #9#9#9'<DataParcela>',#9#9#9'<PagaParcela>',#9#9#9'<DataPagamento>']) of
                                  0 : new_contasreceber[posi].Cod_Cliente := LerDados(linha);
                                  1 : new_contasreceber[posi].parcela := LerDados(linha);
                                  2 : new_contasreceber[posi].data := LerDados(linha);
                                  3 : begin
                                        if LerDados(linha) = 'FALSE'
                                          then new_contasreceber[posi].pago := false
                                          else new_contasreceber[posi].pago := true;
                                      end;
                                  4 : new_contasreceber[posi].pagamento := LerDados(linha);
                                end;
                                readln(ArqImp,linha);
                              end;
                          end;
                 end;
             end;
   end;
  CloseFile(ArqImp);
  nao_existe := false;
  for i := 0 to length(new_contasreceber)-1 do
    begin
      for j := 0 to length(contas_receber)-1 do
        begin
          nao_existe := false;
          if (new_contasreceber[i].Cod_Cliente<>contas_receber[j].Cod_Cliente)or(new_contasreceber[i].parcela<>contas_receber[j].parcela)
           or(new_contasreceber[i].pago<>contas_receber[j].pago)or(new_contasreceber[i].data<>contas_receber[j].data)
           or(new_contasreceber[i].pagamento<>contas_receber[j].pagamento)
            then begin
                   nao_existe := true;
                 end
            else begin
                   break;
                   nao_existe := false;
                 end;
        end;
      if nao_existe
        then begin
               rece.Cod_Cliente := new_contasreceber[i].Cod_Cliente;
               rece.parcela := new_contasreceber[i].parcela;
               rece.pago := new_contasreceber[i].pago;
               rece.data := new_contasreceber[i].data;
               rece.pagamento := new_contasreceber[i].pagamento;
               GravaContasReceberVetor(rece);
             end;
    end;
  EditaNoArquivo;
end;

procedure ImportaDevolucoes(caminho:string);
var
  ArqImp : TextFile;
  linha, tag : string;
  posi, i, j : integer;
  new_devolucoes: array of devolver;
  devo : devolver;
  nao_existe : boolean;
begin
  SetLength(new_devolucoes,0);
  AssignFile(ArqImp,caminho);
  Reset(ArqImp);
  while not(eof(ArqImp)) do
    begin
      readln(ArqImp,linha);
      tag := LerTag(linha);
      if tag = #9'<tabela = devolucoes>'
        then begin
               while tag <> #9'</tabela>' do
                 begin
                   tag := LerTag(linha);
                   readln(ArqImp,linha);
                   if tag = #9#9'<registro>'
                     then begin
                            SetLength(new_devolucoes,length(new_devolucoes)+1);
                            while tag <> #9#9'</registro>' do
                              begin
                                tag := LerTag(linha);
                                posi := length(new_devolucoes)-1;
                                case AnsiIndexStr(tag,[#9#9#9'<CodCliente>',#9#9#9'<CodFilme>',
                                #9#9#9'<DataLocacao>',#9#9#9'<DataDevolucao>',#9#9#9'<Devolvido>',
                                #9#9#9'<TipoLocacao>',#9#9#9'<CodFuncionario>']) of
                                  0 : new_devolucoes[posi].CodCliente := LerDados(linha);
                                  1 : new_devolucoes[posi].codFilmes := LerDados(linha);
                                  2 : new_devolucoes[posi].dataLoc := LerDados(linha);
                                  3 : new_devolucoes[posi].DataDev := LerDados(linha);
                                  4 : begin
                                        if Lerdados(linha) = 'FALSE'
                                          then new_devolucoes[posi].devolvido := false
                                          else new_devolucoes[posi].devolvido := true
                                      end;
                                  5 : new_devolucoes[posi].tipo := LerDados(linha);
                                  6 : new_devolucoes[posi].funcionario := LerDados(linha);
                                end;
                                readln(ArqImp,linha);
                              end;
                          end;
                 end;
             end;
   end;
  CloseFile(ArqImp);
  nao_existe := false;
  for i := 0 to length(new_devolucoes)-1 do
    begin
      for j := 0 to length(filmes_devolver)-1 do
        begin
          nao_existe := false;
          if (new_devolucoes[i].dataLoc <> filmes_devolver[j].dataLoc)or(new_devolucoes[i].DataDev <> filmes_devolver[j].DataDev)
           or(new_devolucoes[i].codFilmes <> filmes_devolver[j].codFilmes)or(new_devolucoes[i].CodCliente <> filmes_devolver[j].CodCliente)
           or(new_devolucoes[i].tipo <> filmes_devolver[j].tipo)or(new_devolucoes[i].funcionario <> filmes_devolver[j].funcionario)
           or(new_devolucoes[i].devolvido <> filmes_devolver[j].devolvido)
            then begin
                   nao_existe := true;
                 end
            else begin
                   break;
                   nao_existe := false;
                 end;
        end;
      if nao_existe
        then begin
               devo.dataLoc := new_devolucoes[i].dataLoc;
               devo.DataDev := new_devolucoes[i].DataDev;
               devo.codFilmes := new_devolucoes[i].codFilmes;
               devo.CodCliente := new_devolucoes[i].CodCliente;
               devo.tipo := new_devolucoes[i].tipo;
               devo.funcionario := new_devolucoes[i].funcionario;
               devo.devolvido := new_devolucoes[i].devolvido;
               GravaDevolucaoVetor(devo);
             end;
    end;
  EditaNoArquivo;
end;

procedure ImportaContasPagar(caminho:string);
var
  ArqImp : TextFile;
  linha, tag : string;
  posi, i, j : integer;
  new_pagar: array of pagar;
  pg : pagar;
  nao_existe : boolean;
begin
  SetLength(new_pagar,0);
  AssignFile(ArqImp,caminho);
  Reset(ArqImp);
  while not(eof(ArqImp)) do
    begin
      readln(ArqImp,linha);
      tag := LerTag(linha);
      if tag = #9'<tabela = contas_Pagar>'
        then begin
               while tag <> #9'</tabela>' do
                 begin
                   tag := LerTag(linha);
                   readln(ArqImp,linha);
                   if tag = #9#9'<registro>'
                     then begin
                            SetLength(new_pagar,length(new_pagar)+1);
                            while tag <> #9#9'</registro>' do
                              begin
                                tag := LerTag(linha);
                                posi := length(new_pagar)-1;
                                case AnsiIndexStr(tag,[#9#9#9'<CodigoFornecedor>',#9#9#9'<DataDaCompra>',
                                #9#9#9'<ValorParcela>',#9#9#9'<PagaParcela>',#9#9#9'<DataDeVencimento>',
                                #9#9#9'<DataDePagamento>']) of
                                  0 : new_pagar[posi].cod_forn := LerDados(linha);
                                  1 : new_pagar[posi].data_compra := LerDados(linha);
                                  2 : new_pagar[posi].valor := LerDados(linha);
                                  3 : begin
                                        if Lerdados(linha) = 'FALSE'
                                          then new_pagar[posi].paga := false
                                          else new_pagar[posi].paga := true
                                      end;
                                  4 : new_pagar[posi].data_venc := LerDados(linha);
                                  5 : new_pagar[posi].data_pag := LerDados(linha);
                                end;
                                readln(ArqImp,linha);
                              end;
                          end;
                 end;
             end;
   end;
  CloseFile(ArqImp);
  nao_existe := false;
    for i := 0 to length(new_pagar)-1 do
    begin
      for j := 0 to length(contas_pagar)-1 do
        begin
          nao_existe := false;
          if (new_pagar[i].cod_forn<>contas_pagar[j].cod_forn)or(new_pagar[i].data_compra<>contas_pagar[j].data_compra)
           or(new_pagar[i].valor<>contas_pagar[j].valor)or(new_pagar[i].paga<>contas_pagar[j].paga)or(new_pagar[i].data_venc<>contas_pagar[j].data_venc)
           or(new_pagar[i].data_pag<>contas_pagar[j].data_pag)
            then begin
                   nao_existe := true;
                 end
            else begin
                   break;
                   nao_existe := false;
                 end;
        end;
      if nao_existe
        then begin
               pg.cod_forn := new_pagar[i].cod_forn;
               pg.data_compra := new_pagar[i].data_compra;
               pg.valor := new_pagar[i].valor;
               pg.paga := new_pagar[i].paga;
               pg.data_venc := new_pagar[i].data_venc;
               pg.data_pag := new_pagar[i].data_pag;
               GravaContasPagarVetor(pg);
             end;
    end;
  EditaNoArquivo;
end;

end.
