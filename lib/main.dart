import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CarouselView Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system, // follows the phone's dark/light setting
      home: const MyHomePage(title: 'Travel Destinations'),
    );
  }
}

/// Simple data model (cleaner and safer than Map<String, dynamic>).
class Destination {
  final String name;
  final String country;
  final String image;
  final String description;

  const Destination({
    required this.name,
    required this.country,
    required this.image,
    required this.description,
  });
}

const List<Destination> destinations = [
  Destination(
    name: 'Kigali',
    country: 'Rwanda',
    image:
        'https://images.unsplash.com/photo-1675756261486-09bd1e0f6c8a?auto=format&fit=crop&w=800&q=80',
    description: 'A clean and beautiful city in the heart of Rwanda.',
  ),
  Destination(
    name: 'Cape Town',
    country: 'South Africa',
    image:
        'https://images.unsplash.com/photo-1580060839134-75a5edca2e99?auto=format&fit=crop&w=800&q=80',
    description: 'Explore mountains, beaches, and beautiful landscapes.',
  ),
  Destination(
    name: 'Nairobi',
    country: 'Kenya',
    image:
        'https://images.unsplash.com/photo-1611348586804-61bf6c080437?auto=format&fit=crop&w=800&q=80',
    description: 'Experience wildlife and modern city life together.',
  ),
  Destination(
    name: 'Zanzibar',
    country: 'Tanzania',
    image:
        'https://images.unsplash.com/photo-1518509562904-e7ef99cdcc86?auto=format&fit=crop&w=800&q=80',
    description: 'Relax on beautiful beaches surrounded by turquoise water.',
  ),
];

// =============================================================================
// HOME PAGE
// =============================================================================
// StatefulWidget because we own a CarouselController (it must be created once
// and disposed, exactly like a ScrollController or PageController).
class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // CarouselController lets code scroll the carousel: animateToItem(index).
  final CarouselController _controller = CarouselController(initialItem: 0);
  int _current = 0; // which item we last jumped to with the buttons

  @override
  void dispose() {
    _controller.dispose(); // always dispose controllers to avoid memory leaks
    super.dispose();
  }

  void _goTo(int index) {
    final i = index.clamp(0, destinations.length - 1);
    setState(() => _current = i);
    _controller.animateToItem(
      i,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _showSelected(Destination d) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('You selected ${d.name}')));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      // The page can be taller than a small phone screen -> make it scrollable
      // so nothing overflows.
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          // -------------------------------------------------------------
          // HEADER
          // -------------------------------------------------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('Explore Destinations',
                style: textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
            child: Text('Discover beautiful places around Africa.',
                style: textTheme.bodyLarge
                    ?.copyWith(color: Theme.of(context).hintColor)),
          ),

          // -------------------------------------------------------------
          // 1) CarouselView  (FIXED item size)
          // -------------------------------------------------------------
          const _SectionTitle(
            '1. CarouselView  (fixed itemExtent)',
            'Every item is exactly 280 px wide. Items at the edge shrink '
                'down to shrinkExtent as you scroll. itemSnapping makes the '
                'carousel settle neatly on an item.',
          ),
          SizedBox(
            // A horizontal carousel needs a bounded HEIGHT. The width comes
            // from the parent (full screen), the height we give here.
            height: 360,
            child: CarouselView(
              // itemExtent = size of each item ALONG the scroll direction.
              // Horizontal scroll -> this is the item's WIDTH.
              itemExtent: 280,

              // Smallest size an item may shrink to when it slides off the
              // edge. Default is 0 (shrinks to nothing). 150 keeps a peek.
              shrinkExtent: 150,

              // true = after you lift your finger, it snaps to an item.
              itemSnapping: true,

              // Space around EACH item.
              padding: const EdgeInsets.symmetric(horizontal: 6),

              // Shape / elevation / background are applied by CarouselView
              // itself (it wraps every child in a Material). That is why we
              // do NOT wrap the content in a Card like before: it would be a
              // card inside a card.
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),

              // onTap gives you the INDEX of the tapped item. No need to put
              // a button inside each child just to detect taps.
              onTap: (index) => _showSelected(destinations[index]),

              // children = the items. Each child is forced to the item size.
              children: [
                for (final d in destinations) DestinationCard(destination: d),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // -------------------------------------------------------------
          // 2) CarouselView.weighted  (items have DIFFERENT sizes)
          // -------------------------------------------------------------
          const _SectionTitle(
            '2. CarouselView.weighted  (flexWeights)',
            'Sizes are ratios, like Flex/Expanded. [1, 6, 1] means: left '
                'item small, middle item BIG (the hero), right item small. '
                'The layout adapts to any screen width, and it is driven by '
                'a CarouselController so the buttons below can move it.',
          ),
          SizedBox(
            height: 300,
            child: CarouselView.weighted(
              controller: _controller,
              // Each number is the share of the screen width one slot gets.
              // With [1, 6, 1] the middle slot gets 6/8 of the width.
              flexWeights: const [1, 6, 1],
              // true = the biggest slot may use the full available width
              // when the carousel is at the start/end.
              consumeMaxWeight: true,
              itemSnapping: true,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              onTap: (index) => _showSelected(destinations[index]),
              children: [
                for (final d in destinations)
                  OverflowBox(
                    minWidth: 260,
                    maxWidth: 260,
                    child: DestinationCard(destination: d, compact: true),
                  ),
              ],
            ),
          ),

          // Buttons that control the carousel from code.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filledTonal(
                  tooltip: 'Previous',
                  onPressed: _current > 0 ? () => _goTo(_current - 1) : null,
                  icon: const Icon(Icons.arrow_back),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '${_current + 1} / ${destinations.length}',
                    style: textTheme.titleMedium,
                  ),
                ),
                IconButton.filledTonal(
                  tooltip: 'Next',
                  onPressed: _current < destinations.length - 1
                      ? () => _goTo(_current + 1)
                      : null,
                  icon: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ),

          Center(
            child: Text('Swipe left or right to explore',
                style: textTheme.bodySmall
                    ?.copyWith(color: Theme.of(context).hintColor)),
          ),
          const SizedBox(height: 24),

          // -------------------------------------------------------------
          // CHEAT SHEET
          // -------------------------------------------------------------
          const _CheatSheet(),
        ],
      ),
    );
  }
}

// =============================================================================
// ONE CAROUSEL ITEM
// =============================================================================
class DestinationCard extends StatelessWidget {
  final Destination destination;
  final bool compact; // smaller text for the weighted carousel

  const DestinationCard({
    super.key,
    required this.destination,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand, // make every layer fill the whole item
      children: [
        // ---- Layer 1: the picture -----------------------------------
        Image.network(
          destination.image,
          fit: BoxFit.cover,

          // Shown WHILE downloading (on a slow phone connection this is
          // what you will see for a moment).
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child; // finished -> show image
            return Container(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                value: progress.expectedTotalBytes != null
                    ? progress.cumulativeBytesLoaded /
                        progress.expectedTotalBytes!
                    : null,
              ),
            );
          },

          // Shown if the download FAILS (no internet, missing INTERNET
          // permission, 404 ...). Without this you just see an empty card
          // and have no clue why.
          errorBuilder: (context, error, stack) {
            debugPrint('Image failed: ${destination.image}\n$error');
            return Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.broken_image_outlined,
                      size: 48,
                      color: Theme.of(context).colorScheme.onPrimaryContainer),
                  const SizedBox(height: 8),
                  Text('Image not available',
                      style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer)),
                ],
              ),
            );
          },
        ),

        // ---- Layer 2: dark gradient so white text stays readable -----
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                // withOpacity is deprecated in new Flutter -> withValues.
                Colors.black.withValues(alpha: 0.85),
              ],
            ),
          ),
        ),

        // ---- Layer 3: the text ---------------------------------------
        Positioned(
          left: 20,
          right: 20,
          bottom: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(destination.country,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  softWrap: false,
                  style: const TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 4),
              Text(destination.name,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  softWrap: false,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: compact ? 24 : 28,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(destination.description,
                  maxLines: compact ? 2 : 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// SMALL UI HELPERS
// =============================================================================
class _SectionTitle extends StatelessWidget {
  final String title;
  final String body;
  const _SectionTitle(this.title, this.body);

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: t.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(body,
              style: t.bodyMedium?.copyWith(color: Theme.of(context).hintColor)),
        ],
      ),
    );
  }
}

class _CheatSheet extends StatelessWidget {
  const _CheatSheet();

  @override
  Widget build(BuildContext context) {
    const rows = <(String, String)>[
      ('itemExtent', 'Fixed size of each item along the scroll direction.'),
      ('flexWeights', 'Ratios for item sizes (CarouselView.weighted only).'),
      ('shrinkExtent', 'Minimum size an item shrinks to at the edges.'),
      ('itemSnapping', 'Settle exactly on an item after a swipe.'),
      ('controller', 'CarouselController: animateToItem(), jumpToItem().'),
      ('onTap', 'Called with the tapped item index.'),
      ('scrollDirection', 'Axis.horizontal (default) or Axis.vertical.'),
      ('reverse', 'Reverse the scroll order.'),
      ('padding / shape / elevation', 'Styling applied to every item.'),
    ];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('CarouselView cheat sheet',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            for (final r in rows)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(r.$1,
                          style: const TextStyle(
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.w600)),
                    ),
                    Expanded(child: Text(r.$2)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
