:- include('utils.pl').

:- include('getRandomBoard.pl').
:- include('displayBoard.pl').

:- include('evaluate.pl').
:- include('claim.pl').
:- include('move.pl').
:- include('interface.pl').

%:- include('tests.pl').


% volatile and dynamic predicates declaration
:- volatile
    board/1,        % the current board state
    player/1,       % the current player
    nextPlayer/1,   % the next player
    toClaim/1,      % which colors are yet to claim
    getColors/2,    % a list of the colors claimed by the selected player getColors(player, Colors)
    getStacks/2.    % a list of the stacks collected by the selected player getStacks(player, Stacks)
    hasClaimed/1.   % a flag to indicate wheter the current player has claimed a color in this turn

:- dynamic
    board/1,
    player/1,
    nextPlayer/1,
    toClaim/1,
    getColors/2,
    getStacks/2,
    hasClaimed/1.

%make bot start first or human start first, 50% chance
randomizeBotPlay:-
    random_select(Temp, [0, 1], _),
    Temp =:= 0,
    assert(player(player1)),
    assert(nextPlayer(bot)),
    write('Player 1 goes first...\n').
randomizeBotPlay:-
    assert(player(bot)),
    assert(nextPlayer(player1)),
    write('Bot goes first...\n').

%game type (User x User | User x Bot)
startGame(quit):-exit. %abort
startGame(instructions):-displayInstructions. %abort
startGame(humanVhuman):- %intialize both players. The real players should randomly choose their turn
    assert(player(player1)),
    assert(nextPlayer(player2)),
    write('Human Vs Human Selected\n').

startGame(humanVbot):- % initialize the player and the nextPlayer randomly, the bot may be first
    write('Human Vs Bot Selected\n'),
    randomizeBotPlay.

%try to read a valid game type (1(humanVhuman), 2(humanVbot) or 3 (quit))
getGameType(GameType):-
    read_line([GameTypeLine|_]),
    menuTranslate(GameType, GameTypeLine).
getGameType(GameType):-
    write('Wrong game type, try again:\n'),
    getGameType(GameType).

%wait for instruction and enter
waitForInstruction:-
    write('Enter your instruction (move, claim, quit)\n'),
    read_line(Instruction),
    parseInstruction(Instruction).

%expecting a move instruction
parseInstruction("move"):-
    repeat,
        move,
    !.%, endTurn. %after a move the next player plays
    %format('Moving from ~d,~d to ~d,~d\n', [Xf, Yf, Xt, Yt]).

%expecting a claim instruction
parseInstruction("claim"):-%instruction was claim and has not claimed any piece
    hasClaimed(false),
    repeat,
        claimColor,
    !,
    nextTurn. % the players can move after a claim
parseInstruction("claim"):-%claim but already claimed a piece in this turn
    write('You can only claim one color per turn\n'), !,  fail.

%expecting a quit instruction
parseInstruction("quit"):-exit.

%unexpected instruction
parseInstruction(_):-
    write('Instruction not recognized, try again.\n'), fail.

%display board and wait for instruction
nextTurn:-
    evaluateBoard,
    displayBoard,
    repeat,
        waitForInstruction,
    !.

%check the bot should play
isBotPlaying:-
    player(bot),!, %the next player is the bot
    playBot.
isBotPlaying.

% inverts the two players
invertPlayers:-
    nextPlayerHasMoves, %only invert if the next player has valid moves
    player(CurrentPlayer),
    nextPlayer(NextPlayer),
    retract(player(_)),
    retract(nextPlayer(_)),
    assert(player(NextPlayer)),
    assert(nextPlayer(CurrentPlayer)).
invertPlayers.%if next player has no valid move, keep the players

%checks the board state, changes the players and starts the nextTurn
endTurn:-
    evaluateBoard, !,
    invertPlayers, !,
    isBotPlaying, !,
    retract(hasClaimed(_)), % clear the hasClaimed flag.
    assert(hasClaimed(false)),
    nextTurn.

%empties the database and stops the program
exit:-clearInit, abort.
%empties the database
clearInit:-
    abolish(board/1),
    abolish(player/1),
    abolish(nextPlayer/1),
    abolish(toClaim/1),
    abolish(getColors/2),
    abolish(getStacks/2),
    abolish(hasClaimed/1),
    assert(hasClaimed(false)).

%where everything begins
init:-
    clearInit,
    displayMenu,
    getGameType(GameType),
    startGame(GameType),
    getRandomBoard(Board),

    player(CurrentPlayer),
    nextPlayer(NextPlayer),

    claimableColors(C),
    assert(toClaim(C)),     % load the colors that can be claimed
    assert(board(Board)),   % save the board state
    assert(getColors(CurrentPlayer, [])),
    assert(getColors(NextPlayer, [])),
    assert(getStacks(CurrentPlayer, [])),
    assert(getStacks(NextPlayer, [])),
    !,
    nextTurn,
    clearInit.
