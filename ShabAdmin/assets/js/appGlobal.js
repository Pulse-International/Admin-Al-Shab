
function validateEmail(email) {
    var re = /\S+@\S+\.\S+/;
    return re.test(email);
}

function validatePhone(phone) {
    var re = /^([0-9])\d{7,14}$/;
    return re.test(phone);
}

function setCookie(c_name, value, exdays) {
    var exdate = new Date();
    exdate.setDate(exdate.getDate() + exdays);
    var c_value = escape(value) + ((exdays == null) ? "" : "; expires=" + exdate.toUTCString());
    document.cookie = c_name + "=" + c_value + "; path=/" + "; secure";
}

function getCookie(c_name) {
    var c_value = document.cookie;
    var c_start = c_value.indexOf(" " + c_name + "=");
    if (c_start == -1) {
        c_start = c_value.indexOf(c_name + "=");
    }
    if (c_start == -1) {
        c_value = null;
    }
    else {
        c_start = c_value.indexOf("=", c_start) + 1;
        var c_end = c_value.indexOf(";", c_start);
        if (c_end == -1) {
            c_end = c_value.length;
        }
        //c_value = decodeURI(c_value.substring(c_start, c_end));
        c_value = unescape(c_value.substring(c_start, c_end));
    }
    return c_value;
}
function getParameterByName(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, '\\$&');
    var regex = new RegExp('[?&]' + name + '(=([^&#]*)|&|#|$)'),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, ' '));
}

function GetURLParameter() {
    var sPageURL = window.location.href;
    var indexOfLastSlash = sPageURL.lastIndexOf("/");

    if (indexOfLastSlash > 0 && sPageURL.length - 1 != indexOfLastSlash) {
        var id = sPageURL.substring(indexOfLastSlash + 1);
        var realID;
        if (id.lastIndexOf("?") > 0)
            realID = id.substring(0, id.lastIndexOf("?"));
        else
            realID = id;
        return realID;
    }
    else
        return 0;
}

function replaceUrlParam(url, paramName, paramValue) {
    if (paramValue == null) {
        paramValue = '';
    }
    var pattern = new RegExp('\\b(' + paramName + '=).*?(&|#|$)');
    if (url.search(pattern) >= 0) {
        return url.replace(pattern, '$1' + paramValue + '$2');
    }
    url = url.replace(/[?#]$/, '');
    return url + (url.indexOf('?') > 0 ? '&' : '?') + paramName + '=' + paramValue;
}

function removeParam(key, sourceURL) {
    var rtn = sourceURL.split("?")[0],
        param,
        params_arr = [],
        queryString = (sourceURL.indexOf("?") !== -1) ? sourceURL.split("?")[1] : "";
    if (queryString !== "") {
        params_arr = queryString.split("&");
        for (var i = params_arr.length - 1; i >= 0; i -= 1) {
            param = params_arr[i].split("=")[0];
            if (param === key) {
                params_arr.splice(i, 1);
            }
        }
        rtn = rtn + "?" + params_arr.join("&");
    }
    return rtn;
}

function updateQueryStringParameter(uri, key, value) {
    var re = new RegExp("([?&])" + key + "=.*?(&|$)", "i");
    var separator = uri.indexOf('?') !== -1 ? "&" : "?";
    if (uri.match(re)) {
        return uri.replace(re, '$1' + key + "=" + value + '$2');
    }
    else {
        return uri + separator + key + "=" + value;
    }
}

function createDate(days, months, years) {
    var date = new Date();
    date.setDate(date.getDate() + days);
    date.setMonth(date.getMonth() + months);
    date.setFullYear(date.getFullYear() + years);
    return date;
}

const getDateTime = (date) => {
    var month = date.getMonth() + 1;
    var days = date.getDate();
    month = month < 10 ? '0' + month : month;
    days = days < 10 ? '0' + days : days;
    var dateOnly = date.getFullYear() + '-' + month + '-' + days;
    let hours = date.getHours();
    let minutes = date.getMinutes();
    const ampm = hours >= 12 ? 'PM' : 'AM';
    hours = hours % 12;
    hours = hours ? hours : 12; // the hour '0' should be '12'
    hours = hours < 10 ? '0' + hours : hours;
    minutes = minutes < 10 ? '0' + minutes : minutes;
    return dateOnly + ' ' + hours + ':' + minutes + ' ' + ampm;
};

function dateDiff(date) {   
    var diff = new Date(Date.parse(date));
    diff.setMinutes(diff.getMinutes() + M_Diff);
    return (diff);
}

function isNumeric(str) {
    if (typeof str != "string") return false
    return !isNaN(str) && !isNaN(parseFloat(str))
}
function isArabic(text) {
    var arabic = /[\u0600-\u06FF]/;
    result = arabic.test(text);
    return result;
}
function LowerCount(inputString) {
    let count = 0;
    for (const char of inputString) {
        if (char.match(/[a-z]/)) {
            count += 1;
        }
    }
    return count;
}