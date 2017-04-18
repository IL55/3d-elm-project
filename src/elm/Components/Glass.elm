module Components.Glass exposing (..)

import Components.Model exposing (GameGlass)

import Math.Vector3 as Vec3 exposing (vec3, Vec3)
import List exposing (map, minimum, maximum)
import Array exposing (fromList)
import Maybe exposing (withDefault)
import Color exposing (Color)
import Components.Vertex exposing (..)
import Components.Face exposing (..)

faceLinesWithMiddleLines : GameGlass -> Color -> Vec3 -> Vec3 -> Vec3 -> Vec3 -> List ( Vertex, Vertex )
faceLinesWithMiddleLines glass rawColor a b c d =
    let
        color =
            let
                c =
                    Color.toRgb rawColor
            in
                vec3
                    (toFloat c.red / 255)
                    (toFloat c.green / 255)
                    (toFloat c.blue / 255)

        colorLine = vec3 1.0 1.0 1.0

        colorBlack = vec3 0.0 0.0 0.0

        linePoint position  =
            Vertex colorLine position

        generalLines = [
          ( linePoint a, linePoint b )
        , ( linePoint b, linePoint c )
        , ( linePoint c, linePoint d )
        , ( linePoint d, linePoint a )
        ]

        -- calculate min max
        vertexs = [ a, b, c, d ]
        ops = [ Vec3.getX, Vec3.getY, Vec3.getZ ]

        limitsList = map (\ op -> {
            min = withDefault (op a) (minimum (map op vertexs)),
            max = withDefault (op a) (maximum (map op vertexs))
        }) ops

        limits = Array.fromList limitsList
        limX = withDefault {min = Vec3.getX a, max = Vec3.getX a} (Array.get 0 limits)
        limY = withDefault {min = Vec3.getY a, max = Vec3.getY a} (Array.get 1 limits)
        limZ = withDefault {min = Vec3.getZ a, max = Vec3.getZ a} (Array.get 2 limits)
        sizeX = glass.width
        sizeY = glass.width
        sizeZ = glass.depth

        middleLinesXY =
            if limZ.min == limZ.max then
                let
                    lenX = limX.max - limX.min
                    stepX = lenX / toFloat(sizeX)
                    arrX = Array.initialize sizeX (\n -> (limX.min + toFloat(n) * stepX))
                    linesX = Array.map (\x ->
                        (linePoint (vec3 x limY.min limZ.min), linePoint (vec3 x limY.max limZ.max))) arrX

                    lenY = limY.max - limY.min
                    stepY = lenY / toFloat(sizeY)
                    arrY = Array.initialize sizeY (\n -> (limY.min + toFloat(n) * stepY))
                    linesY = Array.map (\y ->
                        (linePoint (vec3 limX.min y limZ.min), linePoint (vec3 limX.max y limZ.max))) arrY
                in
                    List.concat [Array.toList linesX, Array.toList linesY]
            else
                []

        middleLinesXZ =
            if limY.min == limY.max then
                let
                    lenX = limX.max - limX.min
                    stepX = lenX / toFloat(sizeX)
                    arrX = Array.initialize sizeX (\n -> (limX.min + toFloat(n) * stepX))
                    linesX = Array.map (\x ->
                        (linePoint (vec3 x limY.min limZ.min), linePoint (vec3 x limY.max limZ.max))) arrX

                    lenZ = limZ.max - limZ.min
                    stepZ = lenZ / toFloat(sizeZ)
                    arrZ = Array.initialize sizeZ (\n -> (limZ.min + toFloat(n) * stepZ))
                    linesZ = Array.map (\z ->
                        (linePoint (vec3 limX.min limY.min z), linePoint (vec3 limX.max limY.max z))) arrZ
                in
                    List.concat [Array.toList linesX, Array.toList linesZ]
            else
                []

        middleLinesYZ =
            if limX.min == limX.max then
                let
                    lenY = limY.max - limY.min
                    stepY = lenY / toFloat(sizeY)
                    arrY = Array.initialize sizeY (\n -> (limY.min + toFloat(n) * stepY))
                    linesY = Array.map (\y ->
                        (linePoint (vec3 limX.min y limZ.min), linePoint (vec3 limX.max y limZ.max))) arrY

                    lenZ = limZ.max - limZ.min
                    stepZ = lenZ / toFloat(sizeZ)
                    arrZ = Array.initialize sizeZ (\n -> (limZ.min + toFloat(n) * stepZ))
                    linesZ = Array.map (\z ->
                        (linePoint (vec3 limX.min limY.min z), linePoint (vec3 limX.max limY.max z))) arrZ
                in
                    List.concat [Array.toList linesY, Array.toList linesZ]
            else
                []

    in
        List.concat [generalLines, middleLinesXY, middleLinesXZ, middleLinesYZ]


glassVertexs : GameGlass -> CubeVertexs
glassVertexs glass =
    let
        sizeX = 2.0 / toFloat(glass.width)
        depth = 2.0 + sizeX * toFloat(glass.depth - glass.width)
    in
    {
        rft =
            vec3 1 1 depth,

        lft =
            vec3 -1 1 depth,

        lbt =
            vec3 -1 -1 depth,

        rbt =
            vec3 1 -1 depth,

        rbb =
            vec3 1 -1 0,

        rfb =
            vec3 1 1 0,

        lfb =
            vec3 -1 1 0,

        lbb =
            vec3 -1 -1 0
    }

glassFaces : GameGlass -> List ( Vertex, Vertex, Vertex )
glassFaces glass =
  let
    cv = glassVertexs glass

    faces = [ face Color.green cv.rft cv.rfb cv.rbb cv.rbt
      , face Color.blue cv.rft cv.rfb cv.lfb cv.lft
      , face Color.yellow cv.rft cv.lft cv.lbt cv.rbt
      --, face Color.red cv.rfb cv.lfb cv.lbb cv.rbb
      , face Color.purple cv.lft cv.lfb cv.lbb cv.lbt
      , face Color.orange cv.rbt cv.rbb cv.lbb cv.lbt
    ]
      |> List.concat
  in
    faces

glassLines : GameGlass -> List ( Vertex, Vertex )
glassLines glass =
  let
    cv = glassVertexs glass

    lines = [ faceLinesWithMiddleLines glass Color.green cv.rft cv.rfb cv.rbb cv.rbt
    , faceLinesWithMiddleLines glass Color.blue cv.rft cv.rfb cv.lfb cv.lft
    , faceLinesWithMiddleLines glass Color.yellow cv.rft cv.lft cv.lbt cv.rbt
    --, faceLinesWithMiddleLines glass Color.red cv.rfb cv.lfb cv.lbb cv.rbb
    , faceLinesWithMiddleLines glass Color.purple cv.lft cv.lfb cv.lbb cv.lbt
    , faceLinesWithMiddleLines glass Color.orange cv.rbt cv.rbb cv.lbb cv.lbt
    ]
      |> List.concat
  in
    lines