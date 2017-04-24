-- remove filled layers from glass
module Components.RemoveLayersFromGlass exposing (..)

import Components.Model exposing ( Model, GameGlass, BlockPosition )
import List.Extra exposing ( groupWhile )

removeLayersFromGlass : Model -> Model
removeLayersFromGlass model =
  let
    oldGame = model.game
    oldBlocks = oldGame.blocks
    width = oldGame.glass.width
    w2 = width * width
    groups = groupWhile (\ a b -> a.z == b.z ) oldBlocks

    newBlocks = List.filter (\ group ->
      List.length group < w2
    ) groups
      |> List.concat

    changedModel = { model |
      game = { oldGame |
        blocks = newBlocks
      }
    }
  in
    changedModel
