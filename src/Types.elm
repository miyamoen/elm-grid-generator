module Types exposing (..)


type alias Model =
    { editMode : EditMode
    , gridState : GridState
    , selectedCellId : Maybe Int
    , selectedGridArea : Maybe String
    }


type alias GridState =
    { cells : List (List Cell)
    , rows : List ScaleUnit
    , columns : List ScaleUnit
    }


type alias ScaleUnit =
    { length : CellLength
    , input : String
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
    | InputColumn Int String
    | InputRow Int String
    | BreakPane String
    | SelectCell Int
    | UnSelectCell
    | InputSelectedCell String
    | EnterCellInput String
    | SelectPane String
    | UnSelectPane
    | InputSelectedPane String
    | EnterPaneInput String
