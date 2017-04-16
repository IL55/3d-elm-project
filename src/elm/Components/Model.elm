module Components.Model exposing (..)

type alias GameGlass = {
  depth: Int,
  width: Int
}

type alias GameView = {
  width: Int,
  height: Int
}

type alias FigurePosition = {
  -- current depth where "middle" block is drawn
  depth: Int,

  rotationX: Int,

  rotationY: Int,

  rotationZ: Int
}

type alias GameFigure = {
  -- figure type
  figureType: Int,

  position: FigurePosition
}

type alias Game = {
  view: GameView,
  glass: GameGlass,
  figure: GameFigure
}

-- MODEL
type alias Model = {
  style: String,
  number: Int,
  isCool: Bool,
  theta: Float,
  game: Game
}