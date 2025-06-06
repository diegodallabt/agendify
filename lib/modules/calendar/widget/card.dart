import 'package:flutter/material.dart';
import '../../../core/utils/formatter.dart';
import '../../schedule/model/post_model.dart';
import '../../schedule/widget/image_item.dart';

class AFYCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AFYCard({
    super.key,
    required this.post,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedDate = Formatter.formatDate(post.date);
    final formattedTime = post.hour;

    return Row(
      spacing: 15,
      children: [
        ImageItem(
          url: post.urlImage,
          isSelected: false,
          onTap: () {},
          width: 110,
          height: 110,
          borderRadius: 9,
          clipRadius: 8,
          horizontalMargin: 0,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 23,
                    width: 23,
                    child: PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, size: 15, color: Colors.grey),
                      onSelected: (value) {
                        if (value == 'editar') onEdit();
                        if (value == 'excluir') onDelete();
                      },
                      itemBuilder:
                          (_) => [
                            const PopupMenuItem(
                              value: 'editar',
                              child: Text('Editar'),
                            ),
                            const PopupMenuItem(
                              value: 'excluir',
                              child: Text('Excluir'),
                            ),
                          ],
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 7,
                children: [
                  Text(
                    post.title,
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    post.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              SizedBox(height: 7),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 13,
                      color: theme.colorScheme.surface,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$formattedDate $formattedTime',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.surface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18),
            ],
          ),
        ),
      ],
    );
  }
}
