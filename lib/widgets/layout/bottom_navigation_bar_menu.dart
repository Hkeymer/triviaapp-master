import 'package:flutter/material.dart';
import 'package:triviaapp/models/menu_item_model.dart';

class BottomNavigationBarMenu extends StatefulWidget {
  final List<MenuItemModel> items;

  const BottomNavigationBarMenu({super.key, required this.items});

  @override
  State<BottomNavigationBarMenu> createState() =>
      _BottomNavigationBarMenuState();
}

class _BottomNavigationBarMenuState extends State<BottomNavigationBarMenu> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      child: Material(
        color: Colors.transparent,
        elevation: 8,
        child: Container(
          height: 90,
          padding: const EdgeInsets.only(top: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 12,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              widget.items.length,
              (index) => _buildItem(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(int index) {
    final item = widget.items[index];
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() => selectedIndex = index);
        item.onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: isSelected ? item.color.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                item.icon,
                size: 22, // icono más pequeño
                color: item.color,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: item.color,
              ),
              child: Text(item.title),
            ),
          ],
        ),
      ),
    );
  }
}
