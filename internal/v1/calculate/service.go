package calculate

type DB struct {
	A int
	B int
}

type DBIntf interface {
	ConnectDB() int
}

func (db DB) ConnectDB() int {
	return db.A + db.B
}

// func ConnectDB(a int, b int) int {
// 	return a + b
// }
