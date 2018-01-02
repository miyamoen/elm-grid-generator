module View.Output exposing (view)

import Html exposing (Html, dl, dd, dt)
import Element exposing (..)
import Element.Attributes as Attrs exposing (..)
import Element.Events exposing (on, onClick)
import Types exposing (..)
import View.StyleSheet exposing (..)
import Rocket exposing ((=>))


view : Model -> Element Styles variation Msg
view model =
    text "TODO"
