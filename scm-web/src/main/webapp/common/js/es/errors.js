/**
 * Szms Error
 */
class SzmsError extends Error {
    /**
     * @param {{
     *     msg: string,
     *     args: {
     *         msgAttrs?: array,
     *         msgType?: string,
     *         _callback?: function,
     *         cause?: Response
     *     }
     * }}
     */
    constructor({msg, ...args}) {
        super(msg)
        this.msg = msg
        this.msgAttrs = args.msgAttrs
        this.msgType = args.msgType || 'alert'
        this._callback = args._callback
        this.response = args.cause
    }

    /* 콜백 호출 */
    doCallback = () => {
        if (this._callback && this._callback instanceof Function) {
            this._callback()
        }
    }

    /* 메시지 처리 */
    doMessaging = async () => {
        return await szms.modal.alert({msg: this.msg, msgAttrs: this.msgAttrs})
    }
}

/**
 * System Error
 */
class SystemError extends SzmsError {
    constructor(args) {
        super(args)
    }

    /* 메인 이동 */
    doExit = async () => {
        await szms.modal.error({msg: 'C0011'})
        document.location.href = _ctxPath + _LOGIN_URL
    }
}

/**
 * Api Error
 */
class ApiError extends SzmsError {
    constructor(args) {
        super(args)
    }

    // TODO: Messaging By Response Status
}

/**
 * Validate Error
 */
class ValidationError extends SzmsError {
    constructor(args) {
        super(args)
    }

    doMessaging = async () => {
        if (this.msgType === 'alert') {
            return await szms.modal.alert({msg: this.msg, msgAttrs: this.msgAttrs})
        }
        if (this.msgType === 'error') {
            return await szms.modal.error({msg: this.msg, msgAttrs: this.msgAttrs})
        }
        // ...
    }
}

/**
 * Handling error by Error Type
 */
const errorHandler = {
    apply: async (error) => {
        if (error instanceof ValidationError) {
            await error.doMessaging()
            error.doCallback()
        } else if (error instanceof ApiError) {
            await error.doMessaging()
        } else if (error instanceof SystemError) {
            await error.doExit()
        }

        if (error && error.response) {
            console.error(error.response)
        }
    }
}
