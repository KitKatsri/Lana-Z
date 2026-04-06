import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../providers/player_provider.dart';

class NowPlayingBar extends StatelessWidget {
  final VoidCallback onTap;

  const NowPlayingBar({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerProvider>();
    final song = player.currentSong;
    if (song == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            margin: const EdgeInsets.fromLTRB(14, 0, 14, 22),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: AppColors.surface.withOpacity(0.88),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.glassBorder, width: 1),
              boxShadow: [
                BoxShadow(
                  color: AppColors.lavender.withOpacity(0.15),
                  blurRadius: 24,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: song.coverUrl,
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                            width: 44, height: 44, color: AppColors.card),
                        errorWidget: (_, __, ___) => Container(
                            width: 44, height: 44, color: AppColors.card),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            song.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            song.artist,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontSize: 11),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: player.previous,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(Icons.skip_previous_rounded,
                            color: AppColors.textPrimary, size: 22),
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: player.togglePlayPause,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.accentGradient,
                        ),
                        child: Icon(
                          player.isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: player.next,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(Icons.skip_next_rounded,
                            color: AppColors.textPrimary, size: 22),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: player.progress,
                    backgroundColor: AppColors.textHint,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.lavender),
                    minHeight: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .slideY(begin: 1.2, end: 0, duration: 350.ms, curve: Curves.easeOut)
        .fadeIn(duration: 300.ms);
  }
}
