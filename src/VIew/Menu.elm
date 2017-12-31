module View.Menu exposing (view)

import Html exposing (Html, dl, dd, dt)
import Element exposing (..)
import Element.Attributes as Attrs exposing (..)
import Element.Events exposing (on, onClick)
import Types exposing (..)
import View.StyleSheet exposing (..)
import Rocket exposing ((=>))


view : Model -> Element Styles variation Msg
view model =
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
                []
                [ text "[panes]"
                , button None [] <| text "cells"
                , button None [] <| text "output"
                ]
            ]
        , hairline HRStyle
        , column None
            [ spacing 5 ]
            [ text "Load preset"
            , row None
                []
                [ button None [ onClick <| SetPreset Simple ] <| text "Simple"
                , button None [ onClick <| SetPreset HolyGrail ] <| text "HolyGrail"
                ]
            ]
        , hairline HRStyle
        , column None
            [ spacing 5 ]
            [ h3 None [] <| text "Shortcut"
            , html <|
                dl []
                    [ dt [] [ Html.text "Ctrl-1" ]
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
