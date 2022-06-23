import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/gym_app_provider.dart';

class GymCard extends StatefulWidget {
  const GymCard(
      {Key? key,
      required this.name,
      required this.seconds,
      this.onTap,
      this.onLongPress})
      : super(key: key);
  final String name;
  final int seconds;
  final Function()? onTap;
  final Function()? onLongPress;

  @override
  State<GymCard> createState() => _GymCardState();
}

class _GymCardState extends State<GymCard> {
  Duration duration = const Duration();
  late Timer? timer;
  bool running = false;

  @override
  void initState() {
    super.initState();
    timer = Timer(
      const Duration(seconds: 1),
      () {},
    );
    reset();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void reset() {
    timer?.cancel();
    Duration downduration = Duration(seconds: widget.seconds);
    duration = downduration;

    setState(() {});
  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    } else {
      setState(() {
        timer?.cancel();
      });
    }
  }

  void removeTime() async {
    const removesecond = -1;
    final seconds = duration.inSeconds + removesecond;
    setState(() {
      duration = Duration(seconds: seconds);
    });
    seconds == 1
        ? ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Hurray..! Done with ${widget.name}'),
            ),
          )
        : null;

    if (seconds <= 0) {
      timer?.cancel();

      Duration downduration = Duration(seconds: widget.seconds);
      duration = downduration;
      setState(() {});
    } else {
      duration = Duration(seconds: seconds);
    }
  }

  void startCountDown() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      removeTime();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: InkWell(
        onLongPress: widget.onLongPress,
        onTap: widget.onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                widget.name,
                style: const TextStyle(
                  fontSize: 20.0,
                ),
              ),
              trailing: running
                  ? Text(
                      '${duration.inSeconds} sec',
                      style: const TextStyle(
                        fontSize: 20.0,
                      ),
                    )
                  : Text(
                      '${widget.seconds} sec',
                      style: const TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
            ),
            actionsButtons(),
          ],
        ),
      ),
    );
  }

  Widget actionsButtons() {
    final isRunning = timer == null ? false : timer!.isActive;
    return Consumer<Flag>(
      builder: (context, provider, child) {
        return !isRunning
            ? Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      if (provider.flag) {
                        provider.setFlag(false);
                        startCountDown();
                      }
                      running = true;
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green)),
                    child: const Text(
                      'Start',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      stopTimer(resets: false);
                      provider.setFlag(true);
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green)),
                    child: const Text(
                      'Pause',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  TextButton(
                    onPressed: () {
                      stopTimer(resets: true);
                      provider.setFlag(true);
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green)),
                    child: const Text(
                      'Reset',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              );
      },
    );
  }
}
