# StreamBuilder Chat Demo

A small Flutter app built for my Mobile App Development class to demonstrate the **`StreamBuilder`** widget.

## Presentation Details

| | |
|---|---|
| **Widget presented** | `StreamBuilder` |
| **Day presented** | Monday, 26 October 2026 |
| **Week** | Week 9 |
| **Presenter** | Nelson Sam Ishimwe |
| **Email** | n.ishimwe7@alustudent.com |

## What is StreamBuilder?

`StreamBuilder` is a Flutter widget that listens to a **stream** (data that arrives over time) and automatically rebuilds the screen every time new data arrives. No manual refresh and no `setState` are needed.

It is used in real-time apps such as chat apps, live scores, Firebase data, location tracking and notifications.

## About the App

A simple chat app with a friend called Alex. It works without internet or Firebase.

- You send a message.
- Alex's status changes from **online** to **typing...**
- After two seconds, Alex replies and the status goes back to **online**.

The screen updates by itself because two `StreamBuilder` widgets are listening to two streams.

## How It Works

| Part | What it does |
|---|---|
| `Message` | Holds the message text and whether I sent it (`isMe`) |
| `ChatService` | Creates two streams with `StreamController` (messages and typing status) and simulates Alex's replies |
| `StreamBuilder<bool>` | Listens to the typing stream and shows "typing..." or "online" in the top bar |
| `StreamBuilder<List<Message>>` | Listens to the messages stream and rebuilds the chat bubbles |

### Key properties of StreamBuilder

- `stream`: which stream to listen to
- `initialData`: what to show before the first data arrives
- `builder`: a function that runs every time new data comes in, receiving a `snapshot` with the latest value

## Run the App

```bash
flutter pub get
flutter run
```

## Where this is used in real apps

Firebase Firestore chats, live location tracking, stock prices and notifications. If the fake `ChatService` were replaced with Firebase, the `StreamBuilder` code would stay almost the same.

## Built With

- Flutter
- Dart (`dart:async` for `StreamController`)
