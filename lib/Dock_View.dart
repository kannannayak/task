// ignore_for_file: use_super_parameters, file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Dock_Controller.dart';
import 'Dock_Model.dart';

class DockView extends StatelessWidget {
  DockView({Key? key}) : super(key: key);

  final DockController controller = Get.put(DockController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(
          () => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.black12,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(controller.items.length, (index) {
                final item = controller.items[index];
                final isDragging = controller.draggingItem.value == item;
                final isHovered =
                    controller.hoveredIndex.value == index && !isDragging;

                return LongPressDraggable<DockItem>(
                  data: item,
                  feedback: Material(
                    color: Colors.transparent,
                    child: _buildDockIcon(item, isDragging, false),
                  ),
                  onDragStarted: () {
                    controller.startDragging(item);
                  },
                  onDragEnd: (_) {
                    controller.stopDragging();
                  },
                  childWhenDragging: const SizedBox.shrink(),
                  child: DragTarget<DockItem>(
                    onWillAccept: (draggedItem) {
                      controller.setHoveredIndex(index);
                      return true;
                    },
                    onLeave: (_) {
                      controller.setHoveredIndex(null);
                    },
                    onAccept: (draggedItem) {
                      controller.reorderItems(draggedItem, index);
                    },
                    builder: (context, candidateData, rejectedData) {
                      return _buildDockIcon(item, isDragging, isHovered);
                    },
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDockIcon(DockItem item, bool isDragging, bool isHovered) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 200),
      scale: isDragging
          ? 1.1
          : isHovered
              ? 1.2
              : 1.0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        constraints: const BoxConstraints(minWidth: 64, minHeight: 64),
        height: 48,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.primaries[item.name.hashCode % Colors.primaries.length]
              .withOpacity(0.8),
          boxShadow: isHovered
              ? [
                  BoxShadow(
                    color:
                        const Color.fromARGB(255, 31, 5, 124).withOpacity(0.6),
                    blurRadius: 100,
                    spreadRadius: -3,
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Icon(
            item.icon,
            color: Colors.white,
            size: isDragging ? 36 : 28,
          ),
        ),
      ),
    );
  }
}
