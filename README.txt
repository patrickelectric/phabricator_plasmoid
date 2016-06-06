# tutorial: https://techbase.kde.org/Development/Tutorials/Plasma4/JavaScript/GettingStarted
# ver também: https://techbase.kde.org/Development/Tutorials/Plasma5/QML2/GettingStarted
# ver também: https://phabricator.kde.org/D623

# Para instalar (rodar dentro da pasta do dentro do diretório):
plasmapkg -i .

# Para remover (rodar dentro da pasta do dentro do diretório):
plasmapkg -r . && rm -R /home/joseneas/.kde4/share/apps/plasma/plasmoids/PhabricatorPlasmoid

# Caso erros na remoção, remover manualmente em: /home/joseneas/.kde4/share/apps/plasma/plasmoids/

# Para rodar uma demo (dentro do diretório - Usar o nome do applet informado em "Name=PhabricatorPlasmoid" no metadata.desktop)
plasmoidviewer PhabricatorPlasmoid

# Packaging
# Run the following from within the PhabricatorPlasmoid directory:
zip -r ../PhabricatorPlasmoid.zip . &&
mv ../PhabricatorPlasmoid.zip ../PhabricatorPlasmoid.plasmoid

# Implementações:
Audit           - Browse and Audit Commits - https://**phabricator_url**/audit
Maniphest       - Tasks and Bugs - https://**phabricator_url**/maniphest
Differential    - Review Code - https://**phabricator_url**/differential
