module DragDrop.Css exposing (..)

import Css exposing (..)
import Css.Elements exposing (img)
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
        , withClass Dropping
            [ borderStyle solid
            ]
        , descendants
            [ img
                [ maxHeight (px 350)
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
