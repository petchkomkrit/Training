package main

import (
	"net/http"
)

type listAllResponse struct {
	Header listAllHeaderResponse `json:"header"`
	Body   listAllBodyResponse   `json:"body"`
}

type listAllHeaderResponse struct {
	Code        int    `json:"code"`
	Description string `json:"description"`
}

type listAllBodyResponse struct {
	Productlist []struct {
		ProductID    int    `json:"product_id"`
		ProductName  string `json:"product_name"`
		ProductPrice string `json:"product_price"`
		ProductURL   string `json:"product_url"`
	} `json:"productlist"`
}

func main() {
	http.HandleFunc("/products", listAllHandle)
	http.ListenAndServe(":8080", nil)
}

func listAllHandle(w http.ResponseWriter, r *http.Request) {

}
