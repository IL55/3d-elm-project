module Components.Vertex exposing (..)
import Math.Vector3 as Vec3 exposing (vec3, Vec3)

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
