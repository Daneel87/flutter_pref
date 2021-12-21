// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class ButtonGroup<T> extends StatelessWidget {
  const ButtonGroup({
    Key? key,
    this.value,
    required this.onChanged,
    this.disabled = false,
    required this.items,
    this.borderRadius,
    this.borderColor,
    this.borderWidth
  }) : super(key: key);

  final ValueChanged<T>? onChanged;
  final bool disabled;
  final T? value;
  final List<ButtonGroupItem<T>> items;
  final BorderRadius? borderRadius;
  final double? borderWidth;
  final Color? borderColor;
  
  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      borderRadius : borderRadius,
      borderWidth : borderWidth,
      borderColor: borderColor,
      isSelected: items.map((e) => e.value == value).toList(),
      onPressed: disabled
          ? null
          : (index) {
              if (onChanged != null) {
                onChanged!(items[index].value);
              }
            },
      children: items.map((e) => e.child).toList(),
    );
  }
}

class ButtonGroupItem<T> {
  const ButtonGroupItem({
    required this.value,
    required this.child,
  });

  final T value;
  final Widget child;

  @override
  String toString() => '$runtimeType $value => $child';
}
