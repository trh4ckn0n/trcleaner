#!/usr/bin/env python3
import os
import shutil
import time
import yaml
import random
from datetime import datetime, timedelta
import questionary
from rich import print
from rich.console import Console
from rich.panel import Panel
import humanfriendly
from tqdm import tqdm

console = Console()

def print_banner():
    slogans = [
        "Cleaner by TRHACKNON",
        "Less trash, more space.",
        "Nettoyage cyberstylé.",
        "Ton stockage te dira merci !"
    ]
    console.print(Panel.fit(f"[bold green]trcleaner[/bold green] - [blue]by TRHACKNON[/blue][cyan]\n{random.choice(slogans)}[/cyan]",
                            border_style="bright_magenta", padding=(1, 4)))

def get_all_files(folder):
    file_list = []
    for root, _, files in os.walk(folder):
        for name in files:
            path = os.path.join(root, name)
            try:
                stat = os.stat(path)
                file_list.append({
                    "path": path,
                    "size": stat.st_size,
                    "mtime": stat.st_mtime
                })
            except:
                continue
    return file_list

def filter_files(files, min_size=0, max_age_days=None, extensions=None):
    now = time.time()
    results = []
    for f in files:
        if f['size'] < min_size:
            continue
        if max_age_days:
            if now - f['mtime'] < max_age_days * 86400:
                continue
        if extensions:
            if not any(f['path'].lower().endswith(ext.lower()) for ext in extensions):
                continue
        results.append(f)
    return results

def exclude_paths(files, exclude_list):
    return [f for f in files if not any(f['path'].startswith(e) for e in exclude_list)]

def action_delete(paths):
    for p in tqdm(paths, desc="Traitement", unit="fichier"):
        try:
            os.remove(p)
            console.print(f"[red]Supprimé[/red] {p}")
        except:
            console.print(f"[yellow]Erreur suppression[/yellow] {p}")

def action_move(paths, dest_folder):
    os.makedirs(dest_folder, exist_ok=True)
    for p in tqdm(paths, desc="Traitement", unit="fichier"):
        try:
            filename = os.path.basename(p)
            shutil.move(p, os.path.join(dest_folder, filename))
            console.print(f"[cyan]Déplacé[/cyan] {p}")
        except:
            console.print(f"[yellow]Erreur déplacement[/yellow] {p}")

def action_compress(paths, archive_name):
    with shutil.make_archive(archive_name, 'zip', root_dir=os.path.dirname(paths[0])) as archive:
        console.print(f"[green]Archive créée[/green] {archive}")

def load_yaml_config(path=".trcleaner.yaml"):
    if not os.path.exists(path):
        console.print("[bold red]Fichier de config YAML introuvable.[/bold red]")
        return None
    with open(path, "r") as f:
        return yaml.safe_load(f)

def main():
    print_banner()
    auto_mode = questionary.confirm("Activer le mode automatique via .yaml ?").ask()

    if auto_mode:
        config = load_yaml_config()
        if not config:
            return
        folder = config['config']['scan_path']
        exclude = config['config'].get('exclude_paths', [])
        filters = config['config']['filters']
        all_files = get_all_files(folder)
        all_files = exclude_paths(all_files, exclude)
        filtered = filter_files(
            all_files,
            min_size=filters.get('min_size_kb', 0) * 1024,
            max_age_days=filters.get('older_than_days'),
            extensions=filters.get('extensions')
        )
        dry = config['config'].get('dry_run', False)
        if dry:
            for f in filtered:
                console.print(f"[yellow][DRY-RUN][/yellow] {f['path']}")
            return

        action = config['config']['action']
        paths = [f['path'] for f in filtered]

        if action == "delete":
            action_delete(paths)
        elif action == "move":
            dest = config['config']['move_dest']
            action_move(paths, dest)
        elif action == "compress":
            name = config['config']['archive_name']
            action_compress(paths, name)
        return

    folder = questionary.path("Dossier à nettoyer ?").ask()
    all_files = get_all_files(folder)

    min_size = int(questionary.text("Taille min (en KB, ex: 5000)", default="0").ask())
    max_age = questionary.text("Âge max en jours (laisser vide pour ignorer)").ask()
    extensions = questionary.text("Extensions séparées par virgules (.zip,.mp4)", default="").ask()

    filtered = filter_files(
        all_files,
        min_size=min_size * 1024,
        max_age_days=int(max_age) if max_age else None,
        extensions=[e.strip() for e in extensions.split(",") if e.strip()]
    )

    files_str = "\n".join(
        f"[green]{f['path']}[/green] - {humanfriendly.format_size(f['size'])}" for f in filtered
    )
    console.print(Panel.fit(files_str, title=f"{len(filtered)} fichiers trouvés", border_style="cyan"))

    action = questionary.select("Action ?", choices=["delete", "move", "compress"]).ask()
    paths = [f['path'] for f in filtered]

    if action == "delete":
        action_delete(paths)
    elif action == "move":
        dest = questionary.path("Dossier de destination ?").ask()
        action_move(paths, dest)
    elif action == "compress":
        name = questionary.text("Nom d'archive (sans extension)").ask()
        shutil.make_archive(name, 'zip', root_dir=folder)
        console.print(f"[green]Archive {name}.zip créée[/green]")

if __name__ == "__main__":
    main()
