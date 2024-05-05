// api.go

package main

import (
	"encoding/json"
	"net/http"
)

func StartServer(graph *CodeGraph) {
	http.HandleFunc("/nodes", func(w http.ResponseWriter, _ *http.Request) {
		// For simplicity, let's return all nodes. You can add query params to filter nodes.
		err := json.NewEncoder(w).Encode(graph.Nodes)
		if err != nil {
			return
		}
	})

	http.HandleFunc("/source-sink-analysis", func(w http.ResponseWriter, r *http.Request) {
		query := r.URL.Query()
		sourceMethod := query.Get("sourceMethod")
		sinkMethod := query.Get("sinkMethod")

		if sourceMethod == "" || sinkMethod == "" {
			http.Error(w, "sinkMethod and sourceMethod query parameters are required", http.StatusBadRequest)
			return
		}

		result := AnalyzeSourceSinkPatterns(graph, sourceMethod, sinkMethod)
		// Return the result as JSON
		// set json content type
		w.Header().Set("Content-Type", "application/json")
		err := json.NewEncoder(w).Encode(result)
		if err != nil {
			return
		}
	})

	// create a http handler to respond with index.html file content
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		// Read the index.html file from html directory
		http.ServeFile(w, r, "html/index.html")
	})

	//nolint:all
	err := http.ListenAndServe(":8080", nil)
	if err != nil {
		return
	}
}
