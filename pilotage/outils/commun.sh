# Fonctions communes aux scripts d'exécution (à sourcer, pas à lancer). ADR 0001, section
# « Les outils d'exécution ».
#
# Variables (toutes facultatives) :
#   NEMETON_CACHE       traces des sessions (défaut ~/.cache/nemetonplateforme), jetables
#   NEMETON_DEV         dossier des dépôts (défaut ~/dev)
#   NEMETON_RENVIRON    fichier d'environnement de la base de test, HORS dépôt, avec un mot
#                       de passe : modèle `renviron.exemple` (défaut ~/.config/nemetonplateforme/renviron)
#   NEMETON_CONTENEUR   conteneur de la base (défaut nemeton_timescaledb)
#   SEUIL_CHARGE_IO     seuil de pression d'E/S en % (défaut 60)
#   FENETRE_CHARGE_IO   avg10, avg60 ou avg300 (défaut avg60 : 60 s)
#   PRESSURE_IO_FICHIER fichier lu (défaut /proc/pressure/io ; pour les essais)
#   A_BLANC=1           affiche la commande au lieu de la lancer
OUTILS=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
DEPOT=$(cd "$OUTILS/../.." && pwd)
CACHE=${NEMETON_CACHE:-$HOME/.cache/nemetonplateforme}
DEV=${NEMETON_DEV:-$HOME/dev}
RENVIRON=${NEMETON_RENVIRON:-$HOME/.config/nemetonplateforme/renviron}
CONTENEUR=${NEMETON_CONTENEUR:-nemeton_timescaledb}

# Contrôle de charge décidé au bilan du 2026-11-20 : s'arrête (code 3) si le disque est saturé.
controle_charge() {
  local f=${PRESSURE_IO_FICHIER:-/proc/pressure/io} seuil=${SEUIL_CHARGE_IO:-60} fen=${FENETRE_CHARGE_IO:-avg60} v num='^[0-9]+([.][0-9]+)?$'
  if [[ ! $seuil =~ $num ]]; then echo "contrôle de charge : SEUIL_CHARGE_IO='$seuil' non numérique, seuil par défaut (60)" >&2; seuil=60; fi
  if [ ! -r "$f" ]; then echo "contrôle de charge ignoré : $f illisible" >&2; return 0; fi
  v=$(awk -v k="$fen" '$1=="some"{for(i=2;i<=NF;i++){split($i,a,"=");if(a[1]==k)print a[2]}}' "$f")
  if [ -z "$v" ]; then echo "contrôle de charge ignoré : $fen introuvable dans $f (format inattendu)" >&2; return 0; fi
  if [[ ! $v =~ $num ]]; then echo "contrôle de charge ignoré : valeur '$v' non numérique dans $f" >&2; return 0; fi
  if awk -v v="$v" -v s="$seuil" 'BEGIN{exit !(v+0>s+0)}'; then
    echo "ARRÊT : pression d'E/S ($fen) à $v % pour un seuil de $seuil % ; attendre que le disque se libère ou régler SEUIL_CHARGE_IO (ADR 0001, « Les outils d'exécution »)." >&2
    return 3
  fi
}

# Charge l'environnement de la base (si le fichier existe) ; sinon le dit sur stderr.
charge_renviron() {
  if [ -f "$RENVIRON" ]; then set -a; . "$RENVIRON"; set +a; return 0; fi
  echo "pas de fichier d'environnement ($RENVIRON) : tests d'intégration de la base ignorés" >&2; return 1
}
