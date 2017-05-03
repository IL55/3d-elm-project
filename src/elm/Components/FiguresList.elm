module Components.FiguresList exposing ( getNextFigure )

import Components.Model exposing ( GameFigure )
import Random exposing (..)

emptyFigure : GameFigure
emptyFigure = {
  figureType = 0,
  position = {
    center = { x = 0, y = 0, z = 0 },
    rotation = { x = 0, y = 0, z = 0 }
  },
  blocks = []
 }


figuresList : List ( GameFigure )
figuresList = [
  {
    figureType = 1,
    position = {
      center = { x = 0, y = 0, z = 0 },
      rotation = { x = 0, y = 0, z = 0 }
    },
    blocks = [
      { x = -1, y = -1, z = 0 },
      { x = -1, y = 0, z = 0 },
      { x = 0, y = 0, z = 0 },
      { x = 1, y = 0, z = 0 },
      { x = 1, y = 1, z = 0 }
    ]
  },
  {
    figureType = 2,
    position = {
      center = { x = 0, y = 0, z = 0 },
      rotation = { x = 0, y = 0, z = 0 }
    },
    blocks = [
      { x = 0, y = 0, z = 0 }
    ]
  },
  {
    figureType = 3,
    position = {
      center = { x = 0, y = 0, z = 0 },
      rotation = { x = 0, y = 0, z = 0 }
    },
    blocks = [
      { x = 0, y = -1, z = 0 },
      { x = 0, y = 0, z = 0 },
      { x = 0, y = 1, z = 0 },
      { x = 0, y = 2, z = 0 }
    ]
  },
  {
    figureType = 4,
    position = {
      center = { x = 0, y = 0, z = 0 },
      rotation = { x = 0, y = 0, z = 0 }
    },
    blocks = [
      { x = 0, y = -1, z = 0 },
      { x = 0, y = 0, z = 0 },
      { x = 1, y = 0, z = 0 },
      { x = 2, y = 0, z = 0 }
    ]
  },
  {
    --  *
    --  **
    figureType = 5,
    position = {
      center = { x = 0, y = 0, z = 0 },
      rotation = { x = 0, y = 0, z = 0 }
    },
    blocks = [
      { x = 0, y = -1, z = 0 },
      { x = 0, y = 0, z = 0 },
      { x = 1, y = 0, z = 0 }
    ]
  },
  {
    -- **
    --  **
    figureType = 6,
    position = {
      center = { x = 0, y = 0, z = 0 },
      rotation = { x = 0, y = 0, z = 0 }
    },
    blocks = [
      { x = 0, y = -1, z = 0 },
      { x = 0, y = 0, z = 0 },
      { x = 1, y = 0, z = 0 },
      { x = 1, y = 1, z = 0 }
    ]
  },
  {
    -- **
    -- **
    figureType = 7,
    position = {
      center = { x = 0, y = 0, z = 0 },
      rotation = { x = 0, y = 0, z = 0 }
    },
    blocks = [
      { x = 0, y = -1, z = 0 },
      { x = 0, y = 0, z = 0 },
      { x = 1, y = 0, z = 0 },
      { x = 1, y = -1, z = 0 }
    ]
  }
 ]

getNextFigure : Seed -> Int -> (GameFigure, Seed)
getNextFigure seed width =
  let
    gen = Random.int 0 (List.length figuresList - 1)
    (index, newSeed) = Random.step gen seed

    -- indexTemp = 6
    newFigure = Maybe.withDefault emptyFigure (List.drop index figuresList |> List.head)
    pos = newFigure.position
    center = newFigure.position.center

    c = width // 2
    -- move figure to center
    newFigureInCenter = { newFigure |
      position = { pos |
        center = { center |
          x = c,
          y = c
        }
      }
    }
  in
    (newFigureInCenter, newSeed)
