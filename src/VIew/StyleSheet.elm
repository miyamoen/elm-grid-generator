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
    | ButtonStyle
    | InputStyle
    | NameInputStyle
    | LinkStyle
    | HRStyle


type Variations
    = HasError


styleSheet : StyleSheet Styles Variations
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
        , style ButtonStyle
            [ Transition.all
            , Font.light
            , Font.center
            , Border.rounded 3
            , Shadow.drop { offset = ( 0, 2 ), blur = 2, color = rgba 0 0 0 0.29 }
            , pseudo "active"
                [ Shadow.inset { offset = ( 0, 0 ), blur = 2, size = 0, color = rgba 128 128 128 0.1 }
                , translate 0 2 0
                ]
            ]
        , style InputStyle
            [ Shadow.innerGlow (rgba 0 0 0 0.3) 0.5
            , variation HasError
                [ Color.background <| rgba 255 170 170 0.8
                ]
            ]
        , style NameInputStyle
            [ Shadow.innerGlow (rgba 0 0 0 0.3) 0.5
            , Font.center
            ]
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
