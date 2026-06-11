# خطوات ربط API المرفقة وبداية شاشة بروفايل المستخدم

## 1. فهم الوضع الحالي للمشروع

- يوجد دعم تسجيل دخول وتسجيل مستخدم في المشروع بالفعل عبر:
  - `lib/features/auth/data/api_service/auth_api.dart`
  - `lib/features/auth/data/repository/auth_repo.dart`
  - `lib/features/auth/presentation/logic/cubit/auth_cubit.dart`
- الـ Token يتم تخزينه باستخدام:
  - `lib/core/helpers/cachhelper.dart`
- التطبيق يحدد الشاشة الأساسية حسب حالة المصادقة في:
  - `lib/main.dart`
- الصفحة الحالية في الـ Drawer تحتوي على بيانات ثابتة (Hardcoded) في:
  - `lib/features/layout/layout_app.dart`

## 2. نقطة البداية: البروفايل باستخدام نقطة النهاية `GET /users/me`

### 2.1. الهدف

- جلب بيانات المستخدم الحالية من الـ API
- عرض اسم المستخدم والبريد في شاشة البروفايل وفي رأس الـ Drawer
- استخدام الـ Token الموجود في التخزين الآمن

### 2.2. API الموجود حالياً

- `GET https://bluebits24.onrender.com/api/v1.0.0/users/me`
- يتطلب الهيدر:
  - `Authorization: Bearer <token>`
  - `Content-type: application/json`

## 3. بنية الربط المقترحة للبروفايل

### 3.1. إنشاء مجلد خاص بالبروفايل

اقترح:
- `lib/features/profile/data/api_service/profile_api.dart`
- `lib/features/profile/data/repository/profile_repo.dart`
- `lib/features/profile/data/models/profile_model.dart`
- `lib/features/profile/presentation/logic/cubit/profile_cubit.dart`
- `lib/features/profile/presentation/screens/profile_screen.dart`

### 3.2. إنشاء Model للبروفايل

- استند إلى هيكل JSON المتوقع من `/users/me`
- مثال الحقول:
  - `id`
  - `name`
  - `email`
  - `profile_image` أو `photo`
  - `role`
  - `createdAt` أو أي حقل آخر يعود من السيرفر

### 3.3. إنشاء ProfileApi

أضف دوال مثل:
- `Future<dynamic> getProfile(String token)`
- `Future<dynamic> updateProfile(Map<String, dynamic> body, String token)`
- `Future<dynamic> uploadProfileImage(File file, String token)` أو `updateProfileWithImage`

### 3.4. إنشاء ProfileRepo

- يستدعي `ProfileApi`
- يحول الاستجابة إلى `ProfileModel`
- يتعامل مع الأخطاء ويرجع `null` أو نتيجة مناسبة

### 3.5. إنشاء ProfileCubit

- مسؤول عن حالات التحميل والنجاح والفشل
- دوال مقترحة:
  - `Future<void> loadProfile()`
  - `Future<void> updateProfile(...)`
  - `Future<void> uploadProfileImage(...)`

## 4. تنفيذ البروفايل داخل واجهة المستخدم

### 4.1. إضافة صفحة في الـ Layout

- في `lib/features/layout/layout_app.dart` أضف:
  - صفحة `ProfileScreen()` في قائمة `_pages`
  - عنصر جديد في الـ Drawer باسم `"البروفايل"`
- عيّن الفهرس المناسب للتحكم في التنقل داخل القائمة الجانبية

### 4.2. عرض بيانات المستخدم في Drawer

- استبدل القيم الثابتة في:
  - `UserAccountsDrawerHeader`
- استخدم نموذج `ProfileModel` أو `UserModel` بعد جلبها من الـ API
- اجعل `accountName` و `accountEmail` ديناميكياً

### 4.3. إنشاء شاشة البروفايل

- عرض:
  - صورة المستخدم (أو أيقونة افتراضية)
  - الاسم
  - البريد
  - زر لتحديث البيانات
  - زر لتحديث الصورة إن كان متوفرًا
- يمكن البدء بشاشة بسيطة ثم توسعتها لاحقاً

## 5. استخدام البيانات المخزنة والـ Token

### 5.1. قراءة الـ Token

في `ProfileApi` أو `ProfileRepo`:
- اطلب `String? token = await CachHelper.getValue('Token');`
- استخدمه في هيدر الطلب:
  - `Authorization: Bearer $token`

### 5.2. تحديث الـ Token

- في حال كان الـ API يعيد توكين جديد عند التحديث، خزّنه مرة أخرى
- خلاف ذلك، احتفظ بالـ Token الحالي

## 6. خطوات عملية تنفيذية مفصلة

1. افتح `lib/features/auth/data/api_service/auth_api.dart`
   - تأكد أن `baseUrl` هو:
     - `https://bluebits24.onrender.com/api/v1.0.0/users/`
2. أنشئ ملف النموذج `profile_model.dart`
3. أنشئ ملف `profile_api.dart` ودالة `getProfile`
4. أنشئ ملف `profile_repo.dart` لتحويل الاستجابة إلى نموذج
5. أنشئ `ProfileCubit` و`profile_state.dart`
6. أضف `ProfileScreen` مع `BlocProvider` أو `BlocBuilder`
7. في `LayoutApp`:
   - أضف الصفحة إلى `_pages`
   - أضف عنصر البروفايل في القائمة الجانبية
8. اجعل رأس الـ Drawer يظهر بيانات البروفايل بعد التحميل
9. استدعِ `loadProfile()` بعد المصادقة أو عند فتح الصفحة

## 7. نقاط مهمة من مصدر الـ API المرفق

- تسجيل حساب: `POST /users/signup`
- تسجيل دخول: `POST /users/login`
- معلومات المستخدم: `GET /users/me`
- تحديث بيانات المستخدم: `PATCH /users/updateMe`
- تحديث ورفع صورة: `PATCH /users/updateMeAndUpload`
- تفعيل بريد: `GET /users/verifyEmail/:token`
- إعادة إرسال التفعيل: `POST /users/resendVerification`

## 8. توصية لتسلسل العمل

1. **ابدأ بتنفيذ جلب البروفايل** (`GET /users/me`)
2. **اعرض البيانات في الـ Drawer**
3. **أنشئ شاشة بروفايل خاصة**
4. **أضف القدرة على تحديث البيانات عبر `PATCH /users/updateMe`**
5. **أضف رفع الصورة عبر `PATCH /users/updateMeAndUpload`**

## 9. اسمح بالتحقق والاختبار

- جرّب نقطة النهاية `GET /users/me` في Postman أولاً مع الـ Token
- ثم نفّذ الطلب داخل التطبيق
- تأكد من أن الـ Token مخزون في `CachHelper`
- تأكد من أن التطبيق ينتقل إلى `LayoutApp()` عند نجاح المصادقة

---

### ملف جديد مقترح
- `PROFILE_API_INTEGRATION_STEPS.md`

إذا تريد، أستطيع الآن إنشاء البنية الفعلية لملفات `profile` وتنفيذ أول نسخة من `ProfileApi` و`ProfileScreen` داخل المشروع.