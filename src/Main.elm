module Main exposing (..)

import Browser
import Decoding exposing (Hand, HandAction, actionsHtml, decodeJson, seatsHtml)
import Html exposing (Html, button, div, h2, text)
import Html.Events exposing (onClick)



-- MAIN
-- TODO This displays the second hand and doesn't display anything if there is only one hand.


main =
    Browser.sandbox { init = processNextHand initialModel, update = update, view = view }



-- MODEL


type alias AnalysisHands =
    { displayedActions : List HandAction
    , upcomingActions : List HandAction
    , prevHands : List Hand
    , nextHands : List Hand
    }


type Model
    = InitializationError String
    | DecodedHands AnalysisHands


initialModel : Model
initialModel =
    case decodeInitialHands of
        Err error ->
            InitializationError error

        Ok hands ->
            DecodedHands (AnalysisHands [] [] [] hands)



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
    case model of
        -- If there is an initialization error then this block shouldn't be executed. Refactor this eventually.
        InitializationError _ ->
            model

        DecodedHands hands ->
            case hands.prevHands of
                -- If there are no previous hands then return the model without modification
                [] ->
                    model

                _ ->
                    let
                        prev =
                            List.take (List.length hands.prevHands - 1) hands.prevHands

                        next =
                            List.drop (List.length hands.prevHands - 1) hands.prevHands ++ hands.nextHands

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
                    DecodedHands
                        { hands
                            | prevHands = prev
                            , nextHands = next
                            , displayedActions = displayed
                            , upcomingActions = upcoming
                        }


processNextHand : Model -> Model
processNextHand model =
    case model of
        -- If there is an initialization error then this block shouldn't be executed. Refactor this eventually.
        InitializationError _ ->
            model

        DecodedHands hands ->
            case hands.nextHands of
                -- If there is no current or next hand them immediately return the model without modification
                [] ->
                    model

                -- When there are no hands beyond the currently displayed hand then return the model without modification
                _ :: [] ->
                    model

                -- Only advance to another hand when there is one available to display
                current :: remaining ->
                    let
                        prev =
                            List.append hands.prevHands (List.singleton current)

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
                    DecodedHands
                        { hands
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
    case model of
        -- If there is an initialization error then this block shouldn't be executed. Refactor this eventually.
        InitializationError _ ->
            model

        DecodedHands hands ->
            case hands.displayedActions of
                [] ->
                    model

                _ ->
                    DecodedHands
                        { hands
                            | displayedActions = List.take (List.length hands.displayedActions - 1) hands.displayedActions
                            , upcomingActions = List.drop (List.length hands.displayedActions - 1) hands.displayedActions ++ hands.upcomingActions
                        }


processNextAction : Model -> Model
processNextAction model =
    case model of
        -- If there is an initialization error then this block shouldn't be executed. Refactor this eventually.
        InitializationError _ ->
            model

        DecodedHands hands ->
            case hands.upcomingActions of
                [] ->
                    model

                current :: rest ->
                    DecodedHands
                        { hands
                            | displayedActions = List.append hands.displayedActions (List.singleton current)
                            , upcomingActions = rest
                        }



-- VIEW


view : Model -> Html Msg
view model =
    case model of
        InitializationError error ->
            div [] [ text error ]

        DecodedHands hands ->
            let
                currentHand =
                    List.head hands.nextHands

                navigationDiv =
                    div []
                        [ button [ onClick PreviousHand ] [ text "Previous Hand" ]
                        , button [ onClick NextHand ] [ text "Next Hand" ]
                        , button [ onClick PreviousAction ] [ text "Previous Action" ]
                        , button [ onClick NextAction ] [ text "Next Action" ]
                        ]
            in
            case currentHand of
                Nothing ->
                    navigationDiv

                Just hand ->
                    div []
                        [ navigationDiv
                        , div []
                            [ h2 [] [ text "Hand Details" ]
                            , div [] [ seatsHtml hand.seats ]
                            , div [] [ actionsHtml hands.displayedActions ]
                            ]
                        ]


decodeInitialHands : Result String (List Hand)
decodeInitialHands =
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
      },
      {
        "Muck": "YRXyD5Gm275t27NjTtcPtQ"
      },
      {
        "Collect": [
          "c2tiA/SMUK+T0PsP2rCOGA",
          {
            "fraction": 0,
            "integer": 19
          }
        ]
      }
    ],
    "game": "NoLimitHoldem",
    "seats": [
      {
        "number": 6,
        "player_id": "Bc/GiC55f7zCtQkHe/XPtQ",
        "stack": {
          "fraction": 50,
          "integer": 1885
        }
      },
      {
        "number": 1,
        "player_id": "c2tiA/SMUK+T0PsP2rCOGA",
        "stack": {
          "fraction": 50,
          "integer": 1105
        }
      },
      {
        "number": 2,
        "player_id": "YRXyD5Gm275t27NjTtcPtQ",
        "stack": {
          "fraction": 73,
          "integer": 1061
        }
      },
      {
        "number": 3,
        "player_id": "uUr5VW+nLr7e9CueUrQ47g",
        "stack": {
          "fraction": 70,
          "integer": 1213
        }
      },
      {
        "number": 4,
        "player_id": "Gmzktdi7SyRTsixKUD1NIw",
        "stack": {
          "fraction": 25,
          "integer": 2580
        }
      },
      {
        "number": 5,
        "player_id": "yRCsk8TI2PAKL9gB4LG+/A",
        "stack": {
          "fraction": 0,
          "integer": 1985
        }
      }
    ],
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
      },
      {
        "Muck": "uUr5VW+nLr7e9CueUrQ47g"
      },
      {
        "Collect": [
          "YRXyD5Gm275t27NjTtcPtQ",
          {
            "fraction": 0,
            "integer": 167
          }
        ]
      }
    ],
    "game": "NoLimitHoldem",
    "seats": [
      {
        "number": 1,
        "player_id": "c2tiA/SMUK+T0PsP2rCOGA",
        "stack": {
          "fraction": 50,
          "integer": 1114
        }
      },
      {
        "number": 2,
        "player_id": "YRXyD5Gm275t27NjTtcPtQ",
        "stack": {
          "fraction": 73,
          "integer": 1051
        }
      },
      {
        "number": 3,
        "player_id": "uUr5VW+nLr7e9CueUrQ47g",
        "stack": {
          "fraction": 70,
          "integer": 1213
        }
      },
      {
        "number": 4,
        "player_id": "Gmzktdi7SyRTsixKUD1NIw",
        "stack": {
          "fraction": 25,
          "integer": 2580
        }
      },
      {
        "number": 5,
        "player_id": "yRCsk8TI2PAKL9gB4LG+/A",
        "stack": {
          "fraction": 0,
          "integer": 2000
        }
      },
      {
        "number": 6,
        "player_id": "Bc/GiC55f7zCtQkHe/XPtQ",
        "stack": {
          "fraction": 50,
          "integer": 1885
        }
      }
    ],
    "stake": {
      "fraction": 0,
      "integer": 10
    }
  }
    ]"""
