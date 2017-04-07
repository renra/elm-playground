module TypeSafety exposing (..)
import Html exposing (h1, div, text)

type Colour = Red | Blue | Yellow | Black | Shade String

colourToS: Colour -> String
colourToS c =
  case c of
    Red ->
      "The colour is red"
    Blue ->
      "The colour is blue"
    Yellow ->
      "The colour is yellow"
    Shade s ->
      "Wow a shade called " ++ s
    _ ->
      "Something I don't know"

main =
  div
    []
    [
      h1 [] [
          text "Union types!"
      ],

      div
        []
        [
          text (colourToS(Blue))
        ],

      div
        []
        [
          text (colourToS(Black))
        ],

      div
        []
        [
          text (colourToS(Shade "Lila"))
        ]
    ]
