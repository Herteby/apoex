module Css exposing (css)


css : String
css =
    """
body{
    font-family:sans-serif;
}
h1{
    margin-top:0;
}
input{
    padding:5px;
}
button{
    padding:5px 15px;
    margin:0px 5px;
}
.form{
    display:flex;
    justify-content:center;
    padding:20px;
}
.panels {
    display:flex;
    justify-content:center;
}
.pagination{
    display:flex;
    justify-content:center;
    align-items:center;
    margin-bottom:10px;
}
.beerList > div{
    width:300px;
    padding:5px 10px;
    display:flex;
    justify-content:space-between;
    cursor:pointer;
    border-radius:5px;
    white-space:no-wrap;
    text-overflow: ellipsis
}
beerList > div:not(:last-child){
    border-bottom:1px solid #ddd;
}
.beerList > div:hover{
    background:#f3f3f3;
}
.beerList >div.selected{
    background:#b7e0f0;
}
.details {
    width:600px;
    margin-left:20px;
    display:flex;
}
.bottle {
    height:300px;
    margin-left:20px;
}
    """
