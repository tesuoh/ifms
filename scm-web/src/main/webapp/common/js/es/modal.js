/**
 * Modal With Promise, Without Callback
 *  - 확인, 취소에 따른 Promise를 return 한다.
 */
szms.modal = {
    /**
     * Modal 창 호출
     * @param {{ ID: string, TEMPLATE: function }} type
     * @param {{
     *      msg: string, msgAttrs: array,
     *      title?: string, guide?: { yes: string, no: string },
     *      id?: string, message?: string
     *  }} props
     * @param { function? } eventHandler
     * @returns {Promise}
     * @private
     */
    _openModal: (type, props, eventHandler) => {
        return new Promise((resolve, reject) => {
            // Modal Active Handle
            window[type.ID] = window[type.ID] || false
            if (window[type.ID]) {
                reject({isDuplicated: true})
            }

            // Modal Dom Handle
            props.id = `modal_${Math.random().toString(36).substring(2, 11)}`
            props.message = szms.modal._getMessage(props)

            document.querySelector('body').insertAdjacentHTML('beforeend', type.TEMPLATE(props))
            window[type.ID] = true

            // Modal Event Handle
            eventHandler = eventHandler || function () {
                const $modal = document.querySelector('#' + props.id)
                $modal.querySelector('#confirmYes').addEventListener(
                    'click',
                    () => {
                        window[type.ID] = false
                        $modal.closest('.alert_wrap').remove()

                        return resolve()
                    })
            }
            eventHandler(props, resolve, reject)
        })
    },

    /**
     * translate message
     *
     * @param {{msg: string, msgAttrs: array}} props
     * @returns {boolean|*|string}
     * @private
     */
    _getMessage: ({msg, msgAttrs}) => {
        if (!/^[A-Z][0-9]{4}$/.test(msg)) {
            return msg
        }

        if (!szms.mssageInfo[msg]) {
            return '메시지코드가 일치하지 않습니다.\n메시지코드를 확인해 주세요.'
        }

        return szms.getMsg(msg, msgAttrs)
    },

    /**
     * 메시지 Alert
     * @param {{ msg: string, msgAttrs?: array }} props
     * @returns {Promise}
     */
    alert: (props) => {
        const type = {
            ID: 'ALERT_ALIVE',
            TEMPLATE: szms.modal.template.ALERT_TEMPLATE
        }

        return szms.modal._openModal(type, props)
    },

    /**
     * 메시지 Error
     * @param {{ msg: string, msgAttrs?: array }} props
     * @returns {Promise}
     */
    error: (props) => {
        const type = {
            ID: 'ERROR_ALIVE',
            TEMPLATE: szms.modal.template.ERROR_TEMPLATE
        }

        return szms.modal._openModal(type, props)
    },

    /**
     * 메시지 Confirm
     * @param {{
     *      msg: string, msgAttrs?: array,
     *      title?: string, guide?: { yes: string, no: string }
     * }} props
     * @returns {Promise}
     */
    confirm: (props) => {
        const type = {
            ID: 'CONFIRM_ALIVE',
            TEMPLATE: szms.modal.template.CONFIRM_TEMPLATE
        }

        // Button Event Bind
        const _eventHandler = (_props, _resolve, _reject) => {
            const $modal = document.querySelector('#' + _props.id)
            $modal.querySelectorAll('.confirm').forEach(el => {
                el.addEventListener('click', () => {
                    window[type.ID] = false
                    $modal.closest('.msgBoxWrap').remove()

                    return el.id === 'confirmYes' ? _resolve() : _reject({isCancel: true})
                })
            })
        }

        return szms.modal._openModal(type, props, _eventHandler)
    }
}

szms.modal.template = {
    ALERT_TEMPLATE: (props) => {
        return `
            <div id='${props.id}' class='alert_wrap' style='display: block;'>
                <div class='alert_layout' style='width:400px;'>
                    <div class='alert_cont'>${props.message}</div>
                    <div class='modal_btnWrap'>
                        <a href='javascript:;' class='btnType type02' id='confirmYes'>확인</a>
                    </div>
                </div>
                <div class='modal_bottom'></div>
            </div>
        `
    },
    CONFIRM_TEMPLATE: (props) => {
        return `
            <div id='${props.id}' class='msgBoxWrap' style='display: block;'>
                <div class='msgBoxWrap_1' style='width:380px;'>
                    <h2>${props.title || '확인'}</h2>
                    <div class='msgBox'>
                        <h5>${props.message}</h5>
                        <ul>
                            <li>${props.guide?.yes || '예 : 삭제'}</li>
                            <li>${props.guide?.no || '아니오 : 현재 화면 유지'}</li>
                        </ul>
                    </div>
             
                    <div class='msgBox_btn'>
                        <a href='javascript:;' class='btnType type03 confirm' id='confirmNo'>아니오</a>
                        <a href='javascript:;' class='btnType type02 confirm' id='confirmYes'>예</a>
                    </div>
                </div>
                <div class='msgBox_bottom'></div>
            </div>
        `
    },
    ERROR_TEMPLATE: (props) => {
        return `
            <div id='${props.id}' class='alert_wrap' style='display: block;'>
                <div class='alert_layout' style='width:400px;'>
                    <div class='alert_cont'>${props.message}<br /><br />${_ERROR_CONTACT_MSG_TEXT}</div>
                    <div class='modal_btnWrap'>
                        <a href='javascript:;' class='btnType type02' id='confirmYes'>확인</a>
                    </div>
                </div>
                <div class='modal_bottom'></div>
            </div>
        `
    }
}
