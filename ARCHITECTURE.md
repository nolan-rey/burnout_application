# Call of Phoenix — Architecture & Documentation Complète

> Flutter 3 · Dart · API CallOfPhoenix (`http://98.66.235.57`)

---

## Table des matières

1. [Vue d'ensemble](#1-vue-densemble)
2. [Structure du projet](#2-structure-du-projet)
3. [Flux d'authentification](#3-flux-dauthentification)
4. [Couche Services](#4-couche-services)
5. [Modèles de données](#5-modèles-de-données)
6. [Écrans & Navigation](#6-écrans--navigation)
7. [Widgets réutilisables](#7-widgets-réutilisables)
8. [Système de thème](#8-système-de-thème)
9. [Flux de données complet](#9-flux-de-données-complet)
10. [État actuel : API vs Mock](#10-état-actuel--api-vs-mock)
11. [Ce qu'il reste à connecter](#11-ce-quil-reste-à-connecter)
12. [Conventions de code](#12-conventions-de-code)

---

## 1. Vue d'ensemble

**Call of Phoenix** est une application mobile Flutter (iOS / Android / macOS) de fitness et coaching. Elle permet de :
- Se connecter via **Firebase Auth** (JWT renvoyé par l'API)
- Consulter et gérer des **programmes d'entraînement**
- Suivre des **séances en direct** (timer, sets, poids, RPE)
- Rejoindre des **événements** et **challenges**
- Interagir avec des **coachs**
- Partager ses séances dans un **feed social**

**Stack :**
| Côté | Technologie |
|---|---|
| Frontend | Flutter 3 / Dart |
| UI | Glass morphism, Google Fonts (Inter), Backdrop Blur |
| Auth | Firebase JWT via API custom |
| HTTP | package `http` ^1.2.1 |
| Persistance token | `shared_preferences` ^2.3.2 |
| Backend | PHP 8.4 · Slim · Firebase Auth · MariaDB 11.4 |
| Base URL | `http://98.66.235.57` |

---

## 2. Structure du projet

```
lib/
├── main.dart                         # Point d'entrée, init AuthService
│
├── models/
│   ├── user.dart                     # Profil utilisateur complet
│   ├── coach.dart                    # Profil coach
│   ├── event.dart                    # Événement / cours collectif
│   ├── session.dart                  # Session simple (carte prochaine séance)
│   ├── challenge.dart                # Challenge 30 jours
│   └── workout_session.dart          # Séance complète (blocks/exercices/sets)
│
├── services/
│   ├── auth_service.dart             # Gestion token JWT (SharedPreferences)
│   ├── api_service.dart              # Client HTTP → API CallOfPhoenix
│   └── mock_data_service.dart        # Données mockées (dev / offline)
│
├── screens/
│   ├── login_page.dart               # Connexion → ApiService.login()
│   ├── register_page.dart            # Inscription multi-étapes (5 steps)
│   ├── main_shell.dart               # Shell avec BottomNav (5 onglets)
│   ├── home_page.dart                # Dashboard
│   ├── events_page.dart              # Calendrier + challenges
│   ├── create_event_page.dart        # Formulaire création événement
│   ├── event_detail_page.dart        # Détail + inscription événement
│   ├── feed_page.dart                # Feed social
│   ├── coach_page.dart               # Annuaire coachs
│   ├── profile_page.dart             # Profil utilisateur
│   ├── imc_calculator_page.dart      # Calculateur IMC
│   ├── session_detail_page.dart      # Aperçu séance avant lancement
│   ├── workout_timer_page.dart       # Timer séance active
│   ├── workout_rpe_page.dart         # Sondage RPE post-séance
│   └── workout_summary_page.dart     # Résumé + partage feed
│
├── theme/
│   └── app_theme.dart                # Couleurs, gradients, ThemeData
│
└── widgets/
    ├── glass_card.dart               # Carte glassmorphism réutilisable
    └── bottom_nav_bar.dart           # Barre de nav animée (shader liquide)
```

---

## 3. Flux d'authentification

```
main()
  └── AuthService().init()            # Charge token depuis SharedPreferences
        ↓
  MaterialApp → LoginPage
        ↓
  _onLogin()
    └── ApiService().login(email, pwd)
          POST /users/login
          ↓ 200 OK { token: "eyJ..." }
          ↓
        AuthService().saveToken(token) # SharedPreferences + mémoire
          ↓
        Navigator.pushReplacement → MainShell
```

**Token :**
- Stocké dans `SharedPreferences` clé `auth_token`
- Injecté automatiquement dans chaque requête protégée via `_authHeaders`
- Expire après **1 heure** (limite Firebase)
- Au prochain démarrage, `AuthService.init()` le recharge — l'utilisateur reste connecté jusqu'à expiration

**Déconnexion :**
```dart
await AuthService().logout(); // efface SharedPreferences
Navigator.pushReplacement → LoginPage
```

---

## 4. Couche Services

### 4.1 `AuthService` — `lib/services/auth_service.dart`

Singleton. Gère le cycle de vie du token JWT.

| Méthode / Propriété | Description |
|---|---|
| `init()` | À appeler dans `main()` — charge le token persisté |
| `token` | Token en mémoire (nullable) |
| `isLoggedIn` | `true` si token non null et non vide |
| `saveToken(String)` | Sauvegarde en mémoire + SharedPreferences |
| `logout()` | Efface mémoire + SharedPreferences |

```dart
// Utilisation type
await AuthService().init();       // main()
await AuthService().saveToken(t); // après login
await AuthService().logout();     // déconnexion
bool ok = AuthService().isLoggedIn;
```

---

### 4.2 `ApiService` — `lib/services/api_service.dart`

Singleton. Toutes les requêtes HTTP vers l'API.

**Constante :**
```dart
static const String _baseUrl = 'http://98.66.235.57';
```

**Headers automatiques :**
- Public : `Content-Type: application/json`
- Protégé : `Content-Type + Authorization: Bearer <token>`

**Gestion d'erreur :**
Toutes les réponses `>= 400` lèvent une `ApiException(statusCode, message)`.

```dart
class ApiException implements Exception {
  final int statusCode;
  final String message;
}
```

**Routes disponibles :**

| Méthode Dart | HTTP | Endpoint | Auth |
|---|---|---|---|
| `login(email, pwd)` | POST | `/users/login` | ❌ |
| `getApiStatus()` | GET | `/` | ❌ |
| `getUsers()` | GET | `/users` | 🔒 |
| `getProgrammes()` | GET | `/programmes` | 🔒 |
| `createProgramme(data)` | POST | `/programmes` | 🔒 |
| `updateProgramme(id, data)` | PUT | `/programmes/{id}` | 🔒 |
| `deleteProgramme(id)` | DELETE | `/programmes/{id}` | 🔒 |

**Exemple d'utilisation :**
```dart
// Login
try {
  final ok = await ApiService().login('email@test.com', 'password');
} on ApiException catch (e) {
  // e.statusCode == 401 → mauvais identifiants
}

// Récupérer les programmes
final List<Map<String, dynamic>> progs = await ApiService().getProgrammes();

// Créer un programme
await ApiService().createProgramme({
  'nom_programme': 'Mon Programme',
  'description': 'Description',
  'id_client': 3,
  'id_createur': 1,
  'date_debut': '2026-04-01',
  'date_fin': '2026-12-31',
});
```

---

### 4.3 `MockDataService` — `lib/services/mock_data_service.dart`

Singleton. Données statiques pour le développement offline.

| Méthode | Retourne |
|---|---|
| `events` | `List<Event>` — 3 événements |
| `coaches` | `List<Coach>` — 6 coachs |
| `challenges` | `List<Challenge>` — 3 challenges |
| `currentUser` | `User` — Thomas Anderson |
| `nextSession` | `Session` — Chest Day |
| `getEventById(id)` | `Event?` |
| `getCoachById(id)` | `Coach?` |
| `getChallengeById(id)` | `Challenge?` |
| `getEventsByCategory(cat)` | `List<Event>` filtré |
| `registerForEvent(eventId)` | `bool` — incrémente participants |
| `joinChallenge(challengeId)` | `bool` — marque comme rejoint |
| `getTodayWorkoutSession()` | `WorkoutSession` complet (Chest Day) |
| `getSessionsForDate(date)` | `List<WorkoutSession>` selon jour semaine |
| `login(email, pwd)` | `bool` — toujours true si champs non vides (**⚠️ non utilisé en prod**) |
| `createAccount(user)` | `bool` — ajoute à liste locale (**⚠️ non persisté**) |

> **Note :** `MockDataService.login()` n'est plus appelé — le `login_page.dart` utilise désormais `ApiService().login()`.

---

## 5. Modèles de données

### 5.1 `User`

```dart
User {
  int id
  String email, password, firstName, lastName
  String get fullName             // '$firstName $lastName'
  String gender, bloodType, favoriteSport
  DateTime? birthDate
  int get age                     // calculé depuis birthDate
  double height, weight
  double get bmi                  // weight / (height/100)²
  String membershipLevel          // ex: 'Phoenix Elite'
  int memberSince, weeklyVisits, caloriesBurned
  String imageUrl, phone, address, city, country
  // Santé
  String personalPhysicalFatigue, personalMentalFatigue
  String medicalCondition, movementLimitations
  // Lifestyle
  String sleepQuality, dietQuality, tobaccoConsumption
  List<SportActivity> sportActivities
  List<ProfessionalActivity> professionalActivities
}
```

### 5.2 `Coach`

```dart
Coach {
  int id
  String name, specialty, imageUrl
  String availability              // ex: 'Disponible aujourd\'hui à 14h'
  bool isAvailable, isPro
}
```

### 5.3 `Event`

```dart
Event {
  int id
  String title, category, description
  DateTime date
  Duration startTime, endTime
  String location, locationDetail, imageUrl
  double price
  int maxParticipants, currentParticipants
  List<String> participantAvatars
  Coach coach
  String intensity, level
  // Helpers
  String get formattedDate        // '12 Oct. 2024' (French)
  String get formattedStartTime   // '10:00'
  String get formattedEndTime     // '11:00'
  String get spotsLeft            // '4 places restantes'
  bool get isFull
}
```

### 5.4 `Challenge`

```dart
Challenge {
  int id
  String title, imageUrl, iconName, todayTask
  int totalDays, completedDays
  bool isJoined
  List<bool>? dayCompletionStatus
  // Helpers
  double get progressPercentage   // 0.0 → 1.0
  int get remainingDays
  String get progressDisplay      // '10/30 jours'
}
```

### 5.5 `WorkoutSession` & hiérarchie

```
WorkoutSession
  ├── id, title, programName, weekLabel, sessionLabel
  ├── type (MUSCU / CARDIO)
  ├── date, time, Coach coach
  └── List<WorkoutBlock> blocks
        └── name
            └── List<WorkoutExercise> exercises
                  ├── id, name, seriesCount, repsPerSerie
                  ├── recupSeconds, note
                  └── List<WorkoutSet> sets
                        ├── setNumber
                        ├── reps? weight? duration?
                        └── isCompleted (mutable)
```

### 5.6 `Session` (carte résumé)

```dart
Session {
  int id
  String title, category, imageUrl
  DateTime date
  Duration time
  Coach coach
  String get dateTimeDisplay      // 'Aujourd\'hui · 17:30'
}
```

---

## 6. Écrans & Navigation

### 6.1 Arbre de navigation

```
LoginPage
  └── (success) → MainShell ──────── IndexedStack (5 onglets)
  └── RegisterPage                      ├── [0] HomePage
        └── (success) → MainShell       ├── [1] EventsPage
                                        │     ├── → EventDetailPage
                                        │     │     └── (inscription mock)
                                        │     └── → CreateEventPage
                                        ├── [2] FeedPage
                                        ├── [3] CoachPage
                                        └── [4] ProfilePage
                                              └── → ImcCalculatorPage

HomePage
  ├── → SessionDetailPage (prochaine séance)
  │     └── → WorkoutTimerPage
  │           └── → WorkoutRpePage
  │                 └── → WorkoutSummaryPage
  │                       └── (pop to) MainShell
  └── → EventDetailPage (événement en banner)

ChallengePage (depuis EventsPage ou HomePage)
  └── (rejoindre challenge via mock)
```

### 6.2 Détail de chaque écran

#### `LoginPage`
- **Service :** `ApiService().login()`
- **Erreurs gérées :** 401 (mauvais identifiants), réseau inaccessible, autres erreurs serveur
- **Navigation :** `pushReplacement → MainShell`

#### `RegisterPage`
- **Service :** `MockDataService().createAccount()` ⚠️ **non connecté API**
- **5 étapes :** Identité → Statut/Fatigue → Adresse → Lifestyle → Qualité de vie
- **Controllers :** 15+ TextEditingController
- **Navigation :** `pushReplacement → MainShell`

#### `MainShell`
- **Widget :** `IndexedStack` — préserve l'état de chaque onglet
- **Tabs :**

| Index | Icône | Écran |
|---|---|---|
| 0 | `home_rounded` | `HomePage` |
| 1 | `calendar_month_rounded` | `EventsPage` |
| 2 | `dynamic_feed_rounded` | `FeedPage` |
| 3 | `sports_gymnastics` | `CoachPage` |
| 4 | `person_rounded` | `ProfilePage` |

#### `HomePage`
- **Service :** `MockDataService()` ⚠️
- **Affiche :** stats user, prochaine session, événements, challenges

#### `EventsPage`
- **Service :** `MockDataService()` ⚠️
- **Sélecteur de date :** semaine courante, tap → liste des séances du jour
- **Challenges :** grille de jours avec statut de complétion

#### `WorkoutTimerPage`
- **State local** (aucun service)
- **Timer :** `Ticker` Flutter (60fps), comptage en secondes
- **Navigation :** `sets → exercices → blocks → WorkoutRpePage`
- **Récupération :** countdown automatique entre les séries

#### `WorkoutSummaryPage`
- **Service :** `MockDataService()` ⚠️
- **Post feed :** local uniquement, non envoyé à l'API

---

## 7. Widgets réutilisables

### 7.1 `GlassCard` — `lib/widgets/glass_card.dart`

```dart
GlassCard({
  Widget? child,
  double? width, height,
  EdgeInsetsGeometry? padding, margin,
  double blurSigma,             // défaut: 20
  double borderRadius,          // défaut: 20
  Gradient? gradient,
  Color? glowColor,             // ajoute BoxShadow coloré
  VoidCallback? onTap,
})
```

Utilise `BackdropFilter` + `ImageFilter.blur`. Le gradient par défaut est `AppColors.liquidGlassGradient`.

### 7.2 `AppBottomNavBar` — `lib/widgets/bottom_nav_bar.dart`

```dart
AppBottomNavBar({
  required int currentIndex,
  required ValueChanged<int> onTap,
})
```

**Animations :**
- `SpringSimulation` pour le déplacement de l'indicateur liquide
- `FragmentShader` pour l'effet bulle/étirement
- `Ticker` via `SingleTickerProviderStateMixin`
- Drag horizontal → snap à l'onglet le plus proche

**Items :**
```dart
[Home, Events, Feed, Coach, Profile]
```

---

## 8. Système de thème

### 8.1 Palette `AppColors`

```dart
// Primaires
primary      = Color(0xFF3B82F6)   // Bleu
primaryLight = Color(0xFF60A5FA)   // Bleu clair
primaryDark  = Color(0xFF2563EB)   // Bleu foncé
accent       = Color(0xFFF59E0B)   // Ambre

// Fonds
backgroundDark = Color(0xFF0F172A) // Navy black
surfaceDark    = Color(0xFF1E293B) // Navy clair
cardDark       = Color(0xFF334155) // Gris
navDark        = Color(0xFF0B1221) // Plus sombre

// Status
success = Color(0xFF10B981)
warning = Color(0xFFF59E0B)
error   = Color(0xFFEF4444)
info    = Color(0xFF06B6D4)

// Glass
glassBorder    = Colors.white.withValues(alpha: 0.12)
glassHighlight = Colors.white.withValues(alpha: 0.2)
glassShadow    = Colors.black.withValues(alpha: 0.3)
textMuted      = Color(0xFF94A3B8)
```

### 8.2 Gradients

```dart
primaryGradient      // Blue → Purple (135°)
glassGradient        // Transparent glass (3 stops)
liquidGlassGradient  // Glass avancé (4 stops, plus lumineux en haut)
darkOverlay          // transparent → black
heroOverlay          // overlay complexe pour images hero
```

### 8.3 Typographie

Police : **Inter** (Google Fonts)
- Titres : `w800`, letterSpacing: `-1`
- Sous-titres : `w600`
- Corps : `w400`-`w500`
- Muted : `AppColors.textMuted`

---

## 9. Flux de données complet

### Flux Login (réel, API connectée)

```
LoginPage._onLogin()
  │
  ├── validation locale (champs non vides)
  │
  └── ApiService().login(email, password)
        │
        POST http://98.66.235.57/users/login
        Body: { email, password }
        │
        ├── 200 { success: true, token: "eyJ..." }
        │     └── AuthService().saveToken(token)
        │           └── SharedPreferences['auth_token'] = token
        │               _token = token
        │               → MainShell
        │
        ├── 401 { success: false, error: "Invalid credentials" }
        │     └── ApiException(401, "Invalid credentials")
        │           └── SnackBar "Email ou mot de passe incorrect"
        │
        └── réseau KO
              └── catch Exception
                    └── SnackBar "Impossible de contacter le serveur"
```

### Flux Séance d'entraînement (mock)

```
HomePage → "Commencer la séance"
  │
  └── SessionDetailPage (MockDataService.nextSession)
        │
        └── WorkoutTimerPage (MockDataService.getTodayWorkoutSession())
              │  Ticker 60fps
              │  blocks[i].exercises[j].sets[k]
              │  isCompleted = true par set
              │
              └── WorkoutRpePage
                    │  RPE 1-10 + Mood emoji
                    │
                    └── WorkoutSummaryPage
                          │  Post optionnel (texte + photo)
                          │
                          └── pop → MainShell
```

### Flux Programmes (API connectée, non utilisé dans UI)

```dart
// Disponible dans ApiService, à brancher dans les écrans
final progs = await ApiService().getProgrammes();
await ApiService().createProgramme({ ... });
await ApiService().updateProgramme(id, { ... });
await ApiService().deleteProgramme(id);
```

---

## 10. État actuel : API vs Mock

| Fonctionnalité | Connecté API | Source |
|---|---|---|
| **Login** | ✅ | `ApiService().login()` |
| **Token persistant** | ✅ | `AuthService` + SharedPreferences |
| **Programmes CRUD** | ✅ (service prêt) | `ApiService()` — ⚠️ pas d'UI |
| **Liste utilisateurs** | ✅ (service prêt) | `ApiService()` — ⚠️ pas d'UI |
| **Register** | ❌ | `MockDataService().createAccount()` |
| **Profil utilisateur** | ❌ | `MockDataService().currentUser` |
| **Événements** | ❌ | `MockDataService().events` |
| **Coachs** | ❌ | `MockDataService().coaches` |
| **Challenges** | ❌ | `MockDataService().challenges` |
| **Feed social** | ❌ | Données statiques dans `feed_page.dart` |
| **Séances** | ❌ | `MockDataService().getTodayWorkoutSession()` |

---

## 11. Ce qu'il reste à connecter

### Priorité 1 — Bloquant

#### A. Android : autoriser HTTP (non-HTTPS)
Fichier : `android/app/src/main/AndroidManifest.xml`
```xml
<application
    android:usesCleartextTraffic="true"
    ... >
```

#### B. iOS : autoriser HTTP
Fichier : `ios/Runner/Info.plist`
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

#### C. Refresh token automatique
Le token Firebase expire après **1h**. Il faut :
1. Intercepter les `ApiException(401, ...)` dans `ApiService`
2. Relancer `POST /users/login` automatiquement (avec credentials sauvegardés)
3. Ou rediriger vers `LoginPage`

---

### Priorité 2 — Routes API à créer côté serveur

Ces fonctionnalités existent dans l'app mais **n'ont pas de endpoint documenté** :

| Fonctionnalité | Route suggérée | Méthode |
|---|---|---|
| Inscription utilisateur | `/users/register` | POST |
| Profil de l'utilisateur connecté | `/users/me` | GET |
| Mettre à jour le profil | `/users/me` | PUT |
| Liste des événements | `/events` | GET |
| Détail événement | `/events/{id}` | GET |
| S'inscrire à un événement | `/events/{id}/register` | POST |
| Liste des coachs | `/coaches` | GET |
| Liste des challenges | `/challenges` | GET |
| Rejoindre un challenge | `/challenges/{id}/join` | POST |
| Séances d'entraînement | `/seances` | GET |
| Feed / posts | `/posts` | GET / POST |

---

### Priorité 3 — Connecter l'UI aux routes existantes

Une fois les routes serveur créées, brancher dans les écrans :

```dart
// register_page.dart — remplacer MockDataService
await ApiService().register({ 'email': ..., 'password': ..., ... });

// home_page.dart — remplacer MockDataService
final user = await ApiService().getMe();
final sessions = await ApiService().getSessionsForDate(DateTime.now());

// events_page.dart
final events = await ApiService().getEvents();

// coach_page.dart
final coaches = await ApiService().getCoaches();
```

---

## 12. Conventions de code

### Patterns utilisés

| Pattern | Implémentation |
|---|---|
| Singleton | `factory MyService() => _instance;` |
| StatefulWidget local | `setState()` pour tout l'état UI |
| Async/await | Toutes les opérations I/O |
| Try/catch avec types | `on ApiException catch (e)` |
| Getter calculés | `get bmi`, `get age`, `get formattedDate` |

### Nommage

- **Fichiers :** `snake_case.dart`
- **Classes :** `PascalCase`
- **Variables/méthodes :** `camelCase`
- **Constantes :** `camelCase` ou `UPPER_CASE` pour les clés de storage

### Structure d'un écran type

```dart
class MyPage extends StatefulWidget { ... }

class _MyPageState extends State<MyPage> {
  // 1. State & controllers
  bool _isLoading = false;

  // 2. initState / dispose

  // 3. Méthodes métier (async, avec try/catch)
  Future<void> _loadData() async { ... }

  // 4. build() + sous-builders _buildXxx()
  @override Widget build(BuildContext context) { ... }
  Widget _buildSomeSection() { ... }
}
```

### Ajout d'un nouvel appel API

1. Ajouter la méthode dans `api_service.dart`
2. Utiliser `_authHeaders` si route protégée, `_publicHeaders` sinon
3. Appeler `_checkStatus(res)` avant de parser
4. Wrapper l'appel dans l'écran avec `try on ApiException catch`
5. Gérer le state `_isLoading` autour de l'appel

```dart
// Template type dans un écran
Future<void> _charger() async {
  setState(() => _isLoading = true);
  try {
    final data = await ApiService().getMaRoute();
    setState(() => _data = data);
  } on ApiException catch (e) {
    // afficher e.message
  } catch (_) {
    // erreur réseau
  } finally {
    setState(() => _isLoading = false);
  }
}
```

---

*Document généré le 23 avril 2026 — Call of Phoenix v1.0.0*
