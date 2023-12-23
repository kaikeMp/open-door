import 'package:flutter/material.dart';
import 'package:open_door/src/features/home/domain/repositories/open_door_repository.dart';

import '../../../injection_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Alignment> _topAlignAnimation;
  late Animation<Alignment> _bottomAlignAnimation;
  final _openDoorRepository = sl.get<OpenDoorRepository>();

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _topAlignAnimation = TweenSequence<Alignment>(
      [
        _sequenceAnimation(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),
        _sequenceAnimation(
          begin: Alignment.topRight,
          end: Alignment.bottomRight,
        ),
        _sequenceAnimation(
          begin: Alignment.bottomRight,
          end: Alignment.bottomLeft,
        ),
        _sequenceAnimation(
          begin: Alignment.bottomLeft,
          end: Alignment.topLeft,
        ),
      ],
    ).animate(_animationController);

    _bottomAlignAnimation = TweenSequence<Alignment>(
      [
        _sequenceAnimation(
          begin: Alignment.bottomRight,
          end: Alignment.bottomLeft,
        ),
        _sequenceAnimation(
          begin: Alignment.bottomLeft,
          end: Alignment.topLeft,
        ),
        _sequenceAnimation(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),
        _sequenceAnimation(
          begin: Alignment.topRight,
          end: Alignment.bottomRight,
        ),
      ],
    ).animate(_animationController);

    _animationController.repeat();

    super.initState();
  }

  TweenSequenceItem<Alignment> _sequenceAnimation({
    required Alignment begin,
    required Alignment end,
  }) {
    return TweenSequenceItem<Alignment>(
      tween: Tween<Alignment>(
        begin: begin,
        end: end,
      ),
      weight: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Open Door'),
        ),
        body: Stack(
          children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, _) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: const [
                        Colors.red,
                        Colors.blue,
                      ],
                      begin: _topAlignAnimation.value,
                      end: _bottomAlignAnimation.value,
                    ),
                  ),
                );
              },
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                child: Text('Open Door'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
