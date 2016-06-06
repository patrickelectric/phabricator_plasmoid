import QtQuick 2.0
import QtQuick.Controls 1.5

TabView {
    anchors.fill: parent
    clip: true

    Tab {
        title: qsTr("Tasks")
        asynchronous: true
        clip: true
        TasksTab { }
    }
    Tab {
        title: qsTr("Reviews")
        asynchronous: true
        clip: true
        ReviewsTab { }
    }
    Tab {
        title: qsTr("Project")
        asynchronous: true
        clip: true
        ProjectTab { }
    }
    Tab {
        title: qsTr("Settings")
        SettingsTab { }
    }
}
