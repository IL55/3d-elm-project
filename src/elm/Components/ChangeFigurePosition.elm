module Components.ChangeFigurePosition exposing (..)

import Components.Model exposing ( Model, GameGlass, BlockPosition )
import Components.Figure exposing ( convertToBlocks )

normalizeAngle : Int -> Int
normalizeAngle angle =
  if angle > 3 then
    0
  else
    if angle < 0 then
      3
    else
      angle

normalizeCoordinate : Int -> Int -> Int
normalizeCoordinate width x =
  if x > (width - 1) then
    width - 1
  else
    if x < 0 then
      0
    else
      x

isGlassIntersection : GameGlass -> BlockPosition -> Bool
isGlassIntersection glass block =
  let
    x = (block.x > (glass.width - 1)) || (block.x < 0)
    y = (block.y > (glass.width - 1)) || (block.y < 0)
    z = (block.z > (glass.depth - 1)) || (block.z < 0)
  in
    x || y || z

isBlockEqual : BlockPosition -> BlockPosition -> Bool
isBlockEqual a b =
    (a.x == b.x) && (a.y == b.y) && (a.z == b.z)

isBlocksIntersection : List ( BlockPosition ) -> List ( BlockPosition ) -> Bool
isBlocksIntersection figureBlocks gameBlocks =
  List.any (\ a -> List.any (\ b -> isBlockEqual a b) gameBlocks) figureBlocks

plus : Int -> Int
plus a = a + 1

minus : Int -> Int
minus a = a - 1

type alias Getter = BlockPosition -> Int
type alias Setter = BlockPosition -> Int -> BlockPosition

getX : Getter
getX a = a.x

setX : Setter
setX a newVal =
  { a |
    x = newVal
  }

getY : Getter
getY a = a.y

setY : Setter
setY a newVal =
  { a |
    y = newVal
  }

getZ : Getter
getZ a = a.z

setZ : Setter
setZ a newVal =
  { a |
    z = newVal
  }

-- change rotation angle
incrementFigureRotateX : Model -> Model
incrementFigureRotateX model =
  changeFigureRotate plus getX setX model

decrementFigureRotateX : Model -> Model
decrementFigureRotateX model =
  changeFigureRotate minus getX setX model

incrementFigureRotateY : Model -> Model
incrementFigureRotateY model =
  changeFigureRotate plus getY setY model

decrementFigureRotateY : Model -> Model
decrementFigureRotateY model =
  changeFigureRotate minus getY setY model

incrementFigureRotateZ : Model -> Model
incrementFigureRotateZ model =
  changeFigureRotate plus getZ setZ model

decrementFigureRotateZ : Model -> Model
decrementFigureRotateZ model =
  changeFigureRotate minus getZ setZ model

-- change center
incrementFigureCenterX : Model -> Model
incrementFigureCenterX model =
  changeFigureCenter plus getX setX model

decrementFigureCenterX : Model -> Model
decrementFigureCenterX model =
  changeFigureCenter minus getX setX model

incrementFigureCenterY : Model -> Model
incrementFigureCenterY model =
  changeFigureCenter plus getY setY model

decrementFigureCenterY : Model -> Model
decrementFigureCenterY model =
  changeFigureCenter minus getY setY model

incrementFigureCenterZ : Model -> Model
incrementFigureCenterZ model =
  changeFigureCenter plus getZ setZ model

decrementFigureCenterZ : Model -> Model
decrementFigureCenterZ model =
  changeFigureCenter minus getZ setZ model


changeFigureRotate : (Int -> Int) -> Getter -> Setter -> Model -> Model
changeFigureRotate op getA setA model =
  let
    oldGame = model.game
    oldFigure = oldGame.figure
    oldPosition = oldFigure.position
    oldRotation = oldPosition.rotation
    newAng = normalizeAngle (op (getA oldRotation))

    newFigure = { oldFigure |
        position = { oldPosition |
          rotation = setA oldRotation newAng
        }
      }
    figureBlocks = convertToBlocks newFigure

    changedModel = { model |
      game = { oldGame |
        figure = newFigure
      }
    }

    -- if some blocks intersected
    iB = isBlocksIntersection figureBlocks oldGame.blocks

    -- or exist intersection with glass
    iG = List.any (isGlassIntersection oldGame.glass) figureBlocks

    newModel =
      if (iB || iG) then
        model
      else
        changedModel
  in
    newModel

changeFigureCenter : (Int -> Int) -> Getter -> Setter -> Model -> Model
changeFigureCenter op getA setA model =
  let
    oldGame = model.game
    oldFigure = oldGame.figure
    oldPosition = oldFigure.position
    oldCenter = oldPosition.center
    newCenter = op (getA oldCenter)

    newFigure = { oldFigure |
        position = { oldPosition |
          center = setA oldCenter newCenter
        }
      }
    figureBlocks = convertToBlocks newFigure

    changedModel = { model |
      game = { oldGame |
        figure = newFigure
      }
    }

    -- if some blocks intersected
    iB = isBlocksIntersection figureBlocks oldGame.blocks

    -- or exist intersection with glass
    iG = List.any (isGlassIntersection oldGame.glass) figureBlocks

    newModel =
      if (iB || iG) then
        model
      else
        changedModel
  in
    newModel

