module Main exposing (..)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)



-- MAIN


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    { prevActions : List String
    , nextActions : List String
    }


init : Model
init =
    Model [] [ "Fold", "Raise", "Fold", "Call" ]



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
        ]


actionText : List String -> String
actionText actions =
    case actions of
        [] ->
            "None"

        action :: _ ->
            action
