/**
 * Form 초기화 - hidden, check, radio 적용
 */
HTMLFormElement.prototype.clear = function () {
    try {
        // 기본 Form Reset
        this.reset()

        // Hidden, Radio, Checkbox 적용
        Array.from(this.elements).forEach((el) => {
            switch (el.type.toLowerCase()) {
                case 'hidden':
                    el.value = '';
                    break;
                case 'radio':
                case 'checkbox':
                    el.checekd = false;
                    break;
                default:
                    break;
            }
        })
    } catch (error) {
        console.error(error)
    }
};

/**
 * Get Maximum value of Array
 */
Array.prototype.max = function () {
    return this.reduce((value1, value2) => {
        return value1 > value2 ? value1 : value2
    })
}

/**
 * Get Minimum value of Array
 */
Array.prototype.min = function () {
    return this.reduce((value1, value2) => {
        return value1 < value2 ? value1 : value2
    })
}

/**
 * Sort Array by field
 */
Array.prototype.sortBy = function (field, sort = 'asc') {
    return this.sort((value1, value2) => {
        return value1[field] > value2[field] ? (sort === 'asc' ? 1 : -1) : (sort === 'asc' ? -1 : 1)
    })
}

/**
 * Array GroupBy
 */
Array.prototype.groupBy = function (key) {
    return this.reduce((acc, curr) => {
        const obj = curr[key]
        acc[obj] = acc[obj] ?? []
        acc[obj].push(curr)
        return acc
    }, {})
};

/**
 * Array GroupBy With Sub Group
 */
Array.prototype.subGroupBy = function (props) {
    try {
        const {key, groupKey} = props

        return this.reduce((acc, curr) => {
            const obj = curr[key]
            if (!acc[obj]) {
                acc[obj] = curr
                acc[obj][groupKey] = []
            }
            acc[obj][groupKey].push(curr)
            return acc
        }, {})
    } catch (error) {
        return this
    }
};
