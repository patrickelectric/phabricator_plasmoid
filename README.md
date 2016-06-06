# Phabricator Plasmoid
a plasmoid to interact with [Phabricator] using [Conduit API] and [QML/Javascript]

- the plasmoid can list the tasks and reviews and filter by project, user or reviewer
- the plasmoid uses [QMl TabView] followed by settings tab with a form to configure the phabricator token, url and user email
- the plasmoid refresh the list after some time that it's configurable in the settings tab
- the plasmoid offers a button to force a update for tasks list and reviews
- the plasmoid uses a local storage supported by qml using pure javascript functions.
- the local storage it's placed in the user's home and can be opened using sqlite browser

 Tips and suggestions are welcome!
 
[//]: # (These are reference links used in the body)

[QML/Javascript]: <http://doc.qt.io/qt-5/qtqml-index.html>
[Phabricator]: <https://www.phacility.com/>
[QMl TabView]: <http://doc.qt.io/qt-5/qml-qtquick-controls-tabview.html>
[git-repo-url]: <https://github.com/joemccann/dillinger.git>
[Conduit API]: <https://secure.phabricator.com/book/phabricator/article/conduit/s>
[local storage]: <http://doc.qt.io/qt-5/qtquick-localstorage-qmlmodule.html>
