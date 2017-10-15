:- use_module(library(lists)).
/* 8 pieces of each main color (D, R, I, G, B) and 3 of the wild color (W) */
boardExample([
    [[empty], [empty], [red], [empty], [black], [empty], [blue], [empty], [empty]],
    [[empty], [empty], [empty], [red], [empty], [ivory], [empty], [empty], [empty]],
    [[empty], [empty], [green], [empty], [ivory], [empty], [black], [empty], [empty]],
    [[empty], [green], [empty], [wild], [empty], [blue], [empty], [blue], [empty]],
    [[empty], [empty], [black], [empty], [ivory], [empty], [green], [empty], [empty]],
    [[empty], [blue], [empty], [green], [empty], [red], [empty], [wild], [empty]],
    [[ivory], [empty], [black], [empty], [blue], [empty], [red], [empty], [ivory]],
    [[empty], [black], [empty], [ivory], [empty], [black], [empty], [green], [empty]],
    [[empty], [empty], [red], [empty], [ivory], [empty], [blue], [empty], [empty]],
    [[empty], [blue], [empty], [wild], [empty], [red], [empty], [green], [empty]],
    [[empty], [empty], [ivory], [empty], [red], [empty], [black], [empty], [empty]],
    [[empty], [empty], [empty], [black], [empty], [green], [empty], [empty], [empty]],
    [[empty], [empty], [red], [empty], [green], [empty], [blue], [empty], [empty]]
]).


% example to get the translation of the value at position (0, 2):
% boardExample(Rb), nth0(0, Rb, Line), nth0(2, Line, [Val|T]), translate(Val, Char), write(Val), write(' is '), write(Char).