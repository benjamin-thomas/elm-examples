module TempConverter exposing (main)

import Browser
import Html exposing (Attribute, Html, input, span, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)



-- MAIN


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type AvailableConversions
    = CelsiusToFahrenheit
    | FahrenheitToCelsius


type alias Model =
    { input : String
    , requestedConversion : AvailableConversions
    }


init : Model
init =
    { input = ""
    , requestedConversion = CelsiusToFahrenheit
    }



-- UPDATE


type Msg
    = ChangeInput String
    | ChangeConversion AvailableConversions


update : Msg -> Model -> Model
update msg model =
    case msg of
        ChangeInput newInput ->
            { model | input = newInput }

        ChangeConversion conv ->
            { model | requestedConversion = conv }



-- VIEW


showCelsiusToFahrenheit celsius =
    span [] [ text (String.fromFloat (celsius * 1.8 + 32) ++ "F°") ]


showFahrenheitToCelsius fahrenheit =
    span [] [ text (String.fromFloat ((fahrenheit - 32) / 1.8) ++ "C°") ]


showErr mode =
    span
        [ style "color" "red"
        , style "font-weight" "bold"
        ]
        [ case mode of
            CelsiusToFahrenheit ->
                text "F°: "

            FahrenheitToCelsius ->
                text "C°: "
        , text "ERR"
        ]


showSelectedConversion model =
    span []
        [ case model.requestedConversion of
            CelsiusToFahrenheit ->
                case String.toFloat model.input of
                    Just val ->
                        showCelsiusToFahrenheit val

                    Nothing ->
                        showErr CelsiusToFahrenheit

            FahrenheitToCelsius ->
                case String.toFloat model.input of
                    Just val ->
                        showFahrenheitToCelsius val

                    Nothing ->
                        showErr FahrenheitToCelsius
        ]


choosenMode mode =
    span []
        [ case mode of
            CelsiusToFahrenheit ->
                text "C°"

            FahrenheitToCelsius ->
                text "F°"
        ]


view : Model -> Html Msg
view model =
    span []
        [ input [ onInput ChangeInput, style "width" "40px" ] []
        , choosenMode model.requestedConversion
        , input
            [ type_ "radio"
            , name "CtoF"
            , checked (model.requestedConversion == CelsiusToFahrenheit)
            , onClick (ChangeConversion CelsiusToFahrenheit)
            ]
            []
        , input
            [ type_ "radio"
            , name "FtoC"
            , checked (model.requestedConversion == FahrenheitToCelsius)
            , onClick (ChangeConversion FahrenheitToCelsius)
            ]
            []
        , showSelectedConversion model
        ]
