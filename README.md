# CarouselView Demo

A small Flutter app that shows how the `CarouselView` widget works, using a list of African travel destinations.

## What is CarouselView?

`CarouselView` is a Material 3 widget that shows a row of items you can swipe through. Items shrink as they slide off the edge, and it can snap to an item when you let go. It needs Flutter 3.24 or newer.

## Two ways to use it

**1. Fixed size: `CarouselView`**

Every item has the same size.

```dart
CarouselView(
  itemExtent: 280,      // width of each item
  shrinkExtent: 150,    // smallest size at the edges
  itemSnapping: true,   // settle on an item after a swipe
  onTap: (index) => print('Tapped $index'),
  children: [ /* your widgets */ ],
)
```

**2. Different sizes: `CarouselView.weighted`**

Item sizes are ratios, like `Expanded`. `[1, 6, 1]` gives a small item, a big hero item and a small item.

```dart
CarouselView.weighted(
  flexWeights: const [1, 6, 1],
  children: [ /* your widgets */ ],
)
```

## Key properties

| Property | What it does |
|---|---|
| `itemExtent` | Fixed size of each item along the scroll direction |
| `flexWeights` | Size ratios (weighted version only) |
| `shrinkExtent` | Minimum size items shrink to at the edges |
| `itemSnapping` | Snap to an item after a swipe |
| `controller` | `CarouselController`, scroll from code with `animateToItem()` |
| `onTap` | Called with the index of the tapped item |
| `scrollDirection` | `Axis.horizontal` (default) or `Axis.vertical` |

## Good to know

- The carousel needs a bounded height, so wrap it in a `SizedBox(height: ...)`.
- `CarouselView` wraps each item in its own `Material`, so you don't need a `Card` inside.
- Dispose any `CarouselController` you create.

## Images not showing in the APK?

`Image.network` needs internet access. Release builds don't get it by default, so add this to `android/app/src/main/AndroidManifest.xml`, above `<application>`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

Then rebuild:

```
flutter clean
flutter build apk --release
```

## Run it

```
flutter pub get
flutter run
```

## Learn more

- [CarouselView API docs](https://api.flutter.dev/flutter/material/CarouselView-class.html)
- [Flutter documentation](https://docs.flutter.dev)
