#!/bin/bash
echo "Installation de trcleaner..."

pip install questionary rich humanfriendly pyyaml

chmod +x trcleaner.py
ln -sf $(pwd)/trcleaner.py /usr/local/bin/trcleaner

echo "Tu peux maintenant lancer [ trcleaner ] depuis le terminal."
