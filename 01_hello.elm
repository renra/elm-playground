module Hello exposing (..)
import Html exposing (h1, div, text)

add : Int -> Int -> Int
add x y =
  x + y

x = 6
y = 10

main =
  div
    []
    [
      h1 [] [
          text "Hello World!"
      ],

      div
        []
        [
          text ("The sum of " ++ toString x ++ " and " ++ toString y ++ " is " ++ (toString (add x y)))
        ]
    ]
