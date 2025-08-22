# Note App 📝

Une application de prise de notes en Markdown simple, élégante et moderne pour Android.

![Flutter](https://img.shields.io/badge/Flutter-3.13+-blue.svg)
![Android](https://img.shields.io/badge/Android-21+-green.svg)
![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)

## ✨ Fonctionnalités

- 📝 **Création et édition de notes en Markdown** - Rédigez vos notes avec la syntaxe Markdown
- 👁️ **Aperçu en temps réel** - Visualisez le rendu de votre Markdown instantanément
- 💾 **Stockage local** - Vos notes sont sauvegardées localement sur votre appareil
- 🔍 **Recherche intégrée** - Trouvez rapidement vos notes par titre ou contenu
- 📱 **Interface moderne** - Design Material avec animations fluides
- 📊 **Statistiques** - Consultez les statistiques de vos notes
- 🎨 **Thème adaptatif** - Compatible avec tous les écrans Android
- ⚡ **Performance optimisée** - Application légère et réactive

## 🖼️ Captures d'écran

### Page d'accueil
- 🌟 Splash screen avec logo animé
- 📋 Liste de toutes vos notes triées par date
- ➕ Bouton flottant pour ajouter une nouvelle note
- 🔍 Barre de recherche intégrée

### Édition de notes
- ✏️ Éditeur Markdown avec coloration syntaxique
- 👁️ Onglet d'aperçu en temps réel
- 💡 Aide intégrée pour la syntaxe Markdown
- 💾 Sauvegarde automatique des modifications

## 🚀 Installation

### Option 1: Télécharger l'APK (Recommandé)
1. Allez dans les [Releases](../../releases) du projet
2. Téléchargez le fichier `.apk` le plus récent
3. Installez l'APK sur votre appareil Android
4. Lancez l'application "Note"

### Option 2: Compiler depuis le code source

#### Prérequis
- Flutter SDK (3.13 ou supérieur)
- Android SDK (API 21+)
- Android Studio ou VS Code avec extensions Flutter

#### Étapes
```bash
# Cloner le repository
git clone [URL_DU_REPO]
cd note_app

# Installer les dépendances
flutter pub get

# Lancer l'application en mode debug
flutter run

# Ou construire l'APK de release
flutter build apk --release
```

## 📚 Guide d'utilisation

### Créer une nouvelle note
1. Appuyez sur le bouton `+` flottant
2. Saisissez un titre pour votre note
3. Rédigez votre contenu en Markdown dans l'onglet "Édition"
4. Consultez le rendu dans l'onglet "Aperçu"
5. Appuyez sur "Enregistrer"

### Syntaxe Markdown supportée
```markdown
# Titre 1
## Titre 2
### Titre 3

**Texte en gras**
*Texte en italique*

- Liste à puces
1. Liste numérotée

[Lien](https://example.com)
`Code en ligne`

```
Bloc de code
```

> Citation
```

### Modifier une note
1. Appuyez sur une note dans la liste
2. Modifiez le titre ou le contenu
3. L'aperçu se met à jour en temps réel
4. Appuyez sur "Mettre à jour"

### Supprimer une note
1. Appuyez sur les 3 points sur une note
2. Sélectionnez "Supprimer"
3. Confirmez la suppression

### Rechercher dans les notes
1. Utilisez la barre de recherche en haut
2. Tapez votre requête
3. Les résultats s'affichent instantanément

## 🔧 Configuration technique

### Dépendances principales
- `flutter_markdown` - Rendu Markdown
- `shared_preferences` - Stockage local
- `provider` - Gestion d'état
- `intl` - Formatage des dates

### Compatibilité Android
- **Version minimale**: Android 5.0 (API 21)
- **Version cible**: Android 13 (API 33)
- **Architectures**: ARM64, ARMv7

### Permissions requises
- `INTERNET` - Pour les liens externes dans les notes (optionnel)

## 🤖 CI/CD avec GitHub Actions

Ce projet utilise GitHub Actions pour :
- ✅ Analyser le code automatiquement
- 🧪 Exécuter les tests
- 📦 Construire l'APK et l'AAB
- 🚀 Créer des releases automatiques

Le workflow se déclenche sur :
- Push vers `main` ou `master`
- Pull requests
- Déclenchement manuel

## 🏗️ Architecture

```
lib/
├── models/          # Modèles de données
│   └── note.dart
├── pages/           # Pages de l'application
│   ├── splash_page.dart
│   ├── home_page.dart
│   └── note_editor_page.dart
├── services/        # Services métier
│   └── note_service.dart
├── widgets/         # Widgets réutilisables
│   └── note_card.dart
└── main.dart        # Point d'entrée
```

## 🎨 Design System

### Couleurs
- **Primaire**: Bleu Material (#2196F3)
- **Accent**: Bleu foncé (#1976D2)
- **Arrière-plan**: Gris clair (#F5F5F5)
- **Surface**: Blanc (#FFFFFF)

### Typographie
- **Police**: Roboto
- **Tailles**: 32px (titres), 24px (sous-titres), 16px (corps)

## 📋 Roadmap

### Version 1.1 (Prochaine)
- [ ] Export des notes en PDF
- [ ] Import/Export JSON
- [ ] Thème sombre
- [ ] Synchronisation cloud (optionnelle)

### Version 1.2
- [ ] Support d'images dans les notes
- [ ] Catégories et tags
- [ ] Widgets Android
- [ ] Raccourcis rapides

## 🤝 Contribution

Les contributions sont les bienvenues ! Pour contribuer :

1. Fork le projet
2. Créez une branche feature (`git checkout -b feature/AmazingFeature`)
3. Committez vos changements (`git commit -m 'Add: Amazing Feature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrez une Pull Request

## 📄 Licence

Distribué sous licence MIT. Voir `LICENSE` pour plus d'informations.

## 📞 Support

Si vous rencontrez des problèmes :
1. Consultez les [Issues](../../issues) existantes
2. Créez une nouvelle issue avec des détails
3. Incluez votre version d'Android et les logs si possible

## ⭐ Remerciements

- [Flutter Team](https://flutter.dev) pour le framework
- [Material Design](https://material.io) pour les guidelines
- [Flutter Markdown](https://pub.dev/packages/flutter_markdown) pour le rendu Markdown
- La communauté Flutter pour l'inspiration

---

**Développé avec ❤️ en France**
