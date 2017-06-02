module DragDrop.DragDrop exposing (..)

import Html exposing (Html, div, text, img)
import Html.Attributes exposing (..)
import Task
import FileReader exposing (..)
import MimeType exposing (MimeType(..))
import DragDrop.DragDropModel as DragDrop exposing (Msg(Drop), dragDropEventHandlers, HoverState(..))
import Html.CssHelpers
import DragDrop.Css as Css
import Json.Encode as Enc


{ class, classList } =
    Html.CssHelpers.withNamespace "dnd"


type alias Model =
    { dnDModel : DragDrop.HoverState
    , imageData :
        MaybeLoading FileContentDataUrl

    -- the image data once it has been loaded
    , imageLoadError :
        Maybe String

    -- the Error in case loading failed
    }


type MaybeLoading a
    = None
    | Loading
    | Image a


init : Model
init =
    Model DragDrop.init None Nothing


type Msg
    = DnD DragDrop.Msg
    | FileData (Result Error FileContentDataUrl)



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- Case drop. Let the DnD library update it's model and emmit the loading effect
        DnD (Drop files) ->
            ( { model
                | dnDModel = DragDrop.update (Drop files) model.dnDModel
                , imageData = Loading
              }
            , loadFirstFile files
            )

        -- Other DnD cases. Let the DnD library update it's model.
        DnD a ->
            ( { model
                | dnDModel = DragDrop.update a model.dnDModel
              }
            , Cmd.none
            )

        FileData (Ok val) ->
            { model
                | imageData = Image val
                , imageLoadError = Nothing
            }
                ! []

        FileData (Err err) ->
            { model | imageLoadError = Just (FileReader.prettyPrint err) } ! []



-- VIEW


dropAllowedForFile : NativeFile -> Bool
dropAllowedForFile file =
    case file.mimeType of
        Nothing ->
            False

        Just mimeType ->
            case mimeType of
                MimeType.Image _ ->
                    True

                _ ->
                    False


view : String -> Model -> Html Msg
view demoFile model =
    Html.map DnD <|
        div
            (classList
                [ ( Css.Dropzone, True )
                , ( Css.Dropping, model.dnDModel == Hovering )
                ]
                :: dragDropEventHandlers
            )
            [ renderImageOrPrompt demoFile model
            ]


renderImageOrPrompt : String -> Model -> Html a
renderImageOrPrompt demoFile model =
    let
        image text_ source =
            [ div
                [ class [ Css.Note ]
                ]
                [ text text_
                ]
            , img
                [ property "src" source
                , style [ ( "max-width", "100%" ) ]
                ]
                []
            ]
    in
        div
            []
            (div
                [ class [ Css.DzMessage ]
                ]
                [ text "Drop your presentation SVG file here"
                ]
                :: (case model.imageData of
                        None ->
                            image "" <| Enc.string demoFile

                        Loading ->
                            image "Loading ..." <| Enc.string ""

                        Image result ->
                            image "Current file:" result
                   )
            )


countStyle : DragDrop.HoverState -> Html.Attribute a
countStyle dragState =
    style
        [ ( "font-size", "20px" )
        , ( "font-family", "monospace" )
        , ( "display", "block" )
        , ( "width", "400px" )
        , ( "height", "200px" )
        , ( "text-align", "center" )
        , ( "background"
          , case dragState of
                DragDrop.Hovering ->
                    "#ffff99"

                DragDrop.Normal ->
                    "#cccc99"
          )
        ]



-- TASKS


loadFirstFile : List NativeFile -> Cmd Msg
loadFirstFile =
    loadFirstFileWithLoader loadData


loadData : FileRef -> Cmd Msg
loadData file =
    FileReader.readAsDataUrl file
        |> Task.map Ok
        |> Task.onError (Task.succeed << Err)
        |> Task.perform FileData



-- small helper method to do nothing if 0 files were dropped, otherwise load the first file


loadFirstFileWithLoader : (FileRef -> Cmd Msg) -> List NativeFile -> Cmd Msg
loadFirstFileWithLoader loader files =
    let
        maybeHead =
            List.head <|
                List.map .blob
                    (List.filter dropAllowedForFile files)
    in
        case maybeHead of
            Nothing ->
                Cmd.none

            Just file ->
                loader file



-- ----------------------------------


main =
    Html.program
        { init = ( init, Cmd.none )
        , update = update
        , view = view ""
        , subscriptions = (always Sub.none)
        }
