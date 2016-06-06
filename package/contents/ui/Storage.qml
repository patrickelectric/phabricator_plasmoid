import QtQuick 2.0
import QtQuick.LocalStorage 2.0 as Sql

// will be saved in ~/.local/share/Phabric_Temp/QML/OfflineStorage/Databases/
Item {

    function getDatabase() {
        return Sql.LocalStorage.openDatabaseSync("PhabricPlasmoid", "1.0", "Phabricator Plasmoid local storage", 1000000);
    }

    function save(setting, value) {
        var result = false;

        try {
            var db = getDatabase();
        } catch(e) {
            console.log("open database error:");
            console.log(e);
            return;
        }

        db.transaction(function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS settings(setting TEXT UNIQUE, value TEXT)');
            var rs = tx.executeSql("INSERT OR REPLACE INTO settings VALUES(?,?)", [setting,value]);
            result = rs.rowsAffected > 0;
        });

        return result;
    }

    function get(setting, defaultValue) {
        try {
            var db = getDatabase();
        } catch(e) {
            console.log("open database error:");
            console.log(e);
            return;
        }

        var result = defaultValue;

        try {
            db.transaction(function(tx) {
                var rs = tx.executeSql("SELECT value FROM settings WHERE setting='"+setting.trim()+"';");
                if (rs.rows.length > 0)
                    result = rs.rows.item(0).value;
           });
        } catch (e) {
            console.log("Database error:");
            console.log(e);
        };

        return result;
    }
}
