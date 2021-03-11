module Forms exposing (..)

import Browser
import Char
import Html exposing (Html, br, div, input, p, text)
import Html.Attributes exposing (placeholder, style, type_, value)
import Html.Events exposing (onInput)

main =
    Browser.sandbox { init = init, update = update, view = view }


type alias Model =
    { name : String
    , password : String
    , passwordConfirmation : String
    }


init : Model
init =
    { name = "John"
    , password = ""
    , passwordConfirmation = ""
    }


type Msg
    = SetName String
    | SetPassword String
    | SetPasswordConfirmation String


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetName name ->
            { model | name = name }

        SetPassword password ->
            { model | password = password }

        SetPasswordConfirmation password ->
            { model | passwordConfirmation = password }


input_ type__ placeholder_ msg =
    input [ type_ type__, placeholder placeholder_, onInput msg ] []


textInput placeholder msg =
    input_ "text" placeholder msg


passwordInput placeholder msg =
    --input_ "password" placeholder msg
    input_ "text" placeholder msg


lineBreak =
    br [] []


minSizeOk password =
    String.length password > 8


samePassword model =
    model.password == model.passwordConfirmation


complexityOk password =
    String.any Char.isUpper password
        && String.any Char.isLower password
        && String.any Char.isDigit password


showNothing =
    p [] []


showErr reason =
    p [ style "color" "red" ] [ text reason ]


showSuccess =
    p [ style "color" "green" ] [ text "Password is OK" ]


validationStatus model =
    let
        passwordIsEmpty =
            String.isEmpty model.password

        failsMinSize =
            not (minSizeOk model.password)

        failsComplexity =
            not (complexityOk model.password)

        notIdentical =
            not (samePassword model)
    in
    if passwordIsEmpty then
        showNothing

    else if failsMinSize then
        showErr "not long enough!"

    else if failsComplexity then
        showErr "not complex enough!"

    else if notIdentical then
        showErr "not the same!"

    else
        showSuccess


view : Model -> Html Msg
view model =
    let
        greetings =
            text ("Hello: " ++ model.name)
    in
    div []
        [ p [] [ greetings ]

         --, textInput "Your name" SetName
        , input [ placeholder "Your name", onInput SetName, value model.name ] []
        , lineBreak
        , passwordInput "Enter your password..." SetPassword
        , lineBreak
        , passwordInput "Confirm your password..." SetPasswordConfirmation
        , validationStatus model
        ]
