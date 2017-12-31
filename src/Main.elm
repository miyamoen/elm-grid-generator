module Main exposing (..)

import Html
import View exposing (view)
import Types exposing (..)
import Types.Presets.Simple as Simple
import Types.Presets.HolyGrail as HolyGrail
import Rocket exposing (..)


---- MODEL ----


init : ( Model, List (Cmd Msg) )
init =
    { editMode = PanesMode
    , gridState = HolyGrail.model
    }
        => []



---- UPDATE ----


update : Msg -> Model -> ( Model, List (Cmd Msg) )
update msg model =
    case msg of
        NoOp ->
            model => []

        SetPreset Simple ->
            { model | gridState = Simple.model } => []

        SetPreset HolyGrail ->
            { model | gridState = HolyGrail.model } => []



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init |> batchInit
        , update = update >> batchUpdate
        , subscriptions = always Sub.none
        }
