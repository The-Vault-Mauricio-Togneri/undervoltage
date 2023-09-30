import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:idlebattle/widgets/game_container.dart';

class PingPongScreen extends StatelessWidget {
  static FadeRoute instance() => FadeRoute(PingPongScreen());

  @override
  Widget build(BuildContext context) {
    return const GameContainer(
      child: TableContainer(),
    );
  }
}

class TableContainer extends StatelessWidget {
  const TableContainer();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Center(
        child: AspectRatio(
          aspectRatio: 5 / 9,
          child: Table(
            child: ForceDetector(
              onPush: _onPush,
            ),
          ),
        ),
      ),
    );
  }

  void _onPush(Offset start, Offset force) {
    print('FORCE: ${start.dx} ${start.dy} ${force.dx} ${force.dy}');
  }
}

class Table extends StatelessWidget {
  final Widget child;

  const Table({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TablePainter(),
      child: child,
    );
  }
}

class TablePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    paint.color = Colors.white;
    paint.style = PaintingStyle.stroke;

    final Rect rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width * 0.7,
      height: size.height * 0.7,
    );

    canvas.drawRect(rect, paint);

    canvas.drawLine(
      Offset(size.width * 0.15, size.height / 2),
      Offset(size.width * 0.85, size.height / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(TablePainter oldDelegate) => false;
}

class ForceDetector extends StatefulWidget {
  final Function(Offset, Offset) onPush;

  const ForceDetector({
    required this.onPush,
  });

  @override
  State<ForceDetector> createState() => _ForceDetectorState();
}

class _ForceDetectorState extends State<ForceDetector> {
  double startX = 0;
  double startY = 0;
  double endX = 0;
  double endY = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: (details) => _onPanEnd(details, constraints),
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    startX = details.localPosition.dx;
    startY = details.localPosition.dy;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    endX = details.localPosition.dx;
    endY = details.localPosition.dy;
  }

  void _onPanEnd(DragEndDetails details, BoxConstraints constraints) {
    final double forceX = endX - startX;
    final double forceY = endY - startY;

    final double width = constraints.maxWidth;
    final double height = constraints.maxHeight;

    final Offset start = Offset(startX / width, startY / height);
    final Offset end = Offset(forceX / width, -forceY / height);

    widget.onPush(start, end);
  }
}
