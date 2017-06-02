module Main exposing (..)

import DiveSvg.Model
import DiveSvg.View
import DiveSvg.Sub
import DiveSvg.Update
import DiveSvg.Parser
import DragDrop.DragDrop as DragDrop
import Html exposing (Html, div, text, ul, li, button, h1)
import Html.Attributes exposing (disabled)
import Html.Events exposing (onClick)
import Json.Decode as Dec
import Base64
import Regex
import Css.Css as Css
import Html.CssHelpers


{ class, classList } =
    Html.CssHelpers.withNamespace ""


type alias Model =
    { dive : DiveSvg.Model.Model DiveSvg.Model.Msg
    , dnd : DragDrop.Model
    , run : Bool
    }


type Msg
    = DiveMsg DiveSvg.Model.Msg
    | DndMsg DragDrop.Msg
    | Run


init : ( Model, Cmd Msg )
init =
    ( Model DiveSvg.Model.init DragDrop.init False
    , Cmd.none
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
            DiveSvg.Update.update msg model.dive
                |> (\( dive, cmd ) ->
                        ( { model
                            | dive = dive
                          }
                        , Cmd.map DiveMsg cmd
                        )
                   )

        Run ->
            ( model, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    updateSubmodels msg model
        |> (\( model, cmd ) ->
                case Debug.log "msg" msg of
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
                                }
                                    ! [ cmd ]

                            Ok dive ->
                                { model
                                    | dive = dive
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
           )


removeUriStart : String -> String
removeUriStart =
    Regex.replace (Regex.AtMost 1) (Regex.regex "^.*;.*,") (always "")


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.run then
        DiveSvg.Sub.subscriptions model.dive
            |> Sub.map DiveMsg
    else
        Sub.none


runnable : Model -> Bool
runnable model =
    model.dnd.imageLoadError
        == Nothing
        && (not <| List.isEmpty model.dive.frames)


view : Model -> Html Msg
view model =
    if model.run then
        DiveSvg.View.view model.dive
            |> Html.map DiveMsg
    else
        div
            [ class [ Css.Frame ]
            ]
            [ h1
                []
                [ text "Dive SVG"
                ]
            , let
                numFrames =
                    List.length model.dive.frames
              in
                div
                    []
                    [ DragDrop.view model.dnd
                        |> Html.map DndMsg
                    , if model.dnd.imageData == Nothing && model.dnd.imageLoadError == Nothing then
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
            ]


main =
    Html.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
