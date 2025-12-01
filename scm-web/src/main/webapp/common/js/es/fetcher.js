const _fetcher = {
    options: {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        }
    },
    /**
     * Handle not caught Error
     * @param response
     * @returns {Promise.reject}
     */
    errorHandler: (response) => {
        switch (response.status) {
            case '302':
            case '403':
                return Promise.reject(new SystemError())
            case '404':
                return Promise.reject(new ApiError({cause: response, msg: 'C0038'}))
            default:
                return Promise.reject(new ApiError({cause: response, msg: 'C0015'}))
        }
    }
}

/**
 * Fetch without callback
 * @param {string} url
 * @param {object} params
 * @param {object} options
 * @returns {Promise}
 */
const fetchData = async (url, params = {}, options = {}) => {
    _fetcher.options = {..._fetcher.options, ...options}
    _fetcher.options.headers[_sch] = _scn
    _fetcher.options.body = JSON.stringify(params)

    try {
        szms.loading.start()

        const response = await fetch(url, _fetcher.options)
        if (response.ok) {
            return response.json()
        }

        return _fetcher.errorHandler(response)
    } catch (error) {
        return Promise.reject(new SystemError())
    } finally {
        szms.loading.end()
        session.clearTime()
    }
}
