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
