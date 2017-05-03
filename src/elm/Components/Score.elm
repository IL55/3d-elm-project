module Components.Score exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import String

-- score component
score : Int -> Html a
score model =
  div
    [ class "h1" ]
    [ text ( "Score " ++ (toString model) ) ]
