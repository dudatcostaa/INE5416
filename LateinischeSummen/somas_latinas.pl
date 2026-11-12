:- use_module(library(clpfd)).

% predicado puzzle/2 tem clausulas em varios arquivos
:- multifile puzzle/2.

% carrega os puzzles
:- [
    'puzzles/puzzle_51.pl',
    'puzzles/puzzle_52.pl',
    'puzzles/puzzle_53.pl',
    'puzzles/puzzle_54.pl',
    'puzzles/puzzle_55.pl',
    'puzzles/puzzle_120.pl',
    'puzzles/puzzle_160.pl',
    'puzzles/puzzle_238.pl',
    'puzzles/puzzle_380.pl',
    'puzzles/puzzle_400.pl'
].


% conta as casas brancas da primeira linha para definir N
contar_brancas([], 0).
contar_brancas([x|T], N) :-
    contar_brancas(T, N1),
    N is N1 + 1.
contar_brancas([p(_)|T], N) :- contar_brancas(T, N).


% monta a grade com variaveis de 1 a N nas casas brancas
% casas pretas viram 0 para nao atrapalhar as somas
montar_grade([], _, []).
montar_grade([Linha|T], N, [Valores|R]) :-
    montar_linha(Linha, N, Valores),
    montar_grade(T, N, R).

montar_linha([], _, []).
montar_linha([x|T], N, [V|R]) :-
    V in 1..N,
    montar_linha(T, N, R).
montar_linha([p(_)|T], N, [0|R]) :- montar_linha(T, N, R).



% restricoes do quadrado latino

% pega somente os valores das casas brancas
brancas([], [], []).
brancas([x|T], [V|R], [V|Vs]) :- brancas(T, R, Vs).
brancas([p(_)|T], [_|R], Vs) :- brancas(T, R, Vs).

% impede numeros repetidos em cada linha ou coluna
verificar_linhas([], []).
verificar_linhas([Linha|T], [Valores|R]) :-
    brancas(Linha, Valores, Vs),
    all_distinct(Vs),
    verificar_linhas(T, R).



% restricoes de soma

% pega o valor de uma celula, usando 0 se estiver fora da grade
% o corte evita tentar a segunda clausula quando a celula existe
valor_celula(Grade, I, J, V) :-
    I >= 0,
    J >= 0,
    nth0(I, Grade, Linha),
    nth0(J, Linha, V), !.
valor_celula(_, _, _, 0).

% pega os oito vizinhos de uma celula
vizinhos(Grade, I, J, [A, B, C, D, E, F, G, H]) :-
    I1 is I - 1,
    I2 is I + 1,
    J1 is J - 1,
    J2 is J + 1,
    valor_celula(Grade, I1, J1, A),
    valor_celula(Grade, I1, J, B),
    valor_celula(Grade, I1, J2, C),
    valor_celula(Grade, I, J1, D),
    valor_celula(Grade, I, J2, E),
    valor_celula(Grade, I2, J1, F),
    valor_celula(Grade, I2, J, G),
    valor_celula(Grade, I2, J2, H).

% percorre as linhas e aplica as restricoes de soma nas casas com pista
verificar_somas([], _, _).
verificar_somas([Linha|T], Grade, I) :-
    somas_linha(Linha, Grade, I, 0),
    I1 is I + 1,
    verificar_somas(T, Grade, I1).

% percorre cada celula da linha, ignorando as que nao possuem pista
% a soma dos vizinhos deve ser igual ao valor da pista
somas_linha([], _, _, _).
somas_linha([x|T], Grade, I, J) :-
    J1 is J + 1,
    somas_linha(T, Grade, I, J1).
somas_linha([p|T], Grade, I, J) :-
    J1 is J + 1,
    somas_linha(T, Grade, I, J1).
somas_linha([p(S)|T], Grade, I, J) :-
    vizinhos(Grade, I, J, Vs),
    sum(Vs, #=, S),
    J1 is J + 1,
    somas_linha(T, Grade, I, J1).

% remove os zeros para nao incluir as casas pretas na busca
% o corte evita backtracking desnecessario sobre os zeros
retirar_zeros([], []).
retirar_zeros([V|T], R) :-
    V == 0, !,
    retirar_zeros(T, R).
retirar_zeros([V|T], [V|R]) :- retirar_zeros(T, R).



% resolucao do puzzle

% monta o problema e aplica as restricoes antes da busca
preparar(Puzzle, Grade, Variaveis) :-
    Puzzle = [Primeira|_],
    contar_brancas(Primeira, N),
    montar_grade(Puzzle, N, Grade),

    % verifica as somas e os valores das linhas
    verificar_somas(Puzzle, Grade, 0),
    verificar_linhas(Puzzle, Grade),

    % verifica as colunas usando transpose
    transpose(Puzzle, PuzzleT),
    transpose(Grade, GradeT),
    verificar_linhas(PuzzleT, GradeT),

    % junta as linhas e retira os zeros
    append(Grade, Todas),
    retirar_zeros(Todas, Variaveis).

% resolve usando as heuristicas ffc e bisect
% ffc escolhe a variavel com menos opcoes e, em caso de empate prioriza a que participa de mais restricoes
% bisect divide o dominio em duas partes durante a busca
resolver(Puzzle, Grade) :-
    preparar(Puzzle, Grade, Variaveis),
    labeling([ffc, bisect], Variaveis).



% impressao do puzzle

% imprime a grade linha por linha
imprimir_grade([], []).
imprimir_grade([Linha|T], [Valores|R]) :-
    imprimir_linha(Linha, Valores),
    nl,
    imprimir_grade(T, R).

% percorre as celulas de uma linha para imprimir
imprimir_linha([], []).
imprimir_linha([Celula|T], [V|R]) :-
    imprimir_celula(Celula, V),
    imprimir_linha(T, R).

% imprime os valores das casas brancas e as pistas das casas pretas
imprimir_celula(x, V) :- write(V), tab(5).
imprimir_celula(p(S), _) :-
    write('['), write(S), write(']'),
    (S < 10 -> tab(3) ; tab(2)).



% testes

% resolve um puzzle pelo numero e mostra o resultado
testar(Id) :-
    puzzle(Id, Puzzle),
    resolver(Puzzle, Grade),
    imprimir_grade(Puzzle, Grade).