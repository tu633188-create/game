part of '../main.dart';

class LevelView extends StatefulWidget {
  const LevelView({
    super.key,
    this.duration = const Duration(seconds: 30),
    this.moles = 9,
    this.onCoinEarned,
    this.onCoinSubtracted,
    this.onGameStart,
  });
  final Duration duration;
  final int moles;
  final Function(int)? onCoinEarned;
  final Function(int)? onCoinSubtracted;
  final VoidCallback? onGameStart;

  @override
  State<LevelView> createState() => _LevelViewState();
}

class _LevelViewState extends State<LevelView> {
  late final LevelController controller =
      LevelController(
          initialDuration: widget.duration,
          totalMoles: widget.moles,
        )
        ..onCoinEarned = widget.onCoinEarned
        ..onCoinSubtracted = widget.onCoinSubtracted;

  @override
  void initState() {
    super.initState();
    bool isDialogShown = false;
    // Gọi callback khi game bắt đầu
    widget.onGameStart?.call();
    controller
      ..start()
      ..addListener(() async {
        if (controller.isGameOver && !isDialogShown) {
          isDialogShown = true;
          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) => GameoverView(controller: controller),
          );
          isDialogShown = false;
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/games/whack_a_mole/bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: ListenableBuilder(
              listenable: controller,
              builder: (context, _) {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          '${controller.countdown}'.replaceAll(
                            RegExp(r'^\d+:|(?=\.).*'),
                            '',
                          ),
                          style: const TextStyle(
                            fontFamily: 'WhackAMole',
                            fontSize: 40.0,
                            color: Colors.brown,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final rows = sqrt(controller.moles.length).ceil();
                          final size = constraints.biggest / rows.toDouble();
                          return Wrap(
                            alignment: WrapAlignment.center,
                            children: [
                              for (var mole in controller.moles)
                                MoleView(
                                  mole,
                                  size: size,
                                  onTap: () => controller.onTap(mole),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
