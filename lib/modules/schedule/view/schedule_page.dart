import 'package:agendify/modules/schedule/widget/image_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/formatter.dart';
import '../viewmodel/schedule_viewmodel.dart';
import '../widget/button.dart';
import '../widget/input.dart';
import '../../schedule/model/post_model.dart';

class SchedulePage extends StatefulWidget {
  final PostModel? editingPost;

  const SchedulePage({super.key, this.editingPost});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final ScrollController _scrollController = ScrollController();
  late ScheduleViewModel viewModel;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  DateTime? _pickedDate;
  TimeOfDay? _pickedTime;

  bool _injectedImage = false;
  String? _injectedUrl;

  bool _isEditing = false;

  @override
  @override
  void initState() {
    super.initState();
    viewModel = context.read<ScheduleViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.resetImageOptions();

      if (widget.editingPost != null) {
        final post = widget.editingPost!;
        _injectedUrl = post.urlImage;
        viewModel.selectExistingImage(_injectedUrl!);
        _injectedImage = true;
      }
    });

    viewModel.addScrollEndListener(
      controller: _scrollController,
      onEndReached: viewModel.loadMoreImages,
    );

    if (widget.editingPost != null) {
      _isEditing = true;
      final post = widget.editingPost!;
      titleController.text = post.title;
      descriptionController.text = post.description;
      dateController.text = Formatter.formatDate(post.date);
      _pickedDate = post.date;
      if (post.hour != null && post.hour!.isNotEmpty) {
        final parts = post.hour!.split(':');
        final h = int.tryParse(parts[0]) ?? 0;
        final m = int.tryParse(parts[1]) ?? 0;
        _pickedTime = TimeOfDay(hour: h, minute: m);
        timeController.text = post.hour!;
      }
    }
  }

  @override
  void dispose() {
    if (_injectedImage && _injectedUrl != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.removeImageOption(_injectedUrl!);
      });
    }
    _scrollController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<ScheduleViewModel>();
    final images = viewModel.imageOptions;
    final selectedUrl = viewModel.selectedImageUrl;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth >= 600;
            final contentWidth = isTablet ? 500.0 : double.infinity;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 300,
                    maxWidth: contentWidth,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 16,
                              color: primaryColor,
                            ),
                          ),
                          Text(
                            _isEditing ? 'Editar postagem' : 'Agendar postagem',
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                      const SizedBox(height: 40),

                      SizedBox(
                        height: 180,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          controller: _scrollController,
                          itemCount:
                              images.length + (viewModel.isLoading ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index >= images.length) {
                              return SizedBox(
                                width: 140,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: primaryColor,
                                  ),
                                ),
                              );
                            }
                            final imageUrl = images[index];
                            final isSelected = imageUrl == selectedUrl;
                            return ImageItem(
                              url: imageUrl,
                              isSelected: isSelected,
                              onTap: () => viewModel.selectImage(imageUrl),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 34),
                      AFYInput(
                        placeholder: 'Qual o título?',
                        label: 'Título',
                        controller: titleController,
                      ),
                      const SizedBox(height: 24),
                      AFYInput(
                        placeholder: 'Escreva algo legal para as pessoas verem',
                        label: 'Legenda',
                        controller: descriptionController,
                        maxLines: 6,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Agendamento',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: AFYInput(
                              placeholder: 'Data',
                              label: '',
                              controller: dateController,
                              readOnly: true,
                              onTap: () async {
                                final selected = await showDatePicker(
                                  context: context,
                                  initialDate: _pickedDate ?? DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                );
                                if (selected != null) {
                                  _pickedDate = selected;
                                  dateController.text = Formatter.formatDate(
                                    selected,
                                  );
                                }
                              },
                              icon: Icons.calendar_today,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AFYInput(
                              placeholder: 'Hora',
                              label: '',
                              controller: timeController,
                              readOnly: true,
                              onTap: () async {
                                final selected = await showTimePicker(
                                  context: context,
                                  initialTime: _pickedTime ?? TimeOfDay.now(),
                                );
                                if (selected != null) {
                                  _pickedTime = selected;
                                  timeController.text = Formatter.formatTime(
                                    selected,
                                  );
                                }
                              },
                              icon: Icons.access_time,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 34),

                      AFYButton(
                        label: _isEditing ? 'Salvar' : 'Agendar',
                        isLoading: false,
                        onPressed: () async {
                          final title = titleController.text.trim();
                          final description = descriptionController.text.trim();
                          final date = _pickedDate;
                          final timeStr = timeController.text.trim();
                          final imageUrl = viewModel.selectedImageUrl;

                          if (_isEditing) {
                            final post = widget.editingPost!;
                            final errorMessage = await viewModel
                                .updateExistingPost(
                                  post: post,
                                  title: title,
                                  description: description,
                                  date: date,
                                  hour: timeStr,
                                  urlImage: imageUrl,
                                );
                            if (errorMessage != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(errorMessage)),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Post atualizado com sucesso!'),
                                ),
                              );
                              Navigator.pop(context);
                            }
                          } else {
                            final errorMessage = await viewModel.schedulePost(
                              title: title,
                              description: description,
                              date: date,
                              hour: timeStr,
                              urlImage: imageUrl,
                            );
                            if (errorMessage != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(errorMessage)),
                              );
                            } else {
                              titleController.clear();
                              descriptionController.clear();
                              dateController.clear();
                              timeController.clear();
                              viewModel.clearSelectedImage();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Post agendado com sucesso!'),
                                ),
                              );
                              Navigator.pop(context);
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
