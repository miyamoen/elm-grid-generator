module Types.Presets.HolyGrail exposing (model)

import Types exposing (..)


model : GridState
model =
    { columns = [ ScaleUnit (Px 120) "120px", ScaleUnit (Frame 4) "4fr", ScaleUnit (Frame 1) "1fr" ]
    , rows =
        [ ScaleUnit (Px 60) "60px"
        , ScaleUnit (Frame 1) "1fr"
        , ScaleUnit (Px 40) "40px"
        ]
    , cells =
        [ [ { id = 0
            , gridArea = "header"
            , input = "header"
            }
          , { id = 3
            , gridArea = "header"
            , input = "header"
            }
          , { id = 6
            , gridArea = "header"
            , input = "header"
            }
          ]
        , [ { id = 1
            , gridArea = "left"
            , input = "left"
            }
          , { id = 4
            , gridArea = "content"
            , input = "content"
            }
          , { id = 7
            , gridArea = "right"
            , input = "right"
            }
          ]
        , [ { id = 2
            , gridArea = "footer"
            , input = "footer"
            }
          , { id = 5
            , gridArea = "footer"
            , input = "footer"
            }
          , { id = 8
            , gridArea = "footer"
            , input = "footer"
            }
          ]
        ]
    }
