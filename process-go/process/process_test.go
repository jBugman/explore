package process

import "testing"
import "github.com/stretchr/testify/assert"

func TestProcess(t *testing.T) {
	assert.Nil(t, Run("Name", "../../test_data"))
}
