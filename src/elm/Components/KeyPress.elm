-- react on key press
module Components.KeyPress exposing (..)

import Components.Model exposing ( Model )
import Components.ChangeFigurePosition exposing (..)
import Components.AddFigureToGlass exposing ( addFigureToGlass )

processKeyPress : Model -> Int -> Model
processKeyPress model keyCode =
  case keyCode of

  -- left
  37 ->
    incrementFigureCenterX model

  -- right
  39 ->
    decrementFigureCenterX model


  -- up
  38 ->
    incrementFigureCenterY model

  -- down
  40 ->
    decrementFigureCenterY model

  -- space
  32 ->
    addFigureToGlass model

  -- q
  81 ->
    incrementFigureRotateX model

  -- w
  87 ->
    incrementFigureRotateY model

  -- e
  69 ->
    incrementFigureRotateZ model

  -- other
  _ ->
    model
