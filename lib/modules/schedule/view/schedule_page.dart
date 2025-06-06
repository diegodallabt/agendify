import 'package:agendify/modules/schedule/widget/image_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/text_utils.dart';
import '../viewmodel/schedule_viewmodel.dart';
import '../widget/button.dart';
import '../widget/input.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

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

  @override
  void initState() {
    super.initState();
    viewModel = context.read<ScheduleViewModel>();
    viewModel.addScrollEndListener(
      controller: _scrollController,
      onEndReached: viewModel.loadMoreImages,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
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
                      Center(
                        child: Text(
                          'Agendar postagem',
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
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
                      AFYInput(label: 'Título', controller: titleController),
                      const SizedBox(height: 24),
                      AFYInput(
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
                              label: '',
                              controller: dateController,
                              readOnly: true,
                              onTap: () async {
                                final selected = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                );
                                if (selected != null) {
                                  dateController.text =
                                    TextUtils.formatDate(selected);
                                }
                              },
                              icon: Icons.calendar_today,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AFYInput(
                              label: '',
                              controller: timeController,
                              readOnly: true,
                              onTap: () async {
                                final selected = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (selected != null) {
                                  timeController.text = TextUtils.formatTime(selected);
                                }
                              },
                              icon: Icons.access_time,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 34),
                      AFYButton(
                        label: 'Agendar',
                        isLoading: false,
                        onPressed: () {},
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
