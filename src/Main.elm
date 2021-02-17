module Main exposing (..)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)

import Json.Decode as Decode
    exposing
        ( Decoder
        , decodeString
        , field
        , index
        , int
        , list
        , map2
        , string
        )
import Html.Attributes exposing (action)


-- MAIN


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    { prevActions : List String
    , nextActions : List String
    , hands : String
    }


init : Model
init =
    Model [] [ "Fold", "Raise", "Fold", "Call" ] """{
        "actions": [
            {
                "Post": [
                "c2tiA/SMUK+T0PsP2rCOGA",
                {
                    "fraction": 0,
                    "integer": 5
                }
                ]
            },
            {
                "Post": [
                "YRXyD5Gm275t27NjTtcPtQ",
                {
                    "fraction": 0,
                    "integer": 10
                }
                ]
            }
        ]
      }"""


type alias Amount =
    { integer: Int
    , fraction: Int
    }

amountDecoder : Decoder Amount
amountDecoder =
    map2 Amount
        (field "integer" int)
        (field "fraction" int)

amountText : Amount -> String
amountText amount =
    "$" ++ (String.fromInt amount.integer) ++ "." ++ (String.fromInt amount.fraction)

type alias Post =
    { playerId: String
    , amount: Amount
    }

postDecoder : Decoder Post
postDecoder =
    map2 Post
        (field "Post" (index 0 string))
        (field "Post" (index 1 amountDecoder))

postText : Post -> String
postText post =
    post.playerId ++ " posts " ++ (amountText post.amount)


actionDecoder : Decoder Post
actionDecoder =
    postDecoder

actionsDecoder : Decoder (List Post)
actionsDecoder =
    field "actions" (list actionDecoder)

actionsText : List Post -> String
actionsText posts =
    String.concat (List.map postText posts)

-- UPDATE


type Msg
    = PreviousAction
    | NextAction


update : Msg -> Model -> Model
update msg model =
    case msg of
        PreviousAction ->
            processPrevAction model

        NextAction ->
            processNextAction model


processPrevAction : Model -> Model
processPrevAction model =
    case model.prevActions of
        [] ->
            model

        _ ->
            { model
                | prevActions = List.take (List.length model.prevActions - 1) model.prevActions
                , nextActions = List.drop (List.length model.prevActions - 1) model.prevActions ++ model.nextActions
            }


processNextAction : Model -> Model
processNextAction model =
    case model.nextActions of
        [] ->
            model

        current :: rest ->
            { model
                | prevActions = List.append model.prevActions (List.singleton current)
                , nextActions = rest
            }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick PreviousAction ] [ text "Previous Action" ]
        , button [ onClick NextAction ] [ text "Next Action" ]
        , div [] [ text ("Action: " ++ actionText model.nextActions) ]
        , div [] [text ("Hand: " ++ handText model.hands)]
        ]


actionText : List String -> String
actionText actions =
    case actions of
        [] ->
            "None"

        action :: _ ->
            action


handText : String -> String
handText hands =
    case decodeString actionsDecoder hands of
       Ok actions -> actionsText actions
       Err error -> "Error decoding hands: " ++ (Decode.errorToString error)