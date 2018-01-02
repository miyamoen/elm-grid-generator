module Main exposing (..)

import Html
import Dom
import Task
import View exposing (view)
import Types exposing (..)
import Types.GridState as GridState
import Types.Accessor as Accessor
import Types.Presets.Simple as Simple
import Types.Presets.HolyGrail as HolyGrail
import Monocle.Lens as Lens exposing (Lens)
import Keyboard.Event
import Keyboard.Key as Key
import Rocket exposing (..)
import Dom


---- MODEL ----


init : ( Model, List (Cmd Msg) )
init =
    { editMode = CellsMode
    , gridState = HolyGrail.model
    , selectedCellId = Nothing
    , selectedGridArea = Nothing
    }
        => [ focusDom ]


focusDom : Cmd Msg
focusDom =
    Dom.focus "outermost" |> Task.attempt (always NoOp)



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

        SwitchEditMode mode ->
            { model | editMode = mode } => []

        AddColumn ->
            Lens.modify Accessor.gridState
                (\grid ->
                    { grid
                        | columns = grid.columns ++ [ ScaleUnit (Frame 1) "1fr" ]
                        , cells =
                            List.map2
                                (\rowCells id ->
                                    List.append rowCells
                                        [ { id = id
                                          , gridArea = "g" ++ toString id
                                          , input = "g" ++ toString id
                                          }
                                        ]
                                )
                                grid.cells
                                (GridState.getMinBlankIds (List.length grid.cells) grid)
                    }
                )
                model
                => []

        RemoveColumn ->
            Lens.modify Accessor.gridState
                (\grid ->
                    let
                        columnCount =
                            List.length grid.columns
                    in
                        if columnCount > 1 then
                            { grid
                                | columns = List.take (columnCount - 1) grid.columns
                                , cells =
                                    List.map
                                        (\rowCells ->
                                            List.take (columnCount - 1) rowCells
                                        )
                                        grid.cells
                            }
                        else
                            grid
                )
                model
                => []

        AddRow ->
            Lens.modify Accessor.gridState
                (\grid ->
                    { grid
                        | rows = grid.rows ++ [ ScaleUnit (Frame 1) "1fr" ]
                        , cells =
                            grid.cells
                                ++ [ List.map
                                        (\id ->
                                            { id = id
                                            , gridArea = "g" ++ toString id
                                            , input = "g" ++ toString id
                                            }
                                        )
                                        (GridState.getMinBlankIds (List.length grid.columns) grid)
                                   ]
                    }
                )
                model
                => []

        RemoveRow ->
            Lens.modify Accessor.gridState
                (\grid ->
                    let
                        rowCount =
                            List.length grid.rows
                    in
                        if rowCount > 1 then
                            { grid
                                | rows = List.take (rowCount - 1) grid.rows
                                , cells = List.take (rowCount - 1) grid.cells
                            }
                        else
                            grid
                )
                model
                => []

        InputColumn targetIdx str ->
            Lens.modify Accessor.gridState
                (\grid ->
                    { grid
                        | columns =
                            List.indexedMap
                                (\idx unit ->
                                    if targetIdx == idx then
                                        { unit
                                            | input = str
                                            , length =
                                                GridState.convertToCellLength str
                                                    |> Maybe.withDefault unit.length
                                        }
                                    else
                                        unit
                                )
                                grid.columns
                    }
                )
                model
                => []

        InputRow targetIdx str ->
            Lens.modify Accessor.gridState
                (\grid ->
                    { grid
                        | rows =
                            List.indexedMap
                                (\idx unit ->
                                    if targetIdx == idx then
                                        { unit
                                            | input = str
                                            , length =
                                                GridState.convertToCellLength str
                                                    |> Maybe.withDefault unit.length
                                        }
                                    else
                                        unit
                                )
                                grid.rows
                    }
                )
                model
                => []

        BreakPane targetArea ->
            Lens.modify Accessor.gridState
                (\grid ->
                    { grid
                        | cells =
                            listListMap
                                (\cell ->
                                    if cell.gridArea == targetArea then
                                        { cell
                                            | gridArea = "g" ++ toString cell.id
                                            , input = "g" ++ toString cell.id
                                        }
                                    else
                                        cell
                                )
                                grid.cells
                    }
                )
                model
                => []

        SelectCell id ->
            { model | selectedCellId = Just id }
                => [ Dom.focus "target-cell"
                        |> Task.attempt (always NoOp)
                   ]

        SelectPane areaName ->
            { model | selectedGridArea = Just areaName }
                => [ Dom.focus "target-pane"
                        |> Task.attempt (always NoOp)
                   ]

        UnSelectCell ->
            case model.selectedCellId of
                Just targetId ->
                    Lens.modify Accessor.gridState
                        (\grid ->
                            { grid
                                | cells =
                                    listListMap
                                        (\cell ->
                                            if cell.id == targetId then
                                                { cell | input = cell.gridArea }
                                            else
                                                cell
                                        )
                                        grid.cells
                            }
                        )
                        { model | selectedCellId = Nothing }
                        => [ focusDom ]

                Nothing ->
                    model => []

        UnSelectPane ->
            case model.selectedGridArea of
                Just targetName ->
                    Lens.modify Accessor.gridState
                        (\grid ->
                            { grid
                                | cells =
                                    listListMap
                                        (\cell ->
                                            if cell.gridArea == targetName then
                                                { cell | input = cell.gridArea }
                                            else
                                                cell
                                        )
                                        grid.cells
                            }
                        )
                        { model | selectedGridArea = Nothing }
                        => [ focusDom ]

                Nothing ->
                    model => []

        InputSelectedCell str ->
            case model.selectedCellId of
                Just targetId ->
                    Lens.modify Accessor.gridState
                        (\grid ->
                            { grid
                                | cells =
                                    listListMap
                                        (\cell ->
                                            if cell.id == targetId then
                                                { cell | input = str }
                                            else
                                                cell
                                        )
                                        grid.cells
                            }
                        )
                        model
                        => []

                Nothing ->
                    model => []

        InputSelectedPane str ->
            case model.selectedGridArea of
                Just targetName ->
                    Lens.modify Accessor.gridState
                        (\grid ->
                            { grid
                                | cells =
                                    listListMap
                                        (\cell ->
                                            if cell.gridArea == targetName then
                                                { cell | input = str }
                                            else
                                                cell
                                        )
                                        grid.cells
                            }
                        )
                        model
                        => []

                Nothing ->
                    model => []

        EnterCellInput input ->
            case ( input, model.selectedCellId ) of
                ( "", _ ) ->
                    model => []

                ( _, Just targetId ) ->
                    Lens.modify Accessor.gridState
                        (\grid ->
                            { grid
                                | cells =
                                    listListMap
                                        (\cell ->
                                            if cell.id == targetId then
                                                { cell | gridArea = cell.input }
                                            else
                                                cell
                                        )
                                        grid.cells
                            }
                        )
                        { model | selectedCellId = Nothing }
                        => []

                ( _, Nothing ) ->
                    model => []

        EnterPaneInput input ->
            case ( input, model.selectedGridArea ) of
                ( "", _ ) ->
                    model => []

                ( _, Just targetName ) ->
                    Lens.modify Accessor.gridState
                        (\grid ->
                            { grid
                                | cells =
                                    listListMap
                                        (\cell ->
                                            if cell.gridArea == targetName then
                                                { cell | gridArea = cell.input }
                                            else
                                                cell
                                        )
                                        grid.cells
                            }
                        )
                        { model | selectedCellId = Nothing }
                        => []

                ( _, Nothing ) ->
                    model => []


listGetAt : Int -> List a -> Maybe a
listGetAt idx xs =
    if idx < 0 then
        Nothing
    else
        List.head <| List.drop idx xs


listListMap : (a -> b) -> List (List a) -> List (List b)
listListMap tagger listList =
    List.map (\list -> List.map tagger list) listList



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init |> batchInit
        , update = update >> batchUpdate
        , subscriptions = always Sub.none
        }
