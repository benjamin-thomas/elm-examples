module Main exposing (..)

import Browser
import Html exposing (Html, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    { content : String
    , silenceWarning : Bool
    }


init : Model
init =
    { content = "Ewan", silenceWarning = True }



-- UPDATE


type Msg
    = Change String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Change newContent ->
            { model | content = newContent ++ newContent }
            --{ model | content = String.reverse newContent }
            --{ model | content = newContent ++ (String.left (String.length newContent) newContent) }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ input [ placeholder "Text to reverse…", autofocus True, value model.content, onInput Change ] []
        --[ input [ placeholder "Text to reverse…", onInput Change ] []
        , div [] [ text (String.reverse model.content) ]
        , div [] [ text ("Total size: " ++ String.fromInt (String.length model.content)) ]
        ]
