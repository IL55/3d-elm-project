module Components.Figure exposing (..)

import Components.Model exposing ( GameGlass, GameFigure, BlockPosition )
import Components.Block exposing ( blockFaces, blockLines )
import Color exposing (Color)
import Components.Vertex exposing (..)

convertToBlocks : GameFigure -> List ( BlockPosition )
convertToBlocks figure =
  let
    -- convert figure coordinates to "blocks" coordinates
    -- translation
    -- TODO: rotation
    blocks = List.map (\ block -> {
        x = block.x + figure.position.center.x,
        y = block.y + figure.position.center.y,
        z = block.z + figure.position.center.z
      }) figure.blocks
  in
    blocks


figureFaces : GameGlass -> GameFigure -> List ( Vertex, Vertex, Vertex )
figureFaces glass figure =
  let
    blocks = convertToBlocks figure

    faces = List.map (\ block -> blockFaces glass block Color.red) blocks
      |> List.concat
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
