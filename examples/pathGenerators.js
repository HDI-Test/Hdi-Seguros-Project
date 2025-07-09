'use strict'

module.exports={
    'jenkins-trigger': (key, rawPayload) => {
        const payload = JSON.parse(rawPayload)
        return `/jenkins/job/co-hdi-acc-sandbox/job/dev/job/${payload.jobId}/buildWithParameters`
    },
}