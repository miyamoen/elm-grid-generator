module View.Helper exposing (..)

import Element exposing (..)
import Element.Attributes as Attrs exposing (..)
import Types exposing (..)
import Rocket exposing ((=>))


simpleButton : style -> List (Attribute variation msg) -> Element style variation msg -> Element style variation msg
simpleButton style attrs elm =
    node "button" <| el style attrs elm


cellLengthToLength : CellLength -> Length
cellLengthToLength length =
    case length of
        Px num ->
            px num

        Percent num ->
            percent num

        Frame num ->
            fillPortion num
