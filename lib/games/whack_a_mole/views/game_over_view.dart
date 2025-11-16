part of '../main.dart';

class GameoverView extends StatefulWidget {
  const GameoverView({super.key, required this.controller});
  final LevelController controller;

  @override
  State<GameoverView> createState() => _GameoverViewState();
}

class _GameoverViewState extends State<GameoverView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        child: Container(
          width: 300.0,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Game Over',
                style: TextStyle(
                  color: Colors.brown,
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                alignment: Alignment.center,
                height: kToolbarHeight * 1.5,
                width: 200.0,
                child: Text.rich(
                  TextSpan(
                    text: 'Your Record\n',
                    children: [
                      TextSpan(
                        text: widget.controller.result?.toString().replaceAll(
                          RegExp(r'^\d+:|(?=\.).*'),
                          '',
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              // Hiển thị coin kiếm được trong game
              Text(
                'Coin kiếm được: ${widget.controller.coinsEarned}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: const Text('Đóng'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
