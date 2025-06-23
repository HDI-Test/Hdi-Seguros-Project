'use strict'

module.exports = {
    'jenkins-token': (key, payload) => {
        return {
            'content-type': 'x-form-urlencoded',
            'Authorization': 'Basic change-me'
        }
    },
}