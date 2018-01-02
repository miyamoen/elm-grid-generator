module View exposing (view)

import Html exposing (Html, dl, dd, dt)
import Element exposing (..)
import Element.Input as Input
import Element.Attributes as Attrs exposing (..)
import Element.Events exposing (on, onClick)
import Types exposing (..)
import View.StyleSheet exposing (..)
import View.Helper exposing (..)
import View.Menu
import View.GridEditor
import View.Output
import Rocket exposing ((=>))


view : Model -> Html Msg
view model =
    Element.viewport styleSheet <|
        appGrid model


appGrid : Model -> Element Styles variation Msg
appGrid model =
    namedGrid MainStyle
        [ width Attrs.fill
        , height Attrs.fill
        ]
        { columns = [ Attrs.fill, px 200 ]
        , rows = [ percent 100 => [ span 1 "left", span 1 "right" ] ]
        , cells =
            [ named "left" <|
                (case model.editMode of
                    PanesMode ->
                        editor model

                    CellsMode ->
                        editor model

                    OutputMode ->
                        View.Output.view model
                )
            , named "right" <| View.Menu.view model
            ]
        }


editor : Model -> Element Styles variation Msg
editor model =
    namedGrid None
        []
        { columns = [ px 60, Attrs.fill, px 50 ]
        , rows =
            [ px 30 => [ span 1 ".", span 1 "column", span 1 "addc" ]
            , Attrs.fill => [ span 1 "row", span 1 "edit", span 1 "." ]
            , px 30 => [ span 1 "addr", span 1 ".", span 1 "." ]
            ]
        , cells =
            [ named "addc" <| columnButtons
            , named "addr" <| rowButtons
            , named "edit" <| View.GridEditor.view model
            , named "column" <| columnInputs model
            , named "row" <| rowInputs model
            ]
        }


columnButtons : Element Styles variation Msg
columnButtons =
    row None
        [ padding 3, spacing 5, spread, clip ]
        [ simpleButton ButtonStyle [ width <| percent 50, onClick AddColumn ] <| text "+"
        , simpleButton ButtonStyle [ width <| percent 50, onClick RemoveColumn ] <| text "-"
        ]


rowButtons : Element Styles variation Msg
rowButtons =
    row None
        [ padding 3, spacing 5, spread, clip ]
        [ simpleButton ButtonStyle [ width <| percent 50, onClick AddRow ] <| text "+"
        , simpleButton ButtonStyle [ width <| percent 50, onClick RemoveRow ] <| text "-"
        ]


columnInputs : Model -> Element Styles variation Msg
columnInputs { gridState } =
    grid None
        []
        { columns = List.map cellLengthToLength gridState.columns
        , rows = [ Attrs.fill ]
        , cells =
            gridState.rawColumns
                |> List.indexedMap
                    (\idx rawString ->
                        cell
                            { start = ( idx, 0 )
                            , width = 1
                            , height = 1
                            , content =
                                row None
                                    [ verticalCenter, padding 1 ]
                                    [ Input.text InputStyle
                                        [ padding 2 ]
                                        { onChange = always NoOp
                                        , value = rawString
                                        , label = inputLabel
                                        , options = []
                                        }
                                    ]
                            }
                    )
        }


rowInputs : Model -> Element Styles variation Msg
rowInputs { gridState } =
    grid None
        []
        { columns = [ Attrs.fill ]
        , rows = List.map cellLengthToLength gridState.rows
        , cells =
            gridState.rawRows
                |> List.indexedMap
                    (\idx rawString ->
                        cell
                            { start = ( 0, idx )
                            , width = 1
                            , height = 1
                            , content =
                                row None
                                    [ alignTop, padding 1 ]
                                    [ Input.text InputStyle
                                        [ padding 2 ]
                                        { onChange = always NoOp
                                        , value = rawString
                                        , label = inputLabel
                                        , options = []
                                        }
                                    ]
                            }
                    )
        }


inputLabel =
    Input.placeholder
        { text = "100px, 5fr, 50%"
        , label = Input.hiddenLabel ""
        }
