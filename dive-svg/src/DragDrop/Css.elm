module DragDrop.Css exposing (..)

import Css exposing (..)
import Css.Elements exposing (img, input)
import Css.Namespace exposing (..)
import Css.Colors exposing (..)


css =
    (stylesheet << namespace "dnd") general


type Classes
    = Dropzone
    | Dropping
    | DzMessage
    | DzError
    | Note


white =
    hex "fff"


general =
    [ class Dropzone
        [ border3 (px 2) dashed (hex "0087F7")
        , borderRadius (px 5)
        , backgroundColor <| hex "F3F4F5"
        , height (px 500)
        , displayFlex
        , justifyContent center
        , alignItems center
        , marginTop (Css.rem 1)
        , position relative
        , withClass Dropping
            [ borderStyle solid
            ]
        , descendants
            [ img
                [ maxHeight (px 350)
                ]
            , input
                [ position absolute
                , left (px 0)
                , top (px 0)
                , margin (px 0)
                , padding (px 0)
                , cursor pointer
                , opacity zero
                , height (pct 100)
                , width (pct 100)
                ]
            , class DzMessage
                [ textAlign center
                , color <| hex "646C7F"
                , margin2 (em 2) zero
                , fontWeight <| int 400
                , descendants
                    [ class Note
                        [ fontSize (em 0.8)
                        , fontWeight (int 200)
                        , property "display" "block"
                        , marginTop (Css.rem 1.4)
                        ]
                    ]
                ]
            ]
        ]
    ]
