module View.GridEditor exposing (view)

import Element exposing (..)
import Element.Attributes as Attrs exposing (..)
import Element.Events exposing (on, onClick, onBlur)
import Element.Input as Input
import Element.Keyed as Keyed
import Types exposing (..)
import Types.GridState exposing (..)
import View.StyleSheet exposing (..)
import View.Helper exposing (..)
import Rocket exposing ((=>))
import Keyboard.Event exposing (considerKeyboardEvent)
import Keyboard.Key exposing (Key(..))


view : Model -> Element Styles variation Msg
view { gridState, editMode, selectedCellId, selectedGridArea } =
    case editMode of
        PanesMode ->
            Keyed.namedGrid None
                []
                { columns = List.map (.length >> cellLengthToLength) gridState.columns
                , rows = namedRowsInPanes gridState.rows gridState.cells
                , cells =
                    cellsToPanes editMode gridState.cells
                        |> List.map
                            (\pane ->
                                Keyed.named pane.gridArea <|
                                    paneView
                                        (selectedGridArea
                                            |> Maybe.map (\name -> name == pane.gridArea)
                                            |> Maybe.withDefault False
                                        )
                                        pane
                            )
                }

        CellsMode ->
            Keyed.namedGrid None
                []
                { columns = List.map (.length >> cellLengthToLength) gridState.columns
                , rows = namedRowsInCells gridState.rows gridState.cells
                , cells =
                    gridState.cells
                        |> List.concat
                        |> List.map
                            (\cell ->
                                Keyed.named ("g" ++ toString cell.id) <|
                                    cellView
                                        (selectedCellId
                                            |> Maybe.map (\id -> id == cell.id)
                                            |> Maybe.withDefault False
                                        )
                                        cell
                            )
                }

        OutputMode ->
            Debug.crash "Bug? ErrCode 0001"


namedRowsInPanes : List ScaleUnit -> List (List Cell) -> List ( Length, List NamedGridPosition )
namedRowsInPanes units cellsList =
    List.map2
        (\{ length } cells ->
            cellLengthToLength length => List.map (\cell -> span 1 cell.gridArea) cells
        )
        units
        cellsList


namedRowsInCells : List ScaleUnit -> List (List Cell) -> List ( Length, List NamedGridPosition )
namedRowsInCells units cellsList =
    List.map2
        (\{ length } cells ->
            cellLengthToLength length => List.map (\cell -> span 1 <| "g" ++ toString cell.id) cells
        )
        units
        cellsList


paneView : Bool -> Pane -> Element Styles variation Msg
paneView selected { id, gridArea, cells } =
    wrappedColumn PaneStyle
        [ center
        , verticalCenter
        , spacing 5
        , padding 3
        ]
        [ if selected then
            Input.text NameInputStyle
                [ paddingXY 0 5
                , Attrs.id "target-pane"
                , onBlur UnSelectPane
                , on "keydown" <|
                    considerKeyboardEvent
                        (\event ->
                            if event.keyCode == Enter then
                                List.head cells
                                    |> Maybe.map .input
                                    |> Maybe.withDefault ""
                                    |> EnterPaneInput
                                    |> Just
                            else
                                Nothing
                        )
                ]
                { onChange = InputSelectedPane
                , value =
                    List.head cells
                        |> Maybe.map .input
                        |> Maybe.withDefault "ErrCode 0002"
                , label = Input.hiddenLabel ""
                , options = []
                }
          else
            el None [ onClick <| SelectPane gridArea ] <| text gridArea
        , when (List.length cells > 1)
            (simpleButton ButtonStyle [ onClick <| BreakPane gridArea ] <| text "unchain")
        ]


cellView : Bool -> Cell -> Element Styles variation Msg
cellView selected { id, gridArea, input } =
    column PaneStyle
        [ center
        , verticalCenter
        , spacing 5
        , padding 3
        ]
        [ if selected then
            Input.text NameInputStyle
                [ paddingXY 0 5
                , Attrs.id "target-cell"
                , onBlur UnSelectCell
                , on "keydown" <|
                    considerKeyboardEvent
                        (\event ->
                            if event.keyCode == Enter then
                                Just <| EnterCellInput input
                            else
                                Nothing
                        )
                ]
                { onChange = InputSelectedCell
                , value = input
                , label = Input.hiddenLabel ""
                , options = []
                }
          else
            el None [ onClick <| SelectCell id ] <| text gridArea
        ]
