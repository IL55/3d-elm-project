module Components.AddFigureToGlass exposing (..)

import Components.Model exposing ( Model, GameGlass, BlockPosition )
import Components.Figure exposing ( convertToBlocks )
import Components.ChangeFigurePosition exposing ( incrementFigureCenterZ )

addFigureToGlass : Model -> Model
addFigureToGlass model =
  let
    modelMoved = moveFigureToGlassBottom model

    oldGame = modelMoved.game
    blocks = oldGame.blocks

    figureBlocks = convertToBlocks oldGame.figure

    newBlocks = List.concat [blocks, figureBlocks]

    changedModel = { modelMoved |
      game = { oldGame |
        blocks = newBlocks
      }
    }
  in
    changedModel

moveFigureToGlassBottom : Model -> Model
moveFigureToGlassBottom model =
  let
    oldGame = model.game
    blocks = oldGame.blocks
    oldFigure = oldGame.figure
    z = oldFigure.position.center.z
    bottom = oldGame.glass.depth - 1
    rangeZ = List.range z bottom

    changedModel = List.foldr (\ a m -> incrementFigureCenterZ m) model rangeZ
  in
    changedModel
