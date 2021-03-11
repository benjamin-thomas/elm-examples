-- Press a button to send a GET request for random cat GIFs.
--
-- Read how it works:
--   https://guide.elm-lang.org/effects/json.html
--


module Cats exposing (Model(..), Msg(..), getRandomCatGif, gifDecoder, init, main, subscriptions, update, view, viewGif)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (Error(..))
import Json.Decode exposing (Decoder, field, string)



-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type Model
    = Loading
    | Failure Http.Error
    | Success String


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading, getRandomCatGif )



-- UPDATE


type Msg
    = MorePlease
    | GotGif (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        MorePlease ->
            ( Loading, getRandomCatGif )

        GotGif result ->
            case result of
                Ok url ->
                    ( Success url, Cmd.none )

                Err reason ->
                    ( Failure reason, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text "Random Cats" ]
        , viewGif model
        ]


showErr str =
    div []
        [ text str
        , button [ onClick MorePlease ] [ text "Try Again!" ]
        ]


viewGif : Model -> Html Msg
viewGif model =
    case model of
        Loading ->
            text "Loading..."

        Failure reason ->
            case reason of
                BadUrl errMsg ->
                    showErr ("bad URL" ++ errMsg)

                BadBody errMsg ->
                    showErr ("bad URL" ++ errMsg)

                Timeout ->
                    showErr "I timed out!"

                NetworkError ->
                    showErr "Bad network"

                BadStatus status ->
                    case status of
                        429 ->
                            showErr "Too many requests, try again later!"

                        _ ->
                            showErr ("Got a bad status: " ++ String.fromInt status)

        Success url ->
            div []
                [ button [ onClick MorePlease, style "display" "block" ] [ text "More Please!" ]
                , img [ src url ] []
                ]



-- HTTP


getRandomCatGif : Cmd Msg
getRandomCatGif =
    Http.get
        { url = "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=cat"
        , expect = Http.expectJson GotGif gifDecoder
        }


gifDecoder : Decoder String
gifDecoder =
    field "data" (field "image_url" string)
