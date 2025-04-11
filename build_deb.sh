#!/bin/bash

APP_NAME="trcleaner"
VERSION="1.0"
ARCH="all"
MAINTAINER="trhacknon <you@example.com>"
DESCRIPTION="Script de nettoyage interactif pour Termux/Kali, fun, coloré et puissant."

BUILD_DIR="deb_build"
INSTALL_DIR="$BUILD_DIR/usr/local/bin"
CONTROL_DIR="$BUILD_DIR/DEBIAN"

# Nettoyage avant build
rm -rf "$BUILD_DIR" "$APP_NAME.deb"
mkdir -p "$INSTALL_DIR" "$CONTROL_DIR"

# Copie du script principal
cp trcleaner.py "$INSTALL_DIR/$APP_NAME"
chmod 755 "$INSTALL_DIR/$APP_NAME"

# Fichier control
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

# Build du .deb
dpkg-deb --build "$BUILD_DIR" "$APP_NAME.deb"

# Résultat
if [ $? -eq 0 ]; then
    echo -e "\n[+] Paquet .deb créé : $APP_NAME.deb"
else
    echo -e "\n[!] Erreur lors de la création du paquet."
fi
