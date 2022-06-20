import 'package:deact/deact.dart';
import 'package:deact/deact_html52.dart';

List<String> emptyBoard() => ['', '', '', '', '', '', '', '', ''];

String togglePlayer(String player) {
  if (player == 'X') {
    return 'O';
  } else {
    return 'X';
  }
}

String? checkWin(List<String> fields) {
  final wins = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  for (final win in wins) {
    var row = '';
    for (final fieldId in win) {
      row += fields[fieldId];
    }
    if (row == 'XXX' || row == 'OOO') {
      return row.substring(0, 1);
    }
  }

  final filledFields = fields.where((field) => field != '').toList().length;
  return filledFields == 9 ? '' : null;
}

void onFieldClick(
  int fieldIndex,
  State<List<String>> board,
  State<String> player,
  State<bool> inGame,
) {
  final currentFieldValue = board.value[fieldIndex];
  if (inGame.value && currentFieldValue == "") {
    board.update((state) {
      state[fieldIndex] = player.value;
    });
    if (checkWin(board.value) != null) {
      inGame.value = false;
    } else {
      player.value = togglePlayer(player.value);
    }
  }
}

DeactNode board() {
  return fc((ctx) {
    final board = ctx.globalState<List<String>>('board');
    final player = ctx.globalState<String>('player');
    final inGame = ctx.globalState<bool>('inGame');
    return table(children: [
      for (int row = 0; row < 3; row++)
        tr(children: [
          for (int col = 0; col < 3; col++)
            td(
                className:
                    '${col == 1 ? 'vert-center' : ''} ${row == 1 ? 'horz-center' : ''}',
                children: [txt(board.value[row * 3 + col])],
                onclick: (_) => onFieldClick(
                      row * 3 + col,
                      board,
                      player,
                      inGame,
                    ))
        ])
    ]);
  });
}

DeactNode currentPlayerMessage() {
  return fc((ctx) {
    final player = ctx.globalState<String>('player');
    final inGame = ctx.globalState<bool>('inGame');
    return div(children: [
      if (inGame.value) ...[
        span(children: [txt('Player ')]),
        span(className: 'accent', children: [txt(player.value)]),
        span(children: [txt(' is on the move...')]),
      ]
    ]);
  });
}

DeactNode message() {
  return fc((ctx) {
    final player = ctx.globalState<String>('player');
    final board = ctx.globalState<List<String>>('board');
    final winner = checkWin(board.value);
    return div(children: [
      if (winner != null && winner != '') ...[
        span(children: [txt('Player ')]),
        span(className: 'accent', children: [txt(winner)]),
        span(children: [txt(' won the game!')]),
      ],
      if (winner == '') span(children: [txt('Draw!')]),
      if (winner == null) ...[
        span(children: [txt('Player ')]),
        span(className: 'accent', children: [txt(player.value)]),
        span(children: [txt(' is on the move...')]),
      ]
    ]);
  });
}

DeactNode newGameButton() {
  return fc((ctx) {
    final player = ctx.globalState<String>('player');
    final board = ctx.globalState<List<String>>('board');
    final inGame = ctx.globalState<bool>('inGame');

    return div(
        className: 'newGame',
        children: [txt('Start new game')],
        onclick: (_) {
          inGame.value = true;
          player.value = togglePlayer(player.value);
          board.value = emptyBoard();
        });
  });
}

DeactNode ticTacToe() {
  return fc((ctx) {
    ctx.state('board', emptyBoard(), global: true);
    ctx.state('player', 'X', global: true);
    ctx.state('inGame', true, global: true);
    return div(
      className: 'root',
      children: [
        br(),
        message(),
        br(),
        board(),
        br(),
        newGameButton(),
      ],
    );
  });
}

void main() {
  deact('#entrypoint', (_) => ticTacToe());
  print('Tic Tac Toe is ready!');
}
