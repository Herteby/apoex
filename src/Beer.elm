module Beer exposing (Beer, decoder)

import Json.Decode as Decode exposing (..)


type alias Beer =
    { id : Int
    , name : String
    , imageUrl : Maybe String
    , abv : Float
    , description : String
    , foodPairing : List String
    }


decoder : Decoder Beer
decoder =
    Decode.map6 Beer
        (field "id" int)
        (field "name" string)
        (field "image_url" (maybe string))
        (field "abv" float)
        (field "description" string)
        (field "food_pairing" (list string))
