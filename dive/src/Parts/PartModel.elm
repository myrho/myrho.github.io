module Parts.PartModel exposing (world, frames)

import Dive.Model exposing (..)
import Dive.Transform exposing (transformWorld)
import Color exposing (black, white, red, blue)
import Collage exposing (defaultLine)
import Params

border =
  { defaultLine
    | width = 0.01
    , color = black
  }

pathArm = 
  [ (0.15, 0.35)
  , (0.5, 0.35)
  , (0.5, 0.1)
  ]

boxWidth =
  0.3

lineHeight =
  1.3

box =
  Rectangle << RectangleObject border white (Size boxWidth 0.2)

modelBox =
  [ box
    <| Position 0 0.35
  , Text
    <| TextObject "Model" black Params.font 0.05 Center lineHeight
    <| Position 0 0.4
  ]
  ++
  ( transformWorld helloWorldPosition helloWorldSize
    <| helloWorld ++ frameFrameHelloWorld
  )
  ++
  (transformWorld (Position -0.008 0.28) (Size 0.0001 0.0001) helloWordText)
 
helloWorldPosition = 
  Position 0 0.32

helloWorldSize =
  Size (1/750) (1/750)

helloWorld =
  [ Text
    <| TextObject "Hello\nW rld" blue "serif" 20 Center 1.5
    <| Position 0 0
  , Image
    <| ImageObject "talks/world.png" 10 10 
    <| Position -5 -30
  ]

transparent =
  Color.rgba 0 0 0 0

frameFrameBorder =
  { defaultLine 
    | color = red
    , width = 0.003
  }

frameFrameHelloWorld =
  [ Rectangle
    <| RectangleObject frameFrameBorder transparent (Size 90 60)
    <| Position 0 -10
  , Text
    <| TextObject "1" red "monospace" 3 Center 1
    <| Position -43 17
  , Rectangle
    <| RectangleObject frameFrameBorder transparent (Size 70 30)
    <| Position 0 3
  , Text
    <| TextObject "2" red "monospace" 3 Center 1
    <| Position -33 15
  , Rectangle
    <| RectangleObject frameFrameBorder transparent (Size 15 15)
    <| Position -5 -30
  , Text
    <| TextObject "3" red "monospace" 3 Center 1
    <| Position -11 -25
  ]

helloWorldFrames =
  [ Frame (Position 0 -10) (Size 90 60) 1000
  , Frame (Position 0 3) (Size 70 30) 500
  , Frame (Position -5 -30) (Size 15 15) 800
  ]

helloWorldCode = """
world =
  [ Text
      { text = "Hello\\nW rld"
      , color = blue
      , font = "serif"
      , size = 20
      , align = Center
      , lineHeight = 1.5
      , position = Position 0 0
      }
  , Image
      { src = "world.png" 
      , width = 10 
      , height = 10 
      , position = Position -5 -30
      }
  ]
"""

helloWorldframesCode_ = """
frames =
  [ { position = {x = 0, y = -10}
    , size = {width = 90, height = 60}
    , duration = 1000
    }
  , { position = {x = 0, y = 3}
    , size = {width = 70, height = 30}
    , duration = 500
    }
  , { position = {x = -8, y = -30}
    , size = {width = 15, height = 15}
    , duration = 800
    }
  ]
"""

helloWorldframesCode = """
  [ Frame 
      (Position 0 -10) 
      (Size 90 60) 
      1000
  , Frame 
      (Position 0 3) 
      (Size 70 30) 
      500
  , Frame 
      (Position -8 -30) 
      (Size 15 15) 
      800
  ]
"""

helloWordText =
  [ Text
    <| TextObject helloWorldCode blue Params.fontCode 1 Left lineHeight
    <| Position -18 12
  , Text
    <| TextObject helloWorldframesCode blue Params.fontCode 1 Left lineHeight
    <| Position -3 -12
  ]

viewport =
  Text
    <| TextObject "viewport: Size" black Params.fontCode 0.02 Center lineHeight
    <| Position 0 0.34

objectBox x y =
  [ box 
    <| Position x y
  , Text
    <| TextObject "Object" black Params.font 0.05 Center lineHeight
    <| Position x y
  ]

animationBox x y =
  [ box 
    <| Position x y
  , Text
    <| TextObject "Animation" black Params.font 0.05 Center lineHeight
    <| Position x (y+0.05)
  , Text
    <| TextObject "passed: Float" black Params.fontCode 0.02 Left lineHeight
    <| Position (x-0.12) (y-0.01)
  ]

framesBox =
  [ box 
    <| Position 0 0
  , Text
    <| TextObject "Frames" black Params.font 0.05 Center lineHeight
    <| Position 0 0
  ]

frameBox x y =
  [ box 
    <| Position x y
  , Text
    <| TextObject "Frame" black Params.font 0.05 Center lineHeight
    <| Position (x) (y + 0.05)
  , Text
    <| TextObject "position: Position" black Params.fontCode 0.02 Left lineHeight
    <| Position (x-0.12) (y - 0.01)
  , Text
    <| TextObject "size: Size" black Params.fontCode 0.02 Left lineHeight
    <| Position (x-0.12) (y - 0.04)
  , Text
    <| TextObject "duration: Int" black Params.fontCode 0.02 Left lineHeight
    <| Position (x-0.12) (y - 0.07)
  ]

rightArm x =
  [ Path
    <| PathObject border
    <| pathArm
  , Text
    <| TextObject "0/1" black Params.fontCode 0.02 Left lineHeight
    <| Position (x+0.01) 0.12
  , Text
    <| TextObject "animation" black Params.fontCode 0.02 Left lineHeight
    <| Position 0.16 0.37
  ]

leftArm =
  [ Path
    <| PathObject border
    <|[ (-0.15, 0.35)
      , (-0.35, 0.35)
      ]
  , Text
    <| TextObject "0..n" black Params.fontCode 0.02 Right lineHeight
    <| Position (-0.29) 0.37
  , Text
    <| TextObject "world" black Params.fontCode 0.02 Right lineHeight
    <| Position -0.16 0.37
  ]

middleArm =
  [ Path
    <| PathObject border
    <|[ (0, 0.25)
      , (0, 0.1)
      ]
  , Text
    <| TextObject "1" black Params.fontCode 0.02 Left lineHeight
    <| Position 0.01 0.12
  , Text
    <| TextObject "frames" black Params.fontCode 0.02 Left lineHeight
    <| Position 0.01 0.22
  ]

leftArm2 x y1 y2 =
  [ Path
    <| PathObject border
    <|[ (negate <| boxWidth/2, y1)
      , (negate x, y1)
      , (negate x, y2)
      , (negate <| boxWidth/2, y2)
      ]
  , Text
    <| TextObject "previous" black Params.fontCode 0.02 Right lineHeight
    <| Position (negate <| boxWidth/2 + 0.01) <| y1+0.02
  , Text
    <| TextObject "0..n" black Params.fontCode 0.02 Right lineHeight
    <| Position (negate <| boxWidth/2 + 0.01) <| y2+0.02
  ]

rightArm2 x y1 y2 =
  [ Path
    <| PathObject border
    <|[ (boxWidth/2, y1)
      , (x, y1)
      , (x, y2)
      , (boxWidth/2, y2)
      ]
  , Text
    <| TextObject "following" black Params.fontCode 0.02 Left lineHeight
    <| Position (boxWidth/2 + 0.01) <| y1+0.02
  , Text
    <| TextObject "0..n" black Params.fontCode 0.02 Left lineHeight
    <| Position (boxWidth/2 + 0.01) <| y2+0.02
  ]

middleArm2 =
  [ Path
    <| PathObject border
    <|[ (0, -0.25)
      , (0, -0.1)
      ]
  , Text
    <| TextObject "1" black Params.fontCode 0.02 Left lineHeight
    <| Position 0.01 -0.22
  , Text
    <| TextObject "current" black Params.fontCode 0.02 Left lineHeight
    <| Position 0.01 -0.12
  ]

animationArm =
  [ Path
    <| PathObject border
    <|[ (0.15, -0.4)
      , (0.5, -0.4)
      , (0.5, -0.1)
      ]
  , Text
    <| TextObject "target" black Params.fontCode 0.02 Left lineHeight
    <| Position (0.51) -0.12
  , Text
    <| TextObject "1" black Params.fontCode 0.02 Left lineHeight
    <| Position 0.16 -0.42
  ]

modelCode = """
type alias Model =
  { world : List Object
  , frames : Frames
  , animation :
      Maybe Animation
  , viewport : Size 
  }
"""

modelText =
  [ Text
    <| TextObject modelCode white Params.fontCode 0.07 Left lineHeight
    <| Position 0 0
  ]

modelText_ =
  [ Text
    <| TextObject "type alias Model =" white Params.fontCode 0.07 Left lineHeight
    <| Position 0 0
  , Text
    <| TextObject "{ viewport : Size" white Params.fontCode 0.07 Left lineHeight
    <| Position 0.08 -0.1
  , Text
    <| TextObject ", world : List Object" white Params.fontCode 0.07 Left lineHeight
    <| Position 0.1 -0.2
  , Text
    <| TextObject ", frames : Frames" white Params.fontCode 0.07 Left lineHeight
    <| Position 0.1 -0.3
  , Text
    <| TextObject ", animation : " white Params.fontCode 0.07 Left lineHeight
    <| Position 0.1 -0.4
  , Text
    <| TextObject "Maybe Animation" white Params.fontCode 0.07 Left lineHeight
    <| Position 0.3 -0.5
  , Text
    <| TextObject "}" white Params.fontCode 0.07 Left lineHeight
    <| Position 0.09 -0.6
  ]

sizeText =
  [ Text
    <| TextObject "type alias Size =" black Params.fontCode 0.07 Left lineHeight
    <| Position 0 0
  , Text
    <| TextObject "{ width : Float" black Params.fontCode 0.07 Left lineHeight
    <| Position 0.08 -0.1
  , Text
    <| TextObject ", height : Float" black Params.fontCode 0.07 Left lineHeight
    <| Position 0.1 -0.2
  , Text
    <| TextObject "}" black Params.fontCode 0.07 Left lineHeight
    <| Position 0.1 -0.3
  ]

world =
  modelBox
  ++
  (objectBox -0.5 0.35)
  ++
  (animationBox 0.5 0)
  ++
  framesBox
  ++
  (frameBox 0 -0.35)
  ++
  (rightArm 0.5)
  ++
  leftArm
  ++
  middleArm
  ++
  (leftArm2 0.3 0 -0.35)
  ++
  (rightArm2 0.3 0 -0.35)
  ++
  middleArm2
  ++
  animationArm
  ++
  (transformWorld (Position -0.05 0.3928) (Size 0.005 0.005) modelText)
  ++
  (transformWorld (Position -0.046824 0.39166) (Size 0.00004 0.00004) sizeText)

helloWorldExplained = 
  [ Frame (Position -0.0082 0.28) (Size 0.002 0.0025) 1000
  , Frame (Position -0.007 0.2779) (Size 0.002 0.002) 1000
  ]

modelCodeFrame =
  [ Frame (Position -0.0469 0.391) (Size 0.005 0.005) 1000
  ]

objectsFrame =
  [ Frame (Position -0.2 0.35) (Size 0.95 0.3) 1000
  ]

framesFrame =
  [ Frame (Position 0 -0.15) (Size 0.5 0.65) 1000
  ]

modelFrame =
  [ Frame (Position 0 0.325) (Size 0.3 0.4) 1000
  ]

animationFrame =
  [ Frame (Position 0.2 -0.15) (Size 0.7 0.7) 1000
  ]

wholeModelFrame =
  [ Frame (Position 0 0) (Size 1 1) 1000
  ]

frames =
  --, Frame (Position -0.0468 0.39166) (Size 0.00005 0.00005) 500
  modelFrame
  ++
  ( List.map (Dive.Transform.transformFrame helloWorldPosition helloWorldSize) helloWorldFrames
  )
  ++
  helloWorldExplained
  ++
  objectsFrame
  ++
  wholeModelFrame
  ++
  framesFrame
  ++
  animationFrame
  ++
  wholeModelFrame
  ++
  modelCodeFrame
