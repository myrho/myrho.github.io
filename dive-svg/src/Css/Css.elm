module Css.Css exposing (..)

import Css exposing (..)
import Css.Elements exposing (..)
import Css.Namespace exposing (..)


css =
    stylesheet general


type Classes
    = StartButton
    | Disabled
    | Frame
    | Msg
    | ErrorMsg
    | SuccessMsg


general =
    [ body
        [ fontFamilies [ "Lato", "Helvetica", "sans-serif" ]
        ]
    , class Frame
        [ maxWidth (px 720)
        , marginLeft auto
        , marginRight auto
        , textAlign center
        ]
    , class StartButton
        [ backgroundColor <| hex "337ab7"
        , border3 (px 1) solid <| hex "2e6da4"
        , color <| hex "fff"
        , borderRadius <| px 6
        , fontWeight <| int 400
        , fontSize <| pct 150
        , padding2 (px 10) <| px 16
        , marginTop <| px 20
        , cursor pointer
        , withClass Disabled
            [ opacity <| num 0.65
            , cursor notAllowed
            ]
        ]
    , class Msg
        [ border3 (px 1) solid <| hex "000"
        , displayFlex
        , justifyContent center
        , alignItems center
        , borderRadius <| px 4
        , height <| px 30
        , marginTop <| px 20
        ]
    , class ErrorMsg
        [ borderColor <| hex "ebccd1"
        , backgroundColor <| hex "f2dede"
        , color <| hex "a94442"
        ]
    , class SuccessMsg
        [ borderColor <| hex "d6e9c6"
        , backgroundColor <| hex "dff0d8"
        , color <| hex "3c763d"
        ]
    ]
