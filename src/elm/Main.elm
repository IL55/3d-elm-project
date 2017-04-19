port module Main exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick )

-- component import example

import Components.Model exposing ( Model, Game, GameGlass )
import Components.Hello exposing ( hello )
import Components.Game exposing ( game )
import Components.ChangeGlassSize exposing (..)

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

normalizeAngle : Int -> Int
normalizeAngle angle =
  if angle > 3 then
    0
  else
    if angle < 0 then
      3
    else
      angle

normalizeCoordinate : Int -> Int -> Int
normalizeCoordinate width x =
  if x > (width - 1) then
    width - 1
  else
    if x < 0 then
      0
    else
      x


-- UPDATE
type Msg = NoOp |
  Increment |
  Decrement |
  IncrementGlassSizeMsg |
  DecrementGlassSizeMsg |
  IncrementGlassWidthMsg |
  DecrementGlassWidthMsg |
  IncrementFigureRotateX |
  DecrementFigureRotateX |
  IncrementFigureRotateY |
  DecrementFigureRotateY |
  IncrementFigureRotateZ |
  DecrementFigureRotateZ |
  IncrementFigureX |
  DecrementFigureX |
  IncrementFigureY |
  DecrementFigureY

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

    IncrementFigureRotateX ->
        let
          oldGame = model.game
          oldFigure = oldGame.figure
          oldPosition = oldFigure.position
          oldRotation = oldPosition.rotation
          newAng = normalizeAngle (oldRotation.x + 1)
        in
        { model |
          game = { oldGame |
              figure = { oldFigure |
                position = { oldPosition |
                  rotation = { oldRotation |
                    x = newAng
                  }
                }
              }

          }
        }

    DecrementFigureRotateX ->
        let
          oldGame = model.game
          oldFigure = oldGame.figure
          oldPosition = oldFigure.position
          oldRotation = oldPosition.rotation
          newAng = normalizeAngle (oldRotation.x - 1)
        in
        { model |
          game = { oldGame |
              figure = { oldFigure |
                position = { oldPosition |
                  rotation = { oldRotation |
                    x = newAng
                  }
                }
              }

          }
        }

    IncrementFigureRotateY ->
        let
          oldGame = model.game
          oldFigure = oldGame.figure
          oldPosition = oldFigure.position
          oldRotation = oldPosition.rotation
          newAng = normalizeAngle (oldRotation.y + 1)
        in
        { model |
          game = { oldGame |
              figure = { oldFigure |
                position = { oldPosition |
                  rotation = { oldRotation |
                    y = newAng
                  }
                }
              }

          }
        }

    DecrementFigureRotateY ->
        let
          oldGame = model.game
          oldFigure = oldGame.figure
          oldPosition = oldFigure.position
          oldRotation = oldPosition.rotation
          newAng = normalizeAngle (oldRotation.y - 1)
        in
        { model |
          game = { oldGame |
              figure = { oldFigure |
                position = { oldPosition |
                  rotation = { oldRotation |
                    y = newAng
                  }
                }
              }

          }
        }

    IncrementFigureRotateZ ->
        let
          oldGame = model.game
          oldFigure = oldGame.figure
          oldPosition = oldFigure.position
          oldRotation = oldPosition.rotation
          newAng = normalizeAngle (oldRotation.z + 1)
        in
        { model |
          game = { oldGame |
              figure = { oldFigure |
                position = { oldPosition |
                  rotation = { oldRotation |
                    z = newAng
                  }
                }
              }

          }
        }

    DecrementFigureRotateZ ->
        let
          oldGame = model.game
          oldFigure = oldGame.figure
          oldPosition = oldFigure.position
          oldRotation = oldPosition.rotation
          newAng = normalizeAngle (oldRotation.z - 1)
        in
        { model |
          game = { oldGame |
              figure = { oldFigure |
                position = { oldPosition |
                  rotation = { oldRotation |
                    z = newAng
                  }
                }
              }

          }
        }

    IncrementFigureX ->
        let
          oldGame = model.game
          oldFigure = oldGame.figure
          oldPosition = oldFigure.position
          oldCenter = oldPosition.center
          width = model.game.glass.width
          newC = normalizeCoordinate width (oldCenter.x + 1)
        in
        { model |
          game = { oldGame |
              figure = { oldFigure |
                position = { oldPosition |
                  center = { oldCenter |
                    x = newC
                  }
                }
              }

          }
        }

    DecrementFigureX ->
        let
          oldGame = model.game
          oldFigure = oldGame.figure
          oldPosition = oldFigure.position
          oldCenter = oldPosition.center
          width = model.game.glass.width
          newC = normalizeCoordinate width (oldCenter.x - 1)
        in
        { model |
          game = { oldGame |
              figure = { oldFigure |
                position = { oldPosition |
                  center = { oldCenter |
                    x = newC
                  }
                }
              }

          }
        }

    IncrementFigureY ->
        let
          oldGame = model.game
          oldFigure = oldGame.figure
          oldPosition = oldFigure.position
          oldCenter = oldPosition.center
          width = model.game.glass.width
          newC = normalizeCoordinate width (oldCenter.y + 1)
        in
        { model |
          game = { oldGame |
              figure = { oldFigure |
                position = { oldPosition |
                  center = { oldCenter |
                    y = newC
                  }
                }
              }

          }
        }

    DecrementFigureY ->
        let
          oldGame = model.game
          oldFigure = oldGame.figure
          oldPosition = oldFigure.position
          oldCenter = oldPosition.center
          width = model.game.glass.width
          newC = normalizeCoordinate width (oldCenter.y - 1)
        in
        { model |
          game = { oldGame |
              figure = { oldFigure |
                position = { oldPosition |
                  center = { oldCenter |
                    y = newC
                  }
                }
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
          , button [ class "btn btn-primary btn-sm", onClick IncrementGlassSizeMsg ] [                  -- click handler
            span[ class "glyphicon glyphicon-star" ][]                                      -- glyphicon
            , span[][ text "+1" ]
          ], button [ class "btn btn-primary btn-sm", onClick DecrementGlassSizeMsg ] [                  -- click handler
            span[ class "glyphicon glyphicon-star" ][]                                      -- glyphicon
            , span[][ text "-1" ]
          ]
          , p [] [ text ( "Width" ) ]
          , button [ class "btn btn-primary btn-sm", onClick IncrementGlassWidthMsg ] [                  -- click handler
            span[ class "glyphicon glyphicon-star" ][]                                      -- glyphicon
            , span[][ text "+1" ]
          ], button [ class "btn btn-primary btn-sm", onClick DecrementGlassWidthMsg ] [                  -- click handler
            span[ class "glyphicon glyphicon-star" ][]                                      -- glyphicon
            , span[][ text "-1" ]
          ]
          , p [] [ text ( "Rotate" ) ]
          , button [ class "btn btn-primary btn-sm", onClick IncrementFigureRotateX ] [                  -- click handler
            span[ class "glyphicon glyphicon-star" ][]                                      -- glyphicon
            , span[][ text "+1x" ]
          ], button [ class "btn btn-primary btn-sm", onClick DecrementFigureRotateX ] [                  -- click handler
            span[ class "glyphicon glyphicon-star" ][]                                      -- glyphicon
            , span[][ text "-1x" ]
          ]
          , button [ class "btn btn-primary btn-sm", onClick IncrementFigureRotateY ] [                  -- click handler
            span[ class "glyphicon glyphicon-star" ][]                                      -- glyphicon
            , span[][ text "+1y" ]
          ], button [ class "btn btn-primary btn-sm", onClick DecrementFigureRotateY ] [                  -- click handler
            span[ class "glyphicon glyphicon-star" ][]                                      -- glyphicon
            , span[][ text "-1y" ]
          ]
          , button [ class "btn btn-primary btn-sm", onClick IncrementFigureRotateZ ] [                  -- click handler
            span[ class "glyphicon glyphicon-star" ][]                                      -- glyphicon
            , span[][ text "+1z" ]
          ], button [ class "btn btn-primary btn-sm", onClick DecrementFigureRotateZ ] [                  -- click handler
            span[ class "glyphicon glyphicon-star" ][]                                      -- glyphicon
            , span[][ text "-1z" ]
          ]
          , p [] [ text ( "Move" ) ]
          , button [ class "btn btn-primary btn-sm", onClick IncrementFigureX ] [                  -- click handler
            span[ class "glyphicon glyphicon-star" ][]                                      -- glyphicon
            , span[][ text "+1x" ]
          ], button [ class "btn btn-primary btn-sm", onClick DecrementFigureX ] [                  -- click handler
            span[ class "glyphicon glyphicon-star" ][]                                      -- glyphicon
            , span[][ text "-1x" ]
          ]
          , button [ class "btn btn-primary btn-sm", onClick IncrementFigureY ] [                  -- click handler
            span[ class "glyphicon glyphicon-star" ][]                                      -- glyphicon
            , span[][ text "+1y" ]
          ], button [ class "btn btn-primary btn-sm", onClick DecrementFigureY ] [                  -- click handler
            span[ class "glyphicon glyphicon-star" ][]                                      -- glyphicon
            , span[][ text "-1y" ]
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
