module Types.Accessor exposing (..)

import Types exposing (..)
import Monocle.Lens as Lens exposing (Lens)


gridState : Lens Model GridState
gridState =
    let
        get { gridState } =
            gridState

        set gridState model =
            { model | gridState = gridState }
    in
        Lens get set
