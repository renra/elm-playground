module TypeSafety exposing (..)
import Html exposing (h1, div, text)

extractSquare : { record | square: (Int -> Int) } -> Int -> Int
extractSquare object n =
  object.square(n)

square : Int -> Int
square a =
  a * a

concat : String -> String -> String
concat a b =
  a ++ b

validObject =
  {
    square = square
  }

invalidObject =
  {
    square = concat
  }

main =
  div
    []
    [
      h1 [] [
          text "Type checking!"
      ],

      div
        []
        [
          text (toString (extractSquare validObject 10))
          --text (toString (extractSquare invalidObject 10))
        ]
    ]
