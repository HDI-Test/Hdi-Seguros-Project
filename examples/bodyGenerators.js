'use strict'

module.exports={
    'to-form-url-encoded': (key, payload) => {
        const form = new URLSearchParams()
        for (const [formKey, val] of Object.entries(payload)) {
            form.append(formKey, val)
        }
        return form.toString()
    },
}