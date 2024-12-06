// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Dock_Model.dart';


class DockController extends GetxController {
  // Observable list of dock items
  final RxList<DockItem> items = <DockItem>[
    DockItem(name: "Person", icon: Icons.person),
    DockItem(name: "Message", icon: Icons.message),
    DockItem(name: "Call", icon: Icons.call),
    DockItem(name: "Camera", icon: Icons.camera),
    DockItem(name: "Photo", icon: Icons.photo),
  ].obs;

  // Dragging state
  var draggingItem = Rxn<DockItem>();
  var hoveredIndex = RxnInt();

  void startDragging(DockItem item) {
    draggingItem.value = item;
  }

  void stopDragging() {
    draggingItem.value = null;
    hoveredIndex.value = null;
  }

  void setHoveredIndex(int? index) {
    hoveredIndex.value = index;
  }

  void reorderItems(DockItem draggedItem, int newIndex) {
    final oldIndex = items.indexOf(draggedItem);
    if (oldIndex != newIndex) {
      items.removeAt(oldIndex);
      items.insert(newIndex, draggedItem);
    }
    stopDragging();
  }
}
