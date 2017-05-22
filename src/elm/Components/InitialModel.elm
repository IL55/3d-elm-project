module Components.InitialModel exposing (..)

import Random exposing (..)

import Components.Model exposing ( Model )
import Components.ChangeGlassSize exposing ( calculateSizes )



initialModel : Model
initialModel = {
  seed = Random.initialSeed 31,
  style = "Blue",
  number = 1,
  isCool = True,
  theta = 3.2,
  game = {
    view = {
      width = 400,
      height = 400
    },
    glass = calculateSizes 10 6,
    blocks = [],
    figure = {
      figureType = 0,
      position = {
        center = { x = 0, y = 0, z = 0 },
        rotation = { x = 0, y = 0, z = 0 }
      },
      blocks = []
    },
    score = 0
  }
 }