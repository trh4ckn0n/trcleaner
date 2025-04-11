# trcleaner - Outil de nettoyage interactif

**trcleaner** est un script de nettoyage interactif conçu pour vous aider à gérer l'espace de stockage de manière fun et efficace. Il est principalement destiné aux utilisateurs de Termux/Kali, mais peut être utilisé sur d'autres systèmes Linux. Ce script permet de supprimer, déplacer ou compresser des fichiers en fonction de différents filtres de taille, âge et extension.

## Fonctionnalités :
- Suppression de fichiers inutiles
- Déplacement de fichiers vers un dossier de destination
- Compression d'archives ZIP
- Interface en ligne de commande interactive et colorée
- Mode automatique via un fichier de configuration YAML

## Prérequis :
- Python 3.x
- Les bibliothèques Python suivantes :
  - `questionary`
  - `rich`
  - `humanfriendly`
  - `pyyaml`
  - `tqdm`

## Installation

### Méthode 1 : Installation avec le fichier `.deb`

1. Téléchargez le fichier `.deb` depuis la section "Releases" de ce dépôt.

2. Installez le paquet `.deb` :

   Sur une distribution Debian/Ubuntu, exécutez la commande suivante pour installer le fichier `.deb` :

   ```bash
   sudo dpkg -i trcleaner_1.0_all.deb
   ```

   Si vous avez des erreurs de dépendances, corrigez-les avec :

   ```bash
   sudo apt-get install -f
   ```

3. Vous pouvez maintenant utiliser **trcleaner** en lançant la commande suivante dans votre terminal :

   ```bash
   trcleaner
   ```

### Méthode 2 : Installation via `pip`

Si vous préférez ne pas utiliser le fichier `.deb`, vous pouvez installer les dépendances nécessaires et utiliser **trcleaner** directement depuis le code source.

1. Clonez ce dépôt :

   ```bash
   git clone https://github.com/username/trcleaner.git
   cd trcleaner
   ```

2. Installez les dépendances Python :

   ```bash
   pip install -r requirements.txt
   ```

3. Rendez le script exécutable :

   ```bash
   chmod +x trcleaner.py
   ```

4. Exécutez le script :

   ```bash
   python3 trcleaner.py
   ```

## Utilisation

Lorsque vous lancez le programme, vous aurez deux options :
- **Mode interactif** : Vous pouvez sélectionner un dossier, définir des filtres (taille minimale, âge maximal des fichiers, extensions), puis choisir une action (supprimer, déplacer, ou compresser les fichiers).
- **Mode automatique** : Si un fichier de configuration `.yaml` est présent, le script fonctionnera en mode automatique pour effectuer les actions spécifiées dans ce fichier.

### Exemple de fichier de configuration YAML (`.trcleaner.yaml`)

```yaml
config:
  scan_path: "/home/user/Downloads"
  exclude_paths:
    - "/home/user/Downloads/excluded_folder"
  filters:
    min_size_kb: 100
    older_than_days: 30
    extensions:
      - ".mp4"
      - ".zip"
  action: "delete"
  dry_run: false
  move_dest: "/home/user/Archive"
  archive_name: "archive"
```

## Aide et Support

Si vous avez des problèmes ou des questions, n'hésitez pas à ouvrir une **issue** sur GitHub.

## Contribuer

Les contributions sont les bienvenues ! Si vous souhaitez améliorer **trcleaner**, vous pouvez :
1. Forker ce dépôt.
2. Créer une branche de développement.
3. Soumettre une pull request avec vos améliorations.

## Licence

Ce projet est sous licence [MIT](LICENSE).
