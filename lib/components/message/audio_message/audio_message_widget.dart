import 'dart:async';

import 'package:chat_package/models/chat_message.dart';
import 'package:chat_package/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

/// Renders a voice-note message with play/pause, a seek slider and the current
/// playback position. Works with both remote urls and local file paths.
class AudioMessageWidget extends StatefulWidget {
  final ChatMessage message;
  final Color senderColor;
  final Color inActiveAudioSliderColor;
  final Color activeAudioSliderColor;

  /// Fraction of the available width the bubble occupies. Defaults to 0.7.
  final double widthFraction;

  const AudioMessageWidget({
    super.key,
    required this.message,
    required this.senderColor,
    required this.inActiveAudioSliderColor,
    required this.activeAudioSliderColor,
    this.widthFraction = 0.7,
  });

  @override
  State<AudioMessageWidget> createState() => _AudioMessageWidgetState();
}

class _AudioMessageWidgetState extends State<AudioMessageWidget> {
  final AudioPlayer _player = AudioPlayer();
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isPlaying = false;

  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<PlayerState>? _stateSub;

  String get _url => widget.message.chatMedia!.url;

  @override
  void initState() {
    super.initState();
    _loadSource();

    _positionSub = _player.positionStream.listen((position) {
      if (mounted) setState(() => _position = position);
    });

    _stateSub = _player.playerStateStream.listen((state) {
      if (!mounted) return;
      if (state.processingState == ProcessingState.completed) {
        // Reset to the start once playback finishes.
        _player.pause();
        _player.seek(Duration.zero);
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
      } else {
        setState(() => _isPlaying = state.playing);
      }
    });
  }

  Future<void> _loadSource() async {
    final loaded = isNetworkSource(_url)
        ? await _player.setUrl(_url)
        : await _player.setFilePath(_url);
    if (mounted) setState(() => _duration = loaded ?? Duration.zero);
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _stateSub?.cancel();
    _player.dispose();
    super.dispose();
  }

  void _togglePlay() {
    _isPlaying ? _player.pause() : _player.play();
  }

  @override
  Widget build(BuildContext context) {
    final maxMs = _duration.inMilliseconds.toDouble();
    final valueMs = _position.inMilliseconds
        .clamp(0, _duration.inMilliseconds)
        .toDouble();
    return Column(
      crossAxisAlignment: widget.message.isSender
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * widget.widthFraction,
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding * 0.75),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: widget.senderColor
                .withValues(alpha: widget.message.isSender ? 1 : 0.1),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: _togglePlay,
                icon: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: widget.message.isSender
                      ? Colors.white
                      : widget.senderColor,
                ),
              ),
              Expanded(
                child: Slider(
                  activeColor: widget.activeAudioSliderColor,
                  inactiveColor: widget.inActiveAudioSliderColor,
                  max: maxMs <= 0 ? 1 : maxMs,
                  value: valueMs,
                  onChanged: (value) =>
                      _player.seek(Duration(milliseconds: value.toInt())),
                ),
              ),
              Text(
                _printDuration(_position),
                style: TextStyle(
                  fontSize: 12,
                  color: widget.message.isSender ? Colors.white : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// formats a [Duration] as `mm:ss` (or `hh:mm:ss` when over an hour)
  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    final hours = duration.inHours == 0 ? '' : '${twoDigits(duration.inHours)}:';
    return '$hours$minutes:$seconds';
  }
}
