# eStore: Unmanned Self-Checkout

A Flutter app for a staff-free self-checkout store. Shoppers scan product barcodes or QR codes to build their cart, then pay by card through Flutterwave or with cash at a cashier. To stop cheating, the app compares the **measured weight of the physical cart** with the **total weight of the scanned items**, and the cart can't be confirmed unless they match.

## Features

- Scan items with the camera to add them to the cart (`flutter_barcode_scanner`)
- Cart with quantities, running total in LKR and per-item weight
- **Weight check**: blocks checkout with *"Cart weight is not equal"* when the scale reading and the scanned items don't match
- Card payments with **Flutterwave**, or "pay cash via cashier"
- Cart history and a shopping list (to-do style)
- Screen for adding new items to the store
- Firebase email/password login, registration and an editable profile

## Tech stack

- **Flutter** (Dart)
- **Firebase Authentication** and **Cloud Firestore**
- **Flutterwave Standard** for payments
- `flutter_barcode_scanner`, `shared_preferences`, `uuid`, `google_fonts`, `flutter_spinkit`

## Data model

The Firestore structure is documented in [`data structure for estore firestore db.png`](data%20structure%20for%20estore%20firestore%20db.png).

## Project structure

```
lib/
  models/       item, shopping list entry
  screens/      landing, login, register, home, shopping cart, checking page,
                payment, cart history, shopping list, add item, edit profile
  services/     Firebase and payment services
  widgets/      drawer, bottom tabs, inputs, buttons, avatar
```

## Getting started

1. Add your Firebase config files and enable Email/Password auth and Firestore.
2. Replace the `publicKey: "xxxxx"` placeholder in `lib/screens/payment.dart` with your Flutterwave public key.
3. Run:
   ```bash
   flutter pub get
   flutter run
   ```

> Built in 2022. Upgrade the Firebase and Flutterwave plugins before building with a current Flutter SDK.

## License

See [LICENSE](LICENSE).
