module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode as D exposing (..)



---- MODEL ----


type Model
    = Failure
    | Loading
    | Success (List VirtualInstance)


type alias Flags =
    { env : String
    , host : String
    , authToken : String
    , basicAuth : String
    }


type alias VirtualInstance =
    { active : Bool
    , companyId : Int
    , domain : String
    , webId : String
    , virtualHost : String
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( Loading, getVirtualInstances flags )



---- UPDATE ----


type Msg
    = GotVirtualInstances (Result Http.Error (List VirtualInstance))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotVirtualInstances result ->
            case result of
                Ok virtualInstances ->
                    ( Success virtualInstances, Cmd.none )

                Err _ ->
                    ( Failure, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    case model of
        Failure ->
            div [ class "fetch-virtual-instances" ]
                [ div [ class "alert alert-danger", attribute "role" "alert" ]
                    [ p [ class "text-center" ] [ text "Looks Something went wrong when fetch the list of virtual instances." ]
                    ]
                ]

        Loading ->
            div [ class "fetch-virtual-instances" ]
                [ span [ class "loading-animation loading-animation" ] []
                ]

        Success virtualInstances ->
            div [ class "fetch-virtual-instances" ]
                [ h1 [ class "text-center mb-4" ] [ text "Virtual Instances" ]
                , div [ class "container" ]
                    [ table [ class "table table-hover" ]
                        [ thead []
                            [ tr []
                                [ th [ class "text-center" ] [ text "Company ID" ]
                                , th [ class "text-center" ] [ text "Domain" ]
                                , th [ class "text-center" ] [ text "Web ID" ]
                                , th [ class "text-center" ] [ text "Virtual Host" ]
                                , th [ class "text-center" ] [ text "Active" ]
                                ]
                            ]
                        , tbody
                            []
                            (List.map virtualInstanceRow virtualInstances)
                        ]
                    ]
                ]


virtualInstanceRow : VirtualInstance -> Html Msg
virtualInstanceRow virtualInstance =
    let
        activeStatusCell =
            if virtualInstance.active then
                td [ attribute "style" "color: var(--green);" ] [ text "✔" ]

            else
                td [ attribute "style" "color: var(--red);" ] [ text "✗" ]
    in
    tr []
        [ td [] [ text (String.fromInt virtualInstance.companyId) ]
        , td [] [ text virtualInstance.domain ]
        , td [] [ text virtualInstance.webId ]
        , td [] [ text virtualInstance.virtualHost ]
        , activeStatusCell
        ]


virtualInstanceDecoder : Decoder VirtualInstance
virtualInstanceDecoder =
    D.map5 VirtualInstance
        (field "active" bool)
        (field "companyId" int)
        (field "domain" string)
        (field "portalInstanceId" string)
        (field "virtualHost" string)


virtualInstanceListDecoder : Decoder (List VirtualInstance)
virtualInstanceListDecoder =
    field "items" (D.list virtualInstanceDecoder)


getVirtualInstances : Flags -> Cmd Msg
getVirtualInstances flags =
    case flags.env of
        "development" ->
            Http.request
                { method = "GET"
                , headers = [ Http.header "Authorization" flags.basicAuth ]
                , url = flags.host ++ "/o/headless-portal-instances/v1.0/portal-instances"
                , body = Http.emptyBody
                , expect = Http.expectJson GotVirtualInstances virtualInstanceListDecoder
                , timeout = Nothing
                , tracker = Nothing
                }

        _ ->
            Http.request
                { method = "GET"
                , headers = []
                , url = "/o/headless-portal-instances/v1.0/portal-instances?p_auth=" ++ flags.authToken
                , body = Http.emptyBody
                , expect = Http.expectJson GotVirtualInstances virtualInstanceListDecoder
                , timeout = Nothing
                , tracker = Nothing
                }



---- PROGRAM ----


main : Program Flags Model Msg
main =
    Browser.element
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
