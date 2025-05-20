import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:chat_package/models/chat_message.dart';
import 'package:chat_package/utils/constants.dart';

/// Renders an audio message bubble with play/pause, seek bar, and timer.
class AudioMessageWidget extends StatefulWidget {
  final ChatMessage message;
  final Color senderColor;
  final Color inactiveAudioSliderColor;
  final Color activeAudioSliderColor;

  const AudioMessageWidget({
    Key? key,
    required this.message,
    required this.senderColor,
    required this.inactiveAudioSliderColor,
    required this.activeAudioSliderColor,
  }) : super(key: key);

  @override
  _AudioMessageWidgetState createState() => _AudioMessageWidgetState();
}

class _AudioMessageWidgetState extends State<AudioMessageWidget> {
  late final AudioPlayer _player;
  late final Future<Duration?> _initFuture;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _initFuture = _loadAudio();
  }

  Future<Duration?> _loadAudio() {
    final url = widget.message.chatMedia!.url;
    if (Uri.tryParse(url)?.isAbsolute ?? false) {
      return _player.setUrl(url);
    }
    return _player.setFilePath(url);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String _format(Duration? d) {
    if (d == null) return '00:00';
    final two = (int n) => n.toString().padLeft(2, '0');
    final m = two(d.inMinutes.remainder(60));
    final s = two(d.inSeconds.remainder(60));
    return d.inHours > 0 ? '${two(d.inHours)}:$m:$s' : '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final isSender = widget.message.isSender;
    final bubbleColor = widget.senderColor.withOpacity(isSender ? 1 : 0.1);
    final iconColor = isSender ? Colors.white : widget.senderColor;

    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: FutureBuilder<Duration?>(
            future: _initFuture,
            builder: (context, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const SizedBox(
                  height: 50,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              return Row(
                children: [
                  // Play/Pause button
                  StreamBuilder<bool>(
                    stream: _player.playingStream,
                    initialData: false,
                    builder: (context, playSnap) {
                      final playing = playSnap.data!;
                      return IconButton(
                        icon: Icon(playing ? Icons.pause : Icons.play_arrow),
                        color: iconColor,
                        onPressed: () =>
                            playing ? _player.pause() : _player.play(),
                      );
                    },
                  ),

                  // Seek bar
                  Expanded(
                    child: StreamBuilder<Duration>(
                      stream: _player.positionStream,
                      initialData: Duration.zero,
                      builder: (context, posSnap) {
                        final pos = posSnap.data!;
                        final total = _player.duration ?? snap.data!;
                        return Slider(
                          min: 0,
                          max: total.inMilliseconds.toDouble(),
                          value: pos.inMilliseconds
                              .clamp(0.0, total.inMilliseconds.toDouble())
                              .toDouble(),
                          activeColor: widget.activeAudioSliderColor,
                          inactiveColor: widget.inactiveAudioSliderColor,
                          onChanged: (ms) =>
                              _player.seek(Duration(milliseconds: ms.toInt())),
                        );
                      },
                    ),
                  ),

                  // Elapsed time
                  StreamBuilder<Duration>(
                    stream: _player.positionStream,
                    initialData: Duration.zero,
                    builder: (context, posSnap) {
                      return Text(
                        _format(posSnap.data),
                        style: TextStyle(fontSize: 12, color: iconColor),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
