import QtQuick 2.5
import QtQuick.Controls 1.4

Item {
    id: requesterApi
    state: "stopped"

    property bool debug: false
    property string requestMessage
    readonly property string url: settingsApi.info.host + "/api/"

    Timer {
        id: requestTimmer
        running: requesterApi.state === "running"
        interval: 30000
    }

    function isSuccess(statusCode) {
        return (200 === statusCode || 201 === statusCode);
    }

    function debugRequest(requestType, requestPath, xhr) {
        if (debug) {
            console.log("");
            console.log("-- debugging request --");
            console.log("request type: " + requestType);
            console.log("request uri: " + requesterApi.url + requestPath);
            console.log("xhr response text: " + xhr.responseText);
            console.log("xhr readyState: " + xhr.readyState);
            console.log("xhr status code: " + xhr.status);
            console.log("-- debugging request --");
            console.log("");
        }
    }

    function serialize(obj) {
        var pairs = [];
        for (var prop in obj) {
            if (!obj.hasOwnProperty(prop))
                continue;

            if (typeof obj[prop] === '[object Object]') {
                pairs.push(serialiseObject(obj[prop]));
                continue;
            }
            pairs.push(prop + '=' + obj[prop]);
        }
        return pairs.join('&');
    }

    function request(requestType, requestPath, dataToSend, callback) {
        var xhr = new XMLHttpRequest();

        xhr.open(requestType, requesterApi.url + requestPath, true);

        xhr.onerror = function() {
            requestTimmer.stop();
            xhr.abort();
            requesterApi.state = "stopped";
        };

        requestTimmer.triggered.connect(function() {
            state = "aborted";
            xhr.abort();
        });

        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                debugRequest(requestType, requestPath, xhr);

                requestTimmer.stop();
                requesterApi.state = "stopped";

                try {
                    callback(JSON.parse(xhr.responseText), parseInt(xhr.status));
                } catch(e) {
                    console.error("error on parse result to callback!");
                    console.error("----");
                    console.error(e);
                    console.error("----");
                    callback({}, 0);
                }
            }
        }

        xhr.setRequestHeader("Content-Type", "application/json");
        xhr.setRequestHeader("Content-Length", parseInt(dataToSend ? dataToSend.length : 1));

        state = "running";     // start countdown
        xhr.send(dataToSend);  // start the request
    }

    function put(path, dataToSend, callback) {
        requesterApi.request("PUT", path, dataToSend || 0, callback);
    }

    function get(path, dataToSend, callback) {
         requesterApi.request("GET", path, dataToSend || 0, callback);
    }

    function post(path, dataToSend, callback) {
        requesterApi.request("POST", path, dataToSend || 0, callback);
    }
}
