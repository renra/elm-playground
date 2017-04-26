import Html exposing (..)
import Time exposing (..)
import Task exposing (..)

--- Update

type Msg = OnTime Time

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    OnTime newTime ->
      (newTime, Cmd.none)


--- Model

type alias Model = Time

init : (Model, Cmd Msg)
init =
  (0, Task.perform OnTime now)


--- Subscriptions

subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every (10*millisecond) OnTime


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

