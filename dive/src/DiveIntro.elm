module DiveIntro exposing (..)

import Color exposing (Color, black)
import List.Extra
import Dive.Model exposing (..)
import Dive.Transform as Transform
import Parts.PartIntro as PartIntro
import Parts.PartModel as PartModel
import Parts.PartView as PartView
import Parts.PartUpdate as PartUpdate
import Parts.PartArch as PartArch

world =
  (Transform.transformWorld (Position 0 0) (Size 1000 1000) PartIntro.world)
  ++ 
  (Transform.transformWorld archPosition archSize PartArch.world)
  ++
  (Transform.transformWorld (Position 0 0) (Size 10 10) PartModel.world)
  ++
  (Transform.transformWorld viewPosition viewSize PartView.world)
  ++
  (Transform.transformWorld updatePosition updateSize PartUpdate.world)

archPosition = 
  Position 0 200

archSize = 
  Size 10 10

updatePosition =
  Position 50 40 

updateSize =
  Size 2 2

viewPosition =
  Position 100 -250

viewSize =
  Size 10 10

modelFrames =
  List.map (Transform.transformFrame (Position 0 0) (Size 10 10)) PartModel.frames

updateFrames =
  List.map (Transform.transformFrame updatePosition updateSize) PartUpdate.frames

viewFrames =
  List.map (Transform.transformFrame viewPosition viewSize) PartView.frames

archFrames =
  List.map (Transform.transformFrame archPosition archSize) PartArch.frames

contactPosition =
  Position -3000 -3000

contactFrame =
  Frame contactPosition (Size 1669 1252) 0

modelFrame =
  Frame (Position 0 0) (Size 10 10) 1000

introFrame =
  Frame (Position 0 0) (Size 3000 3000)

middle pos1 pos2 =
  Position
    ((pos1.x + pos2.x) / 2)
    ((pos1.y + pos2.y) / 2)

frames = 
  Frames
    []
    ( archFrames
      ++
      modelFrames
      ++
      [ modelFrame
      ]
      ++
      viewFrames
      ++
      [ Frame (middle viewPosition updatePosition) (Size 500 500) 1000
      ]
      ++
      updateFrames
      ++
      archFrames
      ++ 
      [ introFrame 1000
      ]
    )
    <| introFrame 0

moveTo (cx, cy) list =
  List.map 
    (\(x,y) ->
      (x + cx, y + cy)
    )
    list
