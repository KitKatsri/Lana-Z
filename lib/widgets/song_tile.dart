import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_colors.dart';
import '../models/song.dart';

class SongTile extends StatelessWidget {
  final Song song;
  final int index;
  final bool isActive;
  final bool isPlaying;
  final VoidCallback onTap;

  const SongTile({
    super.key,
    required this.song,
    required this.index,
    required this.isActive,
    required this.isPlaying,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.lavender.withOpacity(0.06),
      highlightColor: AppColors.lavender.withOpacity(0.04),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.lavender.withOpacity(0.07)
              : Colors.transparent,
          border: isActive
              ? const Border(
                  left: BorderSide(color: AppColors.lavender, width: 2))
              : null,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 30,
              child: isPlaying
                  ? const Icon(Icons.equalizer_rounded,
                      color: AppColors.lavender, size: 18)
                  : Text(
                      index.toString().padLeft(2, '0'),
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(fontSize: 11),
                    ),
            ),
            const SizedBox(width: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: song.coverUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                    width: 50, height: 50, color: AppColors.card),
                errorWidget: (_, __, ___) => Container(
                  width: 50,
                  height: 50,
                  color: AppColors.card,
                  child: const Icon(Icons.music_note,
                      color: AppColors.textHint, size: 18),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    song.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 14,
                          color: isActive
                              ? AppColors.lavender
                              : AppColors.textPrimary,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    song.album,
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
            Text(
              song.durationString,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 11,
                    color: isActive
                        ? AppColors.lavender.withOpacity(0.7)
                        : AppColors.textSecondary,
                  ),
            ),
            const SizedBox(width: 6),
            Icon(Icons.more_vert_rounded,
                color: AppColors.textHint, size: 17),
          ],
        ),
      ),
    );
  }
}
