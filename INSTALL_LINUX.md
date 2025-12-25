# حل مشكلة البناء على Linux

## المشكلة

عند تشغيل التطبيق على Linux، قد تواجه خطأ في CMake متعلق بـ `audioplayers_linux`.

## الحل

قم بتثبيت المكتبات الصوتية المطلوبة:

```bash
sudo apt-get update
sudo apt-get install -y libasound2-dev
```

## بديل: تشغيل على Android/iOS

بما أن التطبيق مصمم بشكل أساسي لـ Android و iOS، يُنصح بتشغيله على هذه المنصات:

### Android:
```bash
flutter run -d android
```

### iOS (على Mac فقط):
```bash
flutter run -d ios
```

## التحقق من الأجهزة المتاحة

لرؤية جميع الأجهزة المتاحة:

```bash
flutter devices
```



