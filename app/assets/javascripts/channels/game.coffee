App.game = App.cable.subscriptions.create "GameChannel",
  connected: ->
    @printMessage("Waiting for opponent...")

  received: (data) ->
    console.log(data.action)
    switch data.action
      when "game_start"
        App.board.position("start")
        App.board.orientation(data.msg)
        @printMessage("Game started! You play as #{data.msg}.")
      when "make_move"
        [source, target] = data.msg.split("-")
        App.chess.move
          from: source
          to: target
          promotion: "q"
        App.board.position(App.chess.fen())
      when "opponent_forfeits"
        @printMessage("Opponent forfeits. You win!")

      when "game_over"
        alert(data.msg)
        @printMessage("Check mate!")

  printMessage: (message) ->
    $("#messages").append("<p>#{message}</p>")
