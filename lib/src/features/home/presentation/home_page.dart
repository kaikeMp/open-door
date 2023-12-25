import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../injection_container.dart';
import 'cubit/home_cubit.dart';

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
  final _cubit = sl.get<HomeCubit>();

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
          title: const Text('Open Door'),
        ),
        body: Stack(
          alignment: Alignment.center,
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
            BlocBuilder<HomeCubit, HomeState>(
              bloc: _cubit,
              builder: (context, state) {
                if (state is HomeLoading) {
                  return const CircularProgressIndicator(color: Colors.black);
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async => _cubit.openDoor(),
                      child: const Text('Abrir porta'),
                    ),
                    const SizedBox(height: 20),
                    if (state is HomeError)
                      Text(
                        'Error: ${state.error}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )
                  ],
                );
              },
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FutureBuilder(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    final data = snapshot.data;

                    if (data == null || snapshot.hasError) {
                      return const SizedBox();
                    }

                    return Text(data.version);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
