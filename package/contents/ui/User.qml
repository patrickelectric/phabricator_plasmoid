import QtQuick 2.0

Item {

    property var info: {
        var infoTemp = __storage.get("user_settings", []);

        if (!infoTemp.length)
            return {}

        return JSON.parse(infoTemp);
    }

    function reset() {
        save({});
    }

    function save(json, userEmail) {
        if (userEmail)
            json["email"] = userEmail;

        storage.save("user_settings", JSON.stringify(json));

        info = json;
    }

    function update(userEmail) {
        if (!userEmail || !settingsApi.info.token) return;

        var params = {
            "api.token": settingsApi.info.token,
            "emails[0]": userEmail
        };

        requesterApi.requestMessage = "Loading user informations...";
        requesterApi.post("user.query", requesterApi.serialize(params), function (jsonResult, statusCode) {
            if (!requesterApi.isSuccess(statusCode))
                setResponseErrorMessage("The request resulted in an error! The server response with status: " + statusCode);
            else if (jsonResult && jsonResult.result)
                save(jsonResult.result[0], userEmail);
            else
                setResponseErrorMessage(jsonResult.error_info);
        });
    }
}
