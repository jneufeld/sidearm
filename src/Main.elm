module Main exposing (..)

import Browser
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (action)
import Html.Events exposing (onClick)
import Json.Decode as Decode
    exposing
        ( Decoder
        , decodeString
        , field
        , index
        , int
        , list
        , map
        , map2
        , oneOf
        , string
        , succeed
        )



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
            },
            "PreFlop",
            {
                "Fold": "uUr5VW+nLr7e9CueUrQ47g"
            },
            {
                "Fold": "Gmzktdi7SyRTsixKUD1NIw"
            },
            {
                "Fold": "yRCsk8TI2PAKL9gB4LG+/A"
            },
            {
                "Fold": "Bc/GiC55f7zCtQkHe/XPtQ"
            },
            {
                "Call": [
                "c2tiA/SMUK+T0PsP2rCOGA",
                {
                    "fraction": 0,
                    "integer": 5
                }
                ]
            },
            {
                "Check": "YRXyD5Gm275t27NjTtcPtQ"
            }
        ]
      }"""


type alias Amount =
    { integer : Int
    , fraction : Int
    }


amountDecoder : Decoder Amount
amountDecoder =
    map2 Amount
        (field "integer" int)
        (field "fraction" int)


amountText : Amount -> String
amountText amount =
    "$" ++ String.fromInt amount.integer ++ "." ++ String.fromInt amount.fraction


type alias Post =
    { playerId : String
    , amount : Amount
    }


postDecoder : Decoder HandAction
postDecoder =
    map PlayerPost
        (map2 Post
            (field "Post" (index 0 string))
            (field "Post" (index 1 amountDecoder))
        )


postText : Post -> String
postText post =
    post.playerId ++ " posts " ++ amountText post.amount


type alias Fold =
    { playerId : String }


foldDecoder : Decoder HandAction
foldDecoder =
    map PlayerFold (map Fold (field "Fold" string))


foldText : Fold -> String
foldText fold =
    fold.playerId ++ " folds"


type alias Check =
    { playerId : String }


checkDecoder : Decoder HandAction
checkDecoder =
    map PlayerCheck (map Check (field "Check" string))


checkText : Check -> String
checkText check =
    check.playerId ++ " checks"


type alias Call =
    { playerId : String
    , amount : Amount
    }


callDecoder : Decoder HandAction
callDecoder =
    map PlayerCall
        (map2 Call
            (field "Call" (index 0 string))
            (field "Call" (index 1 amountDecoder))
        )


callText : Call -> String
callText call =
    call.playerId ++ " calls" ++ amountText call.amount


preFlopDecoder : Decoder HandAction
preFlopDecoder =
    succeed PreFlop


type HandAction
    = PlayerPost Post
    | PlayerFold Fold
    | PlayerCheck Check
    | PlayerCall Call
    | PreFlop


actionDecoder : Decoder HandAction
actionDecoder =
    oneOf
        [ -- Order is extremely important. The first decoder in the list to return a result successfully
          -- will be the result of this function.
          postDecoder
        , foldDecoder
        , checkDecoder
        , callDecoder
        , preFlopDecoder
        ]


actionText : HandAction -> String
actionText action =
    case action of
        PlayerPost post ->
            postText post

        PlayerFold fold ->
            foldText fold

        PlayerCheck check ->
            checkText check

        PlayerCall call ->
            callText call

        PreFlop ->
            "PreFlop"


actionsDecoder : Decoder (List HandAction)
actionsDecoder =
    field "actions" (list actionDecoder)


actionsText : List HandAction -> String
actionsText actions =
    String.concat (List.map actionText actions)



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
        , div [] [ text ("Hand: " ++ handText model.hands) ]
        ]


handText : String -> String
handText hands =
    case decodeString actionsDecoder hands of
        Ok actions ->
            actionsText actions

        Err error ->
            "Error decoding hands: " ++ Decode.errorToString error
