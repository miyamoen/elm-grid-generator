module Types.Presets.Simple exposing (model)

import Types exposing (..)


model : GridState
model =
    { columns = [ ScaleUnit (Frame 1) "1fr" ]
    , rows = [ ScaleUnit (Frame 1) "1fr" ]
    , selectedCell = Nothing
    , cells = [ [ { id = 0, gridArea = "g0", input = "g0" } ] ]
    }
