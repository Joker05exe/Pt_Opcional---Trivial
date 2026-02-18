# Pt_Trivial

Una aplicació de Trivial desenvolupada amb **Flutter** que consumeix preguntes des d'una API remota (JSON), gestiona puntuacions i classifica visualment les preguntes per categories.

## 📋 Funcionalitats

* **Càrrega de Dades Remota:** Obtenció de preguntes mitjançant petició HTTP GET.
* **Gestió de JSON:** Parseig de dades i descodificació d'entitats HTML (ex: `&quot;`).
* **Sistema de Joc:**
    * Preguntes seqüencials.
    * Barreja aleatòria de respostes (*Shuffle*) perquè la correcta no estigui sempre a la mateixa posició.
    * Sistema de Puntuació: **+10 punts** (encert) / **-5 punts** (error).
    * Feedback visual immediat (Verd/Vermell) en respondre.
* **Disseny Visual:**
    * Colors consistents per a cada categoria (Ciència = Verd, Art = Groc, etc.).
    * Indicador de progrés i puntuació en temps real.
* **Pantalles:**
    1.  Càrrega (Spinner).
    2.  Joc (Pregunta i Opcions).
    3.  Resultat Final (Puntuació total i botó de reiniciar).

## 📂 Estructura del Projecte

El codi font es troba dins de la carpeta `lib/` organitzat de la següent manera:

```text
lib/
├── models/
│   └── question.dart         # Model de dades i lògica de parseig JSON
├── screens/
│   ├── game_screen.dart      # Pantalla principal del joc (Lògica d'estat)
│   └── result_screen.dart    # Pantalla de puntuació final
├── utils/
│   └── category_colors.dart  # Mapa de colors estàtic per categories
└── main.dart                 # Punt d'entrada de l'aplicació# Pt_Opcional---Trivial
