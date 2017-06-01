module Main exposing (..)

import DiveSvg.Model
import DiveSvg.View
import DiveSvg.Sub
import DiveSvg.Update
import DiveSvg.Parser
import DragDrop.DragDrop as DragDrop
import Html exposing (Html, div, text)
import Json.Decode as Dec
import Base64
import Regex


type alias Model =
    { dive : DiveSvg.Model.Model DiveSvg.Model.Msg
    , dnd : DragDrop.Model
    , message : String
    }


type Msg
    = DiveMsg DiveSvg.Model.Msg
    | DndMsg DragDrop.Msg


init : ( Model, Cmd Msg )
init =
    ( Model DiveSvg.Model.init DragDrop.init ""
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
                                    | message = err
                                }
                                    ! [ cmd ]

                            Ok dive ->
                                { model
                                    | dive = dive
                                }
                                    ! [ cmd ]

                    _ ->
                        model ! [ cmd ]
           )


removeUriStart : String -> String
removeUriStart =
    Regex.replace (Regex.AtMost 1) (Regex.regex "^.*;.*,") (always "")


subscriptions : Model -> Sub Msg
subscriptions model =
    DiveSvg.Sub.subscriptions model.dive
        |> Sub.map DiveMsg


view : Model -> Html Msg
view model =
    case model.dnd.imageData of
        Nothing ->
            DragDrop.view model.dnd
                |> Html.map DndMsg

        Just _ ->
            if model.message == "" then
                DiveSvg.View.view model.dive
                    |> Html.map DiveMsg
            else
                text model.message


main =
    Html.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
