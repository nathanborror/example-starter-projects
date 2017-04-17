module Main exposing (..)

import Html exposing (Html, div, text)
import GraphQL.Request.Builder exposing (..)
import GraphQL.Request.Builder.Arg as Arg
import GraphQL.Request.Builder.Variable as Var
import GraphQL.Client.Http as GraphQLClient
import Http
import Task exposing (Task)


-- Me


type alias Account =
    { name : String
    }


meQuery : Document Query Account {}
meQuery =
    let
        account =
            object Account
                |> with (field "name" [] string)

        queryRoot =
            extract
                (field "me" [] account)
    in
        queryDocument queryRoot


meQueryRequest : Request Query Account
meQueryRequest =
    meQuery
        |> request {}


sendMeQuery : Cmd Msg
sendMeQuery =
    sendQueryRequest meQueryRequest
        |> Task.attempt QueryResponse



-- Authentication


type alias AuthenticateVars =
    { email : String
    , password : String
    }


authenticateMutation : Document Mutation String AuthenticateVars
authenticateMutation =
    let
        emailVar =
            Var.required "email" .email Var.string

        passwordVar =
            Var.required "password" .password Var.string
    in
        mutationDocument <|
            extract
                (field "authenticate"
                    [ ( "email", Arg.variable emailVar )
                    , ( "password", Arg.variable passwordVar )
                    ]
                    (extract (field "token" [] string))
                )


authenticationMutationRequest : Request Mutation String
authenticationMutationRequest =
    authenticateMutation
        |> request { email = "nathan@nathanborror.com", password = "n" }


sendAuthenticationMutation : Cmd Msg
sendAuthenticationMutation =
    sendMutationRequest authenticationMutationRequest
        |> Task.attempt AuthenticationResponse



-- App


type alias Model =
    { account : Maybe Account
    , error : Maybe GraphQLClient.Error
    }


type Msg
    = QueryResponse (Result GraphQLClient.Error Account)
    | AuthenticationResponse (Result GraphQLClient.Error String)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


init : ( Model, Cmd Msg )
init =
    ( Model Nothing Nothing, sendMeQuery )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        QueryResponse (Ok account) ->
            ( { model | account = Just account }, Cmd.none )

        QueryResponse (Err err) ->
            ( { model | account = Nothing, error = Just err }, Cmd.none )

        AuthenticationResponse (Ok token) ->
            ( model, Cmd.none )

        AuthenticationResponse (Err err) ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    case model.account of
        Just account ->
            div [] [ text account.name ]

        Nothing ->
            viewError model.error


viewError : Maybe GraphQLClient.Error -> Html Msg
viewError error =
    case error of
        Just err ->
            case err of
                GraphQLClient.HttpError _ ->
                    div [] [ text "http error" ]

                GraphQLClient.GraphQLError _ ->
                    div [] [ text "graphql error" ]

        Nothing ->
            text ""


sendQueryRequest : Request Query a -> Task GraphQLClient.Error a
sendQueryRequest request =
    let
        authorization =
            Http.header "Authorization" "Bearer YOUR_AUTH_TOKEN"

        options =
            { method = "POST"
            , headers = [ authorization ]
            , url = "http://localhost:8080/graphql"
            , timeout = Nothing
            , withCredentials = False
            }
    in
        GraphQLClient.customSendQuery options request


sendMutationRequest : Request Mutation a -> Task GraphQLClient.Error a
sendMutationRequest request =
    let
        authorization =
            Http.header "Authorization" "Bearer YOUR_AUTH_TOKEN"

        options =
            { method = "POST"
            , headers = [ authorization ]
            , url = "http://localhost:8080/graphql"
            , timeout = Nothing
            , withCredentials = False
            }
    in
        GraphQLClient.customSendMutation options request
