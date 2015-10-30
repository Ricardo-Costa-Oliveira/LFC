
Trabalho de Processamento de Linguagens__
======
Front-end do compilador para a linguagem de programacao FIXE e geracao de grafo de dependencia de funcoes de um programa (cod.  11567)__
Departamento de Informatica__
Universidade da Beira Interior__
Ano lectivo 2015/2016__
1    Introducao__
Este trabalho e parte constituinte da avaliacao partica da Unidade Curricular de codigo 11567 designada por Processamento de Linguagens, na sua edicao de 2015-2016.__
O  trabalho  visa  o  exercicio  dos  conceitos  e  das  tecnicas  basicas  de  desenho de processadores de linguagens e de compiladores expostos nas aulas da presente UC. Com tal este trabalho e estruturado em varias fases.  Estas diferentes fases visam ilustrar a utilizacao de tecnicas (e ferramentas computacionais associadas) de processamento de linguagens.  Em particular as tecnicas de analises lexica, sintactica e semantica.__
__
2    Descricao geral do trabalho__
O objectivo geral e a construcao de um front-end simples para uma pequena linguagem de programacao (i.e.  que envolve as analises lexicas, sintacticas e semanticas classicas), a linguagem FIXE. Esta linguagem e uma DSL especializada no desenvolvimento de aplicacoes de seguranca/criptogracas.__
A utilizacao do front-end sobre uma programa escrito na linguagem de programacao alvo devera resultar numa analise/procura/listagem completa dos erros de programacao que estas analises sao capazes de detectar, e caso o programa auscultado o permite (i.e.  estar sem erros) a producao em saida de um grafo de dependencia descrito na linguagem DOT.
Nesta parte pretende-se que seja denida a (gramatica para a) linguagem de  programacao  e  construdo  um  pequeno front-end para  esta  linguagem.
Assim pretende-se:

	O lexico e a gramatica (formato BNF) da linguagem denida.

	Um analisador lexico para esta linguagem.

	Um analisador sintatico.

	A  versao  preliminar  de  um  analisador  semantico  que  construa  uma arvore  de  sintaxe  abstracta enfeitada e  uma  tabela  de  smbolo  que permitam  uma  analise  preliminar  da  tipagem  e  a  execucao  do  passo seguinte.

	Um tradutor da arvore de sintaxe abstracta para um cheiro DOT que espelha a estrutura (as dependencias dos smbolos de funcao entre si) do programa fonte.



3    Trabalho Requerido
Para comecar, nao ha imposicao da linguagem de programacao por usar para resolver/implementar este trabalho desde que haja autorizacao explcita do regente da UC da proposta tecnologica do grupo.  Mais, todas as disposicoes aqui listadas deverao ser tomadas em conta.

E esperado igualmente que o grupo reporte atempadamente a equipa docente os entregaveis preliminares mas igualmente as dificuldades ou questoes encontradas.
O trabalho completo devera ser entregue no dia 8 de Janeiro de 2016, e as defesas terao lugar nos primeiros dias da semana seguinte em calendario por definir e afixar na pagina da UC. A entrega devera respeitar as modalidades de entrega descritas na seccao  4.
Define-se diferentes momentos de realizacao que descrevemos a seguir e para os quais juntamos um conjunto de objectivos { com respectiva de data limite  de  realizacao  (entrega,  comunicacao  do  trabalho  realizado  a  equipa docente).



3.1    Primeira etapa
Data limite de realizacao:  31 de Outubro de 2015.
Espera-se nesta etapa que o grupo estude os exemplos de programas da linguagem alvo.  Estes exemplos sao representativos da linguagem de programacao alvo, a linguagem FIXE, e deverao poder ser analisados pelas solucoes implementadas neste trabalho.
Na  sequencia  do  estudo,  espera-se  que  o  grupo  define  cuidadosamente a gramatica (formato BNF) da linguagem com base nestes exemplos.  Esta gramatica constitui o entregavel para esta etapa.



3.2    Segunda etapa
Data limite de realizacao:  13 de Novembro de 2015.
Espera-se  nesta  etapa  que  seja  construido  o  analisador  lexico.   O
lexer
resultante constitui o entregavel para esta etapa.



3.3    Terceira etapa
Data limite de realizacao:  4 de Dezembro de 2015.
Espera-se  nesta  etapa  que  seja  construido  o  analisador  sintactico  com-
pleto, com o devido processamento dos erros sintacticos.  O
parser
resultante
constitui o entregavel para esta etapa.



3.4    Quarta etapa
Data limite de realizacao:  18 de Dezembro de 2015.
Espera-se nesta etapa que o o analisador sintactico seja extendido com a  capacidade  em  construir  uma  AST  e  uma  tabela  de  simbolos.   O
parser extendido resultante constitui o entregavel para esta etapa.



3.5    Quinta etapa
Data limite de realizacao:  8 de Janeiro de 2016.
Espera-se nesta etapa que seja construido o analisador semiantico para a linguagem FIXE. Este analisador verifica a tipagem e o iambito (scope) dos
simbolos dos programa analisado.  Espera-se igualmente que uma analise de dependiencia  dos  simbolos  seja  conduzida  e  que  esta  resulte  na  geracao  de
um grafo de dependiencia na forma de um ficheiro DOT produzido na saida desta analise.
4    Entrega do trabalho
O  trabalho  deve  ser  entregue  num  arquivo  tar  comprimido  (nome.tgz)  em que nome e o identificador do vosso grupo.  este arquivo deve conter todos os ficheiros fontes necessarios a compilacao assim como um Makefile completo (as entradas all e clean devem estar presentes).
Este arquivo devera igualmente conter o relatorio que descreve o trabalho feito,  as  escolhas  (de  desenho,  etc.)   tomadas,  a  documentacao  do  codigo e  o  manual  do  utilizador.

E  igualmente  esperada  que  seja  preparada  uma apresentacao para a respetiva apresentacao
