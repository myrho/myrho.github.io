module Parts.PartIntro exposing (world)

import Dive.Model exposing (..)
import Dive.Transform as T
import Params
import Color exposing (black)
import ElmLogo

world =
  (T.transformWorld (Position 0 0) (Size 0.9 0.9) ElmLogo.logo)
  ++
  [ Text
    <| TextObject "Dive" black Params.font 0.5 Center 1
    <| Position 0 0.9 
  , Text
    <| TextObject "Prezi-like Presentations\nin Elm" black Params.font 0.2 Center 1.2
    <| Position 0 -0.7 
  , Text
    <| TextObject "github.com/myrho/dive" black Params.font 0.1 Center 1.2
    <| Position 0 -1.2 
  ]

