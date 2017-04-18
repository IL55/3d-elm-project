module Components.Face exposing (..)
import Math.Vector3 as Vec3 exposing (vec3, Vec3)
import Color exposing (Color)
import Components.Vertex exposing (..)

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

        vertex position =
            Vertex color position

        colorLine = vec3 1.0 1.0 1.0
        --v1 = Vec3.sub c b
        --k = Vec3.length v1 / 100.0
        k = 0.02


        lineVertex position =
            Vertex colorLine position

        nearVertex p1 p2 =
            Vertex colorLine (Vec3.add p1 (Vec3.scale k (Vec3.direction p2 p1)))

        lines = [
            ( lineVertex a, lineVertex b, nearVertex b c )
            , ( lineVertex a, nearVertex a d, nearVertex b c )
            , ( lineVertex b, lineVertex c, nearVertex c d )
            , ( lineVertex b, nearVertex b a, nearVertex c d )
            , ( lineVertex c, lineVertex d, nearVertex d a )
            , ( lineVertex c, nearVertex c b, nearVertex d a )
            , ( lineVertex d, lineVertex a, nearVertex a d )
            , ( lineVertex d, nearVertex d c, nearVertex a d )
        ]
    in
        [ ( vertex a, vertex b, vertex c )
        , ( vertex c, vertex d, vertex a )
        ]

faceLines : Vec3 -> Vec3 -> Vec3 -> Vec3 -> List ( Vertex, Vertex )
faceLines a b c d =
    let
        colorLine = vec3 1.0 1.0 1.0

        linePoint position  =
            Vertex colorLine position

        generalLines = [
          ( linePoint a, linePoint b )
        , ( linePoint b, linePoint c )
        , ( linePoint c, linePoint d )
        , ( linePoint d, linePoint a )
        ]
    in
        generalLines
