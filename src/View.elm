module View exposing (view)

import Html exposing (Html, dl, dd, dt)
import Element exposing (..)
import Element.Attributes as Attrs exposing (..)
import Element.Events exposing (on, onClick)
import Types exposing (..)
import View.StyleSheet exposing (..)
import View.Menu
import View.GridEditor
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
            [ named "left" <| editor model
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
            [ named "addc" <| addButtons
            , named "addr" <| addButtons
            , named "edit" <| View.GridEditor.view model
            ]
        }


addButtons : Element Styles variation Msg
addButtons =
    row None
        []
        [ button None [] <| text "+"
        , button None [] <| text "-"
        ]
