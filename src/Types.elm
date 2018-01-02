module Types exposing (..)


type alias Model =
    { editMode : EditMode
    , gridState : GridState
    }


type alias GridState =
    { cells : List (List Cell)
    , rows : List CellLength
    , rawRows : List String
    , columns : List CellLength
    , rawColumns : List String
    , selectedCell : Maybe Cell
    }


type alias Cell =
    { id : Int
    , gridArea : String
    , input : String
    }


type alias Pane =
    { id : String
    , gridArea : String
    , cells : List Cell
    }


type EditMode
    = PanesMode
    | CellsMode
    | OutputMode


type CellLength
    = Px Float
    | Percent Float
    | Frame Int


type Presets
    = Simple
    | HolyGrail


type Msg
    = NoOp
    | SetPreset Presets
    | SwitchEditMode EditMode
    | AddColumn
    | RemoveColumn
    | AddRow
    | RemoveRow
