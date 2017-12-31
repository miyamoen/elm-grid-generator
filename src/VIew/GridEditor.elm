module View.GridEditor exposing (view)

import Element exposing (..)
import Element.Attributes as Attrs exposing (..)
import Element.Events exposing (on, onClick)
import Types exposing (..)
import Types.GridState exposing (..)
import View.StyleSheet exposing (..)
import View.Helper exposing (..)
import Rocket exposing ((=>))


view : Model -> Element Styles variation Msg
view { gridState, editMode } =
    namedGrid None
        []
        { columns = List.map cellLengthToLength gridState.columns
        , rows = namedRows gridState.rows gridState.cells
        , cells =
            cellsToPanes editMode gridState.cells
                |> List.map (\pane -> named pane.gridArea <| paneView pane)
        }


namedRows : List CellLength -> List (List Cell) -> List ( Length, List NamedGridPosition )
namedRows lengths cellsList =
    List.map2
        (\length cells ->
            cellLengthToLength length => List.map (\cell -> span 1 cell.gridArea) cells
        )
        lengths
        cellsList


paneView : Pane -> Element Styles variation Msg
paneView { id, gridArea, cells } =
    el PaneStyle [] empty
