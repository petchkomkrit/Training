package main

import (
	"github.com/petchkomkrit/Training/controller"
	"github.com/petchkomkrit/Training/internal/v1/calculate"
)

func main() {
	db := calculate.DB{
		A: 10,
		B: 5,
	}
	controller.Route(db)
}

// func main() {
// 	controller.Route()
// }
