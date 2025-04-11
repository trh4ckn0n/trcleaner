# Exemples de configuration YAML pour `trcleaner`

Voici plusieurs exemples de fichiers `.yaml` que vous pouvez utiliser avec **trcleaner** selon différents scénarios.

---

### 1. Nettoyage des vidéos et APK trop lourds dans les téléchargements

```yaml
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
```

---

2. Déplacement des fichiers ZIP vieux de plus de 7 jours vers un dossier backup

```yaml
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
```

---

3. Compression des documents de travail après 60 jours

```yaml
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
```

---

4. Mode test (dry-run) pour voir ce qui serait supprimé

```yaml
config:
  scan_path: "/var/log"
  exclude_paths: []
  filters:
    extensions: [".log"]
    min_size_kb: 100
    older_than_days: 5
  action: "delete"
  dry_run: true
```

---

5. Suppression automatique des anciens fichiers torrents

```yaml
config:
  scan_path: "/home/user/Torrents"
  exclude_paths: []
  filters:
    extensions: [".torrent"]
    min_size_kb: 0
    older_than_days: 10
  action: "delete"
  dry_run: false
```

---
