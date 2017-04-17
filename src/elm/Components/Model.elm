module Components.Model exposing (..)

import Math.Vector3 as Vec3 exposing (vec3, Vec3)

type alias GameGlass = {
  -- depth of glass
  depth: Int,

  -- size of glass
  width: Int,

  -- size of one block
  blockSize: Float,

  -- center of glass in blocks coordinates
  center: Vec3
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

type alias BlockPosition = {
  x: Int,

  y: Int,

  z: Int
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