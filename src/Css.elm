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
    padding:10px;
    background:white;
    border-radius:5px;
    border:none;
    box-shadow:1px 1px 4px inset rgba(0,0,0,0.3)
}
button{
    padding:10px 20px;
    margin:0px 10px;
    background:white;
    border-radius:5px;
    border:none;
    box-shadow:1px 2px 4px rgba(0,0,0,0.3), -1px -2px 3px inset rgba(0,0,0,0.1);
    cursor:pointer;
}
button:active{
    box-shadow:1px 1px 3px inset rgba(0,0,0,0.3)
}
button:disabled{
    pointer-events:none;
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
    box-shadow:1px 2px 4px rgba(0,0,0,0.3), -1px -2px 3px inset rgba(0,0,0,0.1);
}
.beerList >div.selected{
    box-shadow:1px 1px 4px inset rgba(0,0,0,0.3)
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
