module Types.Presets.HolyGrail exposing (model)

import Types exposing (..)


model : GridState
model =
    { columns = [ Px 120, Frame 4, Frame 1 ]
    , rawColumns = [ "120px", "4fr", "1fr" ]
    , rows =
        [ Px 60
        , Frame 1
        , Px 40
        ]
    , rawRows =
        [ "60px"
        , "1fr"
        , "40px"
        ]
    , rowCount = 3
    , columnCount = 3
    , selectedCell = Nothing
    , cells =
        [ [ { id = 0
            , gridArea = "header"
            }
          , { id = 3
            , gridArea = "header"
            }
          , { id = 6
            , gridArea = "header"
            }
          ]
        , [ { id = 1
            , gridArea = "left"
            }
          , { id = 4
            , gridArea = "content"
            }
          , { id = 7
            , gridArea = "right"
            }
          ]
        , [ { id = 2
            , gridArea = "footer"
            }
          , { id = 5
            , gridArea = "footer"
            }
          , { id = 8
            , gridArea = "footer"
            }
          ]
        ]
    }
