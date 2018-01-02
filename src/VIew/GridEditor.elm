module View.GridEditor exposing (view)

import Element exposing (..)
import Element.Attributes as Attrs exposing (..)
import Element.Events exposing (on, onClick)
import Element.Keyed as Keyed
import Types exposing (..)
import Types.GridState exposing (..)
import View.StyleSheet exposing (..)
import View.Helper exposing (..)
import Rocket exposing ((=>))


view : Model -> Element Styles variation Msg
view { gridState, editMode } =
    case editMode of
        PanesMode ->
            Keyed.namedGrid None
                []
                { columns = List.map cellLengthToLength gridState.columns
                , rows = namedRowsInPanes gridState.rows gridState.cells
                , cells =
                    cellsToPanes editMode gridState.cells
                        |> List.map (\pane -> Keyed.named pane.gridArea <| paneView pane)
                }

        CellsMode ->
            Keyed.namedGrid None
                []
                { columns = List.map cellLengthToLength gridState.columns
                , rows =
                    namedRowsInCells gridState.rows gridState.cells
                        |> Debug.log "ふみ"
                , cells =
                    gridState.cells
                        |> List.concat
                        |> List.map (\cell -> Keyed.named ("g" ++ toString cell.id) <| cellView cell)
                }

        OutputMode ->
            Debug.crash "Bug? ErrCode 0001"


namedRowsInPanes : List CellLength -> List (List Cell) -> List ( Length, List NamedGridPosition )
namedRowsInPanes lengths cellsList =
    List.map2
        (\length cells ->
            cellLengthToLength length => List.map (\cell -> span 1 cell.gridArea) cells
        )
        lengths
        cellsList


namedRowsInCells : List CellLength -> List (List Cell) -> List ( Length, List NamedGridPosition )
namedRowsInCells lengths cellsList =
    List.map2
        (\length cells ->
            cellLengthToLength length => List.map (\cell -> span 1 <| "g" ++ toString cell.id) cells
        )
        lengths
        cellsList


paneView : Pane -> Element Styles variation Msg
paneView { id, gridArea, cells } =
    wrappedColumn PaneStyle
        [ center
        , verticalCenter
        , spacing 5
        ]
        [ text gridArea
        , when (List.length cells > 1)
            (node "button" <| el ButtonStyle [] <| text "unchain")
        ]


cellView : Cell -> Element Styles variation Msg
cellView { id, gridArea, input } =
    column PaneStyle
        [ center
        , verticalCenter
        , spacing 5
        ]
        [ text gridArea
        ]
