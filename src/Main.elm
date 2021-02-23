module Main exposing (..)

import Browser
import Html exposing (Html, button, div, h2, li, ol, text)
import Html.Attributes exposing (action)
import Html.Events exposing (onClick)
import Json.Decode as JD
    exposing
        ( Decoder
        )



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


decodeHands : String -> List Hand
decodeHands json =
    case JD.decodeString handsDecoder json of
        Ok hands ->
            hands

        Err error ->
            []


initialHands : List Hand
initialHands =
    decodeHands """[
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


init : Model
init =
    Model [] [] [] initialHands


type alias Amount =
    { integer : Int
    , fraction : Int
    }


amountDecoder : Decoder Amount
amountDecoder =
    JD.map2 Amount
        (JD.field "integer" JD.int)
        (JD.field "fraction" JD.int)



-- TODO Format `fraction` to print two digits (e.g. "$5.20")
-- TODO If `fraction` is 0 then don't print decimal or fraction value


amountText : Amount -> String
amountText amount =
    "$" ++ String.fromInt amount.integer ++ "." ++ String.fromInt amount.fraction



-- TODO Set `playerId` to position (e.g. "Hijack" or "Big Blind") instead of PII-stripped string. This needs to be done
-- for other actions as well.


type alias Post =
    { playerId : String
    , amount : Amount
    }


postDecoder : Decoder HandAction
postDecoder =
    JD.map PlayerPost
        (JD.map2 Post
            (JD.field "Post" (JD.index 0 JD.string))
            (JD.field "Post" (JD.index 1 amountDecoder))
        )


postText : Post -> String
postText post =
    post.playerId ++ " posts " ++ amountText post.amount


type alias Fold =
    { playerId : String }


foldDecoder : Decoder HandAction
foldDecoder =
    JD.map PlayerFold (JD.map Fold (JD.field "Fold" JD.string))


foldText : Fold -> String
foldText fold =
    fold.playerId ++ " folds"


type alias Check =
    { playerId : String }


checkDecoder : Decoder HandAction
checkDecoder =
    JD.map PlayerCheck (JD.map Check (JD.field "Check" JD.string))


checkText : Check -> String
checkText check =
    check.playerId ++ " checks"


type alias Call =
    { playerId : String
    , amount : Amount
    }


callDecoder : Decoder HandAction
callDecoder =
    JD.map PlayerCall
        (JD.map2 Call
            (JD.field "Call" (JD.index 0 JD.string))
            (JD.field "Call" (JD.index 1 amountDecoder))
        )


callText : Call -> String
callText call =
    call.playerId ++ " calls " ++ amountText call.amount


type alias Bet =
    { playerId : String
    , amount : Amount
    }


betDecoder : Decoder HandAction
betDecoder =
    JD.map PlayerBet
        (JD.map2 Bet
            (JD.field "Bet" (JD.index 0 JD.string))
            (JD.field "Bet" (JD.index 1 amountDecoder))
        )


betText : Bet -> String
betText bet =
    bet.playerId ++ " bets " ++ amountText bet.amount


type alias Raise =
    { playerId : String
    , amount : Amount
    , total : Amount
    }


raiseDecoder : Decoder HandAction
raiseDecoder =
    JD.map PlayerRaise
        (JD.map3 Raise
            (JD.field "Raise" (JD.index 0 JD.string))
            (JD.field "Raise" (JD.index 1 amountDecoder))
            (JD.field "Raise" (JD.index 2 amountDecoder))
        )


raiseText : Raise -> String
raiseText raise =
    raise.playerId ++ " raises " ++ amountText raise.amount ++ " to " ++ amountText raise.total


type alias Show =
    { playerId : String
    , card1 : Card
    , card2 : Card
    }


showDecoder : Decoder HandAction
showDecoder =
    JD.map PlayerShow
        (JD.map3 Show
            (JD.field "Show" (JD.index 0 JD.string))
            (JD.field "Show" (JD.index 1 cardDecoder))
            (JD.field "Show" (JD.index 2 cardDecoder))
        )


showText : Show -> String
showText show =
    show.playerId ++ " shows " ++ cardText show.card1 ++ cardText show.card2


type alias Card =
    { rank : Rank
    , suit : Suit
    }


type Rank
    = Ace
    | King
    | Queen
    | Jack
    | Ten
    | Nine
    | Eight
    | Seven
    | Six
    | Five
    | Four
    | Three
    | Two


type Suit
    = Club
    | Diamond
    | Heart
    | Spade


rankDecoder : Decoder Rank
rankDecoder =
    JD.string
        |> JD.andThen
            (\r ->
                case r of
                    "Ace" ->
                        JD.succeed Ace

                    "King" ->
                        JD.succeed King

                    "Queen" ->
                        JD.succeed Queen

                    "Jack" ->
                        JD.succeed Jack

                    "Ten" ->
                        JD.succeed Ten

                    "Nine" ->
                        JD.succeed Nine

                    "Eight" ->
                        JD.succeed Eight

                    "Seven" ->
                        JD.succeed Seven

                    "Six" ->
                        JD.succeed Six

                    "Five" ->
                        JD.succeed Five

                    "Four" ->
                        JD.succeed Four

                    "Three" ->
                        JD.succeed Three

                    "Two" ->
                        JD.succeed Two

                    _ ->
                        JD.fail ("Invalid rank: " ++ r)
            )


rankText : Rank -> String
rankText rank =
    case rank of
        Ace ->
            "A"

        King ->
            "K"

        Queen ->
            "Q"

        Jack ->
            "J"

        Ten ->
            "T"

        Nine ->
            "9"

        Eight ->
            "8"

        Seven ->
            "7"

        Six ->
            "6"

        Five ->
            "5"

        Four ->
            "4"

        Three ->
            "3"

        Two ->
            "2"


suitDecoder : Decoder Suit
suitDecoder =
    JD.string
        |> JD.andThen
            (\s ->
                case s of
                    "Club" ->
                        JD.succeed Club

                    "Diamond" ->
                        JD.succeed Diamond

                    "Heart" ->
                        JD.succeed Heart

                    "Spade" ->
                        JD.succeed Spade

                    _ ->
                        JD.fail ("Invalid suit: " ++ s)
            )


suitText : Suit -> String
suitText suit =
    case suit of
        Club ->
            "c"

        Diamond ->
            "d"

        Heart ->
            "h"

        Spade ->
            "s"


cardDecoder : Decoder Card
cardDecoder =
    JD.map2 Card
        (JD.field "rank" rankDecoder)
        (JD.field "suit" suitDecoder)


cardText : Card -> String
cardText card =
    rankText card.rank ++ suitText card.suit


flopDecoder : Decoder HandAction
flopDecoder =
    JD.map3 Flop
        (JD.field "Flop" (JD.index 0 cardDecoder))
        (JD.field "Flop" (JD.index 1 cardDecoder))
        (JD.field "Flop" (JD.index 2 cardDecoder))


flopText : Card -> Card -> Card -> String
flopText card1 card2 card3 =
    "Flop: " ++ cardText card1 ++ " " ++ cardText card2 ++ " " ++ cardText card3


turnDecoder : Decoder HandAction
turnDecoder =
    JD.map Turn
        (JD.field "Turn" cardDecoder)


turnText : Card -> String
turnText card =
    "Turn: " ++ cardText card


riverDecoder : Decoder HandAction
riverDecoder =
    JD.map River
        (JD.field "River" cardDecoder)


riverText : Card -> String
riverText card =
    "River: " ++ cardText card


preFlopDecoder : Decoder HandAction
preFlopDecoder =
    JD.succeed PreFlop


type HandAction
    = PlayerPost Post
    | PlayerFold Fold
    | PlayerCheck Check
    | PlayerCall Call
    | PlayerBet Bet
    | PlayerRaise Raise
    | PlayerShow Show
    | Flop Card Card Card
    | Turn Card
    | River Card
    | PreFlop


actionDecoder : Decoder HandAction
actionDecoder =
    JD.oneOf
        [ -- Order is extremely important. The first decoder in the list to return a result successfully
          -- will be the result of this function.
          postDecoder
        , foldDecoder
        , checkDecoder
        , callDecoder
        , betDecoder
        , raiseDecoder
        , showDecoder
        , flopDecoder
        , turnDecoder
        , riverDecoder
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

        PlayerBet bet ->
            betText bet

        PlayerRaise raise ->
            raiseText raise

        PlayerShow show ->
            showText show

        Flop card1 card2 card3 ->
            flopText card1 card2 card3

        Turn card ->
            turnText card

        River card ->
            riverText card

        PreFlop ->
            "Dealer deals pocket cards"


actionsDecoder : Decoder (List HandAction)
actionsDecoder =
    JD.list actionDecoder


actionsText : List HandAction -> List String
actionsText actions =
    List.map actionText actions


actionsHtml : List HandAction -> Html Msg
actionsHtml actions =
    ol [] (List.map (\action -> li [] [ text (actionText action) ]) actions)


type alias Hand =
    { actions : List HandAction
    , stake : Amount
    , game : String
    }


handDecoder : Decoder Hand
handDecoder =
    JD.map3 Hand
        (JD.field "actions" actionsDecoder)
        (JD.field "stake" amountDecoder)
        (JD.field "game" JD.string)


handHtml : Maybe Hand -> Html msg
handHtml hand =
    case hand of
        Just h ->
            div []
                [ div [] [ text (h.game ++ " - " ++ amountText h.stake) ]
                , ol [] (List.map (\action -> li [] [ text action ]) (actionsText h.actions))
                ]

        Nothing ->
            div [] [ text "No hand" ]


handsDecoder : Decoder (List Hand)
handsDecoder =
    JD.list handDecoder


handsHtml : List Hand -> Html msg
handsHtml hands =
    ol [] (List.map (\hand -> li [] [ handHtml hand ]) (List.map (\hand -> Just hand) hands))



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
