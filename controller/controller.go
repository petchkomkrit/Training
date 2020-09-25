package controller

import (
	"fmt"

	"github.com/petchkomkrit/Training/internal/v1/calculate"
)

func Route(db calculate.DBIntf) {
	fmt.Printf("%+v\n", db.ConnectDB())
}

// func Route() {
// 	fmt.Printf("%+v\n", calculate.ConnectDB(10, 5))
// }
