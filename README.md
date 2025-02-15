# flutter_application_1

A new Flutter project.สำหรับจัดการข้อมูลนักศึกษา โดยใช้ Firebase Firestore สำหรับเก็บข้อมูล ซึ่งอนุญาตให้ผู้ใช้สามารถเพิ่ม แก้ไข ลบ และดูข้อมูลนักศึกษาแบบเรียลไทม์


## ฟีเจอร์
- เพิ่มข้อมูลนักศึกษา: กรอกชื่อ, รหัสนักเรียน, สาขาวิชา, ปีการศึกษา
- แก้ไขข้อมูลนักศึกษา: แก้ไขข้อมูลของนักศึกษาที่มีอยู่
- ลบข้อมูลนักศึกษา: ลบข้อมูลของนักศึกษาออกจากฐานข้อมูล 
- อัพเดตแบบเรียลไทม์: แอปจะฟังการเปลี่ยนแปลงใน และอัพเดต UI อัตโนมัติเมื่อมีการเปลี่ยนแปลงข้อมูล

## Add pub library

to add firebase to project

```
 flutter pub add cloud_firestore
 flutter pub add firebase_core
```
## Connect to Firebase project


```
dart pub global activate flutterfire_cli
flutterfire configure --project=[FIREBASE_PROJECT_CONSOLE_NAME]
```
