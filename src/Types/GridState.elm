module Types.GridState exposing (..)

import Types exposing (..)
import Set


cellsToPanes : EditMode -> List (List Cell) -> List Pane
cellsToPanes mode cellsList =
    case mode of
        PanesMode ->
            List.concat cellsList
                |> List.map .gridArea
                |> Set.fromList
                |> Set.toList
                |> List.filter (\name -> name /= ".")
                |> List.map
                    (\name ->
                        let
                            includedCells =
                                List.concat cellsList
                                    |> List.filter (\cell -> cell.gridArea == name)
                        in
                            { id = name ++ (List.map (.id >> toString) includedCells |> String.join "-")
                            , cells = includedCells
                            , gridArea = name
                            }
                    )

        CellsMode ->
            Debug.crash "TODO"

        OutputMode ->
            Debug.crash "cellsToPanes is not called in OutputMode. ErrCode 0000"
