module Components.Cube exposing (..)

{-
   Rotating cube with colored sides.
-}

-- import AnimationFrame
import Color exposing (Color)
import Html exposing (Html)
import Html.Attributes exposing (width, height, style)
import Math.Matrix4 as Mat4 exposing (Mat4)
import Math.Vector3 as Vec3 exposing (vec3, Vec3)
-- import Time exposing (Time)
import WebGL exposing (Mesh, Shader)
import Components.Model exposing (Model, Game, GameGlass, BlockPosition)
import List exposing (map, minimum, maximum)
import Array exposing (fromList)
import Maybe exposing (withDefault)


-- cube : Float -> Html Time
-- cube =
--    Html.program
--        { init = ( 0, Cmd.none )
--        , view = view
--        , subscriptions = (\_ -> AnimationFrame.diffs Basics.identity)
--        , update = (\dt theta -> ( theta + dt / 5000, Cmd.none ))
--        }


cube : Model -> Html a
cube model =
    WebGL.toHtml
        [ width model.game.view.width
        , height model.game.view.height
        , style [ ( "display", "block" ) ]
        ]
        [ WebGL.entity
            vertexShader
            fragmentShader
            (glassMesh model.game.glass)
            (uniforms model.theta),
          WebGL.entity
            vertexShader
            fragmentShader
            (linesMesh model.game.glass)
            (uniforms model.theta),
          WebGL.entity
            vertexShader
            fragmentShader
            (blocksMesh model.game.glass)
            (uniforms model.theta)
        ]


type alias Uniforms =
    { rotation : Mat4
    , perspective : Mat4
    , camera : Mat4
    , shade : Float
    }


uniforms : Float -> Uniforms
uniforms theta =
    { rotation =
        Mat4.mul
            (Mat4.makeRotate (1 * theta) (vec3 0 1 0))
            (Mat4.makeRotate (0.06 * theta) (vec3 1 1 1))
    , perspective = Mat4.makePerspective 45 1 0.01 20
    , camera = Mat4.makeLookAt (vec3 0 0 5) (vec3 0 0 0) (vec3 0 1 0)
    , shade = 0.8
    }



-- Mesh


type alias Vertex =
    { color : Vec3
    , position : Vec3
    }

type alias CubeVertexs = {
    rft: Vec3,
    lft: Vec3,
    lbt: Vec3,
    rbt: Vec3,
    rbb: Vec3,
    rfb: Vec3,
    lfb: Vec3,
    lbb: Vec3
}

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


blocksMesh : GameGlass -> Mesh Vertex
blocksMesh glass =
    let
        block = { x = 0, y = 0, z = 0 }
        cv = blockVertexs block glass.blockSize glass.center

        faces = [ face Color.green cv.rft cv.rfb cv.rbb cv.rbt
        , face Color.blue cv.rft cv.rfb cv.lfb cv.lft
        , face Color.yellow cv.rft cv.lft cv.lbt cv.rbt
        , face Color.red cv.rfb cv.lfb cv.lbb cv.rbb
        , face Color.purple cv.lft cv.lfb cv.lbb cv.lbt
        , face Color.orange cv.rbt cv.rbb cv.lbb cv.lbt
        ]
            |> List.concat
            |> WebGL.triangles
    in
        faces


glassMesh : GameGlass -> Mesh Vertex
glassMesh glass =
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
            |> WebGL.triangles
    in
        faces

linesMesh : GameGlass -> Mesh Vertex
linesMesh glass =
    let
        cv = glassVertexs glass

        lines = [ faceLines glass Color.green cv.rft cv.rfb cv.rbb cv.rbt
        , faceLines glass Color.blue cv.rft cv.rfb cv.lfb cv.lft
        , faceLines glass Color.yellow cv.rft cv.lft cv.lbt cv.rbt
        --, faceLines glass Color.red cv.rfb cv.lfb cv.lbb cv.rbb
        , faceLines glass Color.purple cv.lft cv.lfb cv.lbb cv.lbt
        , faceLines glass Color.orange cv.rbt cv.rbb cv.lbb cv.lbt
        ]
            |> List.concat
            |> WebGL.lines
    in
        lines

face : Color -> Vec3 -> Vec3 -> Vec3 -> Vec3 -> List ( Vertex, Vertex, Vertex )
face rawColor a b c d =
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

        colorWhite = vec3 1.0 1.0 0.0

        colorBlack = vec3 0 0 0

        vertex position =
            Vertex color position

        linePoint position  =
            Vertex colorWhite position
    in
        [ ( vertex a, vertex b, vertex c )
        , ( vertex c, vertex d, vertex a )
        ]

faceLines : GameGlass -> Color -> Vec3 -> Vec3 -> Vec3 -> Vec3 -> List ( Vertex, Vertex )
faceLines glass rawColor a b c d =
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


-- Shaders


vertexShader : Shader Vertex Uniforms { vcolor : Vec3 }
vertexShader =
    [glsl|
        attribute vec3 position;
        attribute vec3 color;
        uniform mat4 perspective;
        uniform mat4 camera;
        uniform mat4 rotation;
        varying vec3 vcolor;
        void main () {
            gl_Position = perspective * camera * rotation * vec4(position, 1.0);
            vcolor = color;
        }
    |]


fragmentShader : Shader {} Uniforms { vcolor : Vec3 }
fragmentShader =
    [glsl|
        precision mediump float;
        uniform float shade;
        varying vec3 vcolor;
        void main () {
            gl_FragColor = shade * vec4(vcolor, 1.0);
        }
    |]