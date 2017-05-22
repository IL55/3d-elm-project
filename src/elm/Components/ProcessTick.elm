module Components.ProcessTick exposing (..)

import Components.Model exposing ( Model )
import Components.ChangeFigurePosition exposing ( incrementFigureCenterZ )
import Components.AddFigureToGlass exposing ( addFigureToGlass )

processTick : Model -> Model
processTick model =
  let
    modelMoved = incrementFigureCenterZ model

    oldFigureZ = model.game.figure.position.center.z
    newFigureZ = modelMoved.game.figure.position.center.z

    changedModel =
      if oldFigureZ == newFigureZ then
        addFigureToGlass model
      else
        modelMoved
  in
    changedModel