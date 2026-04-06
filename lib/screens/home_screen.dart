import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../models/song.dart';
import '../providers/player_provider.dart';
import '../routes.dart';
import '../widgets/song_tile.dart';
import '../widgets/now_playing_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedMood = 'All';
  final ScrollController _scrollController = ScrollController();
  double _appBarOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final opacity = (_scrollController.offset / 90).clamp(0.0, 1.0);
    if ((opacity - _appBarOpacity).abs() > 0.01) {
      setState(() => _appBarOpacity = opacity);
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final songs = SongData.byMood(_selectedMood);
    final player = context.watch<PlayerProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: _buildHeader()),
                SliverToBoxAdapter(child: _buildFeaturedSection(player)),
                SliverToBoxAdapter(child: _buildMoodFilter()),
                SliverToBoxAdapter(child: _buildSectionLabel()),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => SongTile(
                      song: songs[i],
                      index: i + 1,
                      isActive: player.currentSong?.id == songs[i].id,
                      isPlaying:
                          player.currentSong?.id == songs[i].id &&
                          player.isPlaying,
                      onTap: () {
                        player.playSong(songs[i], queue: songs);
                        Navigator.pushNamed(context, AppRoutes.player);
                      },
                    )
                        .animate(delay: (i * 55).ms)
                        .fadeIn(duration: 400.ms)
                        .slideX(begin: 0.08, end: 0, curve: Curves.easeOut),
                    childCount: songs.length,
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: player.hasCurrentSong ? 110 : 24),
                ),
              ],
            ),
            if (player.hasCurrentSong)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: NowPlayingBar(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.player),
                ),
              ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        color: AppColors.background.withOpacity(_appBarOpacity * 0.9),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 20 * _appBarOpacity,
              sigmaY: 20 * _appBarOpacity,
            ),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.glassWhite,
                    border: Border.all(color: AppColors.glassBorder, width: 1),
                  ),
                  child: const Icon(Icons.person_outline_rounded,
                      size: 18, color: AppColors.textPrimary),
                ),
              ),
              title: AnimatedOpacity(
                opacity: _appBarOpacity,
                duration: const Duration(milliseconds: 150),
                child: Text(
                  'LANA Z',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(fontSize: 13, letterSpacing: 4),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search_rounded,
                      color: AppColors.textPrimary),
                  onPressed: () {},
                ),
                const SizedBox(width: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 96, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'GOOD EVENING',
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(fontSize: 10, letterSpacing: 3.5),
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 6),
          Text(
            'What\'s your\nvibe tonight?',
            style: Theme.of(context).textTheme.displayMedium,
          )
              .animate(delay: 180.ms)
              .fadeIn(duration: 700.ms)
              .slideY(begin: 0.25, end: 0, curve: Curves.easeOut),
        ],
      ),
    );
  }

  Widget _buildFeaturedSection(PlayerProvider player) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 14),
          child: Text('FEATURED',
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(letterSpacing: 3)),
        ),
        SizedBox(
          height: 210,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: SongData.featured.length,
            itemBuilder: (context, i) {
              final song = SongData.featured[i];
              return _FeaturedCard(
                song: song,
                isActive: player.currentSong?.id == song.id,
                isPlaying:
                    player.currentSong?.id == song.id && player.isPlaying,
                onTap: () {
                  player.playSong(song, queue: SongData.catalog);
                  Navigator.pushNamed(context, AppRoutes.player);
                },
              )
                  .animate(delay: (i * 70).ms)
                  .fadeIn(duration: 500.ms)
                  .slideX(begin: 0.15, end: 0, curve: Curves.easeOut);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMoodFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
          child: Text('MOOD',
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(letterSpacing: 3)),
        ),
        SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: SongData.moods.map((mood) {
              final selected = _selectedMood == mood;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedMood = mood),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: selected ? AppColors.accentGradient : null,
                      color: selected ? null : AppColors.glassWhite,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected
                            ? Colors.transparent
                            : AppColors.glassBorder,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      mood,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: selected
                                ? Colors.white
                                : AppColors.textSecondary,
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            fontSize: 12,
                          ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionLabel() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _selectedMood == 'All'
                ? 'ALL TRACKS'
                : '${_selectedMood.toUpperCase()} TRACKS',
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(letterSpacing: 2.5),
          ),
          Text(
            '${SongData.byMood(_selectedMood).length} songs',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final Song song;
  final bool isActive;
  final bool isPlaying;
  final VoidCallback onTap;

  const _FeaturedCard({
    required this.song,
    required this.isActive,
    required this.isPlaying,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 155,
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: isActive
                  ? AppColors.lavender.withOpacity(0.35)
                  : Colors.black.withOpacity(0.4),
              blurRadius: isActive ? 24 : 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: song.coverUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: AppColors.card),
                errorWidget: (_, __, ___) => Container(
                  color: AppColors.card,
                  child: const Icon(Icons.music_note,
                      color: AppColors.textHint),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.78),
                    ],
                    stops: const [0.4, 1.0],
                  ),
                ),
              ),
              if (isActive)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    border:
                        Border.all(color: AppColors.lavender, width: 2),
                  ),
                ),
              Positioned(
                bottom: 14,
                left: 14,
                right: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.lavender.withOpacity(0.35),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        song.mood.toUpperCase(),
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(
                              color: AppColors.champagne,
                              fontSize: 8,
                              letterSpacing: 1.5,
                            ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      song.title,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                              fontSize: 13,
                              color: AppColors.textPrimary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      song.artist,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ),
              if (isPlaying)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.accentGradient,
                    ),
                    child: const Icon(Icons.equalizer_rounded,
                        size: 15, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
