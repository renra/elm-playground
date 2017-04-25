import Html exposing (..)
import Time exposing (..)
import Task exposing (..)
import Mouse

--- Update

type Msg = NewPosition Mouse.Position

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NewPosition p ->
      (p, Cmd.none)


--- Model

type alias Model = Mouse.Position

-- TODO: how to get the initial mouse position?
init : (Model, Cmd Msg)
init =
  ({x = 0, y = 0}, Cmd.none)


--- Subscriptions

subscriptions : Model -> Sub Msg
subscriptions model =
  Mouse.moves (\x -> NewPosition x)


--- View

view : Model -> Html Msg
view model =
  div
    []
    [
      text (toString model)
    ]

main =
  Html.program
    {
      init = init,
      view = view,
      subscriptions = subscriptions,
      update = update
    }

