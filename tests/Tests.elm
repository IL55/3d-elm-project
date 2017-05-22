module Tests exposing (..)

import Test exposing (..)
import Expect
import Fuzz exposing (list, int, tuple, string)
import String
import Components.ChangeFigurePosition exposing (..)


all : Test
all =
    describe "Sample Test Suite"
        [ describe "Normalize angle"
            [ test "Should return 0" <|
                \() ->
                    Expect.equal 0 (normalizeAngle 0)
            , test "Should not be negative" <|
                \() ->
                    Expect.equal 3 (normalizeAngle -1)
            , test "Should not be big" <|
                \() ->
                    Expect.equal 0 (normalizeAngle 4)
            ]
        , describe "Fuzz test examples, using randomly generated input"
            [ fuzz (list int) "Lists always have positive length" <|
                \aList ->
                    List.length aList |> Expect.atLeast 0
            , fuzz (list int) "Sorting a list does not change its length" <|
                \aList ->
                    List.sort aList |> List.length |> Expect.equal (List.length aList)
            , fuzzWith { runs = 1000 } int "List.member will find an integer in a list containing it" <|
                \i ->
                    List.member i [ i ] |> Expect.true "If you see this, List.member returned False!"
            , fuzz2 string string "The length of a string equals the sum of its substrings' lengths" <|
                \s1 s2 ->
                    s1 ++ s2 |> String.length |> Expect.equal (String.length s1 + String.length s2)
            ]
        ]
