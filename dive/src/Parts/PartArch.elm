module Parts.PartArch exposing (world, frames)

import Dive.Model exposing (..)
import Dive.Transform exposing (transformWorld)
import Color exposing (black, white, red, blue)
import Collage exposing (defaultLine)
import Params

archCode ="""
main =
  Html.program
    { init = model
    , view = view
    , update = update
    , subscriptions = 
        subscriptions
    }
"""

archText = 
  [ Text
    <| TextObject archCode Color.darkRed Params.fontCode 1 Left 1.3
    <| Position -5 0
  ]

world =
  archText

archFrame =
  Frame (Position 3 -6) (Size 12 12) 1000

frames =
  [ archFrame
  ]
    
