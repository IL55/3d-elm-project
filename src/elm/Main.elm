port module Main exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick )
import Keyboard exposing (..)
import Json.Decode

-- component import example

import Components.Model exposing ( Model, Game, GameGlass )
import Components.Hello exposing ( hello )
import Components.Game exposing ( game )
import Components.ChangeGlassSize exposing (..)
import Components.ChangeFigurePosition exposing (..)
import Components.AddFigureToGlass exposing (..)
import Random exposing (..)
import Components.KeyPress exposing ( processKeyPress )

-- define port
port showPortName : String -> Cmd msg

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Keyboard.downs KeyMsg ]


-- APP
main : Program Never Model Msg
main =
  program {
    init = init,
    view = view,
    update = update,
    subscriptions = subscriptions
  }

model : Model
model = {
  seed = Random.initialSeed 31,
  style = "Blue",
  number = 1,
  isCool = True,
  theta = 3.2,
  game = {
    view = {
      width = 400,
      height = 400
    },
    glass = calculateSizes 10 4,
    blocks = [],
    figure = {
      figureType = 1,
      position = {
        center = { x = 0, y = 0, z = 0 },
        rotation = { x = 0, y = 0, z = 0 }
      },
      blocks = [
        { x = 0, y = 0, z = 0 }
      ]
    }
  }
 }

init : ( Model, Cmd msg )
init =
    ( model, Cmd.none )

-- UPDATE
type Msg = NoOp |
  Increment |
  Decrement |
  IncrementGlassSizeMsg |
  DecrementGlassSizeMsg |
  IncrementGlassWidthMsg |
  DecrementGlassWidthMsg |
  IncrementFigureRotateXMsg |
  DecrementFigureRotateXMsg |
  IncrementFigureRotateYMsg |
  DecrementFigureRotateYMsg |
  IncrementFigureRotateZMsg |
  DecrementFigureRotateZMsg |
  IncrementFigureCenterXMsg |
  DecrementFigureCenterXMsg |
  IncrementFigureCenterYMsg |
  DecrementFigureCenterYMsg |
  IncrementFigureCenterZMsg |
  DecrementFigureCenterZMsg |
  AddFigureToGlassMsg |
  KeyMsg Keyboard.KeyCode

update : Msg -> Model -> (Model, Cmd msg)
update msg model =
  let
    _ = Debug.log "yo" model
  in
  case msg of
    NoOp -> ( model, Cmd.none )

    Increment ->
      ({
        model |
          theta = model.theta + 0.1
      }, Cmd.none)

    Decrement ->
      ( {
        model |
          theta = model.theta - 0.1
      }, Cmd.none )

    IncrementGlassSizeMsg ->
      ( incrementGlassSize model, Cmd.none )

    DecrementGlassSizeMsg ->
      ( decrementGlassSize model, Cmd.none )

    IncrementGlassWidthMsg ->
      ( incrementGlassWidth model, Cmd.none )

    DecrementGlassWidthMsg ->
      ( decrementGlassWidth model, Cmd.none )

    IncrementFigureRotateXMsg ->
      ( incrementFigureRotateX model, Cmd.none )

    DecrementFigureRotateXMsg ->
      ( decrementFigureRotateX model, Cmd.none )

    IncrementFigureRotateYMsg ->
      ( incrementFigureRotateY model, Cmd.none )

    DecrementFigureRotateYMsg ->
      ( decrementFigureRotateY model, Cmd.none )

    IncrementFigureRotateZMsg ->
      ( incrementFigureRotateZ model, Cmd.none )

    DecrementFigureRotateZMsg ->
      ( decrementFigureRotateZ model, Cmd.none )

    IncrementFigureCenterXMsg ->
      ( incrementFigureCenterX model, Cmd.none )

    DecrementFigureCenterXMsg ->
      ( decrementFigureCenterX model, Cmd.none )

    IncrementFigureCenterYMsg ->
      ( incrementFigureCenterY model, Cmd.none )

    DecrementFigureCenterYMsg ->
      ( decrementFigureCenterY model, Cmd.none )

    IncrementFigureCenterZMsg ->
      ( incrementFigureCenterZ model, Cmd.none )

    DecrementFigureCenterZMsg ->
      ( decrementFigureCenterZ model, Cmd.none )

    AddFigureToGlassMsg ->
      ( addFigureToGlass model, Cmd.none )

    KeyMsg code ->
      ( processKeyPress model code, Cmd.none )

-- VIEW
-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib
view : Model -> Html Msg
view model =
  div [ class "container", style [("margin-top", "30px"), ( "text-align", "center" )]][
    div [ class "row" ][
      div [ class "col-xs-12" ][
        div [ class "jumbotron" ][
          hello model.number
          , game model
          , p [] [
            text ( "Angle" )
            , button [ class "btn btn-primary btn-sm", onClick Increment ] [
              span[ class "glyphicon" ][]
              , span[][ text "+1" ]
            ]
            , button [ class "btn btn-primary btn-sm", onClick Decrement ] [
              span[ class "glyphicon" ][]
                , span[][ text "-1" ]
            ]
          ]
          , p [] [
            text ( "Depth" )
            , button [ class "btn btn-primary btn-sm", onClick IncrementGlassSizeMsg ] [
              span[ class "glyphicon" ][]
              , span[][ text "+1" ]
            ], button [ class "btn btn-primary btn-sm", onClick DecrementGlassSizeMsg ] [
              span[ class "glyphicon" ][]
              , span[][ text "-1" ]
            ]
          ]
          , p [] [
            text ( "Width" )
            , button [ class "btn btn-primary btn-sm", onClick IncrementGlassWidthMsg ] [
              span[ class "glyphicon" ][]
              , span[][ text "+1" ]
            ], button [ class "btn btn-primary btn-sm", onClick DecrementGlassWidthMsg ] [
              span[ class "glyphicon" ][]
              , span[][ text "-1" ]
            ]
          ]
          , p [] [ text ( "Rotate" ) ]
          , button [ class "btn btn-primary btn-sm", onClick IncrementFigureRotateXMsg ] [
            span[ class "glyphicon" ][]
            , span[][ text "+1x" ]
          ], button [ class "btn btn-primary btn-sm", onClick DecrementFigureRotateXMsg ] [
            span[ class "glyphicon" ][]
            , span[][ text "-1x" ]
          ]
          , button [ class "btn btn-primary btn-sm", onClick IncrementFigureRotateYMsg ] [
            span[ class "glyphicon" ][]
            , span[][ text "+1y" ]
          ], button [ class "btn btn-primary btn-sm", onClick DecrementFigureRotateYMsg ] [
            span[ class "glyphicon" ][]
            , span[][ text "-1y" ]
          ]
          , button [ class "btn btn-primary btn-sm", onClick IncrementFigureRotateZMsg ] [
            span[ class "glyphicon" ][]
            , span[][ text "+1z" ]
          ], button [ class "btn btn-primary btn-sm", onClick DecrementFigureRotateZMsg ] [
            span[ class "glyphicon" ][]
            , span[][ text "-1z" ]
          ]
          , p [] [ text ( "Move" ) ]
          , button [ class "btn btn-primary btn-sm", onClick IncrementFigureCenterXMsg ] [
            span[ class "glyphicon" ][]
            , span[][ text "+1x" ]
          ], button [ class "btn btn-primary btn-sm", onClick DecrementFigureCenterXMsg ] [
            span[ class "glyphicon" ][]
            , span[][ text "-1x" ]
          ]
          , button [ class "btn btn-primary btn-sm", onClick IncrementFigureCenterYMsg ] [
            span[ class "glyphicon" ][]
            , span[][ text "+1y" ]
          ], button [ class "btn btn-primary btn-sm", onClick DecrementFigureCenterYMsg ] [
            span[ class "glyphicon" ][]
            , span[][ text "-1y" ]
          ]
          , button [ class "btn btn-primary btn-sm", onClick IncrementFigureCenterZMsg ] [
            span[ class "glyphicon" ][]
            , span[][ text "+1z" ]
          ], button [ class "btn btn-primary btn-sm", onClick DecrementFigureCenterZMsg ] [
            span[ class "glyphicon" ][]
            , span[][ text "-1z" ]
          ]
          , button [ class "btn btn-primary btn-sm", onClick AddFigureToGlassMsg ] [
            span[ class "glyphicon" ][]
            , span[][ text "Add" ]
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
