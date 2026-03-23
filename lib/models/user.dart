class SportActivity {
  String name;
  String weeklyFrequency;
  String dailyFrequency;
  String level;

  SportActivity({
    this.name = '',
    this.weeklyFrequency = '',
    this.dailyFrequency = '',
    this.level = '',
  });
}

class ProfessionalActivity {
  String name;
  String physicalFatigue;
  String mentalFatigue;

  ProfessionalActivity({
    this.name = '',
    this.physicalFatigue = '',
    this.mentalFatigue = '',
  });
}

class User {
  int id;
  String password;
  String presentation;
  String firstName;
  String lastName;
  String get fullName => '$firstName $lastName';
  String gender;
  DateTime? birthDate;
  String imageUrl;
  String email;
  String phone;
  String address;
  String postalCode;
  String city;
  String country;
  String maritalStatus;
  String partnerName;
  String personalPhysicalFatigue;
  String personalMentalFatigue;
  String personalFatigueComment;
  List<ProfessionalActivity> professionalActivities;
  String professionalFatigueComment;
  String tobaccoConsumption;
  String alcoholConsumption;
  String drugConsumption;
  String movementLimitations;
  String plannedOperation;
  String medicalCondition;
  String specificMedicalTreatment;
  int maxHeartRate;
  int restHeartRate;
  int weeklyTrainingCount;
  int sessionsPerTraining;
  String timePerSession;
  String totalWeeklyTime;
  String sleepQuality;
  String sleepQuantity;
  String dietQuality;
  String dietQuantity;
  List<SportActivity> sportActivities;
  String membershipLevel;
  int memberSince;
  int get age => birthDate != null
      ? (DateTime.now().difference(birthDate!).inDays / 365.25).floor()
      : 0;
  String bloodType;
  String favoriteSport;
  double height;
  double weight;
  double get bmi => height > 0 ? weight / ((height / 100) * (height / 100)) : 0;
  String get bmiDisplay => bmi.toStringAsFixed(1);
  int weeklyVisits;
  int caloriesBurned;

  User({
    this.id = 0,
    this.password = '',
    this.presentation = '',
    this.firstName = '',
    this.lastName = '',
    this.gender = '',
    this.birthDate,
    this.imageUrl = '',
    this.email = '',
    this.phone = '',
    this.address = '',
    this.postalCode = '',
    this.city = '',
    this.country = '',
    this.maritalStatus = '',
    this.partnerName = '',
    this.personalPhysicalFatigue = '',
    this.personalMentalFatigue = '',
    this.personalFatigueComment = '',
    List<ProfessionalActivity>? professionalActivities,
    this.professionalFatigueComment = '',
    this.tobaccoConsumption = '',
    this.alcoholConsumption = '',
    this.drugConsumption = '',
    this.movementLimitations = '',
    this.plannedOperation = '',
    this.medicalCondition = '',
    this.specificMedicalTreatment = '',
    this.maxHeartRate = 0,
    this.restHeartRate = 0,
    this.weeklyTrainingCount = 0,
    this.sessionsPerTraining = 0,
    this.timePerSession = '',
    this.totalWeeklyTime = '',
    this.sleepQuality = '',
    this.sleepQuantity = '',
    this.dietQuality = '',
    this.dietQuantity = '',
    List<SportActivity>? sportActivities,
    this.membershipLevel = '',
    this.memberSince = 0,
    this.bloodType = '',
    this.favoriteSport = '',
    this.height = 0,
    this.weight = 0,
    this.weeklyVisits = 0,
    this.caloriesBurned = 0,
  })  : professionalActivities = professionalActivities ?? [],
        sportActivities = sportActivities ?? [];
}
