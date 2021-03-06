module Components.Game exposing (..)

{-
  Rotating game with colored sides.
-}

-- import AnimationFrame
import Html exposing (Html)
import Html.Attributes exposing (width, height, style)
import Math.Matrix4 as Mat4 exposing (Mat4)
import Math.Vector3 as Vec3 exposing (vec3, Vec3)
-- import Time exposing (Time)
import WebGL exposing (Mesh, Shader)
import Components.Model exposing (Model, Game, GameGlass, BlockPosition)

import Components.Glass exposing (..)
import Components.Vertex exposing (..)
import Components.Block exposing (..)
import Components.Figure exposing (..)


-- cube : Float -> Html Time
-- cube =
--  Html.program
--  { init = ( 0, Cmd.none )
--   , view = view
--   , subscriptions = (\_ -> AnimationFrame.diffs Basics.identity)
--   , update = (\dt theta -> ( theta + dt / 5000, Cmd.none ))
--  }


game : Model -> Html a
game model =
  WebGL.toHtmlWith [ WebGL.alpha True, WebGL.antialias, WebGL.depth 1 ]
  [ width model.game.view.width
  , height model.game.view.height
  , style [ ( "display", "block" ) ]
  ]
  [
    WebGL.entity
      vertexShader
      fragmentShader
      (linesMesh model.game)
      (uniforms model.theta),
    WebGL.entity
      vertexShader
      fragmentShader
      (blocksMesh model.game)
      (uniforms model.theta),
    WebGL.entity
      vertexShader
      glassFragmentShader
      (glassMesh model.game.glass)
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

blocksMesh : Game -> Mesh Vertex
blocksMesh game =
  let
    ffaces = figureFaces game.glass game.figure
    faces = blocksFaces game.glass game.blocks
  in
    [faces, ffaces]
      |> List.concat
      |> WebGL.triangles


glassMesh : GameGlass -> Mesh Vertex
glassMesh glass =
  let
    faces = glassFaces glass
      |> WebGL.triangles
  in
    faces

linesMesh : Game -> Mesh Vertex
linesMesh game =
  let
    lines = glassLines game.glass
    blines = blocksLines game.glass game.blocks
    flines = figureLines game.glass game.figure
  in
    [lines, blines, flines]
      |> List.concat
      |> WebGL.lines


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

glassFragmentShader : Shader {} Uniforms { vcolor : Vec3 }
glassFragmentShader =
  [glsl|
    precision mediump float;
    uniform float shade;
    varying vec3 vcolor;
    void main () {
      gl_FragColor = shade * vec4(vcolor, 1.0);
      if(gl_FragColor.a < 0.5)
        discard;
    }
  |]