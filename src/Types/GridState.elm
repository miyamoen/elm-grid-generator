module Types.GridState exposing (cellsToPanes, getMinBlankIds)

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
            List.concat cellsList
                |> List.map
                    (\cell ->
                        { id = toString cell.id
                        , gridArea = cell.gridArea
                        , cells = [ cell ]
                        }
                    )

        OutputMode ->
            Debug.crash "cellsToPanes is not called in OutputMode. ErrCode 0000"


getMinBlankIds : Int -> GridState -> List Int
getMinBlankIds count { cells } =
    cells
        |> List.concat
        |> List.map .id
        |> (\ids ->
                getMinBlankIds_
                    { olds = ids
                    , next = 0
                    , news = []
                    , count = count
                    }
           )


getMinBlankIds_ : { olds : List Int, news : List Int, next : Int, count : Int } -> List Int
getMinBlankIds_ ({ olds, news, next, count } as acc) =
    if count == 0 then
        List.reverse news
    else if List.member next olds then
        getMinBlankIds_ { acc | next = next + 1 }
    else
        getMinBlankIds_ { acc | next = next + 1, news = next :: news, count = count - 1 }
