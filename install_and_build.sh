#!/bin/bash

APP_NAME="trcleaner"
VERSION="1.0"
ARCH="all"
MAINTAINER="trhacknon <jeremydiliotti@gmail.com>"
DESCRIPTION="Script de nettoyage interactif pour Termux/Kali, fun, coloré et puissant."

BUILD_DIR="deb_build"
INSTALL_DIR="$BUILD_DIR/usr/local/bin"
CONTROL_DIR="$BUILD_DIR/DEBIAN"
EXAMPLES_DIR="examples"

# Vérification des arguments
if [ "$1" == "--generate-examples-only" ]; then
    echo "[*] Génération des fichiers YAML d'exemples uniquement..."

    mkdir -p "$EXAMPLES_DIR"

    cat > "$EXAMPLES_DIR/delete_big_apk_mp4.yaml" <<EOF
config:
  scan_path: "/sdcard/Download"
  exclude_paths:
    - "/sdcard/Download/dont_touch"
  filters:
    extensions: [".mp4", ".apk"]
    min_size_kb: 10000
    older_than_days: 15
  action: "delete"
  dry_run: false
EOF

    cat > "$EXAMPLES_DIR/move_old_zip.yaml" <<EOF
config:
  scan_path: "/sdcard/Download"
  exclude_paths: []
  filters:
    extensions: [".zip"]
    min_size_kb: 0
    older_than_days: 7
  action: "move"
  move_dest: "/sdcard/backup_zips"
  dry_run: false
EOF

    cat > "$EXAMPLES_DIR/compress_old_docs.yaml" <<EOF
config:
  scan_path: "/home/user/Documents"
  exclude_paths:
    - "/home/user/Documents/encours"
  filters:
    extensions: [".docx", ".pdf", ".xlsx"]
    min_size_kb: 200
    older_than_days: 60
  action: "compress"
  archive_name: "old_docs_backup"
  dry_run: false
EOF

    cat > "$EXAMPLES_DIR/dry_run_log_cleanup.yaml" <<EOF
config:
  scan_path: "/var/log"
  exclude_paths: []
  filters:
    extensions: [".log"]
    min_size_kb: 100
    older_than_days: 5
  action: "delete"
  dry_run: true
EOF

    cat > "$EXAMPLES_DIR/delete_old_torrents.yaml" <<EOF
config:
  scan_path: "/home/user/Torrents"
  exclude_paths: []
  filters:
    extensions: [".torrent"]
    min_size_kb: 0
    older_than_days: 10
  action: "delete"
  dry_run: false
EOF

    echo -e "[+] Fichiers YAML d'exemples générés dans le dossier [$EXAMPLES_DIR]"

    exit 0
fi

# Si l'argument n'est pas "--generate-examples-only", continue le processus normal d'installation

# Étape 1 : Installation des dépendances Python
echo "[*] Installation des dépendances Python..."
pip install questionary rich humanfriendly pyyaml tqdm
# pip install questionary rich humanfriendly pyyaml tqdm --break-system-packages

# Étape 2 : Créer le lien symbolique
chmod +x trcleaner.py
sudo ln -sf $(pwd)/trcleaner.py /usr/local/bin/trcleaner

# Étape 3 : Création du paquet .deb
echo "[*] Création du paquet .deb..."

rm -rf "$BUILD_DIR" "$APP_NAME.deb"
mkdir -p "$INSTALL_DIR" "$CONTROL_DIR"

cp trcleaner.py "$INSTALL_DIR/$APP_NAME"
chmod 755 "$INSTALL_DIR/$APP_NAME"

cat > "$CONTROL_DIR/control" <<EOF
Package: $APP_NAME
Version: $VERSION
Section: utils
Priority: optional
Architecture: $ARCH
Maintainer: $MAINTAINER
Description: $DESCRIPTION
EOF

chmod 755 "$CONTROL_DIR"
dpkg-deb --build "$BUILD_DIR" "$APP_NAME.deb"

if [ $? -eq 0 ]; then
    echo -e "\n[+] Paquet .deb créé : $APP_NAME.deb"
else
    echo -e "\n[!] Erreur lors de la création du paquet."
    exit 1
fi

# Étape 4 : Génération des fichiers d'exemples YAML
echo "[*] Génération des fichiers YAML d'exemples..."

mkdir -p "$EXAMPLES_DIR"

cat > "$EXAMPLES_DIR/delete_big_apk_mp4.yaml" <<EOF
config:
  scan_path: "/sdcard/Download"
  exclude_paths:
    - "/sdcard/Download/dont_touch"
  filters:
    extensions: [".mp4", ".apk"]
    min_size_kb: 10000
    older_than_days: 15
  action: "delete"
  dry_run: false
EOF

cat > "$EXAMPLES_DIR/move_old_zip.yaml" <<EOF
config:
  scan_path: "/sdcard/Download"
  exclude_paths: []
  filters:
    extensions: [".zip"]
    min_size_kb: 0
    older_than_days: 7
  action: "move"
  move_dest: "/sdcard/backup_zips"
  dry_run: false
EOF

cat > "$EXAMPLES_DIR/compress_old_docs.yaml" <<EOF
config:
  scan_path: "/home/user/Documents"
  exclude_paths:
    - "/home/user/Documents/encours"
  filters:
    extensions: [".docx", ".pdf", ".xlsx"]
    min_size_kb: 200
    older_than_days: 60
  action: "compress"
  archive_name: "old_docs_backup"
  dry_run: false
EOF

cat > "$EXAMPLES_DIR/dry_run_log_cleanup.yaml" <<EOF
config:
  scan_path: "/var/log"
  exclude_paths: []
  filters:
    extensions: [".log"]
    min_size_kb: 100
    older_than_days: 5
  action: "delete"
  dry_run: true
EOF

cat > "$EXAMPLES_DIR/delete_old_torrents.yaml" <<EOF
config:
  scan_path: "/home/user/Torrents"
  exclude_paths: []
  filters:
    extensions: [".torrent"]
    min_size_kb: 0
    older_than_days: 10
  action: "delete"
  dry_run: false
EOF

echo -e "[+] Fichiers YAML d'exemples générés dans le dossier [$EXAMPLES_DIR]"

# Fin
echo -e "\n[*] Installation terminée. Tu peux maintenant lancer [trcleaner] depuis le terminal."
