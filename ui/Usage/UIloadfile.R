
GetUIload_file<- function(){
    div(id="Load_file",
    class="section scrollpsy",
    br(tags$h3("Load File")),
    style="white-space: initial;",
    p(stri_rand_lipsum(1, start_lipsum = TRUE)))
}