% Define the maximum capacities of the jugs
capacity(jug1, 4).
capacity(jug2, 3).

% Define the goal state (target amount of water)
goal_state(2).

% Initial state
initial_state(state(0, 0)).

% Define the possible moves with action descriptions
move(state(X, Y), state(4, Y), 'Fill 4L jug.') :- capacity(jug1, 4), X < 4.
move(state(X, Y), state(X, 3), 'Fill 3L jug.') :- capacity(jug2, 3), Y < 3.
move(state(X, Y), state(0, Y), 'Empty 4L jug.') :- X > 0.
move(state(X, Y), state(X, 0), 'Empty 3L jug.') :- Y > 0.
move(state(X, Y), state(NewX, NewY), 'Pour water from 4L jug to 3L jug.') :- 
    capacity(jug2, CapY),
    X > 0,
    Y < CapY,
    Transfer is min(X, CapY - Y),
    NewX is X - Transfer,
    NewY is Y + Transfer.
move(state(X, Y), state(NewX, NewY), 'Pour water from 3L jug to 4L jug.') :- 
    capacity(jug1, CapX),
    Y > 0,
    X < CapX,
    Transfer is min(Y, CapX - X),
    NewX is X + Transfer,
    NewY is Y - Transfer.

% Solve the problem using depth-first search
solve(Solution) :-
    initial_state(StartState),
    goal_state(Goal),
    dfs(StartState, Goal, [StartState], [], Solution).

% Depth-first search algorithm
dfs(state(X, _), Goal, _, Actions, [(state(X, 0), 'Goal State reached...') | Actions]) :-
    X =:= Goal.
dfs(CurrentState, Goal, Path, Actions, Solution) :-
    move(CurrentState, NextState, Action),
    \+ member(NextState, Path),  % Avoid cycles
    dfs(NextState, Goal, [NextState | Path], [(NextState, Action) | Actions], Solution).

% Print the solution in a readable format
print_solution([]).
print_solution([(state(X, Y), Action) | Rest]) :-
    format('4L:~w & 3L:~w (Action: ~w)~n', [X, Y, Action]),
    print_solution(Rest).

% Query the solution and print it
water_jug(Solution) :-
    solve(SolutionPath),
    reverse(SolutionPath, Solution),
    print_solution(Solution).
