class OnboardingModel {
  final String title;
  final String body;
  final String image;

  OnboardingModel({
    required this.title,
    required this.body,
    required this.image,
  });
}

List<OnboardingModel> onboardingcontent = [
  OnboardingModel(
    title: 'Blue Bits 24 مرحبًا بك في',
    body:
        'منصتك الرقمية المتكاملة لطلاب هندسة المعلوماتية كل ما تحتاجه في مكان واحد',
    image: 'assets/images/onboarding1.png',
  ),
  OnboardingModel(
    title: 'ادرس بذكاء، لا بجهد',
    body:
        'تصفح وحمل محاضراتك بسهولة، واستخدم الذكاء الاصطناعي للحصول على ملخصات سريعة ودقيقة',
    image: 'assets/images/onboarding2.png',
  ),
  OnboardingModel(
    title: 'اختبر معلوماتك وطور مهاراتك',
    body:
        'بنك أسئلة شامل (MCQ) لمساعدتك في مراجعة المواد وتنظيم مهامك الدراسية اليومية',
    image: 'assets/images/onboarding3.png',
  ),
  OnboardingModel(
    title: 'برنامجك الامتحاني.. بدون تعارضات',
    body:
        'أدخل تفضيلاتك ودع خوارزميتنا الذكية تقترح لك أفضل برنامج امتحاني مخصص ومثالي لك',
    image: 'assets/images/onboarding4.png',
  ),
];
