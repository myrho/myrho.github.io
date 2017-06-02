port module Stylesheets exposing (..)

import Css.File exposing (..)
import Css.Css
import DragDrop.Css
import Html exposing (div)


port files : CssFileStructure -> Cmd msg


cssFiles : CssFileStructure
cssFiles =
    toFileStructure [ ( "styles.css", compile [ Css.Css.css, DragDrop.Css.css ] ) ]


main =
    Platform.program
        { init = ( (), files cssFiles )
        , update = \_ _ -> ( (), Cmd.none )
        , subscriptions = \_ -> Sub.none
        }
