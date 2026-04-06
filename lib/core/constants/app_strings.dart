/// All hardcoded strings used across AUN BMI Tracker.
class AppStrings {
  AppStrings._();

  // ──────────────────────────── App ──────────────────────────────
  static const String appName = 'AUN BMI Tracker';
  static const String appTagline = 'Track your health journey';

  // ──────────────────────────── Screen titles ───────────────────
  static const String splashTitle = 'AUN BMI Tracker';
  static const String homeTitle = 'BMI Calculator';
  static const String resultTitle = 'Your Result';
  static const String historyTitle = 'History';
  static const String profilesTitle = 'Profiles';
  static const String tipsTitle = 'Health Tips';
  static const String shareTitle = 'Share Result';

  // ──────────────────────────── Bottom nav labels ───────────────
  static const String navCalculator = 'Calculator';
  static const String navHistory = 'History';
  static const String navProfiles = 'Profiles';
  static const String navTips = 'Tips';

  // ──────────────────────────── Form labels ─────────────────────
  static const String labelHeight = 'Height';
  static const String labelWeight = 'Weight';
  static const String labelAge = 'Age';
  static const String labelGender = 'Gender';
  static const String labelName = 'Name';
  static const String labelMale = 'Male';
  static const String labelFemale = 'Female';
  static const String labelOther = 'Other';

  // ──────────────────────────── Unit labels ──────────────────────
  static const String unitCm = 'cm';
  static const String unitKg = 'kg';
  static const String unitFt = 'ft';
  static const String unitIn = 'in';
  static const String unitLb = 'lb';
  static const String unitMetric = 'Metric';
  static const String unitImperial = 'Imperial';

  // ──────────────────────────── Button texts ────────────────────
  static const String btnCalculate = 'Calculate BMI';
  static const String btnRecalculate = 'Recalculate';
  static const String btnSave = 'Save';
  static const String btnCancel = 'Cancel';
  static const String btnDelete = 'Delete';
  static const String btnShare = 'Share';
  static const String btnAddProfile = 'Add Profile';
  static const String btnEditProfile = 'Edit Profile';
  static const String btnViewHistory = 'View History';
  static const String btnGetStarted = 'Get Started';
  static const String btnContinue = 'Continue';
  static const String btnRetry = 'Retry';

  // ──────────────────────────── BMI categories ──────────────────
  static const String bmiUnderweight = 'Underweight';
  static const String bmiNormal = 'Normal';
  static const String bmiOverweight = 'Overweight';
  static const String bmiObese = 'Obese';
  static const String bmiSeverelyObese = 'Severely Obese';

  static const String bmiUnderweightRange = 'BMI < 18.5';
  static const String bmiNormalRange = '18.5 ≤ BMI < 25';
  static const String bmiOverweightRange = '25 ≤ BMI < 30';
  static const String bmiObeseRange = 'BMI ≥ 30';

  // ──────────────────────────── Health tip categories ────────────
  static const String tipCategoryNutrition = 'Nutrition';
  static const String tipCategoryExercise = 'Exercise';
  static const String tipCategoryLifestyle = 'Lifestyle';
  static const String tipCategorySleep = 'Sleep';
  static const String tipCategoryHydration = 'Hydration';
  static const String tipCategoryMentalHealth = 'Mental Health';

  // ──────────────────────────── Messages ─────────────────────────
  static const String msgNoHistory = 'No BMI records yet.\nCalculate your first BMI!';
  static const String msgNoProfiles = 'No profiles created.\nAdd a profile to get started!';
  static const String msgDeleteConfirm = 'Are you sure you want to delete this?';
  static const String msgSaved = 'Saved successfully';
  static const String msgDeleted = 'Deleted successfully';
  static const String msgError = 'Something went wrong. Please try again.';
  static const String msgInvalidHeight = 'Please enter a valid height';
  static const String msgInvalidWeight = 'Please enter a valid weight';
  static const String msgInvalidAge = 'Please enter a valid age';

  // ──────────────────────────── Result descriptions ─────────────
  static const String descUnderweight =
      'You are underweight. Consider consulting a healthcare provider for a balanced diet plan.';
  static const String descNormal =
      'Great job! Your BMI is within the healthy range. Maintain your current lifestyle.';
  static const String descOverweight =
      'You are overweight. Regular exercise and a balanced diet can help you reach a healthier weight.';
  static const String descObese =
      'Your BMI indicates obesity. Please consult a healthcare professional for guidance.';

  /// Returns the BMI category label for a given BMI value.
  static String bmiCategory(double bmi) {
    if (bmi < 18.5) return bmiUnderweight;
    if (bmi < 25.0) return bmiNormal;
    if (bmi < 30.0) return bmiOverweight;
    if (bmi < 35.0) return bmiObese;
    return bmiSeverelyObese;
  }

  /// Returns the BMI description for a given BMI value.
  static String bmiDescription(double bmi) {
    if (bmi < 18.5) return descUnderweight;
    if (bmi < 25.0) return descNormal;
    if (bmi < 30.0) return descOverweight;
    return descObese;
  }
}
