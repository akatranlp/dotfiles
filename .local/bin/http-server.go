// &>/dev/null; /usr/bin/env go run "$0" "$@"; exit "$?"
package main

import (
	"flag"
	"fmt"
	"net/http"
	"net/http/httputil"
	"net/url"
	"strings"
)

func main() {
	proxy := flag.String("proxy", "", "Proxy specified path to address [/api:http://localhost:3000]")
	port := flag.Int("port", 8000, "port which the server is running on")
	flag.Parse()

	listenAddress := fmt.Sprintf(":%d", *port)
	if *proxy == "" {
		fmt.Printf("Listening on %s\n", listenAddress)
		if err := http.ListenAndServe(listenAddress, http.FileServer(http.Dir("."))); err != nil {
			panic(err)
		}
	}

	mux := http.NewServeMux()
	p := *proxy
	idx := strings.IndexByte(p, ':')
	if idx < 0 {
		panic("invalid argument")
	}
	path := p[:idx]
	address := p[idx+1:]
	target, err := url.Parse(address)
	if err != nil {
		panic(err)
	}
	mux.Handle(fmt.Sprintf("%s/", path), httputil.NewSingleHostReverseProxy(target))
	mux.Handle("/", http.FileServer(http.Dir(".")))
	fmt.Printf("Listening on %s\n", listenAddress)
	if err := http.ListenAndServe(listenAddress, mux); err != nil {
		panic(err)
	}
}
