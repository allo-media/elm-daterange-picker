module Main exposing (main)

import Browser
import DateRangePicker as Picker
import DateRangePicker.Range as Range exposing (Range)
import Html exposing (..)
import Task exposing (Task)
import Time


type Model
    = Loading
    | Ready Picker.State


type Msg
    = PickerChanged Picker.State


init : () -> ( Model, Cmd Msg )
init _ =
    let
        config =
            Picker.configure
                (\default ->
                    { default
                        | allowFuture = False
                    }
                )
    in
    ( Loading
    , Picker.initToday config Nothing
        |> Task.perform PickerChanged
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PickerChanged state ->
            ( Ready state, Cmd.none )


view : Model -> Html Msg
view model =
    case model of
        Loading ->
            text "Loading"

        Ready picker ->
            div []
                [ text "Selected: "
                , case Picker.getValue picker of
                    Just range ->
                        text (Range.format Time.utc range)

                    Nothing ->
                        text "nothing selected"
                , Picker.view PickerChanged picker
                ]


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        Ready picker ->
            Picker.subscriptions PickerChanged picker

        Loading ->
            Sub.none


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
