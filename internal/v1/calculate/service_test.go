package calculate

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func Test_ConnectDB_success1(t *testing.T) {

	db := DB{
		A: 10,
		B: 5,
	}

	expect := 15
	result := db.ConnectDB()

	assert.Equal(t, expect, result)
}

type DBMockIntf interface {
	ConnectDB() int
}

type DBMock struct {
	Result int
}

func (m DBMock) ConnectDB() int {
	return m.Result
}

func Test_ConnectDB_success(t *testing.T) {

	db := DBMock{
		Result: 25,
	}

	expect := 15
	result := db.ConnectDB()

	assert.Equal(t, expect, result)
}
