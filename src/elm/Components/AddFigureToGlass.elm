module Components.AddFigureToGlass exposing (..)

import Components.Model exposing ( Model, GameGlass, BlockPosition )
import Components.Figure exposing ( convertToBlocks )
import Components.ChangeFigurePosition exposing ( incrementFigureCenterZ )
import Components.FiguresList exposing ( getNextFigure )
import Components.RemoveLayersFromGlass exposing ( removeLayersFromGlass )


addFigureToGlass : Model -> Model
addFigureToGlass model =
  let
    modelMoved = moveFigureToGlassBottom model

    oldGame = modelMoved.game
    blocks = oldGame.blocks

    figureBlocks = convertToBlocks oldGame.figure

    newBlocks = List.concat [blocks, figureBlocks]

    -- get next random figure
    (newFigure, newSeed) = getNextFigure model.seed oldGame.glass.width

    changedModel = removeLayersFromGlass { modelMoved |
      seed = newSeed,
      game = { oldGame |
        blocks = newBlocks,
        figure = newFigure,
        -- add to score number of applied blocks
        -- in the old figure
        score = oldGame.score + List.length oldGame.figure.blocks
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
