module Types exposing (..)


type alias Model =
    { editMode : EditMode
    , gridState : GridState
    }


type alias GridState =
    { cells : List (List Cell)
    , rows : List CellLength
    , rawRows : List String
    , rowCount : Int
    , columns : List CellLength
    , rawColumns : List String
    , columnCount : Int
    , selectedCell : Maybe Cell
    }


type alias Cell =
    { id : Int
    , gridArea : String
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
