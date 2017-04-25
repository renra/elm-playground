import Html exposing (..)
import Html.Attributes exposing (..)
import Collage exposing(..)
import Element exposing(..)
import Color exposing (..)
import Time exposing (..)
import Task exposing (..)
import Window
import Mouse

--- Model

type alias Position =
  {
    x : Float,
    y : Float
  }

type alias Size =
  {
    width : Float,
    height : Float
  }

type alias Model =
  {
    mousePos : Position,
    carPos : Position,
    collage: Size
  }

type Msg = NewMousePosition Mouse.Position | OnTime Time | WindowSize Window.Size

initialSizeCmd : Cmd Msg
initialSizeCmd =
  Task.perform WindowSize Window.size

init : (Model, Cmd Msg)
init =
  ({ mousePos = (Position 0 0), carPos = (Position 0 0), collage = (Size 0 0)}, initialSizeCmd)


--- Subscriptions
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [
      Time.every (10*millisecond) OnTime,
      Mouse.moves (\pos -> NewMousePosition pos)
    ]


--- Update

type HorizontalDirection = Left | Right
type VerticalDirection = Up | Down

type alias Direction = (HorizontalDirection, VerticalDirection)

getHorizontalDirection : Position -> Position -> HorizontalDirection
getHorizontalDirection mousePos carPos =
  if mousePos.x > carPos.x then
    Right
  else
    Left

getVerticalDirection : Position -> Position -> VerticalDirection
getVerticalDirection mousePos carPos =
  -- offsetting the car size, give or take
  if (mousePos.y - 50) > carPos.y then
    Up
  else
    Down

getDirection : Position -> Position -> Direction
getDirection mousePos carPos =
  ((getHorizontalDirection mousePos carPos), (getVerticalDirection mousePos carPos))

-- Returns canvas mouse coordinates
correctMousePos : Mouse.Position -> Size -> Position
correctMousePos mousePos collageSize =
  Position
    ((toFloat mousePos.x) - (collageSize.width / 2))
    ((collageSize.height / 2) - (toFloat mousePos.y) + 180)  -- 180 offsets the text at the top, not exact


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    WindowSize size ->
      ({model | collage = (Size (toFloat size.width) (toFloat size.height))}, Cmd.none)
    NewMousePosition mousePos ->
      (
        {model | mousePos = (correctMousePos mousePos model.collage)},
        Cmd.none
      )
    OnTime _ ->
      case (getDirection model.mousePos model.carPos) of
        (Right, Up) ->
          ({model | carPos = (Position (model.carPos.x + 1) (model.carPos.y + 1))}, Cmd.none)
        (Left, Up) ->
          ({model | carPos = (Position (model.carPos.x - 1) (model.carPos.y + 1))}, Cmd.none)
        (Right, Down) ->
          ({model | carPos = (Position (model.carPos.x + 1) (model.carPos.y - 1))}, Cmd.none)
        (Left, Down) ->
          ({model | carPos = (Position (model.carPos.x - 1) (model.carPos.y - 1))}, Cmd.none)


--- View

chassis = filled black (rect 160 50)
top = filled black (rect 100 60)
wheel = filled red (circle 24)
hunterCat = Element.image 60 60 "assets/cat_hunteress.jpg"

drawCar : Position -> List Form
drawCar position =
  [
    chassis |> move (position.x, position.y),
    top |> move (position.x, position.y + 30),
    wheel |> move (position.x - 40, position.y - 28),
    wheel |> move (position.x + 40, position.y - 28),
    toForm hunterCat |> move (position.x, position.y + 25)
  ]


view : Model -> Html Msg
view model =
  div
    [
      style [
        ("cursor", "url(assets/mouse.jpg), auto")
      ]
    ]
    [
      h1
        [
          style [
            ("text-align", "center")
          ]
        ]
        [
          Html.text "The mouse-chasing car"
        ],

      div
        [
          style [("text-align", "center")]
        ]
        [
          "Canvas size: (height=" ++ (toString model.collage.height) ++ ",width=" ++ (toString model.collage.width) ++ ")"
            |> Html.text
        ],

      div
        [
          style [("text-align", "center")]
        ]
        [
          "In-canvas mouse position: (x=" ++ (toString model.mousePos.x) ++ ",y=" ++ (toString model.mousePos.y) ++ "(give or take))"
            |> Html.text
        ],

      div
        [
          style [("text-align", "center")]
        ]
        [
          "In-canvas car position: (x=" ++ (toString model.carPos.x) ++ ",y=" ++ (toString model.carPos.y) ++ ")"
            |> Html.text
        ],

      div
        [
          style [("text-align", "center")]
        ]
        [
          "Car direction: " ++ (getDirection model.mousePos model.carPos |> toString)
            |> Html.text
        ],

      toHtml (collage (truncate model.collage.width) (truncate model.collage.height)
        (drawCar model.carPos)
      ),

      div
        [
          style [("text-align", "center")]
        ]
        [
          Html.text "Cat image taken from ",
          a
            [
              href "https://www.thedodo.com/cats-chatting-up-humans-1634864494.html",
              target "blank"
            ]
            [
              Html.text "https://www.thedodo.com/cats-chatting-up-humans-1634864494.html"
            ]
        ]
    ]

main =
  Html.program
    {
      init = init,
      view = view,
      subscriptions = subscriptions,
      update = update
    }

