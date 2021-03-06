import Motion exposing (Motion, Model, makeUpdate, cue, isRunning)

import Time exposing (Time, millisecond, second)

import Html
import Svg exposing (Svg, svg, circle)
import Svg.Attributes exposing (width, viewBox, cx, cy, r, fill)

import Animation exposing
    ( from, to, duration
    )


type alias Circle =
    { x : Float
    }

type Msg = Tick Time

main = Html.program
    { init = (initialModel, Cmd.none)
    , update = update
    , view = view
    , subscriptions = subscriptions
    }

initialModel : Model Circle
initialModel =
    Model
        { x = 300 }
        (from 100 >> to 300 >> duration (2 * second) |> cue)

update : Msg -> Model Circle -> (Model Circle, Cmd Msg)
update (Tick time) model =
    (update_ time model, Cmd.none)

update_ : Time -> Model Circle -> Model Circle
update_ =
    makeUpdate (\newX circ -> { circ | x = newX })

view : Model Circle -> Svg Msg
view model =
    if (not <| isRunning model.motion) then
        svg [] []
    else
        let
            x = toString model.circ.x
        in
            svg
            [ width "500px"
            , viewBox "0 0 500 500"
            ]
            [ circle [ cx x, cy "200", r "20", fill "#aa0000" ] []
            ]

subscriptions : Model c -> Sub Msg
subscriptions model =
    Time.every (30 * millisecond) Tick
