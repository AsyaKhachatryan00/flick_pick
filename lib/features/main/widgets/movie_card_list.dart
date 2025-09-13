import 'package:flick_pick/features/main/widgets/movie_card.dart';
import 'package:flick_pick/models/movie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MovieCardList extends StatefulWidget {
  const MovieCardList({
    super.key,
    required this.movies,
    required this.isEditing,
    required this.onTap,
    this.onReorder,
  });
  final List<Movie> movies;
  final RxBool isEditing;
  final void Function(int oldIndex, int newIndex)? onReorder;
  final ValueChanged<Movie> onTap;

  @override
  State<MovieCardList> createState() => _MovieCardListState();
}

class _MovieCardListState extends State<MovieCardList> {
  final PageController _pageController = PageController(viewportFraction: 0.7);
  final ScrollController _reorderController = ScrollController();
  double currentPage = 0.0;
  double _reorderOffset = 0.0;

  List<Movie> get _movies => widget.movies;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (!_pageController.hasClients) return;
      final page = _pageController.page ?? 0.0;
      if (!mounted) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_pageController.hasClients) return;
        setState(() => currentPage = page);
      });
    });

    widget.isEditing.listen((isEditing) {
      if (!isEditing) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted || !_pageController.hasClients) return;
          _pageController.jumpToPage(0);
        });
      }
    });

    _reorderController.addListener(() {
      final off = _reorderController.offset;
      if (!mounted) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() => _reorderOffset = off);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (widget.isEditing.value && widget.onReorder != null) {
        return NotificationListener<ScrollNotification>(
          onNotification: (n) {
            if (n.metrics.axis == Axis.horizontal) {
              setState(() => _reorderOffset = n.metrics.pixels);
            }
            return false;
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              const double itemWidth = 281;
              const double spacing = 16;
              const double listPad = 12;

              final viewportCenter = _reorderOffset + constraints.maxWidth / 2;

              double computeScale(int i) {
                final tileCenter =
                    listPad + (i * (itemWidth + spacing)) + itemWidth / 2;
                final dist = (tileCenter - viewportCenter).abs();
                final norm = (dist / (itemWidth + spacing)).clamp(0.0, 1.0);
                return (1 - norm * 0.2).clamp(0.8, 1.0);
              }

              double computeOpacity(int i) {
                final tileCenter =
                    listPad + (i * (itemWidth + spacing)) + itemWidth / 2;
                final dist = (tileCenter - viewportCenter).abs();
                final norm = (dist / (itemWidth + spacing)).clamp(0.0, 1.0);
                return (1 - norm * 0.5).clamp(0.5, 1.0);
              }

              return ReorderableListView.builder(
                key: const PageStorageKey('movie_reorder'),
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: listPad),
                physics: const BouncingScrollPhysics(),
                buildDefaultDragHandles: false,
                proxyDecorator: (child, index, animation) {
                  final t = CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOut,
                  );
                  return Transform.scale(
                    scale: 1.02 + 0.02 * t.value,
                    child: Transform.rotate(
                      angle: 0.06 * t.value,
                      child: Material(
                        color: Colors.transparent,
                        elevation: 10,
                        borderRadius: BorderRadius.circular(16),
                        child: child,
                      ),
                    ),
                  );
                },
                itemCount: _movies.length,
                onReorder: (oldIndex, newIndex) {
                  if (newIndex > oldIndex) newIndex--;
                  widget.onReorder!(oldIndex, newIndex);
                  setState(() {});
                },
                itemBuilder: (context, index) {
                  final movie = _movies[index];
                  final scale = computeScale(index);
                  final opacity = computeOpacity(index);

                  return MovieCard(
                    key: ValueKey(movie.id),
                    movie: movie,
                    onTap: widget.onTap,
                    index: index,
                    scale: scale,
                    opacity: opacity,
                    isEditing: widget.isEditing,
                  );
                },
              );
            },
          ),
        );
      }

      return PageView.builder(
        controller: _pageController,
        itemCount: _movies.length,
        itemBuilder: (context, index) {
          final movie = _movies[index];
          final scale = (1 - (currentPage - index).abs() * 0.2).clamp(0.8, 1.0);
          final opacity = (1 - (currentPage - index).abs() * 0.5).clamp(
            0.5,
            1.0,
          );

          return MovieCard(
            movie: movie,
            onTap: widget.onTap,
            scale: scale,
            opacity: opacity,
            isEditing: widget.isEditing,
          );
        },
      );
    });
  }
}
