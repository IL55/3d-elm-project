port module Main exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick )
import Math.Vector3 as Vec3 exposing (vec3, Vec3)

-- component import example

import Components.Model exposing ( Model, Game, GameGlass )
import Components.Hello exposing ( hello )
import Components.Game exposing ( game )

-- define port
port showPortName : String -> Cmd msg


-- APP
main : Program Never Model Msg
main =
  Html.beginnerProgram { model = model, view = view, update = update }


model : Model
model = {
  style = "Blue",
  number = 1,
  isCool = True,
  theta = 3.2,
  game = {
    view = {
      width = 400,
      height = 400
    },
    glass =
      let
        d = 8
        w = 6
        bs = 2.0 / toFloat(w)

        w2 = toFloat(w) / 2.0
        bs2 = bs / 2.0
      in
      {
        depth = d,
        width = w,

        blockSize = bs,
        center = vec3 (w2 * bs - bs2) (w2 * bs - bs2) (-1.0 * bs2)
    },
    blocks = [
      { x = 0, y = 0, z = 0 },
      { x = 3, y = 3, z = 4 },
      { x = 5, y = 5, z = 7 }
    ],
    figure = {
      figureType = 1,
      position = {
        center = { x = 2, y = 2, z = 2 },
        rotation = { x = 0, y = 0, z = 0 }
      },
      blocks = [
        { x = 0, y = 0, z = 0 },
        { x = 1, y = 0, z = 0 },
        { x = 2, y = 0, z = 0 },
        { x = 2, y = 1, z = 0 }
      ]
    }
  }
 }


-- UPDATE
type Msg = NoOp |
  Increment |
  Decrement |
  IncrementGlassSize |
  DecrementGlassSize |
  IncrementGlassWidth |
  DecrementGlassWidth

update : Msg -> Model -> Model
update msg model =
  let
    _ = Debug.log "yo" model
  in
  case msg of
    NoOp -> model

    Increment ->  if model.number < 3 then
                    {
                      model |
                        number = model.number + 1,
                        theta = model.theta + 0.1
                    }
                  else
                    {
                      model |
                        theta = model.theta + 0.1
                    }

    Decrement ->  if model.number > 0 then
                    {
                      model |
                        number = model.number - 1,
                        theta = model.theta - 0.1
                    }
                  else
                    {
                      model |
                        theta = model.theta + 0.1
                    }

    IncrementGlassSize ->
        let
          oldGame = model.game
          oldGlass = oldGame.glass
        in
        { model |
          game = { oldGame |
              glass = {
                oldGlass |
                  depth = oldGlass.depth + 1
              }

          }
        }

    DecrementGlassSize ->
        let
          oldGame = model.game
          oldGlass = oldGame.glass
        in
        { model |
          game = { oldGame |
              glass = {
                oldGlass |
                  depth = oldGlass.depth - 1
              }

          }
        }

    IncrementGlassWidth ->
        let
          oldGame = model.game
          oldGlass = oldGame.glass
        in
        { model |
          game = { oldGame |
              glass = {
                oldGlass |
                  width = oldGlass.width + 1
              }

          }
        }

    DecrementGlassWidth ->
        let
          oldGame = model.game
          oldGlass = oldGame.glass
        in
        { model |
          game = { oldGame |
              glass = {
                oldGlass |
                  width = oldGlass.width - 1
              }

          }
        }

-- VIEW
-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib
view : Model -> Html Msg
view model =
  div [ class "container", style [("margin-top", "30px"), ( "text-align", "center" )] ][    -- inline CSS (literal)
    div [ class "row" ][
      div [ class "col-xs-12" ][
        div [ class "jumbotron" ][
          game model
          , hello model.number                                                              -- ext 'hello' component (takes 'model' as arg)
          , p [] [ text ( "Angle" ) ]
          , button [ class "btn btn-primary btn-sm", onClick Increment ] [                  -- click handler
            span[ class "glyphicon glyphicon-star" ][]                                      -- glyphicon
            , span[][ text "+1" ]
          ]
          , button [ class "btn btn-primary btn-sm", onClick Decrement ] [
            span[ class "glyphicon glyphicon-star" ][]                                      -- glyphicon
              , span[][ text "-1" ]
          ]
          , p [] [ text ( "Depth" ) ]
          , button [ class "btn btn-primary btn-sm", onClick IncrementGlassSize ] [                  -- click handler
            span[ class "glyphicon glyphicon-star" ][]                                      -- glyphicon
            , span[][ text "+1" ]
          ], button [ class "btn btn-primary btn-sm", onClick DecrementGlassSize ] [                  -- click handler
            span[ class "glyphicon glyphicon-star" ][]                                      -- glyphicon
            , span[][ text "-1" ]
          ]
          , p [] [ text ( "Width" ) ]
          , button [ class "btn btn-primary btn-sm", onClick IncrementGlassWidth ] [                  -- click handler
            span[ class "glyphicon glyphicon-star" ][]                                      -- glyphicon
            , span[][ text "+1" ]
          ], button [ class "btn btn-primary btn-sm", onClick DecrementGlassWidth ] [                  -- click handler
            span[ class "glyphicon glyphicon-star" ][]                                      -- glyphicon
            , span[][ text "-1" ]
          ]

        ]
      ]
    ]
  ]


-- CSS STYLES
styles : { img : List ( String, String ) }
styles =
  {
    img =
      [ ( "width", "33%" )
      , ( "border", "4px solid #337AB7")
      ]
  }
