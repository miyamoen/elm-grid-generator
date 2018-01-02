module View exposing (view)

import Html exposing (Html, dl, dd, dt)
import Element exposing (..)
import Element.Input as Input
import Element.Attributes as Attrs exposing (..)
import Element.Events exposing (on, onWithOptions, onClick)
import Types exposing (..)
import Types.GridState exposing (..)
import View.StyleSheet exposing (..)
import View.Helper exposing (..)
import View.Menu
import View.GridEditor
import View.Output
import Keyboard.Event exposing (considerKeyboardEvent)
import Keyboard.Key as Key
import Json.Decode as Json
import Rocket exposing ((=>))


view : Model -> Html Msg
view model =
    Element.viewport styleSheet <|
        appGrid model


appGrid : Model -> Element Styles Variations Msg
appGrid model =
    namedGrid MainStyle
        [ width Attrs.fill
        , height Attrs.fill
        , Attrs.id "outermost"
        , attribute "tabindex" "0"
        , onWithOptions "keydown" { stopPropagation = False, preventDefault = True } <|
            considerKeyboardEvent
                (\{ ctrlKey, shiftKey, keyCode } ->
                    case ( keyCode, ctrlKey, shiftKey ) of
                        ( Key.One, True, False ) ->
                            Just <| SwitchEditMode PanesMode

                        ( Key.Two, True, False ) ->
                            Just <| SwitchEditMode CellsMode

                        ( Key.Three, True, False ) ->
                            Just <| SwitchEditMode OutputMode

                        ( Key.Left, False, True ) ->
                            Just RemoveColumn

                        ( Key.Right, False, True ) ->
                            Just AddColumn

                        ( Key.Up, False, True ) ->
                            Just RemoveRow

                        ( Key.Down, False, True ) ->
                            Just AddRow

                        _ ->
                            Nothing
                )
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


editor : Model -> Element Styles Variations Msg
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


columnInputs : Model -> Element Styles Variations Msg
columnInputs { gridState } =
    grid None
        []
        { columns = List.map (.length >> cellLengthToLength) gridState.columns
        , rows = [ Attrs.fill ]
        , cells =
            gridState.columns
                |> List.indexedMap
                    (\idx unit ->
                        cell
                            { start = ( idx, 0 )
                            , width = 1
                            , height = 1
                            , content =
                                row None
                                    [ verticalCenter, padding 1 ]
                                    [ Input.text InputStyle
                                        [ padding 2
                                        , vary HasError <| scaleUnitHasError unit
                                        ]
                                        { onChange = InputColumn idx
                                        , value = unit.input
                                        , label = inputLabel
                                        , options = []
                                        }
                                    ]
                            }
                    )
        }


rowInputs : Model -> Element Styles Variations Msg
rowInputs { gridState } =
    grid None
        []
        { columns = [ Attrs.fill ]
        , rows = List.map (.length >> cellLengthToLength) gridState.rows
        , cells =
            gridState.rows
                |> List.indexedMap
                    (\idx unit ->
                        cell
                            { start = ( 0, idx )
                            , width = 1
                            , height = 1
                            , content =
                                row None
                                    [ alignTop, padding 1 ]
                                    [ Input.text InputStyle
                                        [ padding 2
                                        , vary HasError <| scaleUnitHasError unit
                                        ]
                                        { onChange = InputRow idx
                                        , value = unit.input
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
