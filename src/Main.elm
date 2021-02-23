module Main exposing (..)

import Browser
import Decoding exposing (Hand, HandAction, actionsHtml, decodeJson)
import Html exposing (Html, button, div, h2, text)
import Html.Events exposing (onClick)



-- MAIN


main =
    Browser.sandbox { init = processNextHand init, update = update, view = view }



-- MODEL


type alias Model =
    { displayedActions : List HandAction
    , upcomingActions : List HandAction
    , prevHands : List Hand
    , nextHands : List Hand
    }


init : Model
init =
    Model [] [] [] initialHands



-- UPDATE


type Msg
    = PreviousHand
    | NextHand
    | PreviousAction
    | NextAction


update : Msg -> Model -> Model
update msg model =
    case msg of
        PreviousHand ->
            processPrevHand model

        NextHand ->
            processNextHand model

        PreviousAction ->
            processPrevAction model

        NextAction ->
            processNextAction model


processPrevHand : Model -> Model
processPrevHand model =
    case model.prevHands of
        [] ->
            model

        _ ->
            let
                prev =
                    List.take (List.length model.prevHands - 1) model.prevHands

                next =
                    List.drop (List.length model.prevHands - 1) model.prevHands ++ model.nextHands

                curr =
                    List.head next

                ( displayed, upcoming ) =
                    initialActionSplit
                        (case curr of
                            Just hand ->
                                hand.actions

                            Nothing ->
                                []
                        )
            in
            { model
                | prevHands = prev
                , nextHands = next
                , displayedActions = displayed
                , upcomingActions = upcoming
            }


processNextHand : Model -> Model
processNextHand model =
    case model.nextHands of
        [] ->
            model

        current :: remaining ->
            let
                prev =
                    List.append model.prevHands (List.singleton current)

                next =
                    List.head remaining

                ( displayed, upcoming ) =
                    initialActionSplit
                        (case next of
                            Just hand ->
                                hand.actions

                            Nothing ->
                                []
                        )
            in
            { model
                | prevHands = prev
                , nextHands = remaining
                , displayedActions = displayed
                , upcomingActions = upcoming
            }


initialActionSplit : List HandAction -> ( List HandAction, List HandAction )
initialActionSplit actions =
    let
        displayed =
            List.take 3 actions

        upcoming =
            List.drop 3 actions
    in
    ( displayed, upcoming )


processPrevAction : Model -> Model
processPrevAction model =
    case model.displayedActions of
        [] ->
            model

        _ ->
            { model
                | displayedActions = List.take (List.length model.displayedActions - 1) model.displayedActions
                , upcomingActions = List.drop (List.length model.displayedActions - 1) model.displayedActions ++ model.upcomingActions
            }


processNextAction : Model -> Model
processNextAction model =
    case model.upcomingActions of
        [] ->
            model

        current :: rest ->
            { model
                | displayedActions = List.append model.displayedActions (List.singleton current)
                , upcomingActions = rest
            }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick PreviousHand ] [ text "Previous Hand" ]
        , button [ onClick NextHand ] [ text "Next Hand" ]
        , button [ onClick PreviousAction ] [ text "Previous Action" ]
        , button [ onClick NextAction ] [ text "Next Action" ]
        , div []
            [ h2 [] [ text "Hand Details" ]
            , div [] [ actionsHtml model.displayedActions ]
            ]
        ]


initialHands : List Hand
initialHands =
    decodeJson """[
        {
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
                },
                {
                    "Flop": [
                    {
                        "rank": "King",
                        "suit": "Club"
                    },
                    {
                        "rank": "Five",
                        "suit": "Diamond"
                    },
                    {
                        "rank": "Seven",
                        "suit": "Club"
                    }
                    ]
                },
                {
                    "Check": "c2tiA/SMUK+T0PsP2rCOGA"
                },
                {
                    "Check": "YRXyD5Gm275t27NjTtcPtQ"
                },
                {
                    "Turn": {
                    "rank": "Nine",
                    "suit": "Spade"
                    }
                },
                {
                    "Check": "c2tiA/SMUK+T0PsP2rCOGA"
                },
                {
                    "Check": "YRXyD5Gm275t27NjTtcPtQ"
                },
                {
                    "River": {
                    "rank": "Four",
                    "suit": "Spade"
                    }
                },
                {
                    "Check": "c2tiA/SMUK+T0PsP2rCOGA"
                },
                {
                    "Check": "YRXyD5Gm275t27NjTtcPtQ"
                },
                {
                    "Show": [
                    "c2tiA/SMUK+T0PsP2rCOGA",
                    {
                        "rank": "Five",
                        "suit": "Heart"
                    },
                    {
                        "rank": "Ten",
                        "suit": "Heart"
                    }
                    ]
                }
            ],
            "game": "NoLimitHoldem",
            "stake": {
            "fraction": 0,
            "integer": 10
            }
        },
        {
            "actions": [
            {
                "Post": [
                "YRXyD5Gm275t27NjTtcPtQ",
                {
                    "fraction": 0,
                    "integer": 5
                }
                ]
            },
            {
                "Post": [
                "uUr5VW+nLr7e9CueUrQ47g",
                {
                    "fraction": 0,
                    "integer": 10
                }
                ]
            },
            "PreFlop",
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
                    "integer": 10
                }
                ]
            },
            {
                "Call": [
                "YRXyD5Gm275t27NjTtcPtQ",
                {
                    "fraction": 0,
                    "integer": 5
                }
                ]
            },
            {
                "Check": "uUr5VW+nLr7e9CueUrQ47g"
            },
            {
                "Flop": [
                {
                    "rank": "Two",
                    "suit": "Diamond"
                },
                {
                    "rank": "Six",
                    "suit": "Diamond"
                },
                {
                    "rank": "Nine",
                    "suit": "Heart"
                }
                ]
            },
            {
                "Check": "YRXyD5Gm275t27NjTtcPtQ"
            },
            {
                "Check": "uUr5VW+nLr7e9CueUrQ47g"
            },
            {
                "Check": "c2tiA/SMUK+T0PsP2rCOGA"
            },
            {
                "Turn": {
                "rank": "Five",
                "suit": "Heart"
                }
            },
            {
                "Bet": [
                "YRXyD5Gm275t27NjTtcPtQ",
                {
                    "fraction": 0,
                    "integer": 30
                }
                ]
            },
            {
                "Call": [
                "uUr5VW+nLr7e9CueUrQ47g",
                {
                    "fraction": 0,
                    "integer": 30
                }
                ]
            },
            {
                "Fold": "c2tiA/SMUK+T0PsP2rCOGA"
            },
            {
                "River": {
                "rank": "King",
                "suit": "Club"
                }
            },
            {
                "Bet": [
                "YRXyD5Gm275t27NjTtcPtQ",
                {
                    "fraction": 0,
                    "integer": 40
                }
                ]
            },
            {
                "Call": [
                "uUr5VW+nLr7e9CueUrQ47g",
                {
                    "fraction": 0,
                    "integer": 40
                }
                ]
            },
            {
                "Show": [
                "YRXyD5Gm275t27NjTtcPtQ",
                {
                    "rank": "Nine",
                    "suit": "Club"
                },
                {
                    "rank": "King",
                    "suit": "Heart"
                }
                ]
            }
            ],
            "game": "NoLimitHoldem",
            "stake": {
            "fraction": 0,
            "integer": 10
            }
        },
        {
            "actions": [
            {
                "Post": [
                "V1tBWCstw/IRehRmisMDJg",
                {
                    "fraction": 0,
                    "integer": 5
                }
                ]
            },
            {
                "Post": [
                "DdYt9O93aLl3XboT1BK3HQ",
                {
                    "fraction": 0,
                    "integer": 10
                }
                ]
            },
            "PreFlop",
            {
                "Fold": "YRXyD5Gm275t27NjTtcPtQ"
            },
            {
                "Raise": [
                "7uKPjPg5l/gwaCxpksjtGQ",
                {
                    "fraction": 0,
                    "integer": 40
                },
                {
                    "fraction": 0,
                    "integer": 40
                }
                ]
            },
            {
                "Fold": "yRCsk8TI2PAKL9gB4LG+/A"
            },
            {
                "Call": [
                "Gmzktdi7SyRTsixKUD1NIw",
                {
                    "fraction": 0,
                    "integer": 40
                }
                ]
            },
            {
                "Fold": "V1tBWCstw/IRehRmisMDJg"
            },
            {
                "Fold": "DdYt9O93aLl3XboT1BK3HQ"
            },
            {
                "Flop": [
                {
                    "rank": "Queen",
                    "suit": "Heart"
                },
                {
                    "rank": "Seven",
                    "suit": "Diamond"
                },
                {
                    "rank": "Seven",
                    "suit": "Spade"
                }
                ]
            },
            {
                "Check": "7uKPjPg5l/gwaCxpksjtGQ"
            },
            {
                "Check": "Gmzktdi7SyRTsixKUD1NIw"
            },
            {
                "Turn": {
                "rank": "Ace",
                "suit": "Spade"
                }
            },
            {
                "Check": "7uKPjPg5l/gwaCxpksjtGQ"
            },
            {
                "Check": "Gmzktdi7SyRTsixKUD1NIw"
            },
            {
                "River": {
                "rank": "Queen",
                "suit": "Spade"
                }
            },
            {
                "Check": "7uKPjPg5l/gwaCxpksjtGQ"
            },
            {
                "Bet": [
                "Gmzktdi7SyRTsixKUD1NIw",
                {
                    "fraction": 0,
                    "integer": 110
                }
                ]
            },
            {
                "Call": [
                "7uKPjPg5l/gwaCxpksjtGQ",
                {
                    "fraction": 0,
                    "integer": 110
                }
                ]
            },
            {
                "Show": [
                "Gmzktdi7SyRTsixKUD1NIw",
                {
                    "rank": "Nine",
                    "suit": "Diamond"
                },
                {
                    "rank": "Queen",
                    "suit": "Diamond"
                }
                ]
            }
            ],
            "game": "NoLimitHoldem",
            "stake": {
                "fraction": 0,
                "integer": 10
            }
        }
    ]
    """
