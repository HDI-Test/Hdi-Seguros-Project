'use strict'

module.exports={
    'jenkins-trigger': (key, rawPayload) => {
        const payload = JSON.parse(rawPayload)
        return `/job/${payload.jobId}/buildWithParameters?token=${payload.token}`
    },
}