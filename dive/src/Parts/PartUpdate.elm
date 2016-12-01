module Parts.PartUpdate exposing (world, frames)

import Dive.Model exposing (..)
import Dive.Transform exposing (transformWorld)
import Color exposing (black, white, red, blue)
import Collage exposing (defaultLine)
import Params

color =
  Color.black

msgCode ="""
type Msg =
  Resize Window.Size
  | Forth
  | Animate Time
"""

subDecl = "subscriptions : Model -"
subDecl2 = "> Sub Msg"

subCode ="""
subscriptions model =
  Sub.batch
    [ Window.resizes Resize
    , Mouse.clicks (always Forth)
    , animateSub model
    ]
"""

animateDecl = "animateSub : Model -"
animateDecl2 = "> Sub Msg"

animateCode ="""
animateSub model =
  case model.animation of
    Just animation -> 
      AnimationFrame.diffs Animate
    Nothing ->
      Sub.none
"""

updateDecl = "update : Msg -"
updateDecl1 = "> Model -"
updateDecl2 = "> Model"

updateCode = """
update msg model =
  case msg of
    Resize size ->
      { model
        | viewport = 
          { width = toFloat size.width
          , height = toFloat size.height
          }
      }
    Forth ->
      case List.head model.frames.following of
        Nothing ->
          model
        Just frame ->
          { model
            | animation = 
                Just
                  { passed = 0
                  , target = frame 
                  }
          }
    Animate diff ->
      case model.animation of
        Nothing ->
          model
        Just animation ->
          let
            passed = 
              animation.passed 
              + (diff / animation.target.duration)
          in
            if passed < 1
              then
                { model
                  | animation =
                      Just 
                        { animation 
                          | passed = passed
                        }
                }
              else
                { model
                  | animation = Nothing
                  , frames = 
                      updateFrames animation model.frames 
                }
"""

msgText x y = 
  [ Text
    <| TextObject msgCode color Params.fontCode 1 Left 1.3
    <| Position (x-0.2) (y-1)
  ]

subText x y =
  [ Text
    <| TextObject subDecl color Params.fontCode 1 Left 1.3
    <| Position (x-0.2) (y-1)
  , Text
    <| TextObject subDecl2 color Params.fontCode 1 Left 1.3
    <| Position (x+13.7) (y-1)
  , Text
    <| TextObject subCode color Params.fontCode 1 Left 1.3
    <| Position (x-0.2) (y-1)
  ]

updateText x y =
  [ Text
    <| TextObject updateDecl color Params.fontCode 1 Left 1.3
    <| Position (x-0.2) (y-1)
  , Text
    <| TextObject updateDecl1 color Params.fontCode 1 Left 1.3
    <| Position (x+8.2) (y-1)
  , Text
    <| TextObject updateDecl2 color Params.fontCode 1 Left 1.3
    <| Position (x+13.7) (y-1)
  , Text
    <| TextObject updateCode color Params.fontCode 1 Left 1.3
    <| Position (x-0.2) (y-1)
  ]

animateText x y =
  [ Text
    <| TextObject animateDecl color Params.fontCode 1 Left 1.3
    <| Position (x-0.2) (y-1)
  , Text
    <| TextObject animateDecl2 color Params.fontCode 1 Left 1.3
    <| Position (x+11.9) (y-1)
  , Text
    <| TextObject animateCode color Params.fontCode 1 Left 1.3
    <| Position (x-0.2) (y-1)
  ]


world =
  (msgText 0 0)
  ++
  (transformWorld (Position 16 16) (Size 1 1) <| subText 0 0)
  ++
  (transformWorld (Position 22.0 8.47) (Size 0.01 0.01) <| animateText 0 0)
  ++
  (transformWorld (Position 40 40) (Size 1 1) <| updateText 0 0)

frames =
  [ Frame (Position 4 -4.0) (Size 17 17) 1000
  , Frame (Position 26 12.0) (Size 18 18) 1000
  , Frame (Position 22.1 8.4) (Size 0.3 0.3) 1000
  , Frame (Position 51 35.0) (Size 19 19) 1000
  , Frame (Position 54 19.0) (Size 19 19) 1000
  , Frame (Position 56 5.0) (Size 29 18) 1000
  , Frame (Position 57 -8.0) (Size 17 17) 1000
  , Frame (Position 61 -18.0) (Size 27 17) 1000
  ]
    
