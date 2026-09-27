import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../models/app_models.dart';

class EarnScreen extends StatefulWidget {
  final AppState appState;
  final Function(EarnTask task) onStartTask;

  const EarnScreen({
    super.key,
    required this.appState,
    required this.onStartTask,
  });

  @override
  State<EarnScreen> createState() => _EarnScreenState();
}

class _EarnScreenState extends State<EarnScreen> {
  TaskCategory selectedCategory = TaskCategory.all;
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredTasks = widget.appState.tasks.where((t) {
      bool matchesCategory = selectedCategory == TaskCategory.all || t.category == selectedCategory;
      bool matchesSearch = searchQuery.isEmpty ||
          t.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          t.sponsor.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Task Marketplace', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('Complete tasks from verified sponsors to earn coins instantly.', style: TextStyle(color: Color(0xFFBFDBFE), fontSize: 13)),
                    ],
                  ),
                ),
                const Icon(Icons.stars_rounded, color: Color(0xFFF59E0B), size: 40),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Search Bar
          TextField(
            onChanged: (val) => setState(() => searchQuery = val),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search tasks by title or sponsor...',
              hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
              prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF64748B)),
              filled: true,
              fillColor: const Color(0xFF1E293B),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF334155))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF334155))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF3B82F6))),
            ),
          ),

          const SizedBox(height: 16),

          // Category Chips Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryFilterChip(label: 'All Tasks', category: TaskCategory.all, icon: Icons.grid_view_rounded),
                _buildCategoryFilterChip(label: 'YouTube Videos', category: TaskCategory.youtube, icon: Icons.play_circle_fill_rounded),
                _buildCategoryFilterChip(label: 'Instagram', category: TaskCategory.instagram, icon: Icons.camera_alt_rounded),
                _buildCategoryFilterChip(label: 'Telegram', category: TaskCategory.telegram, icon: Icons.send_rounded),
                _buildCategoryFilterChip(label: 'Offers & Surveys', category: TaskCategory.offers, icon: Icons.assignment_turned_in_rounded),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Tasks Count Header
          Text(
            'Available Tasks (${filteredTasks.length})',
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          // Tasks Grid / List
          if (filteredTasks.isEmpty)
            Container(
              padding: const EdgeInsets.all(40),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                children: [
                  Icon(Icons.search_off_rounded, color: Color(0xFF64748B), size: 48),
                  SizedBox(height: 12),
                  Text('No tasks found in this category', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14)),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredTasks.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                final isDone = widget.appState.completedTaskIds.contains(task.id);

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          task.thumbnailUrl,
                          width: 90,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 90,
                            height: 60,
                            color: const Color(0xFF334155),
                            child: const Icon(Icons.play_circle_fill, color: Colors.white70),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Text(task.sponsor, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                                const SizedBox(width: 8),
                                const Text('•', style: TextStyle(color: Color(0xFF64748B))),
                                const SizedBox(width: 8),
                                const Icon(Icons.timer_outlined, color: Color(0xFF64748B), size: 14),
                                const SizedBox(width: 4),
                                Text('${task.durationSeconds}s', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF59E0B).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.monetization_on_rounded, color: Color(0xFFF59E0B), size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  '+${task.rewardCoins} Coins',
                                  style: const TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: isDone ? null : () => widget.onStartTask(task),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDone ? Colors.grey : const Color(0xFF2563EB),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Text(isDone ? 'Done ✓' : _getTaskCta(task.category), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  String _getTaskCta(TaskCategory category) {
    switch (category) {
      case TaskCategory.youtube:
        return 'Watch Now';
      case TaskCategory.instagram:
        return 'Follow';
      case TaskCategory.telegram:
        return 'Join Channel';
      default:
        return 'Start Task';
    }
  }

  Widget _buildCategoryFilterChip({
    required String label,
    required TaskCategory category,
    required IconData icon,
  }) {
    bool isSelected = selectedCategory == category;

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: FilterChip(
        selected: isSelected,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.white : const Color(0xFF94A3B8)),
            const SizedBox(width: 6),
            Text(label),
          ],
        ),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF94A3B8),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          fontSize: 13,
        ),
        backgroundColor: const Color(0xFF1E293B),
        selectedColor: const Color(0xFF2563EB),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFF334155))),
        onSelected: (_) => setState(() => selectedCategory = category),
      ),
    );
  }
}
