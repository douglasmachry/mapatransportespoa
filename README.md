# Mapa Transportes POA — iOS Prototype

A historical iOS application prototype for searching public bus lines in Porto Alegre, Brazil, and requesting their itinerary data.

> **Status:** Study project last updated in June 2019. The original transport API endpoint and current service availability have not been verified.

## What the app explores

- Loads a list of bus lines from the POA Transporte service.
- Provides search and picker controls to filter/select a line by code or name.
- Requests itinerary data for the selected line.
- Uses MapKit and Core Location to present a map view and request the user's location.
- Tracks location updates and calculates the distance between consecutive location readings.

The source contains early API and map flows; it should not be treated as a complete, currently operational public-transport application.

## Technology

- Swift
- UIKit and Storyboards
- MapKit
- Core Location
- URLSession
- Codable / JSONDecoder
- Core Data project scaffold

## Original API integration

The original code calls the POA Transporte API over plain HTTP:

```text
http://www.poatransporte.com.br/php/facades/process.php
```

It uses the `nc&t=o` action to load bus lines and the `il&p={lineId}` action to request an itinerary. These endpoints are retained here only to explain the original integration; their present-day availability and security have not been checked.

## Project layout

```text
projetoDouglas/
  AppDelegate.swift
  ViewController.swift
  MapViewController.swift
  Info.plist
  Base.lproj/
  projetoDouglas.xcdatamodeld/
projetoDouglas.xcodeproj/
```

## Running the historical project

Open `projetoDouglas.xcodeproj` in Xcode. The project uses APIs and project settings from the 2019 iOS ecosystem and may require migration to build with a current Xcode/iOS SDK. The original external API may also be unavailable or may have changed its response format.

## Security and privacy notes

The original `Info.plist` allows arbitrary network loads, and the transport requests use HTTP. A production successor should use HTTPS, remove broad App Transport Security exceptions, handle network errors and API changes, and explain location use to the user. No current transport-service uptime or accuracy is claimed.
