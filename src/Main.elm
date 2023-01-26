module Main exposing (..)

import Beer exposing (Beer)
import Browser
import Css
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode
import List.Extra as List


type alias Model =
    { search : String
    , beers : Dict Int (Result Http.Error (List Beer))
    , loadingFirstPage : Bool
    , page : Int
    , detailsId : Maybe Int
    }


type Msg
    = SetSearch String
    | Submit
    | GetPage Int
    | GotBeers Int (Result Http.Error (List Beer))
    | SetSelected Int


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { search = ""
      , beers = Dict.empty
      , loadingFirstPage = False
      , page = 1
      , detailsId = Nothing
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetSearch string ->
            ( { model | search = string }, Cmd.none )

        Submit ->
            ( { model
                | beers = Dict.empty
                , loadingFirstPage = True
                , page = 1
              }
            , getBeers model.search 1
            )

        GetPage page ->
            ( { model | page = page }
            , case Dict.get page model.beers of
                Just (Ok _) ->
                    Cmd.none

                _ ->
                    getBeers model.search page
            )

        GotBeers page result ->
            ( { model | beers = Dict.insert page result model.beers, loadingFirstPage = False }
            , Cmd.none
            )

        SetSelected int ->
            ( { model | detailsId = Just int }, Cmd.none )


getBeers : String -> Int -> Cmd Msg
getBeers search page =
    Http.get
        { url = "https://api.punkapi.com/v2/beers?per_page=10&page=" ++ String.fromInt page ++ "&beer_name=" ++ search
        , expect = Http.expectJson (GotBeers page) (Decode.list Beer.decoder)
        }


view : Model -> Html Msg
view model =
    div []
        [ node "style" [] [ text Css.css ]
        , searchForm model
        , div [ class "panels" ]
            [ if model.loadingFirstPage then
                text "Loading..."

              else if model.beers == Dict.empty then
                text ""

              else if Dict.get 1 model.beers == Just (Ok []) then
                text "Found no beers matching your search"

              else
                beerList model
            , detailsView model
            ]
        ]


searchForm : Model -> Html Msg
searchForm model =
    Html.form [ onSubmit Submit, class "form", id "searchForm" ]
        [ input
            [ onInput SetSearch
            , value model.search
            , placeholder "Search beers"
            ]
            []
        , button [] [ text "Search" ]
        ]


beerList : Model -> Html Msg
beerList model =
    div []
        [ div [ class "pagination" ]
            [ button
                [ onClick (GetPage (model.page - 1))
                , disabled (model.page <= 1)
                , id "prevPage"
                ]
                [ text "<" ]
            , text (String.fromInt model.page)
            , button
                [ onClick (GetPage (model.page + 1))
                , disabled
                    ((Dict.get model.page model.beers
                        |> Maybe.andThen Result.toMaybe
                        |> Maybe.withDefault []
                        |> List.length
                     )
                        < 10
                    )
                , id "nextPage"
                ]
                [ text ">" ]
            ]
        , case Dict.get model.page model.beers of
            Nothing ->
                div [ style "width" "300px" ] [ text "Loading..." ]

            Just (Err _) ->
                div []
                    [ div [] [ text "Something went wrong" ]
                    , button [ onClick Submit ] [ text "Try again" ]
                    ]

            Just (Ok []) ->
                text "Found no more beers matching your search"

            Just (Ok beers) ->
                div [ class "beerList" ]
                    (List.map
                        (\beer ->
                            div
                                [ onClick (SetSelected beer.id)
                                , tabindex 0
                                , class
                                    (if model.detailsId == Just beer.id then
                                        "selected"

                                     else
                                        ""
                                    )
                                ]
                                [ div [] [ text beer.name ]
                                , div [] [ text (String.fromFloat beer.abv ++ "%") ]
                                ]
                        )
                        beers
                    )
        ]


detailsView : Model -> Html msg
detailsView model =
    div [ class "details" ]
        (case model.detailsId of
            Just selected ->
                case
                    Dict.values model.beers
                        |> List.filterMap Result.toMaybe
                        |> List.concat
                        |> List.find (\beer -> beer.id == selected)
                of
                    Just beer ->
                        [ div []
                            [ h1 [] [ text beer.name ]
                            , p [] [ text beer.description ]
                            , b [] [ text (String.fromFloat beer.abv ++ "% ABV") ]
                            , h4 [] [ text "Pairs well with" ]
                            , ul [] (List.map (\food -> li [] [ text food ]) beer.foodPairing)
                            ]
                        , case beer.imageUrl of
                            Just url ->
                                img [ src url, class "bottle" ] []

                            Nothing ->
                                text ""
                        ]

                    Nothing ->
                        []

            Nothing ->
                []
        )
