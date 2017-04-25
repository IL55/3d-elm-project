-- remove filled layers from glass
module Components.RemoveLayersFromGlass exposing (..)

import Components.Model exposing ( Model, GameGlass, BlockPosition )
import Dict.Extra exposing ( groupBy )
import Dict exposing ( values )

removeLayersFromGlass : Model -> Model
removeLayersFromGlass model =
  let
    oldGame = model.game
    oldBlocks = oldGame.blocks
    width = oldGame.glass.width
    w2 = width * width
    groups = Dict.values (groupBy .z oldBlocks)
    _ = Debug.log "groups" groups

    newBlocks = List.foldr (\ group (newGroups, zShift) ->
      let
        _ = Debug.log "List.length group" (List.length group)
        filteredGroups =
          if List.length group < w2 then
            let
              movedBlocks = List.map (\ block ->
                { block |
                  z = block.z + zShift
                })
                group
            in
            List.append newGroups [ movedBlocks ]
          else
            newGroups

        zNewShift =
          if List.length group < w2 then
            zShift
          else
            zShift + 1
      in
        (filteredGroups, zNewShift)
      ) ([], 0) groups
        |> Tuple.first
        |> List.concat

    changedModel = { model |
      game = { oldGame |
        blocks = newBlocks
      }
    }
  in
    changedModel
