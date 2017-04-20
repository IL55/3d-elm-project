module Components.ChangeGlassSize exposing (..)

import Components.Model exposing ( Model, GameGlass )
import Math.Vector3 as Vec3 exposing (vec3, Vec3)

calculateSizes : Int -> Int -> GameGlass
calculateSizes d w =
  let
    viewSize = 3.0
    bs = viewSize / toFloat(w)

    w2 = toFloat(w) / 2.0
    bs2 = bs / 2.0
  in
  {
    depth = d,
    width = w,

    blockSize = bs,
    center = vec3 (w2 * bs - bs2) (w2 * bs - bs2) (-1.0 * bs2)
  }


incrementGlassSize : Model -> Model
incrementGlassSize model =
  let
    oldGame = model.game
    oldGlass = oldGame.glass
    newDepth = oldGlass.depth + 1
    newGlass = calculateSizes newDepth oldGlass.width
  in
  { model |
    game = { oldGame |
        glass = newGlass
    }
  }

decrementGlassSize : Model -> Model
decrementGlassSize model =
  let
    oldGame = model.game
    oldGlass = oldGame.glass
    newDepth = oldGlass.depth - 1
    newGlass = calculateSizes newDepth oldGlass.width
  in
  { model |
    game = { oldGame |
        glass = newGlass
    }
  }

incrementGlassWidth : Model -> Model
incrementGlassWidth model =
  let
    oldGame = model.game
    oldGlass = oldGame.glass
    newWidth = oldGlass.width + 1
    newGlass = calculateSizes oldGlass.depth newWidth
  in
  { model |
    game = { oldGame |
        glass = newGlass
    }
  }

decrementGlassWidth : Model -> Model
decrementGlassWidth model =
  let
    oldGame = model.game
    oldGlass = oldGame.glass
    newWidth = oldGlass.width - 1
    newGlass = calculateSizes oldGlass.depth newWidth
  in
  { model |
    game = { oldGame |
        glass = newGlass
    }
  }
