package main

import (
	"flag"
	"net/http"
)

func main() {
	path := flag.String("path", "/repo", "path to repo")
	addr := flag.String("addr", ":8080", "addr:host on which to bind")
	flag.Parse()
	http.Handle("/", http.FileServer(http.Dir(*path)))
	http.ListenAndServe(*addr, nil)
}
