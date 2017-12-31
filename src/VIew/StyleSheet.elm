module View.StyleSheet exposing (..)

import Style exposing (..)
import Style.Font as Font
import Style.Color as Color
import Style.Shadow as Shadow
import Style.Border as Border
import Style.Transition as Transition exposing (Transition)
import Color exposing (Color, rgba)


type Styles
    = None
    | MainStyle
    | MenuStyle
    | PaneStyle
    | LinkStyle
    | HRStyle


styleSheet : StyleSheet Styles variation
styleSheet =
    Style.styleSheet
        [ style None []
        , style MainStyle
            [ Font.typeface [ Font.font "Meiryo" ]
            , Font.alignLeft
            ]
        , style MenuStyle
            [ Color.background <| rgba 68 68 68 1
            , Color.text <| rgba 221 221 221 1
            ]
        , style PaneStyle
            [ prop "outline" "black dashed 1px" ]
        , style LinkStyle
            [ Color.text <| rgba 119 170 255 1
            , Font.underline
            ]
        , style HRStyle
            [ Border.all 1
            , prop "border-style" "inset"
            ]
        ]


kari : Property class variation
kari =
    Transition.transitions
        [ { delay = 0
          , duration = 1000
          , easing = "ease"
          , props = [ "grid-template-columns", "grid-template-rows" ]
          }
        ]
