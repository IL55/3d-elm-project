module Components.Block exposing (..)
import Math.Vector3 as Vec3 exposing (vec3, Vec3)
import Color exposing (Color)

import Components.Model exposing (Model, Game, GameGlass, BlockPosition)
import Components.Vertex exposing (..)
import Components.Face exposing (..)

translateVertex : BlockPosition -> Float -> Vec3 -> Vec3 -> Vec3
translateVertex blockPosition blockSize glassCenter v =
    let
        x = toFloat(blockPosition.x)
        y = toFloat(blockPosition.y)
        z = toFloat(blockPosition.z)
        move = vec3 x y z
        m1 = Vec3.scale blockSize move

        vScale = Vec3.scale (blockSize / 2.0) v
        vSub = Vec3.sub vScale glassCenter
        vAdd = Vec3.add vSub m1

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

blocksFaces : GameGlass -> List ( Vertex, Vertex, Vertex )
blocksFaces glass =
  let
    block0 = { x = 0, y = 0, z = 0 }
    block1 = { x = 3, y = 3, z = 4 }
    block2 = { x = glass.width - 1, y = glass.width - 1, z = glass.depth - 1 }

    faces0 = blockFaces glass block0 Color.green
    faces1 = blockFaces glass block1 Color.blue
    faces2 = blockFaces glass block2 Color.red

    faces = [ faces0, faces1, faces2 ]
      |> List.concat
  in
    faces