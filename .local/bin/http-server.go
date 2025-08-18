//usr/bin/env go run "$0" "$@"; exit "$?"
package main

import (
	"fmt"
	"net/http"
)

func main() {
	fmt.Println("Listening on 0.0.0.0:8000")
	http.ListenAndServe(":8000", http.FileServer(http.Dir(".")))
}
