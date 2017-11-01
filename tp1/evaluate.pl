/* This file contains all the predicates required for the game logic to be implemented (allowed moves, ...)*/

/* Which board cells can be used (since it is not a board of squares) */

/*[0, 0, 1, 0, 1, 0, 1, 0, 0]*/
/* first line of matrix */
isValid(0, 2).
isValid(0, 4).
isValid(0, 6).
/* second line of matrix */
isValid(1, 3).
isValid(1, 5).
/* third line of matrix */
isValid(2, 2).
isValid(2, 4).
isValid(2, 6).

/*[0, 1, 0, 1, 0, 1, 0, 1, 0]*/
/* fourth line of matrix */
isValid(3, 1).
isValid(3, 3).
isValid(3, 5).
isValid(3, 7).
/* fifth line of matrix */
isValid(4, 2).
isValid(4, 4).
isValid(4, 6).
/* sixth line of matrix */
isValid(5, 1).
isValid(5, 3).
isValid(5, 5).
isValid(5, 7).

/*[1, 0, 1, 0, 1, 0, 1, 0, 1]*/
/* seventh line of matrix */
isValid(6, 0).
isValid(6, 2).
isValid(6, 4).
isValid(6, 6).
isValid(6, 8).

/*[0, 1, 0, 1, 0, 1, 0, 1, 0]*/
/* eigth line of matrix */
isValid(7, 1).
isValid(7, 3).
isValid(7, 5).
isValid(7, 7).
/* nineth line of matrix */
isValid(8, 2).
isValid(8, 4).
isValid(8, 6).
/* tenth line of matrix */
isValid(9, 1).
isValid(9, 3).
isValid(9, 5).
isValid(9, 7).

/*[0, 0, 1, 0, 1, 0, 1, 0, 0]*/
/* eleventh line of matrix */
isValid(10, 2).
isValid(10, 4).
isValid(10, 6).
/* twelfth line of matrix */
isValid(11, 3).
isValid(11, 5).
/* thirteenth line of matrix */
isValid(12, 2).
isValid(12, 4).
isValid(12, 6).


/* convert the isValid predicate into a list of two lists containg the x and the y values of isValid*/
getValidPositions(Result):-
    findall(X-Y, isValid(X,Y), Result).

isMoveValid(Xf, Yf, Xt, Yt):-
    checkValidMove(Xf, Yf),
    checkValidMove(Xt, Yt).

/* inBoard(X, Y):-
    X > -1, X < 9,
    Y > -1, Y < 13. */

%check if the board is in a final state, probably use validMove and find_all
evaluateBoard:-
    write('----TODO: evaluate board state\n').

%check if the next player has at least one valid move
nextPlayerHasMoves:-
    write('----TODO: nextPlayerHasMoves not implemented\n').


%fails if X and Y's top color is not a neutral piece
isStackNeutral(X, Y):-
    getBoardTopColor(X, Y, Piece), %single NEUTRAl piece
    toClaim(NeutralPieces),
    nth0(_, NeutralPieces, Piece). %if this is a neutral piece