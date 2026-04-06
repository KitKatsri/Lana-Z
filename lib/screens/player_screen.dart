import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../providers/player_provider.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerProvider>();
    final song = player.currentSong;

    if (song == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: const Center(
          child: Text('No song selected',
              style: TextStyle(color: AppColors.textSecondary)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: Colors.white, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'NOW PLAYING',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.white.withOpacity(0.5),
                fontSize: 9,
                letterSpacing: 3,
              ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert_rounded,
                color: Colors.white.withOpacity(0.7)),
            onPressed: () => _showOptionsSheet(context, player),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            child: CachedNetworkImage(
              key: ValueKey(song.coverUrl),
              imageUrl: song.coverUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) =>
                  Container(color: AppColors.background),
              errorWidget: (_, __, ___) =>
                  Container(color: AppColors.background),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 48, sigmaY: 48),
            child: Container(color: Colors.black.withOpacity(0.6)),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Expanded(
                    flex: 10,
                    child: Center(
                      child: _AlbumArt(key: ValueKey(song.id), song: song),
                    ),
                  ),
                  const SizedBox(height: 28),
                  _SongInfo(song: song),
                  const SizedBox(height: 20),
                  _ProgressBar(),
                  const SizedBox(height: 22),
                  _Controls(),
                  const SizedBox(height: 24),
                  _BottomRow(),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showOptionsSheet(BuildContext context, PlayerProvider player) {
    final song = player.currentSong!;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36, height: 3,
              decoration: BoxDecoration(
                color: AppColors.textHint,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(song.title, style: Theme.of(context).textTheme.titleLarge),
            Text(song.artist, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 20),
            _OptionTile(icon: Icons.playlist_add_rounded, label: 'Add to Playlist'),
            _OptionTile(icon: Icons.share_outlined, label: 'Share'),
            _OptionTile(icon: Icons.info_outline_rounded, label: 'Song Info'),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _AlbumArt extends StatelessWidget {
  final dynamic song;
  const _AlbumArt({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerProvider>();
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      transformAlignment: Alignment.center,
      transform: Matrix4.identity()..scale(player.isPlaying ? 1.0 : 0.90),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.55),
            blurRadius: 60,
            offset: const Offset(0, 20),
          ),
          BoxShadow(
            color: AppColors.lavender.withOpacity(player.isPlaying ? 0.25 : 0.05),
            blurRadius: 50,
            spreadRadius: -5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: CachedNetworkImage(
          imageUrl: song.coverUrl,
          fit: BoxFit.cover,
          placeholder: (_, __) => Container(
            color: AppColors.card,
            child: const Center(
              child: CircularProgressIndicator(
                  color: AppColors.lavender, strokeWidth: 2),
            ),
          ),
          errorWidget: (_, __, ___) => Container(
            color: AppColors.card,
            child: const Icon(Icons.music_note,
                color: AppColors.textHint, size: 48),
          ),
        ),
      ),
    )
        .animate(key: key)
        .scale(
          begin: const Offset(0.82, 0.82),
          end: const Offset(1, 1),
          duration: 600.ms,
          curve: Curves.easeOut,
        )
        .fadeIn(duration: 400.ms);
  }
}

class _SongInfo extends StatefulWidget {
  final dynamic song;
  const _SongInfo({required this.song});

  @override
  State<_SongInfo> createState() => _SongInfoState();
}

class _SongInfoState extends State<_SongInfo> {
  bool _liked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.song.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                widget.song.artist,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.6),
                    ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => setState(() => _liked = !_liked),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.all(10),
            child: Icon(
              _liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: _liked ? AppColors.softPink : Colors.white,
              size: 26,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProvider>(
      builder: (context, player, _) {
        return Column(
          children: [
            Slider(value: player.progress, onChanged: player.seekTo),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(player.elapsedTimeString,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.45),
                            fontSize: 11,
                          )),
                  Text(player.currentSong?.durationString ?? '--:--',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.45),
                            fontSize: 11,
                          )),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Controls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProvider>(
      builder: (context, player, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: player.toggleShuffle,
              child: Icon(Icons.shuffle_rounded,
                  size: 22,
                  color: player.isShuffle
                      ? AppColors.lavender
                      : Colors.white.withOpacity(0.45)),
            ),
            GestureDetector(
              onTap: player.previous,
              child: const Icon(Icons.skip_previous_rounded,
                  color: Colors.white, size: 40),
            ),
            GestureDetector(
              onTap: player.togglePlayPause,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppColors.lavender, AppColors.softPink],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.lavender
                          .withOpacity(player.isPlaying ? 0.50 : 0.25),
                      blurRadius: player.isPlaying ? 28 : 14,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  player.isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ),
            ),
            GestureDetector(
              onTap: player.next,
              child: const Icon(Icons.skip_next_rounded,
                  color: Colors.white, size: 40),
            ),
            GestureDetector(
              onTap: player.toggleRepeat,
              child: Icon(Icons.repeat_rounded,
                  size: 22,
                  color: player.isRepeat
                      ? AppColors.lavender
                      : Colors.white.withOpacity(0.45)),
            ),
          ],
        );
      },
    );
  }
}

class _BottomRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _BottomAction(icon: Icons.queue_music_rounded, label: 'QUEUE'),
        _BottomAction(icon: Icons.lyrics_outlined, label: 'LYRICS'),
        _BottomAction(icon: Icons.share_outlined, label: 'SHARE'),
      ],
    );
  }
}

class _BottomAction extends StatelessWidget {
  final IconData icon;
  final String label;
  const _BottomAction({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.45), size: 22),
        const SizedBox(height: 4),
        Text(label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white.withOpacity(0.35),
                  fontSize: 9,
                )),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  const _OptionTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary),
      title: Text(label, style: Theme.of(context).textTheme.titleMedium),
      contentPadding: EdgeInsets.zero,
      onTap: () => Navigator.pop(context),
    );
  }
}
