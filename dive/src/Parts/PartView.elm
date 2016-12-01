module Parts.PartView exposing (world, frames)

import String
import Dive.Model exposing (..)
import Dive.Transform exposing (transformWorld)
import Color exposing (black, white, red, blue)
import Collage exposing (defaultLine)
import Params

numberColor = 
  Color.darkBlue

codeColor =
  white

linenumbers text =
  String.split "\n" text
    |> List.length
    |> List.range 1
    |> List.map toString
    |> List.intersperse "\n"
    |> String.concat

viewCode ="""
view model =
  model.world 
  |> List.map object2Form
  |> groupTransform 
      (transform model)
  |> \\x -> [x]
  |> collage 
      model.viewport.width 
      model.viewport.height
  |> toHtml
"""

viewDecl = "view : Model -"
viewDecl2 = "> Html Msg"
-- the - sign followed by any character (except whitespace) has some odd impact on the positioning of the form

object2FormDecl = "object2Form : Object -"
object2FormDecl2 = "> Form"

object2FormCode ="""
object2Form object =
  case object of
    Image {src, width, height, position} ->
      image width height src
        |> toForm
        |> move (position.x, position.y)
    ...
"""

transformDecl = "transform : Model -"
transformDecl2 = "> Transform"

transformCode = """
transform model =
  let
    frame =
      case model.animation of
        Nothing ->
          model.frames.current
        Just animation ->
          animate 
            animation.passed 
            model.frames.current 
            animation.target
  in
    matrix model.viewport frame
"""

viewText x y = 
  [ Text
    <| TextObject viewDecl codeColor Params.fontCode 1 Left 1.3
    <| Position (x-0.2) (y-1)
  , Text
    <| TextObject viewDecl2 codeColor Params.fontCode 1 Left 1.3
    <| Position (x+8.2) (y-1)
  , Text
    <| TextObject viewCode codeColor Params.fontCode 1 Left 1.3
    <| Position (x-0.2) (y-1)
  , Text
    <| TextObject (linenumbers viewCode) numberColor Params.fontCode 1 Right 1.3
    <| Position (x-0.5) (y-1)
  ]

object2FormText x y =
  [ Text
    <| TextObject object2FormDecl codeColor Params.fontCode 1 Left 1.3
    <| Position (x-0.2) (y-1)
  , Text
    <| TextObject object2FormDecl2 codeColor Params.fontCode 1 Left 1.3
    <| Position (x+13.0) (y-1)
  , Text
    <| TextObject object2FormCode codeColor Params.fontCode 1 Left 1.3
    <| Position (x-0.2) (y-1)
  , Text
    <| TextObject (linenumbers object2FormCode) numberColor Params.fontCode 1 Right 1.3
    <| Position (x-0.5) (y-1)
  ]

transformText x y =
  [ Text
    <| TextObject transformDecl Color.darkBlue Params.fontCode 1 Left 1.3
    <| Position (x-0.2) (y-1)
  , Text
    <| TextObject transformDecl2 Color.darkBlue Params.fontCode 1 Left 1.3
    <| Position (x+11.2) (y-1)
  , Text
    <| TextObject transformCode Color.darkBlue Params.fontCode 1 Left 1.3
    <| Position (x-0.2) (y-1)
  , Text
    <| TextObject (linenumbers transformCode) Color.lightBlue Params.fontCode 1 Right 1.3
    <| Position (x-0.5) (y-1)
  ]


world =
  (viewText 0 0)
  ++
  (transformWorld (Position 8.41 -4.8) (Size 0.01 0.01) <| object2FormText 0 0)
  ++
  (transformWorld (Position 7.275 -7.2) (Size 0.004 0.004) <| transformText 0 0)

viewTextFrame =
  Frame (Position 9.5 -7) (Size 15 17) 1000

frames =
  [ Frame (Position 0.96 -1.0) (Size 2.5 1.7) 300
  , Frame (Position 10.6 -1.0) (Size 2.5 1.7) 6000
  , viewTextFrame
  , Frame (Position 8.52 -4.85) (Size 0.3 0.2) 1000
  , viewTextFrame
  , Frame (Position 7.31 -7.24) (Size 0.1 0.1) 1000
  , viewTextFrame
  ]
    
