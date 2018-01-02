module Types.GridState
    exposing
        ( cellsToPanes
        , getMinBlankIds
        , convertToCellLength
        , scaleUnitHasError
        , toCss
        )

import Types exposing (..)
import Set
import Mustache


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


convertToCellLength : String -> Maybe CellLength
convertToCellLength str =
    if String.endsWith "px" str then
        String.dropRight 2 str
            |> String.toFloat
            |> Result.toMaybe
            |> Maybe.map Px
    else if String.endsWith "fr" str then
        String.dropRight 2 str
            |> String.toInt
            |> Result.toMaybe
            |> Maybe.map Frame
    else if String.endsWith "%" str then
        String.dropRight 1 str
            |> String.toFloat
            |> Result.toMaybe
            |> Maybe.map Percent
    else
        Nothing


scaleUnitHasError : ScaleUnit -> Bool
scaleUnitHasError { input } =
    convertToCellLength input
        |> Maybe.map (\_ -> False)
        |> Maybe.withDefault True


toCss : GridState -> String
toCss { cells, rows, columns } =
    Mustache.render
        [ List.map (.length >> cellLengthToCss) columns
            |> String.join " "
            |> Mustache.Variable "columns"
        , List.map (.length >> cellLengthToCss) rows
            |> String.join " "
            |> Mustache.Variable "rows"
        , cells
            |> List.map
                (\list ->
                    list
                        |> List.map .gridArea
                        |> String.join " "
                        |> \str -> String.concat [ "'", str, "'" ]
                )
            |> String.join " "
            |> Mustache.Variable "areas"
        , cellsToPanes PanesMode cells
            |> List.map
                (\{ gridArea } ->
                    Mustache.render [ Mustache.Variable "gridArea" gridArea ] areaCssTemplate
                )
            |> String.concat
            |> Mustache.Variable "areaCss"
        , cellsToPanes PanesMode cells
            |> List.map
                (\{ gridArea } ->
                    Mustache.render [ Mustache.Variable "gridArea" gridArea ] areaHtmlTemplate
                )
            |> String.concat
            |> Mustache.Variable "areaHtml"
        ]
        cssTemplate


cssTemplate : String
cssTemplate =
    """// CSS
.container {
    width: 100%;
    height: 100%;
    display: grid;
    grid-template-columns: {{ columns }};
    grid-template-rows: {{ rows }};
    grid-template-areas: {{ areas }};
}

{{ areaCss }}
// HTML
<div class='container'>
{{ areaHtml }}</div>
"""


areaCssTemplate : String
areaCssTemplate =
    """.area-{{ gridArea }} {
    grid-area: {{ gridArea }};
}

"""


areaHtmlTemplate : String
areaHtmlTemplate =
    """  <div class='area-{{ gridArea }}'></div>
"""


cellLengthToCss : CellLength -> String
cellLengthToCss length =
    case length of
        Px num ->
            toString num ++ "px"

        Percent num ->
            toString num ++ "%"

        Frame num ->
            toString num ++ "fr"
