module Components.Figure exposing (..)

import Components.Model exposing ( GameGlass, GameFigure, BlockPosition )
import Components.Block exposing ( blockFaces, blockLines )
import Color exposing (Color)
import Components.Vertex exposing (..)

-- sin a
sinA : Int -> Int
sinA angle =
  case angle of
    -- sin 0 = 0
    0 -> 0

    -- sin pi/2 = 1
    1 -> 1

    -- sin pi = 0
    2 -> 0

    -- sin 3/4 pi = -1
    3 -> -1

    _ -> 0

-- cos a
cosA : Int -> Int
cosA angle =
  case angle of
    -- cos 0 = 1
    0 -> 1

    -- cos pi/2 = 0
    1 -> 0

    -- cos pi = -1
    2 -> -1

    -- cos 3/4 pi = 0
    3 -> 0

    _ -> 0

addVector : BlockPosition -> BlockPosition -> BlockPosition
addVector a b = {
    x = a.x + b.x,
    y = a.y + b.y,
    z = a.z + b.z
  }

rotateX : Int -> BlockPosition -> BlockPosition
rotateX angle v =
  let
    sa = sinA angle
    ca = cosA angle
  in {
    x = v.x,
    y = v.y * ca + v.z * sa,
    z = (-1) * v.y * sa + v.z * ca
  }

rotateY : Int -> BlockPosition -> BlockPosition
rotateY angle v =
  let
    sa = sinA angle
    ca = cosA angle
  in {
    x = v.x * ca + v.z * sa,
    y = v.y,
    z = (-1) * v.x * sa + v.z * ca
  }

rotateZ : Int -> BlockPosition -> BlockPosition
rotateZ angle v =
  let
    sa = sinA angle
    ca = cosA angle
  in {
    x = v.x * ca - v.y * sa,
    y = v.x * sa + v.y * ca,
    z = v.z
  }


convertToBlocks : GameFigure -> List ( BlockPosition )
convertToBlocks figure =
  let
    -- convert figure coordinates to "blocks" coordinates
    -- translation + rotation
    blocks = List.map (\ block ->
      addVector figure.position.center
        (rotateX figure.position.rotation.x
          (rotateY figure.position.rotation.y
            (rotateZ figure.position.rotation.z block)))
      ) figure.blocks
  in
    blocks


figureFaces : GameGlass -> GameFigure -> List ( Vertex, Vertex, Vertex )
figureFaces glass figure =
  let
    blocks = convertToBlocks figure

    faces = List.map (\ block -> blockFaces glass block Color.red) blocks
      |> List.concat
    -- faces = []
  in
    faces

figureLines : GameGlass -> GameFigure -> List ( Vertex, Vertex )
figureLines glass figure =
  let
    blocks = convertToBlocks figure

    faces = List.map (\ block -> blockLines glass block) blocks
      |> List.concat
  in
    faces
