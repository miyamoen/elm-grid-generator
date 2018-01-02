module Main exposing (..)

import Html
import View exposing (view)
import Types exposing (..)
import Types.GridState as GridState
import Types.Accessor as Accessor
import Types.Presets.Simple as Simple
import Types.Presets.HolyGrail as HolyGrail
import Monocle.Lens as Lens exposing (Lens)
import Rocket exposing (..)


---- MODEL ----


init : ( Model, List (Cmd Msg) )
init =
    { editMode = CellsMode
    , gridState = HolyGrail.model
    }
        => []



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
                        | columns = grid.columns ++ [ Frame 1 ]
                        , rawColumns = grid.rawColumns ++ [ "1fr" ]
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
                                , rawColumns = List.take (columnCount - 1) grid.rawColumns
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
                        | rows = grid.rows ++ [ Frame 1 ]
                        , rawRows = grid.rawRows ++ [ "1fr" ]
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
                                , rawRows = List.take (rowCount - 1) grid.rawRows
                                , cells =
                                    List.take (rowCount - 1) grid.cells
                            }
                        else
                            grid
                )
                model
                => []



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init |> batchInit
        , update = update >> batchUpdate
        , subscriptions = always Sub.none
        }
