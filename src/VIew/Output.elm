module View.Output exposing (view)

import Html exposing (Html, pre)
import Element exposing (..)
import Element.Attributes as Attrs exposing (..)
import Element.Events exposing (on, onClick)
import Types exposing (..)
import Types.GridState exposing (toCss)
import View.StyleSheet exposing (..)
import Rocket exposing ((=>))


view : Model -> Element Styles variation Msg
view { gridState } =
    column None
        [ paddingXY 10 12, spacing 5, scrollbars ]
        [ h3 None [] <| text "OutputMode"
        , el None [] <| html <| pre [] [ Html.text <| toCss gridState ]
        ]
