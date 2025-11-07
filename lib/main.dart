import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

/// MyApp: sets up Theme switching and hosts HomePage
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme(bool dark) {
    setState(() {
      _themeMode = dark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    final light = ThemeData(
      brightness: Brightness.light,
      colorSchemeSeed: Colors.indigo,
      useMaterial3: true,
    );
    final dark = ThemeData(
      brightness: Brightness.dark,
      colorSchemeSeed: Colors.indigo,
      useMaterial3: true,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MP Lab - Advanced UI',
      theme: light,
      darkTheme: dark,
      themeMode: _themeMode,
      home: HomePage(
          onThemeChanged: _toggleTheme, isDark: _themeMode == ThemeMode.dark),
    );
  }
}

/// CustomTitle: requirement #2 (stateless, text bold size 24, accepts text and color)
class CustomTitle extends StatelessWidget {
  final String text;
  final Color? color;

  const CustomTitle({Key? key, required this.text, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: color ?? Theme.of(context).textTheme.titleLarge?.color,
      ),
    );
  }
}

/// CustomCounter: requirement #3 (stateful widget with + and -)
class CustomCounter extends StatefulWidget {
  final int initial;
  final void Function(int)? onChanged;

  const CustomCounter({Key? key, this.initial = 0, this.onChanged})
      : super(key: key);

  @override
  State<CustomCounter> createState() => _CustomCounterState();
}

class _CustomCounterState extends State<CustomCounter> {
  late int _count;

  @override
  void initState() {
    super.initState();
    _count = widget.initial;
  }

  void _inc() {
    setState(() {
      _count++;
    });
    widget.onChanged?.call(_count);
  }

  void _dec() {
    setState(() {
      _count--;
    });
    widget.onChanged?.call(_count);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(onPressed: _dec, icon: Icon(Icons.remove)),
        Text('$_count', style: TextStyle(fontSize: 20)),
        IconButton(onPressed: _inc, icon: Icon(Icons.add)),
      ],
    );
  }
}

/// MovingLogo: requirement #6 (explicit animation, AnimationController + Tween)
class MovingLogo extends StatefulWidget {
  const MovingLogo({Key? key}) : super(key: key);

  @override
  State<MovingLogo> createState() => _MovingLogoState();
}

class _MovingLogoState extends State<MovingLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    _animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {
          _progress = _animation.value;
        });
      });
  }

  void _run() {
    _controller.reset();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 80,
          width: double.infinity,
          child: LayoutBuilder(builder: (context, constraints) {
            final maxShift = constraints.maxWidth - 60;
            final left = maxShift * _progress;
            return Stack(
              children: [
                Positioned(left: left, top: 10, child: FlutterLogo(size: 60)),
              ],
            );
          }),
        ),
        SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: _run,
          icon: Icon(Icons.play_arrow),
          label: Text('Run Logo Animation'),
        ),
      ],
    );
  }
}

/// GestureBox: requirement #7 (detect tap, double tap, long press)
class GestureBox extends StatefulWidget {
  const GestureBox({Key? key}) : super(key: key);

  @override
  State<GestureBox> createState() => _GestureBoxState();
}

class _GestureBoxState extends State<GestureBox> {
  Color _bg = Colors.grey.shade300;
  String _last = 'None';

  void _set(Color c, String name) {
    setState(() {
      _bg = c;
      _last = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _set(Colors.green.shade300, 'Single Tap'),
      onDoubleTap: () => _set(Colors.blue.shade300, 'Double Tap'),
      onLongPress: () => _set(Colors.orange.shade300, 'Long Press'),
      child: Container(
        height: 100,
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: _bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black26),
        ),
        child: Center(child: Text('Gesture: $_last')),
      ),
    );
  }
}

/// AnimatedBoxes: requirement #1 (Container, Row, Column, Wrap)
class AnimatedBoxes extends StatelessWidget {
  const AnimatedBoxes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Boxes (Container, Row, Column, Wrap):'),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _box(Colors.red, 'A'),
                    _box(Colors.green, 'B'),
                    _box(Colors.blue, 'C'),
                    _box(Colors.purple, 'D'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _box(Color c, String label) {
    return Container(
      width: 70,
      height: 70,
      color: c,
      child: Center(child: Text(label, style: TextStyle(color: Colors.white))),
    );
  }
}

/// AnimatedContainerExample: requirement #5
class AnimatedContainerExample extends StatefulWidget {
  const AnimatedContainerExample({Key? key}) : super(key: key);

  @override
  State<AnimatedContainerExample> createState() =>
      _AnimatedContainerExampleState();
}

class _AnimatedContainerExampleState extends State<AnimatedContainerExample> {
  bool _toggled = false;

  void _toggle() {
    setState(() {
      _toggled = !_toggled;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = _toggled ? 160.0 : 100.0;
    final radius = _toggled ? 32.0 : 8.0;
    final color = _toggled ? Colors.teal : Colors.deepOrange;

    return GestureDetector(
      onTap: _toggle,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Center(
            child: Text('Tap me', style: TextStyle(color: Colors.white))),
      ),
    );
  }
}

/// AnimatedListDemo: requirement #9
class AnimatedListDemo extends StatefulWidget {
  const AnimatedListDemo({Key? key}) : super(key: key);

  @override
  State<AnimatedListDemo> createState() => _AnimatedListDemoState();
}

class _AnimatedListDemoState extends State<AnimatedListDemo> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<String> _items = [];
  int _counter = 0;

  void _addItem() {
    final index = _items.length;
    final newItem = 'Item ${++_counter}';
    _items.insert(index, newItem);
    _listKey.currentState
        ?.insertItem(index, duration: Duration(milliseconds: 400));
  }

  void _removeItem(int index) {
    final removed = _items.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) =>
          SizeTransition(sizeFactor: animation, child: _buildTile(removed)),
      duration: Duration(milliseconds: 300),
    );
  }

  Widget _buildTile(String text) {
    return ListTile(title: Text(text), trailing: Icon(Icons.delete));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          ElevatedButton.icon(
              onPressed: _addItem,
              icon: Icon(Icons.add),
              label: Text('Add item')),
        ]),
        SizedBox(height: 8),
        Container(
          height: 200,
          decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
          child: AnimatedList(
            key: _listKey,
            initialItemCount: _items.length,
            itemBuilder: (context, index, animation) {
              final item = _items[index];
              return SizeTransition(
                sizeFactor: animation,
                child: Dismissible(
                  key: ValueKey(item),
                  onDismissed: (dir) => _removeItem(index),
                  child: ListTile(
                    title: Text(item),
                    trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _removeItem(index)),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// HomePage: combines everything
class HomePage extends StatefulWidget {
  final void Function(bool) onThemeChanged;
  final bool isDark;
  const HomePage({Key? key, required this.onThemeChanged, required this.isDark})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counterValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MP Lab - Themed Interactive UI'),
        actions: [
          Row(
            children: [
              Icon(Icons.light_mode, size: 18),
              Switch(value: widget.isDark, onChanged: widget.onThemeChanged),
              Icon(Icons.dark_mode, size: 18),
              SizedBox(width: 8),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Center(
          child: Column(
            children: [
              CustomTitle(
                  text: 'Welcome to MP Lab',
                  color: Theme.of(context).colorScheme.primary),
              SizedBox(height: 12),
              AnimatedBoxes(),
              Divider(),
              CustomTitle(text: 'Counter Section'),
              CustomCounter(
                  initial: 0,
                  onChanged: (val) => setState(() => _counterValue = val)),
              SizedBox(height: 6),
              Text('Counter value used elsewhere: $_counterValue'),
              Divider(),
              CustomTitle(text: 'AnimatedContainer (Tap to change)'),
              AnimatedContainerExample(),
              Divider(),
              CustomTitle(text: 'Explicit Animation'),
              MovingLogo(),
              Divider(),
              CustomTitle(text: 'Gesture Detector Practice'),
              GestureBox(),
              Divider(),
              CustomTitle(text: 'Animated List'),
              AnimatedListDemo(),
              Divider(),
              CustomTitle(text: 'Mini Project: Themed Interactive Card'),
              SizedBox(height: 8),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 6,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    children: [
                      CustomTitle(
                          text: 'Profile Card',
                          color: Theme.of(context).colorScheme.secondary),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(radius: 30, child: Icon(Icons.person)),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Asilbek Axmadjonov',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text('Student • UI Lab'),
                              SizedBox(height: 6),
                              CustomCounter(
                                initial: 0,
                                onChanged: (val) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Counter updated: $val'),
                                      duration: Duration(milliseconds: 600),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                              title: Text('Hello'),
                              content: Text('You tapped the card!')),
                        ),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                          width: double.infinity,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.2),
                                Colors.transparent
                              ],
                            ),
                          ),
                          child: Center(
                              child: Text('Tap this area to see a dialog')),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
