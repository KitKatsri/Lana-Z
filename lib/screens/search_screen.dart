import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../providers/audio_provider.dart';
import '../models/song.dart';
import '../routes.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _hasQuery = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audio = context.watch<AudioProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: SafeArea(
          child: Column(
            children: [
              // ── Search bar ─────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_ios_rounded,
                          color: AppColors.textPrimary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.glassWhite,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: AppColors.glassBorder, width: 1),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search_rounded,
                                color: AppColors.textSecondary, size: 18),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontSize: 14),
                                decoration: InputDecoration(
                                  hintText: 'Search songs, artists...',
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(fontSize: 13),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                onChanged: (val) {
                                  setState(() => _hasQuery = val.isNotEmpty);
                                  if (val.length > 2) {
                                    context
                                        .read<AudioProvider>()
                                        .search(val);
                                  }
                                },
                              ),
                            ),
                            if (_hasQuery)
                              GestureDetector(
                                onTap: () {
                                  _controller.clear();
                                  setState(() => _hasQuery = false);
                                  context.read<AudioProvider>().search('');
                                },
                                child: const Icon(Icons.close_rounded,
                                    color: AppColors.textSecondary,
                                    size: 16),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Results ────────────────────────────────────────────
              Expanded(
                child: _hasQuery
                    ? _buildSearchResults(audio)
                    : _buildChart(audio),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChart(AudioProvider audio) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
          child: Text('TRENDING NOW',
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(letterSpacing: 3)),
        ),
        Expanded(
          child: audio.chartSongs.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(
                      color: AppColors.lavender, strokeWidth: 2))
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: audio.chartSongs.length,
                  itemBuilder: (context, i) => _SongRow(
                    song: audio.chartSongs[i],
                    index: i + 1,
                    isActive: audio.currentSong?.id ==
                        audio.chartSongs[i].id,
                    isPlaying: audio.currentSong?.id ==
                            audio.chartSongs[i].id &&
                        audio.isPlaying,
                    onTap: () {
                      audio.playSong(audio.chartSongs[i],
                          queue: audio.chartSongs);
                      Navigator.pushNamed(context, AppRoutes.player);
                    },
                  )
                      .animate(delay: (i * 40).ms)
                      .fadeIn(duration: 350.ms)
                      .slideX(begin: 0.06, end: 0),
                ),
        ),
      ],
    );
  }

  Widget _buildSearchResults(AudioProvider audio) {
    if (audio.isLoading) {
      return const Center(
          child: CircularProgressIndicator(
              color: AppColors.lavender, strokeWidth: 2));
    }
    if (audio.searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off_rounded,
                color: AppColors.textHint, size: 48),
            const SizedBox(height: 12),
            Text('No results found',
                style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      );
    }
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: audio.searchResults.length,
      itemBuilder: (context, i) => _SongRow(
        song: audio.searchResults[i],
        index: i + 1,
        isActive: audio.currentSong?.id == audio.searchResults[i].id,
        isPlaying: audio.currentSong?.id == audio.searchResults[i].id &&
            audio.isPlaying,
        onTap: () {
          audio.playSong(audio.searchResults[i],
              queue: audio.searchResults);
          Navigator.pushNamed(context, AppRoutes.player);
        },
      )
          .animate(delay: (i * 40).ms)
          .fadeIn(duration: 350.ms)
          .slideX(begin: 0.06, end: 0),
    );
  }
}

class _SongRow extends StatelessWidget {
  final Song song;
  final int index;
  final bool isActive;
  final bool isPlaying;
  final VoidCallback onTap;

  const _SongRow({
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                placeholder: (_, __) =>
                    Container(width: 50, height: 50, color: AppColors.card),
                errorWidget: (_, __, ___) =>
                    Container(width: 50, height: 50, color: AppColors.card),
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
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
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
                    '${song.artist} • ${song.album}',
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
            const Icon(Icons.play_circle_outline_rounded,
                color: AppColors.textHint, size: 22),
          ],
        ),
      ),
    );
  }
}
