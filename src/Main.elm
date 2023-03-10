module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (..)
import Http
import Json.Decode as D exposing (Decoder)



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
  = Failure
  | Loading
  | Success Spaceship


type alias Spaceship =
  { name : String
  }


init : () -> (Model, Cmd Msg)
init _ =
  (Loading, getSpaceship)



-- UPDATE


type Msg
  = GotSpaceship (Result Http.Error Spaceship)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GotSpaceship result ->
      case result of
        Ok spaceship ->
          (Success spaceship, Cmd.none)

        Err _ ->
          (Failure, Cmd.none)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ h1 [] [ text "My Spaceship" ]
    , viewSpaceship model
    ]


viewSpaceship : Model -> Html Msg
viewSpaceship model =
  case model of
    Failure ->
      div []
        [ text "Loading the spaceship failed..."
        ]

    Loading ->
      text "Loading..."

    Success spaceship ->
      div []
        [ h2 [] [ text spaceship.name ]
        ]



-- HTTP


getSpaceship : Cmd Msg
getSpaceship =
  Http.get
    { url = "http://localhost:55667/spaceships/bouwe"
    , expect = Http.expectJson GotSpaceship spaceshipDecoder
    }


spaceshipDecoder : Decoder Spaceship
spaceshipDecoder =
  D.map Spaceship
    (D.field "name" D.string)