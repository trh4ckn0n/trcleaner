#!/bin/bash

APP_NAME="trcleaner"
VERSION="1.0"
ARCH="all"
MAINTAINER="trhacknon <you@example.com>"
DESCRIPTION="Script de nettoyage interactif pour Termux/Kali, fun, coloré et puissant."

BUILD_DIR="deb_build"
INSTALL_DIR="$BUILD_DIR/usr/local/bin"
CONTROL_DIR="$BUILD_DIR/DEBIAN"

# Étape 1 : Installation des dépendances Python
echo "Installation des dépendances Python..."
pip install questionary rich humanfriendly pyyaml

# Étape 2 : Créer le lien symbolique pour exécuter le script directement
chmod +x trcleaner.py
ln -sf $(pwd)/trcleaner.py /usr/local/bin/trcleaner

# Étape 3 : Création du paquet .deb
echo "Création du paquet .deb..."

# Nettoyage avant build
rm -rf "$BUILD_DIR" "$APP_NAME.deb"
mkdir -p "$INSTALL_DIR" "$CONTROL_DIR"

# Copie du script principal dans le dossier approprié
cp trcleaner.py "$INSTALL_DIR/$APP_NAME"
chmod 755 "$INSTALL_DIR/$APP_NAME"

# Création du fichier control pour le paquet .deb
cat > "$CONTROL_DIR/control" <<EOF
Package: $APP_NAME
Version: $VERSION
Section: utils
Priority: optional
Architecture: $ARCH
Maintainer: $MAINTAINER
Description: $DESCRIPTION
EOF

# Permissions correctes
chmod 755 "$CONTROL_DIR"

# Build du paquet .deb
dpkg-deb --build "$BUILD_DIR" "$APP_NAME.deb"

# Vérification du succès de la création du paquet
if [ $? -eq 0 ]; then
    echo -e "\n[+] Paquet .deb créé : $APP_NAME.deb"
else
    echo -e "\n[!] Erreur lors de la création du paquet."
    exit 1
fi

# Étape 4 : Fin de l'installation
echo "Installation terminée. Tu peux maintenant lancer [trcleaner] depuis le terminal."
