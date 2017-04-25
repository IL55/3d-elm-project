module Components.Block exposing (..)
import Math.Vector3 as Vec3 exposing (vec3, Vec3)
import Color exposing (Color)
import Dict.Extra exposing ( groupBy )
import Dict exposing ( values )

import Components.Model exposing (Model, Game, GameGlass, BlockPosition)
import Components.Vertex exposing (..)
import Components.Face exposing (..)

translateVertex : BlockPosition -> Float -> Vec3 -> Vec3 -> Vec3
translateVertex blockPosition blockSize glassCenter v =
    let
        x = toFloat(blockPosition.x)
        y = toFloat(blockPosition.y)
        z = toFloat(blockPosition.z)

        vBlockCenter = Vec3.scale blockSize (vec3 x y z)

        vLocalVertex = Vec3.scale (blockSize / 2.0) v
        vSub = Vec3.sub vLocalVertex glassCenter
        vAdd = Vec3.add vSub vBlockCenter

    in
        vAdd


blockVertexs : BlockPosition -> Float -> Vec3 -> CubeVertexs
blockVertexs blockPosition blockSize glassCenter =
    let
        mv = translateVertex blockPosition blockSize glassCenter
    in
    {
        rft =
            mv (vec3 1 1 1),

        lft =
            mv (vec3 -1 1 1),

        lbt =
            mv (vec3 -1 -1 1),

        rbt =
            mv (vec3 1 -1 1),

        rbb =
            mv (vec3 1 -1 -1),

        rfb =
            mv (vec3 1 1 -1),

        lfb =
            mv (vec3 -1 1 -1),

        lbb =
            mv (vec3 -1 -1 -1)
    }


blockFaces : GameGlass -> BlockPosition -> Color -> List ( Vertex, Vertex, Vertex )
blockFaces glass block color =
    let
        cv = blockVertexs block glass.blockSize glass.center

        faces = [ face color cv.rft cv.rfb cv.rbb cv.rbt
        , face color cv.rft cv.rfb cv.lfb cv.lft
        , face color cv.rft cv.lft cv.lbt cv.rbt
        , face color cv.rfb cv.lfb cv.lbb cv.rbb
        , face color cv.lft cv.lfb cv.lbb cv.lbt
        , face color cv.rbt cv.rbb cv.lbb cv.lbt
        ]
            |> List.concat
    in
        faces

getColorByDepth : Int -> Color
getColorByDepth z =
    let
        c = rem z 10
    in
        case c of
            0 -> Color.blue

            1 -> Color.orange

            2 -> Color.yellow

            3 -> Color.green

            4 -> Color.purple

            5 -> Color.darkGreen

            6 -> Color.red

            7 -> Color.darkBlue

            8 -> Color.charcoal

            9 -> Color.darkPurple

            _ -> Color.blue

blocksFaces : GameGlass -> List ( BlockPosition ) -> List ( Vertex, Vertex, Vertex )
blocksFaces glass blocks =
  let
    groups = Dict.values (groupBy .z blocks)
    groupsFaces = List.map (\ group ->
        (List.map (\ block -> blockFaces glass block (getColorByDepth block.z)) group)
    ) groups
      |> List.concat
    faces = groupsFaces
      |> List.concat
  in
    faces

blockLines : GameGlass -> BlockPosition -> List ( Vertex, Vertex )
blockLines glass block =
  let
    cv = blockVertexs block glass.blockSize glass.center

    lines = [
      faceLines cv.rft cv.rfb cv.rbb cv.rbt
    , faceLines cv.rft cv.rfb cv.lfb cv.lft
    , faceLines cv.rft cv.lft cv.lbt cv.rbt
    , faceLines cv.rfb cv.lfb cv.lbb cv.rbb
    , faceLines cv.lft cv.lfb cv.lbb cv.lbt
    , faceLines cv.rbt cv.rbb cv.lbb cv.lbt
    ]
      |> List.concat
  in
    lines

blocksLines : GameGlass -> List ( BlockPosition ) -> List ( Vertex, Vertex )
blocksLines glass blocks =
  let
    faces = List.map (\ block -> blockLines glass block) blocks
      |> List.concat
  in
    faces