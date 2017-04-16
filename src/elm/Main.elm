port module Main exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick )

-- component import example

import Components.Model exposing ( Model, Game, GameGlass )
import Components.Hello exposing ( hello )
import Components.Cube exposing ( cube )

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
    glass = {
      depth = 8,
      width = 6
    },
    figure = {
      figureType = 0,
      position = {
        depth = 0,
        rotationX = 0,
        rotationY = 0,
        rotationZ = 0
      }
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
          cube model
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
