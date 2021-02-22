module Main exposing (..)

import Browser
import Html exposing (Html, button, div, li, ol, text)
import Html.Attributes exposing (action)
import Html.Events exposing (onClick)
import Json.Decode
    exposing
        ( Decoder
        , andThen
        , decodeString
        , fail
        , field
        , index
        , int
        , list
        , map
        , map2
        , map3
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
    Model [] [] """[
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
            "stake": {
            "fraction": 0,
            "integer": 10
            }
        }
      ]"""


type alias Amount =
    { integer : Int
    , fraction : Int
    }


amountDecoder : Decoder Amount
amountDecoder =
    map2 Amount
        (field "integer" int)
        (field "fraction" int)



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
    call.playerId ++ " calls " ++ amountText call.amount


type alias Show =
    { playerId : String
    , card1 : Card
    , card2 : Card
    }


showDecoder : Decoder HandAction
showDecoder =
    map PlayerShow
        (map3 Show
            (field "Show" (index 0 string))
            (field "Show" (index 1 cardDecoder))
            (field "Show" (index 2 cardDecoder))
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
    string
        |> andThen
            (\r ->
                case r of
                    "Ace" ->
                        succeed Ace

                    "King" ->
                        succeed King

                    "Queen" ->
                        succeed Queen

                    "Jack" ->
                        succeed Jack

                    "Ten" ->
                        succeed Ten

                    "Nine" ->
                        succeed Nine

                    "Eight" ->
                        succeed Eight

                    "Seven" ->
                        succeed Seven

                    "Six" ->
                        succeed Six

                    "Five" ->
                        succeed Five

                    "Four" ->
                        succeed Four

                    "Three" ->
                        succeed Three

                    "Two" ->
                        succeed Two

                    _ ->
                        fail ("Invalid rank: " ++ r)
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
    string
        |> andThen
            (\s ->
                case s of
                    "Club" ->
                        succeed Club

                    "Diamond" ->
                        succeed Diamond

                    "Heart" ->
                        succeed Heart

                    "Spade" ->
                        succeed Spade

                    _ ->
                        fail ("Invalid suit: " ++ s)
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
    map2 Card
        (field "rank" rankDecoder)
        (field "suit" suitDecoder)


cardText : Card -> String
cardText card =
    rankText card.rank ++ suitText card.suit


flopDecoder : Decoder HandAction
flopDecoder =
    map3 Flop
        (field "Flop" (index 0 cardDecoder))
        (field "Flop" (index 1 cardDecoder))
        (field "Flop" (index 2 cardDecoder))


flopText : Card -> Card -> Card -> String
flopText card1 card2 card3 =
    "Flop: " ++ cardText card1 ++ " " ++ cardText card2 ++ " " ++ cardText card3


turnDecoder : Decoder HandAction
turnDecoder =
    map Turn
        (field "Turn" cardDecoder)


turnText : Card -> String
turnText card =
    "Turn: " ++ cardText card


riverDecoder : Decoder HandAction
riverDecoder =
    map River
        (field "River" cardDecoder)


riverText : Card -> String
riverText card =
    "River: " ++ cardText card


preFlopDecoder : Decoder HandAction
preFlopDecoder =
    succeed PreFlop


type HandAction
    = PlayerPost Post
    | PlayerFold Fold
    | PlayerCheck Check
    | PlayerCall Call
    | PlayerShow Show
    | Flop Card Card Card
    | Turn Card
    | River Card
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
    list actionDecoder


actionsText : List HandAction -> List String
actionsText actions =
    List.map actionText actions


type alias Hand =
    { actions : List HandAction
    , stake : Amount
    , game : String
    }


handDecoder : Decoder Hand
handDecoder =
    map3 Hand
        (field "actions" actionsDecoder)
        (field "stake" amountDecoder)
        (field "game" string)


handHtml : Hand -> Html msg
handHtml hand =
    div []
        [ div [] [ text (hand.game ++ " - " ++ amountText hand.stake) ]
        , ol [] (List.map (\action -> li [] [ text action ]) (actionsText hand.actions))
        ]


handsDecoder : Decoder (List Hand)
handsDecoder =
    list handDecoder


handsHtml : List Hand -> Html msg
handsHtml hands =
    ol [] (List.map (\hand -> li [] [ handHtml hand ]) hands)



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
        , handsHtml (decodeHands model.hands)
        ]


decodeHands : String -> List Hand
decodeHands json =
    case decodeString handsDecoder json of
        Ok hands ->
            hands

        Err error ->
            []
