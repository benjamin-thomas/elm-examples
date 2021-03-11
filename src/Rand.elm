module Rand exposing (..)

-- elm-live ./src/Rand.elm --start-page index2.html -- --output=main.js
-- echo ./css/main.css | entr -rp touch ./src/Rand.elm
-- Press a button to generate a random number between 1 and 6.
--   https://guide.elm-lang.org/effects/random.html

import Browser
import Html exposing (Html, button, div, h1, img, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Random
import Svg exposing (circle, svg)
import Svg.Attributes exposing (cx, cy, height, r, viewBox, width)



-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Model =
    { die1 : DieFace
    , die2 : DieFace
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model One One
    , Cmd.none
    )



-- UPDATE


type DieFace
    = One
    | Two
    | Three
    | Four
    | Five
    | Six


type Msg
    = Roll
    | NewFaces ( DieFace, DieFace )



--


randomFace : Random.Generator DieFace
randomFace =
    Random.uniform One [ Two, Three, Four, Five, Six ]


randomFaces : Random.Generator ( DieFace, DieFace )
randomFaces =
    Random.pair randomFace randomFace


genNewFaces : Cmd Msg
genNewFaces =
    Random.generate NewFaces randomFaces


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model, genNewFaces )

        NewFaces ( face1, face2 ) ->
            ( Model face1 face2, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


svgShape : DieFace -> List (Svg.Svg msg)
svgShape dieFace =
    case dieFace of
        One ->
            [ circle
                [ cx "100"
                , cy "100"
                , r "20"
                ]
                []
            ]

        Two ->
            [ circle
                [ cx "40"
                , cy "40"
                , r "20"
                ]
                []
            , circle
                [ cx "160"
                , cy "160"
                , r "20"
                ]
                []
            ]

        Three ->
            [ circle
                [ cx "40"
                , cy "40"
                , r "20"
                ]
                []
            , circle
                [ cx "100"
                , cy "100"
                , r "20"
                ]
                []
            , circle
                [ cx "160"
                , cy "160"
                , r "20"
                ]
                []
            ]

        Four ->
            [ circle
                [ cx "40"
                , cy "40"
                , r "20"
                ]
                []
            , circle
                [ cx "40"
                , cy "160"
                , r "20"
                ]
                []
            , circle
                [ cx "160"
                , cy "160"
                , r "20"
                ]
                []
            , circle
                [ cx "160"
                , cy "40"
                , r "20"
                ]
                []
            ]

        Five ->
            [ circle
                [ cx "40"
                , cy "40"
                , r "20"
                ]
                []
            , circle
                [ cx "40"
                , cy "160"
                , r "20"
                ]
                []
            , circle
                [ cx "160"
                , cy "160"
                , r "20"
                ]
                []
            , circle
                [ cx "160"
                , cy "40"
                , r "20"
                ]
                []
            , circle
                [ cx "100"
                , cy "100"
                , r "20"
                ]
                []
            ]

        Six ->
            [ circle
                [ cx "40"
                , cy "40"
                , r "20"
                ]
                []
            , circle
                [ cx "40"
                , cy "160"
                , r "20"
                ]
                []
            , circle
                [ cx "160"
                , cy "160"
                , r "20"
                ]
                []
            , circle
                [ cx "160"
                , cy "40"
                , r "20"
                ]
                []
            , circle
                [ cx "100"
                , cy "40"
                , r "20"
                ]
                []
            , circle
                [ cx "100"
                , cy "160"
                , r "20"
                ]
                []
            ]


dieFaceToInt : DieFace -> Int
dieFaceToInt dieFace =
    case dieFace of
        One ->
            1

        Two ->
            2

        Three ->
            3

        Four ->
            4

        Five ->
            5

        Six ->
            6


view : Model -> Html Msg
view model =
    let
        faceStr1 =
            String.fromInt (dieFaceToInt model.die1)

        faceStr2 =
            String.fromInt (dieFaceToInt model.die2)
    in
    div []
        [ h1 [] [ text ("hello: " ++ faceStr1 ++ "/" ++ faceStr2) ]
        , img [ class "die-face", class ("face-" ++ faceStr1) ] []
        , img [ class "die-face", class ("face-" ++ faceStr2) ] []
        , svg
            [ width "200"
            , height "200"
            , viewBox "0 0 200 200"
            ]
            (svgShape model.die1)
        , svg
            [ width "200"
            , height "200"
            , viewBox "0 0 200 200"
            ]
            (svgShape model.die2)
        , button [ onClick Roll ] [ text "Roll" ]
        ]
