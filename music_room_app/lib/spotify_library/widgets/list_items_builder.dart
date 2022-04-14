import 'package:flutter/material.dart';
import 'package:music_room_app/spotify_library/widgets/list_items_manager.dart';
import 'empty_content.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  const ListItemsBuilder(
      {Key? key,
      required this.snapshot,
      required this.itemBuilder,
      required this.emptyScreen,
      required this.manager,
      this.bottomAddTile})
      : super(key: key);
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder itemBuilder;
  final ListItemsManager manager;
  final StatelessWidget emptyScreen;
  final Widget? bottomAddTile;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData && manager.isLoading == false) {
      final List<T>? items = snapshot.data;
      if (items != null) {
        if (items.isNotEmpty) {
          return _buildList(items);
        } else {
          return emptyScreen;
        }
      } else if (snapshot.hasError) {
        return const EmptyContent(
            title: 'Something went wrong',
            message: 'Can\'t load items right now');
      }
    }
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildList(List<T> items) {
    int itemCount = bottomAddTile == null ? items.length + 2 : items.length + 3;
    return ListView.separated(
      itemCount: itemCount,
      separatorBuilder: (context, index) => const Divider(height: 0.5),
      itemBuilder: (context, index) {
        if (index == 0 || index == itemCount - 1) {
          return Container();
        }
        if (bottomAddTile != null && index == itemCount - 2) {
          return bottomAddTile!;
        }
        return itemBuilder(context, items[index - 1]);
      },
    );
  }
}
