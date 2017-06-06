module Main exposing (..)

import DiveSvg.Model
import DiveSvg.View
import DiveSvg.Sub
import DiveSvg.Update
import DiveSvg.Parser
import DragDrop.DragDrop as DragDrop
import Html exposing (Html, div, h1, h2, button, text, img, span, a)
import Html.Attributes exposing (disabled, style, href)
import Html.Events exposing (onClick)
import Json.Decode as Dec
import Base64
import Regex
import Css.Css as Css
import Html.CssHelpers
import Http


{ class, classList } =
    Html.CssHelpers.withNamespace ""


demoFile =
    "samples/demo.svg?7"


type alias Model =
    { dive : Maybe DiveSvg.Model.Model
    , dnd : DragDrop.Model
    , run : Bool
    , demoFile : String
    }


type Msg
    = DiveMsg DiveSvg.Model.Msg
    | DndMsg DragDrop.Msg
    | Run
    | Load (Result Http.Error String)


init : { file : Maybe String, time : Int } -> ( Model, Cmd Msg )
init { file, time } =
    let
        f =
            Maybe.withDefault demoFile file
    in
        ( Model Nothing DragDrop.init False f
        , Http.getString (f ++ "?" ++ (toString time)) |> Http.send Load
        )


updateSubmodels : Msg -> Model -> ( Model, Cmd Msg )
updateSubmodels msg model =
    case msg of
        DndMsg msg ->
            DragDrop.update msg model.dnd
                |> (\( dnd, cmd ) ->
                        ( { model
                            | dnd = dnd
                          }
                        , Cmd.map DndMsg cmd
                        )
                   )

        DiveMsg msg ->
            case model.dive of
                Nothing ->
                    ( model, Cmd.none )

                Just dive ->
                    DiveSvg.Update.update msg dive
                        |> (\( dive, cmd ) ->
                                ( { model
                                    | dive = Just dive
                                  }
                                , Cmd.map DiveMsg cmd
                                )
                           )

        Run ->
            ( model, Cmd.none )

        Load _ ->
            ( model, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    updateSubmodels msg model
        |> (\( model, cmd ) ->
                case msg of
                    DndMsg (DragDrop.FileData (Ok str)) ->
                        case
                            Dec.decodeValue Dec.string str
                                |> Result.map removeUriStart
                                |> Result.andThen Base64.decode
                                |> Result.andThen DiveSvg.Parser.load
                        of
                            Err err ->
                                { model
                                    | dnd =
                                        model.dnd
                                            |> (\dnd ->
                                                    { dnd
                                                        | imageLoadError = Just err
                                                    }
                                               )
                                    , dive = Nothing
                                }
                                    ! [ cmd ]

                            Ok dive ->
                                { model
                                    | dive = Just dive
                                }
                                    ! [ cmd ]

                    DndMsg _ ->
                        model ! [ cmd ]

                    DiveMsg _ ->
                        model ! [ cmd ]

                    Run ->
                        { model
                            | run = True
                        }
                            ! [ cmd ]

                    Load result ->
                        { model
                            | dive =
                                Result.mapError toString result
                                    |> Result.andThen DiveSvg.Parser.load
                                    |> Result.toMaybe
                        }
                            ! [ cmd ]
           )


removeUriStart : String -> String
removeUriStart =
    Regex.replace (Regex.AtMost 1) (Regex.regex "^.*;.*,") (always "")


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.run then
        case model.dive of
            Nothing ->
                Sub.none

            Just dive ->
                DiveSvg.Sub.subscriptions dive
                    |> Sub.map DiveMsg
    else
        Sub.none


runnable : Model -> Bool
runnable model =
    model.dive /= Nothing


view : Model -> Html Msg
view model =
    if model.run then
        case model.dive of
            Nothing ->
                text "nothing to run"

            Just dive ->
                DiveSvg.View.view dive
                    |> Html.map DiveMsg
    else
        div
            [ class [ Css.Frame ]
            ]
            [ h1
                []
                [ text "Dive SVG"
                ]
            , div
                [ class [ Css.Subhead ]
                ]
                [ text "Prezi-like presentations in plain SVG"
                ]
            , div
                [ class [ Css.Note ]
                ]
                [ text "Works best in the Chrome browser."
                ]
            , let
                numFrames =
                    Maybe.map (.frames >> List.length >> (+) 1) model.dive
                        |> Maybe.withDefault 0
              in
                div
                    []
                    [ DragDrop.view model.demoFile model.dnd
                        |> Html.map DndMsg
                    , if model.dive == Nothing && model.dnd.imageLoadError == Nothing then
                        text ""
                      else
                        div
                            [ class [ Css.Msg ]
                            , classList
                                [ ( Css.ErrorMsg, not <| runnable model )
                                , ( Css.SuccessMsg, runnable model )
                                ]
                            ]
                            [ text <|
                                case model.dnd.imageLoadError of
                                    Nothing ->
                                        toString numFrames
                                            ++ " frame"
                                            ++ (if numFrames == 1 then
                                                    ""
                                                else
                                                    "s"
                                               )
                                            ++ " found"

                                    Just err ->
                                        err
                            ]
                    , button
                        [ disabled <| not <| runnable model
                        , onClick Run
                        , class [ Css.StartButton ]
                        , classList [ ( Css.Disabled, not <| runnable model ) ]
                        ]
                        [ text "Let's go"
                        ]
                    ]
            , h2
                []
                [ text "Usage"
                ]
            , div
                [ class [ Css.Note ]
                ]
                [ text "As opposed to slide based presentations, visual presentations (like "
                , a
                    [ href "https://prezi.com"
                    ]
                    [ text "Prezi"
                    ]
                , text "'s) contain all the content in one big picture. Content is presented by moving and zooming into certain parts (frames) of this picture."
                ]
            , div
                [ class [ Css.Note ]
                ]
                [ text "With "
                , span
                    [ style [ ( "font-weight", "bold" ) ]
                    ]
                    [ text "Dive SVG"
                    ]
                , text " you can use plain SVG for that. Draw the big picture and the frames using your favorite vector graphics editor (eg. "
                , a
                    [ href "http://inkscape.org"
                    ]
                    [ text "Inkscape"
                    ]
                , text "), save it as SVG and drop the file in the dropzone above. And you are ready to run your visual presentation!"
                ]
            , div
                [ class [ Css.Note ]
                ]
                [ text "Here is an "
                , a
                    [ href "samples/demo.svg"
                    ]
                    [ text "example file"
                    ]
                , text "."
                ]
            , div
                [ class [ Css.Note ]
                ]
                [ text "Groups of "
                , span
                    [ style
                        [ ( "font-weight", "bold" )
                        ]
                    ]
                    [ span
                        [ style
                            [ ( "color", "red" )
                            ]
                        ]
                        [ text "red rectangles "
                        ]
                    , text
                        "plus a number "
                    ]
                , text
                    "are removed and turned into frames. These are the parts of your SVG where you want to put focus on in your presentation."
                ]
            , h2
                []
                [ text "Source"
                ]
            , div
                [ class [ Css.Note ]
                , style [ ( "font-weight", "bold" ) ]
                ]
                [ text "100% open source, completely client side, your file never gets uploaded anywhere!"
                ]
            , div
                [ class [ Css.Note ]
                ]
                [ text "Source code of this page can be found "
                , a
                    [ href "https://github.com/myrho/myrho.github.io/tree/master/dive-svg"
                    ]
                    [ text "here"
                    ]
                , text "."
                ]
            ]


main =
    Html.programWithFlags
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
