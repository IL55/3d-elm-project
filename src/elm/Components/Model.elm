module Components.Model exposing (..)

import Math.Vector3 as Vec3 exposing (vec3, Vec3)

-- definition of glass
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
  -- position of the center in "blocks" coordinates
  center: BlockPosition,

  -- rotation of the figure's center in 3 axis
  rotation: BlockPosition
}

-- position for one block
-- in "blocks" coordinates
type alias BlockPosition = {
  x: Int,

  y: Int,

  z: Int
}

type alias GameFigure = {
  -- figure type
  figureType: Int,

  position: FigurePosition,

  -- list of figure's blocks in "figure" coordinates
  blocks: List ( BlockPosition )
}

type alias Game = {
  -- view settings
  view: GameView,

  -- glass settings
  glass: GameGlass,

  -- all blocks which have been applied to glass
  blocks: List ( BlockPosition ),

  -- current figure
  figure: GameFigure
}

-- MODEL
type alias Model = {
  style: String,
  number: Int,
  isCool: Bool,
  theta: Float,

  -- game model
  game: Game
}