:- use_module(library(system)).
:- use_module(library(random)).
:- use_module(library(lists)).


setRandomSeed:-
	now(Time), S is Time mod 30269,
	getrand(random(X, Y, Z, _)),
	setrand(random(S, X, Y, Z)), !.
:-setRandomSeed. %set a random seed

listToString(List, Result):-
	listToString(List, '', Result).

listToString([], Final, Final).
listToString([H|T], Temp, Final):-
	atom_concat(Temp, H, NewRes),
	listToString(T, NewRes, Final).

numberToString(Number, String):-
	number_chars(Number, TempList),
	listToString(TempList, String).

writeString(_, 0).
writeString(String, Count):-
    write(String),
    NewCount is Count - 1,
    writeString(String, NewCount).

%https://stackoverflow.com/questions/41454755/how-can-i-replace-an-element-of-a-list-using-an-index-in-prolog
replaceAt([_|T],0,E,[E|T]).
replaceAt([H|T],P,E,[H|R]) :-
    P > 0, NP is P-1, replaceAt(T,NP,E,R).

%replace a stack at the Line, Column by the NewStack
replaceBoardStack(Board, X, Y, NewStack, NewBoard):-
    nth0(X, Board, Line),
    replaceAt(Line, Y, NewStack, NewLine), %replace the cell for the new piece
    replaceAt(Board, X, NewLine, NewBoard).


getBoardTopColor(X, Y, TopColor):-
    board(B),
    nth0(X, B, Line), %get the line
    nth0(Y, Line, [TopColor|_]). %get the cell and the head which is the top color

getBoardStack(X, Y, Stack):-
    board(B),
    nth0(X, B, Line),  %get the line
    nth0(Y, Line, Stack). %get the Stack

%get the stack height (getBoardStackHeight/4 sets the last as the Stack)
getBoardStackHeight(X, Y, Height):-getBoardStackHeight(X, Y, Height, _).
getBoardStackHeight(X, Y, Height, Stack):-
    getBoardStack(X, Y, Stack),
    length(Stack, Height).

%get the player that owns this color, fails if none:
getPlayerFromColor(Color, _Player):-
    toClaim(ToClaim),
    nth0(_, ToClaim, Color), %if the color is not claimed, fails
    !, fail.
%assuming then, that this color is claimed, it belongs to player1, player2 or bot
%testing player1
getPlayerFromColor(Color, Player):-testPlayerOwnsColor(player1, Color, Player).
getPlayerFromColor(Color, Player):-testPlayerOwnsColor(player2, Color, Player).
getPlayerFromColor(Color, Player):-testPlayerOwnsColor(bot, Color, Player).

testPlayerOwnsColor(Player, Color, Player):-
    getColors(Player, Colors),
    nth0(_, Colors, Color), %if the color belongs to player 1
    !.

%not implementation
not(X):-X, !, fail.
not(_).

clear:-write('\33\[2J').


% databse manipulation helpers, remove arity one for consulting the database
% board database helpers
board(B):-
    game(G),
    board(G, B).
saveBoard(B):-
    retract(board(_, _)),
    game(G),
    assert(board(G, B)).
% player database helpers
player(Player):-
    game(G),
    player(G, Player).
savePlayer(Player):-
    retract(player(_, _)),
    game(G),
    assert(player(G, Player)).
% next player database helpers
nextPlayer(Player):-
    game(G),
    nextPlayer(G, Player).
saveNextPlayer(Player):-
    retract(nextPlayer(_, _)),
    game(G),
    assert(nextPlayer(G, Player)).
% to claim database helpers
toClaim(Colors):-
    game(G),
    toClaim(G, Colors).
saveToClaim(Colors):-
    retract(toClaim(_, _)),
    game(G),
    assert(toClaim(G, Colors)).
% get colors database helpers
getColors(Player, Colors):-
    game(G),
    getColors(G, Player, Colors).
saveGetColors(Player, Colors):-
    retract(getColors(_, _, _)),
    game(G),
    assert(getColors(G, Player, Colors)).
