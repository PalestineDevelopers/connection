# palestine_connection

## Part of [PalestineDevelopers](https://github.com/PalestineDevelopers)

Lightweight internet connection test, lookup Google domain.

[![License](https://img.shields.io/github/license/PalestineDevelopers/connection?style=for-the-badge)](https://github.com/PalestineDevelopers)
[![Pub](https://img.shields.io/badge/Palestine%20Connection-pub-blue?style=for-the-badge)](https://pub.dev/packages/palestine_connection)
[![Example](https://img.shields.io/badge/Example-Ex-success?style=for-the-badge)](https://pub.dev/packages/palestine_connection/example)

[![GitHub release](https://img.shields.io/github/v/release/PalestineDevelopers/connection?style=for-the-badge)](https://github.com/PalestineDevelopers/connection/releases)
[![GitHub stars](https://img.shields.io/github/stars/PalestineDevelopers/connection?style=for-the-badge)](https://github.com/PalestineDevelopers/connection)
[![GitHub forks](https://img.shields.io/github/forks/PalestineDevelopers/connection?style=for-the-badge)](https://github.com/PalestineDevelopers/connection)

## Table Of Contents

* [Features](#features)
* [Getting started](#getting-started)
* [Usage](#usage)

## Features

* Periodic internet connection tests
* dispose method

## Getting started

To start, import package

```dart
import 'package:palestine_connection/palestine_connection.dart';
```

## Usage

Just as easy as this

```dart
final PalConnection connection = PalConnection();
connection.initialize(
    domain: PalDomain.random, // Domain To Test On (optional)
    periodicInSeconds: 3, // 3 seconds
    onConnectionLost: () {
      // No Internet
    },
    onConnectionRestored: () {
      // Internet is back
    },
  );
```

It could get more easier actually

```dart
PalConnection().initialize(
    periodicInSeconds: 3, // 3 seconds
    onConnectionLost: () {
      // No Internet
    },
    onConnectionRestored: () {
      // Internet is back
    },
  );
```

Then you could dispose it

```dart
connection.dispose();
```
