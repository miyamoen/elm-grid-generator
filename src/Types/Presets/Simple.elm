module Types.Presets.Simple exposing (model)

import Types exposing (..)


model : GridState
model =
    { columns = [ Frame 1 ]
    , rawColumns = [ "1fr" ]
    , rows = [ Frame 1 ]
    , rawRows = [ "1fr" ]
    , rowCount = 1
    , columnCount = 1
    , selectedCell = Nothing
    , cells = [ [ { id = 0, gridArea = "g0", input = "g0" } ] ]
    }
