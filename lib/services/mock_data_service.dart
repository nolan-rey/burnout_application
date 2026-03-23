import '../models/coach.dart';
import '../models/user.dart';
import '../models/challenge.dart';
import '../models/event.dart';
import '../models/session.dart';
import '../models/workout_session.dart';

class MockDataService {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal();

  final List<Coach> _coaches = const [
    Coach(
      id: 1,
      name: 'Jean Dupont',
      specialty: 'Expert Musculation',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBmbwEFj5TKWV-201_ftoAkWLTZEd29MqEBarRXRKAnS8MWHmDpNJwkwwpQP6IvXLPH3IK_Sn_YuqAVP1zqAd8_9zvHbpQSEb8IytCit9HKsvOq4NSl9j7gDSm5uriuW4e60EQ9B-KnYKf7KfpIgp3cd6nSV66k9hTQBuV4mt6h7W5mCjv9XzBJpa16Aoql-eOJB_z72UffpDjA2Rz3Eua52hS2ZGA9qJ6bF-UUYzmhTCeMqIHREeD3NeJwQwA9c4b1KvB0WxvKT5rP',
      availability: "Disponible aujourd'hui à 14h",
      isAvailable: true,
      isPro: true,
    ),
    Coach(
      id: 2,
      name: 'Marie Curie',
      specialty: 'Yoga Master',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAkibmsICns5DYlRd3uBudFy4LwEz896-mw4nmEmtYWIBuArdlVPBJ6OjsIFTYy64malPI_5MY7ewpUC8Eqqb5Gs7nE9A7yoFM-yAsKVijFJy67tzr9CFoNuhWIgfnPz1iXC_UKGhJdX5_aMhszACADZbG9R8e1gDfDqFOA9fMzbtxe8XNtUpbctrEb-BiuDuUg71MjwGPIDpEbiFx_X9BnTEx8Gv1n016VCHxRXkSn8WStLEb0ejqRIjjXcUtbxWhW4kCOcdu_Etq_',
      availability: 'En séance actuellement',
      isAvailable: false,
      isPro: true,
    ),
    Coach(
      id: 3,
      name: 'Lucas Martin',
      specialty: 'Crossfit & Cardio',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCeGfbQBqxIC3tOEV4QDWtpFFBKls7yyIzKfN-0_Tq0HzkEhraMTr9wYzX80Odm_wp6LjAs_Awi0V96gT9BvfMN8HucXyEGva0UVDgUkdidrdqfpk2vS-8GReFrgGXiqx45oXonz0RU49ASoNpO3PYJ45TOlCklYMkHi7XhV_0JatiU5bJ7MEOSjT__ZaBW7Gz3AssBA2Smftm2pZbDLkGmop2-woBl9u87el0-QKXdz0mx77YWk52CLH8GEof6EDa5heZ_KmTZCBdA',
      availability: "Absent jusqu'au 15 Oct",
      isAvailable: false,
      isPro: false,
    ),
    Coach(
      id: 4,
      name: 'Sophie Bernard',
      specialty: 'Nutritionniste',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuADAchHqxLUlaykGUxbJG4DFP-CTNuyJ0zMKmMiWXaKI3PO72hFtOYRANl6u0oN8y4rLrzVHr6kcz5iunhDnKod9OCQyZR6QEaY_g2hdvCtkU2Wvfi_Gv5nRCJg37DYn4oawo4RA_bPY1q_ElSY108toC9SjOQVBNnaHfDO8a9skjMbo2vP-lRrYDwRCjzke3SFj06B3dACnd8DsUSJ62npR1PWQsCpwN0aQ7FowotxbvZKzoWeGBEW9ytsUYpWlGp6iSFY__nuq9ps',
      availability: 'Disponible demain matin',
      isAvailable: true,
      isPro: true,
    ),
    Coach(
      id: 5,
      name: 'Sarah Leclere',
      specialty: 'Yoga & Flexibilité',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCmDxM0SYPbZ_8EFhZA0SZrGj5QuZfkRMYgjZ94zbZuJVrUAGVce8_2LSzpEcK5xEy-wMvMBC7kMfedwhnuvdRSjHoTGHCSsMZhOqbi2LfRdoK8wB3b3-7pHLjDyIzU3RWvmrMcagGNP-99qmEK106dQtojGcFqWUEf2S1bS1-JmyGxh2-fZzp1I6mZC9vevjMDRQ2zZcH9iKhS3pB2kew2ps8lke6KXGSWBy9goLW3XeiIgU9VJD-jIwK7I0wEVAVkngvBMdyax13m',
      availability: 'Disponible',
      isAvailable: true,
      isPro: true,
    ),
    Coach(
      id: 6,
      name: 'Marc Dubois',
      specialty: 'Force & Musculation',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuANZVhojxzwzQDxwfoAoIVtZw6t8x9BDKxzS6DoEgfiJASpk56W4wEfeWno0R3Ejr9pz_Ba1ajVLlzz6heY_OTDWk1gk8UU6mQ6mY2otbRlqOoaXY6pnURYMs3JHr3TL0IEGdhWHm-9woRWEQR3ju_UqKZfIsMb_WiYE27yql-p-mEVdfoJDAnIX_pmTeZRd0aS30zZo0QbFCTMFxbUgbmzP2-xZk6Vinu8TZMssfOW40l_HjisuCx9OgVj6k-j42Sv7yEFSw6K9YIn',
      availability: 'Disponible',
      isAvailable: true,
      isPro: true,
    ),
  ];

  late final List<Event> _events = [
    Event(
      id: 1,
      title: 'Morning Yoga Flow',
      category: 'Yoga',
      description: 'Rejoignez-nous pour une session intense de Yoga Flow matinal. Ce cours combine respiration et mouvements dynamiques pour améliorer votre flexibilité et renforcer vos muscles profonds.',
      date: DateTime(2024, 10, 12),
      startTime: const Duration(hours: 10),
      endTime: const Duration(hours: 11),
      location: 'Paris',
      locationDetail: 'Salle A • Call of Phoenix Gym',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBQFy95_ingZGKzx-cCcbukWIdy3e1V-3dKezBXyT1g650wtyiYUNabHw1QHIkxb0xqEcffYjsoC31ZjpNBmmf7anEDLQ2U3tYlG3kiiqCQ-vgsiDfCMshw1tyXrMz78bMrEzQ28tQd2Pla2alOl2KGznY8wjwtRTcR2w6wBL2z3aYPedpRtvLrDcUC3aLr47V-X8HJ9sICxyV5cINk9Wc4o_50jZmN48lpGmi0WHPrzLt2lqgintBQxs88mhBGhcOsBa_DZ3WqnYUT',
      price: 15,
      maxParticipants: 20,
      currentParticipants: 16,
      coach: _coaches[4],
      intensity: 'Intense',
      level: 'Intermédiaire',
      participantAvatars: [
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCgV4NouZ4LBunLyAmZoRsuTz3HNsRxqord7kbtjM0q5XP1ZSKNpt0Vyy4n9mpbophd3AVxNdwTsJhV1ZD0CqOYN2ESD2QxIRo2veMmyI8O0DufdFNomcqwwft6W9Oy0Dgdq5hA9CCHCw_L_Jo1fWbVk4M32bx8DYU7X9ybxQE9a7eTEgmnd_YmzvKN_lR473ZyjIWSJwPnMrn9U27RqYCBNS2fugfTqRBnZY_wvtgWloOwoLhKU1WR8Pc1QJQWPR82LlMuGme08pU8',
        'https://lh3.googleusercontent.com/aida-public/AB6AXuC24ppwcvNOSRshCy_bXVf1oTj21M-wDStF4d344xJeeXPJdiooarRL_GKKgdjhHeFNmT-xtVmRFPS2VdTFt9BgLlCwy_DqAfN-hLLyhn5DVGnStcVmHTb7EpmSG-_bL024Jmr4asN75Qah1lZaH0JMeN9dFa05EaSYwqVd-fdW30dphjrQ7OpctRWge1IPxeBTaJVpMyWn-pAZMmiyQMefIoIw_CmqAQPU5EJeUAJq9bh_rqL59-G-fnBVuDXKKZa2bzhdpYk9nlvy',
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDEcYMqWhe-mlsLvGvA96xIR2_2YjjkAbx0Sy-VZljg4UhMIPN1GpnY1LR1t-SmqDdPQ2QkHUVnSOpJJD-kkwD4Aknv5Ixm2gCsSMv4U1TKHpW6fzJXFxFLrg2vuklDzWQVeGvO7lasE6DqjwrK4QMCoB-3Ry15R6dRI3-4_okeL8GKZTG43d3qa1fau-d4LqviICsE84DX4fHHi-BFw7kt-jpYSfKs4a42CMLRF5679vYj_xF2uV4wuV99Ickc8aN4E1JV3Qg3zRyv',
      ],
    ),
    Event(
      id: 2,
      title: 'Urban Cross Training',
      category: 'Cardio',
      description: 'Entraînement en plein air combinant cardio et renforcement musculaire.',
      date: DateTime(2024, 10, 14),
      startTime: const Duration(hours: 18, minutes: 30),
      endTime: const Duration(hours: 19, minutes: 30),
      location: 'Annecy',
      locationDetail: 'Le Pâquier',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCIDz6uARmNX2mf6bjr2OggXNnG7nMru03wXPIE1Ow1JZkbIyPgU8wZslMHeam_el3QtGxzFiYSH_f0I-j0245CAuvyL33hRUgcWKuWcGqcab4PGEsYQ1US4QvHgo1Dn0BBB_eNSAIhZxleOHoka0SttfIagm1W9dg0KR0FeFOrsNjzEgT_6NFPMkFUk3sM--V6Do123o6nX5_ORRNvxoYhY6NrZE1UCcKtFHx0MF7Q4UfFOVHmy5hW3WDufvbK-aWIMUymB5kJnA9k',
      price: 0,
      maxParticipants: 50,
      currentParticipants: 28,
      coach: _coaches[2],
      intensity: 'Élevée',
      level: 'Tous niveaux',
    ),
    Event(
      id: 3,
      title: 'Technique Powerlifting',
      category: 'Force',
      description: 'Masterclass sur les techniques de powerlifting avec un coach expert.',
      date: DateTime(2024, 10, 20),
      startTime: const Duration(hours: 14),
      endTime: const Duration(hours: 16),
      location: 'Paris',
      locationDetail: 'Zone Force',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCmDxM0SYPbZ_8EFhZA0SZrGj5QuZfkRMYgjZ94zbZuJVrUAGVce8_2LSzpEcK5xEy-wMvMBC7kMfedwhnuvdRSjHoTGHCSsMZhOqbi2LfRdoK8wB3b3-7pHLjDyIzU3RWvmrMcagGNP-99qmEK106dQtojGcFqWUEf2S1bS1-JmyGxh2-fZzp1I6mZC9vevjMDRQ2zZcH9iKhS3pB2kew2ps8lke6KXGSWBy9goLW3XeiIgU9VJD-jIwK7I0wEVAVkngvBMdyax13m',
      price: 30,
      maxParticipants: 15,
      currentParticipants: 7,
      coach: _coaches[5],
      intensity: 'Intense',
      level: 'Avancé',
    ),
  ];

  late final List<Challenge> _challenges = [
    Challenge(
      id: 1,
      title: '30 Day Squat',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuD09BNViI4muxpjteb6UDdiYjWrlI-T7qYWt3Nko9G64mpdOIPRKwPhKrpj8_SPDeQc48e2gQu_2bm2IfqOZFIqm3IjDO6FH96hivgIGjy9Wz-qpt_RjZcjaKdNGGz4TG79-bhI8KkFypB_smAWyS5Oh6YVkVAmP7kjdC9C53pGrvh_1aRMrQIoXfbk8-asMvHD2TySStO3e0tDjVxltXRYv8yLziZehY1tzmZTKkpvuyKjrBuuQNsHrFg9M43Ec8gkLRwWeYOMJ4SP',
      totalDays: 30,
      completedDays: 10,
      isJoined: true,
      todayTask: '50 Squats',
      iconName: 'fitness_center',
      dayCompletionStatus: List.generate(30, (i) => i < 10),
    ),
    Challenge(
      id: 2,
      title: 'Phoenix Rising',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA_tAhmMg_CrLYpV6Lkg2Z39HznWkBIhzUJiqTFaLIG-ai-z5ZKZ4EZnYIrBJi0NFGIFMyjJCbQk2mHqlaPFBp4170Mx9PAnIAHDO-9meVWF4kG9f4IwaJ3MgofogQPIRtxQ4P5m6tsz3cDjgVjCf5tP_9CejycVcNcS260yc6eV031kZP8R6QaW4H2o2GKaorc4oAGfWBI9doPMoUOpgrf-1l-0kQppweAgE9IpA0EsVDQTdYNIYnYJS7Vst0WFXMSzkR97DgS7peL',
      totalDays: 7,
      completedDays: 5,
      isJoined: true,
      todayTask: '30 min Rowing',
      iconName: 'rowing',
    ),
    Challenge(
      id: 3,
      title: 'Cardio Blast',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBCIKdpDRa3uNgdr9Qtgj8gc_2CUH1QBowro-tqEDlcM9ils27iBvTwi4miWXkxy1c0Os2v7M-Dabc0XCDCi2ENS0aDsqZVj5Le2c1d508DT7wmBm_VjTGx3_hqxPqmm6r9lu96y3RhYkaXnMeEVaHKN7LNzwmqGGXcM-p57OhgvApWSR-ickFua_6GJK_s3iWkVXq5-IT0RkJsBy2BBc-C982USr64wH8PFH6nLa1KMTZuqv1hFATiTKWSSZqMlPMLzI7dkUyOQe2u',
      totalDays: 14,
      completedDays: 0,
      isJoined: false,
      todayTask: '20 min Run',
      iconName: 'directions_run',
    ),
  ];

  late final User _currentUser = User(
    id: 1,
    firstName: 'Thomas',
    lastName: 'Anderson',
    email: 'thomas.anderson@example.com',
    phone: '+33 6 12 34 56 78',
    address: '15 Rue de la Paix, 75002 Paris',
    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAybvQxmSQuXivTHv21xeh35fRUsdZQO5YhYuIGnEFn2T0yfV1kUDli6rwsnHR6qB6x-MDQLlb1wk7v-j0zr9zjDuCwiBGGmba5gj3hd0xbwSiYPzgIDqfkPCgvBzBe5MqOCHTN1eGBTZ6V-O8oR92L9PaCCnwxa0bPyFcobtyQUTJfLGq9-MC1XLVQ7YCqFJRq3Q1rukSdJtM09ZVmBAG45WiCZe1-eD0onHoxM0uWjn6xkKZgigPDEfhNIv_mO2cjjwEwnj79E3T7',
    membershipLevel: 'Phoenix Elite',
    memberSince: 2021,
    birthDate: DateTime(1995, 3, 22),
    gender: 'Homme',
    bloodType: 'O+',
    favoriteSport: 'Crossfit & Powerlifting',
    height: 180,
    weight: 75,
    weeklyVisits: 3,
    caloriesBurned: 1240,
  );

  late final Session _nextSession = Session(
    id: 1,
    title: 'Chest Day',
    category: 'Force',
    date: DateTime.now(),
    time: const Duration(hours: 17, minutes: 30),
    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAnIGVS58sxYo_FKXHXKtyEgb2kkO8XU25VsgQSiG_Y4HM0jzAPAZjWlsscSm1nc1izJJGVT6eALKE2jmjNDWUqujqycDGpDe-QWZT4gQD9-lALkDGKJJrb2hgGenlHDp9BR6-QPC1s2I6aQTIZC41p4lYSLdI9VIWJwMfQ0hVOIX1ANpO1B0LnqhuqiZLbtUnfVWFki0Jonyn69R7wNgOLLGZamh6yYV58KtsfTr9sjzcln-wx5bwwtJA02rvSv6Oi7fcs2PqaKyPZ',
    coach: _coaches[5],
  );

  final List<User> _registeredUsers = [];

  List<Event> get events => _events;
  List<Coach> get coaches => _coaches;
  List<Challenge> get challenges => _challenges;
  User get currentUser => _currentUser;
  Session get nextSession => _nextSession;

  Event? getEventById(int id) => _events.where((e) => e.id == id).firstOrNull;
  Coach? getCoachById(int id) => _coaches.where((c) => c.id == id).firstOrNull;
  Challenge? getChallengeById(int id) => _challenges.where((c) => c.id == id).firstOrNull;

  List<Event> getEventsByCategory(String category) {
    if (category.isEmpty || category == 'Tous') return _events;
    return _events.where((e) => e.category == category || e.location == category).toList();
  }

  bool login(String email, String password) {
    return email.isNotEmpty && password.isNotEmpty;
  }

  bool createAccount(User user) {
    if (user.email.isEmpty || user.password.isEmpty) return false;
    if (_registeredUsers.any((u) => u.email == user.email)) return false;
    user.id = _registeredUsers.length + 100;
    user.membershipLevel = 'Phoenix Member';
    user.memberSince = DateTime.now().year;
    _registeredUsers.add(user);
    return true;
  }

  bool registerForEvent(int eventId) {
    final evt = getEventById(eventId);
    if (evt != null && evt.currentParticipants < evt.maxParticipants) {
      evt.currentParticipants++;
      return true;
    }
    return false;
  }

  bool joinChallenge(int challengeId) {
    final challenge = getChallengeById(challengeId);
    if (challenge != null) {
      challenge.isJoined = true;
      return true;
    }
    return false;
  }

  WorkoutSession getTodayWorkoutSession() {
    return WorkoutSession(
      id: 1,
      title: 'Séance Musculation',
      programName: 'Programme Force Erik',
      weekLabel: 'Semaine 1',
      sessionLabel: 'Séance 1',
      type: 'MUSCU',
      date: DateTime.now(),
      time: const Duration(hours: 17, minutes: 30),
      coach: _coaches[5],
      blocks: [
        WorkoutBlock(name: 'Échauffement Prophylactique', exercises: [
          WorkoutExercise(id: 1, name: 'Rotation épaules + mobilité hanches', seriesCount: 2, repsPerSerie: 10, recupSeconds: 0, note: 'Mouvement lent et contrôlé', sets: [WorkoutSet(setNumber: 1, reps: 10), WorkoutSet(setNumber: 2, reps: 10)]),
        ]),
        WorkoutBlock(name: 'Core', exercises: [
          WorkoutExercise(id: 2, name: 'Gainage planche', seriesCount: 3, repsPerSerie: 1, recupSeconds: 60, note: 'Tenir 30 secondes par série', sets: [WorkoutSet(setNumber: 1, duration: 30), WorkoutSet(setNumber: 2, duration: 30), WorkoutSet(setNumber: 3, duration: 30)]),
          WorkoutExercise(id: 3, name: 'Crunch bicycle', seriesCount: 3, repsPerSerie: 15, recupSeconds: 45, sets: [WorkoutSet(setNumber: 1, reps: 15), WorkoutSet(setNumber: 2, reps: 15), WorkoutSet(setNumber: 3, reps: 15)]),
        ]),
        WorkoutBlock(name: 'Force - Poussée', exercises: [
          WorkoutExercise(id: 4, name: 'Développé couché barre', seriesCount: 4, repsPerSerie: 8, recupSeconds: 120, note: 'CTI > 1 alors charge indispensable', sets: [WorkoutSet(setNumber: 1, reps: 8, weight: 80), WorkoutSet(setNumber: 2, reps: 8, weight: 82.5), WorkoutSet(setNumber: 3, reps: 8, weight: 85), WorkoutSet(setNumber: 4, reps: 8, weight: 85)]),
          WorkoutExercise(id: 5, name: 'Développé incliné haltères', seriesCount: 3, repsPerSerie: 10, recupSeconds: 90, sets: [WorkoutSet(setNumber: 1, reps: 10, weight: 28), WorkoutSet(setNumber: 2, reps: 10, weight: 30), WorkoutSet(setNumber: 3, reps: 10, weight: 30)]),
          WorkoutExercise(id: 6, name: 'Dips lestés', seriesCount: 3, repsPerSerie: 10, recupSeconds: 90, sets: [WorkoutSet(setNumber: 1, reps: 10, weight: 10), WorkoutSet(setNumber: 2, reps: 10, weight: 10), WorkoutSet(setNumber: 3, reps: 10, weight: 10)]),
        ]),
        WorkoutBlock(name: 'Accessoire - Épaules / Triceps', exercises: [
          WorkoutExercise(id: 7, name: 'Élévations latérales haltères', seriesCount: 3, repsPerSerie: 15, recupSeconds: 60, sets: [WorkoutSet(setNumber: 1, reps: 15, weight: 10), WorkoutSet(setNumber: 2, reps: 15, weight: 10), WorkoutSet(setNumber: 3, reps: 15, weight: 10)]),
          WorkoutExercise(id: 8, name: 'Triceps poulie haute', seriesCount: 3, repsPerSerie: 12, recupSeconds: 60, sets: [WorkoutSet(setNumber: 1, reps: 12, weight: 25), WorkoutSet(setNumber: 2, reps: 12, weight: 25), WorkoutSet(setNumber: 3, reps: 12, weight: 27.5)]),
        ]),
      ],
    );
  }

  List<WorkoutSession> getSessionsForDate(DateTime date) {
    final dayOfWeek = date.weekday;
    if (dayOfWeek == DateTime.monday || dayOfWeek == DateTime.wednesday || dayOfWeek == DateTime.friday) {
      return [
        WorkoutSession(
          id: 1,
          title: 'Séance Musculation',
          programName: 'Programme Force Erik',
          weekLabel: 'Semaine 1',
          sessionLabel: 'Séance 1',
          type: 'MUSCU',
          date: date,
          time: const Duration(hours: 17, minutes: 30),
          coach: _coaches[5],
          blocks: [
            WorkoutBlock(name: 'Échauffement Prophylactique', exercises: [
              WorkoutExercise(id: 1, name: 'Rotation épaules + mobilité hanches', seriesCount: 2, repsPerSerie: 10, recupSeconds: 0, note: 'Mouvement lent et contrôlé', sets: [WorkoutSet(setNumber: 1, reps: 10), WorkoutSet(setNumber: 2, reps: 10)]),
            ]),
            WorkoutBlock(name: 'Force - Poussée', exercises: [
              WorkoutExercise(id: 2, name: 'Développé couché barre', seriesCount: 4, repsPerSerie: 8, recupSeconds: 120, note: 'Charge indispensable', sets: [WorkoutSet(setNumber: 1, reps: 8, weight: 80), WorkoutSet(setNumber: 2, reps: 8, weight: 82.5), WorkoutSet(setNumber: 3, reps: 8, weight: 85), WorkoutSet(setNumber: 4, reps: 8, weight: 85)]),
              WorkoutExercise(id: 3, name: 'Développé incliné haltères', seriesCount: 3, repsPerSerie: 10, recupSeconds: 90, sets: [WorkoutSet(setNumber: 1, reps: 10, weight: 28), WorkoutSet(setNumber: 2, reps: 10, weight: 30), WorkoutSet(setNumber: 3, reps: 10, weight: 30)]),
              WorkoutExercise(id: 4, name: 'Dips lestés', seriesCount: 3, repsPerSerie: 10, recupSeconds: 90, sets: [WorkoutSet(setNumber: 1, reps: 10, weight: 10), WorkoutSet(setNumber: 2, reps: 10, weight: 10), WorkoutSet(setNumber: 3, reps: 10, weight: 10)]),
            ]),
            WorkoutBlock(name: 'Accessoire - Épaules / Triceps', exercises: [
              WorkoutExercise(id: 5, name: 'Élévations latérales haltères', seriesCount: 3, repsPerSerie: 15, recupSeconds: 60, sets: [WorkoutSet(setNumber: 1, reps: 15, weight: 10), WorkoutSet(setNumber: 2, reps: 15, weight: 10), WorkoutSet(setNumber: 3, reps: 15, weight: 10)]),
              WorkoutExercise(id: 6, name: 'Triceps poulie haute', seriesCount: 3, repsPerSerie: 12, recupSeconds: 60, sets: [WorkoutSet(setNumber: 1, reps: 12, weight: 25), WorkoutSet(setNumber: 2, reps: 12, weight: 25), WorkoutSet(setNumber: 3, reps: 12, weight: 27.5)]),
            ]),
          ],
        ),
      ];
    } else if (dayOfWeek == DateTime.tuesday || dayOfWeek == DateTime.thursday) {
      return [
        WorkoutSession(
          id: 2,
          title: 'Séance Cardio',
          programName: 'Programme Force Erik',
          weekLabel: 'Semaine 1',
          sessionLabel: 'Séance Cardio',
          type: 'CARDIO',
          date: date,
          time: const Duration(hours: 7),
          coach: _coaches[2],
          blocks: [
            WorkoutBlock(name: 'Échauffement', exercises: [
              WorkoutExercise(id: 1, name: 'Gainage planche', seriesCount: 3, repsPerSerie: 1, recupSeconds: 60, note: 'Tenir 30 secondes', sets: [WorkoutSet(setNumber: 1, duration: 30), WorkoutSet(setNumber: 2, duration: 30), WorkoutSet(setNumber: 3, duration: 30)]),
              WorkoutExercise(id: 2, name: 'Crunch bicycle', seriesCount: 3, repsPerSerie: 15, recupSeconds: 45, sets: [WorkoutSet(setNumber: 1, reps: 15), WorkoutSet(setNumber: 2, reps: 15), WorkoutSet(setNumber: 3, reps: 15)]),
            ]),
            WorkoutBlock(name: 'Cardio Principal', exercises: [
              WorkoutExercise(id: 3, name: 'Course à pied', seriesCount: 1, repsPerSerie: 1, recupSeconds: 0, note: 'Allure modérée', sets: [WorkoutSet(setNumber: 1, duration: 1800)]),
              WorkoutExercise(id: 4, name: 'Vélo elliptique', seriesCount: 3, repsPerSerie: 1, recupSeconds: 30, sets: [WorkoutSet(setNumber: 1, duration: 300), WorkoutSet(setNumber: 2, duration: 300), WorkoutSet(setNumber: 3, duration: 300)]),
            ]),
          ],
        ),
      ];
    }
    return [];
  }
}
