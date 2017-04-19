port module Main exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick )

-- component import example

import Components.Model exposing ( Model, Game, GameGlass )
import Components.Hello exposing ( hello )
import Components.Game exposing ( game )
import Components.ChangeGlassSize exposing (..)
import Components.ChangeFigurePosition exposing (..)

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
    glass = calculateSizes 8 6,
    blocks = [
      { x = 0, y = 0, z = 0 },
      { x = 3, y = 3, z = 4 },
      { x = 5, y = 5, z = 7 }
    ],
    figure = {
      figureType = 1,
      position = {
        center = { x = 2, y = 2, z = 2 },
        rotation = { x = 1, y = 1, z = 1 }
      },
      blocks = [
        { x = -1, y = -1, z = 0 },
        { x = -1, y = 0, z = 0 },
        { x = 0, y = 0, z = 0 },
        { x = 1, y = 0, z = 0 },
        { x = 1, y = 1, z = 0 }
      ]
    }
  }
 }

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
  DecrementFigureCenterZMsg

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

    IncrementGlassSizeMsg ->
      incrementGlassSize model

    DecrementGlassSizeMsg ->
      decrementGlassSize model

    IncrementGlassWidthMsg ->
      incrementGlassWidth model

    DecrementGlassWidthMsg ->
      decrementGlassWidth model

    IncrementFigureRotateXMsg ->
      incrementFigureRotateX model

    DecrementFigureRotateXMsg ->
      decrementFigureRotateX model

    IncrementFigureRotateYMsg ->
      incrementFigureRotateY model

    DecrementFigureRotateYMsg ->
      decrementFigureRotateY model

    IncrementFigureRotateZMsg ->
      incrementFigureRotateZ model

    DecrementFigureRotateZMsg ->
      decrementFigureRotateZ model

    IncrementFigureCenterXMsg ->
      incrementFigureCenterX model

    DecrementFigureCenterXMsg ->
      decrementFigureCenterX model

    IncrementFigureCenterYMsg ->
      incrementFigureCenterY model

    DecrementFigureCenterYMsg ->
      decrementFigureCenterY model

    IncrementFigureCenterZMsg ->
      incrementFigureCenterZ model

    DecrementFigureCenterZMsg ->
      decrementFigureCenterZ model


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
          , button [ class "btn btn-primary btn-sm", onClick Increment ] [
            span[ class "glyphicon glyphicon-star" ][]
            , span[][ text "+1" ]
          ]
          , button [ class "btn btn-primary btn-sm", onClick Decrement ] [
            span[ class "glyphicon glyphicon-star" ][]
              , span[][ text "-1" ]
          ]
          , p [] [ text ( "Depth" ) ]
          , button [ class "btn btn-primary btn-sm", onClick IncrementGlassSizeMsg ] [
            span[ class "glyphicon glyphicon-star" ][]
            , span[][ text "+1" ]
          ], button [ class "btn btn-primary btn-sm", onClick DecrementGlassSizeMsg ] [
            span[ class "glyphicon glyphicon-star" ][]
            , span[][ text "-1" ]
          ]
          , p [] [ text ( "Width" ) ]
          , button [ class "btn btn-primary btn-sm", onClick IncrementGlassWidthMsg ] [
            span[ class "glyphicon glyphicon-star" ][]
            , span[][ text "+1" ]
          ], button [ class "btn btn-primary btn-sm", onClick DecrementGlassWidthMsg ] [
            span[ class "glyphicon glyphicon-star" ][]
            , span[][ text "-1" ]
          ]
          , p [] [ text ( "Rotate" ) ]
          , button [ class "btn btn-primary btn-sm", onClick IncrementFigureRotateXMsg ] [
            span[ class "glyphicon glyphicon-star" ][]
            , span[][ text "+1x" ]
          ], button [ class "btn btn-primary btn-sm", onClick DecrementFigureRotateXMsg ] [
            span[ class "glyphicon glyphicon-star" ][]
            , span[][ text "-1x" ]
          ]
          , button [ class "btn btn-primary btn-sm", onClick IncrementFigureRotateYMsg ] [
            span[ class "glyphicon glyphicon-star" ][]
            , span[][ text "+1y" ]
          ], button [ class "btn btn-primary btn-sm", onClick DecrementFigureRotateYMsg ] [
            span[ class "glyphicon glyphicon-star" ][]
            , span[][ text "-1y" ]
          ]
          , button [ class "btn btn-primary btn-sm", onClick IncrementFigureRotateZMsg ] [
            span[ class "glyphicon glyphicon-star" ][]
            , span[][ text "+1z" ]
          ], button [ class "btn btn-primary btn-sm", onClick DecrementFigureRotateZMsg ] [
            span[ class "glyphicon glyphicon-star" ][]
            , span[][ text "-1z" ]
          ]
          , p [] [ text ( "Move" ) ]
          , button [ class "btn btn-primary btn-sm", onClick IncrementFigureCenterXMsg ] [
            span[ class "glyphicon glyphicon-star" ][]
            , span[][ text "+1x" ]
          ], button [ class "btn btn-primary btn-sm", onClick DecrementFigureCenterXMsg ] [
            span[ class "glyphicon glyphicon-star" ][]
            , span[][ text "-1x" ]
          ]
          , button [ class "btn btn-primary btn-sm", onClick IncrementFigureCenterYMsg ] [
            span[ class "glyphicon glyphicon-star" ][]
            , span[][ text "+1y" ]
          ], button [ class "btn btn-primary btn-sm", onClick DecrementFigureCenterYMsg ] [
            span[ class "glyphicon glyphicon-star" ][]
            , span[][ text "-1y" ]
          ]
          , button [ class "btn btn-primary btn-sm", onClick IncrementFigureCenterZMsg ] [
            span[ class "glyphicon glyphicon-star" ][]
            , span[][ text "+1z" ]
          ], button [ class "btn btn-primary btn-sm", onClick DecrementFigureCenterZMsg ] [
            span[ class "glyphicon glyphicon-star" ][]
            , span[][ text "-1z" ]
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
