module View.Menu exposing (view)

import Html exposing (Html, dl, dd, dt)
import Element exposing (..)
import Element.Attributes as Attrs exposing (..)
import Element.Events exposing (on, onClick)
import Types exposing (..)
import View.StyleSheet exposing (..)
import View.Helper exposing (simpleButton)
import Rocket exposing ((=>))


view : Model -> Element Styles variation Msg
view { editMode } =
    column MenuStyle
        [ paddingXY 15 18, spacing 10 ]
        [ column None
            [ spacing 5 ]
            [ text "CSS Grid Editor"
            , link "https://github.com/miyamoen/elm-grid-generator" <| el LinkStyle [] (text "Github")
            ]
        , hairline HRStyle
        , column None
            [ spacing 5 ]
            [ text "EditMode"
            , row None
                [ spacing 5 ]
                [ if editMode == PanesMode then
                    text "[panes]"
                  else
                    simpleButton ButtonStyle [ onClick <| SwitchEditMode PanesMode ] <| text "panes"
                , if editMode == CellsMode then
                    text "[cells]"
                  else
                    simpleButton ButtonStyle [ onClick <| SwitchEditMode CellsMode ] <| text "cells"
                , if editMode == OutputMode then
                    text "[output]"
                  else
                    simpleButton ButtonStyle [ onClick <| SwitchEditMode OutputMode ] <| text "output"
                ]
            ]
        , hairline HRStyle
        , column None
            [ spacing 5 ]
            [ text "Save/Load Grid"
            , row None
                [ spacing 5 ]
                [ simpleButton ButtonStyle [ onClick <| SaveGridState ] <| text "Save"
                , simpleButton ButtonStyle [ onClick <| LoadGridState ] <| text "Load"
                ]
            ]
        , hairline HRStyle
        , column None
            [ spacing 5 ]
            [ text "Load preset"
            , row None
                [ spacing 5 ]
                [ simpleButton ButtonStyle [ onClick <| SetPreset Simple ] <| text "Simple"
                , simpleButton ButtonStyle [ onClick <| SetPreset HolyGrail ] <| text "HolyGrail"
                ]
            ]
        , hairline HRStyle
        , column None
            [ spacing 5 ]
            [ h3 None [] <| text "Shortcut"
            , html <|
                dl []
                    [ dt [] [ Html.text "Ctrl-S" ]
                    , dd [] [ Html.text "Save" ]
                    , dt [] [ Html.text "Ctrl-L" ]
                    , dd [] [ Html.text "Load" ]
                    , dt [] [ Html.text "Ctrl-1" ]
                    , dd [] [ Html.text "Pane Mode" ]
                    , dt [] [ Html.text "Ctrl-2" ]
                    , dd [] [ Html.text "Cell Mode" ]
                    , dt [] [ Html.text "Ctrl-3" ]
                    , dd [] [ Html.text "Output Mode" ]
                    , dt [] [ Html.text "Shift-Arrow" ]
                    , dd [] [ Html.text "Expand/Shrink" ]
                    ]
            ]
        ]
