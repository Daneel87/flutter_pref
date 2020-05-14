// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'service/pref_service.dart';

class RadioPreference<T> extends StatefulWidget {
  const RadioPreference(
    this.title,
    this.val,
    this.localGroupKey, {
    this.desc,
    this.selected = false,
    this.ignoreTileTap = false,
    this.isDefault = false,
    this.onSelect,
    this.disabled = false,
    this.leading,
  });

  final String title;
  final String desc;
  final T val;
  final String localGroupKey;
  final bool selected;
  final bool isDefault;

  final Function onSelect;
  final bool ignoreTileTap;

  final bool disabled;

  final Widget leading;

  @override
  _RadioPreferenceState createState() => _RadioPreferenceState<T>();
}

class _RadioPreferenceState<T> extends State<RadioPreference<T>> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    PrefService.of(context).onNotify(widget.localGroupKey, _onNotify);
  }

  void _onNotify() {
    try {
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    PrefService.of(context).onNotifyRemove(widget.localGroupKey, _onNotify);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isDefault &&
        PrefService.of(context).get(widget.localGroupKey) == null) {
      onChange(widget.val);
    }

    return ListTile(
      title: Text(widget.title),
      leading: widget.leading,
      subtitle: widget.desc == null ? null : Text(widget.desc),
      trailing: Radio<T>(
        value: widget.val,
        groupValue: PrefService.of(context).get(widget.localGroupKey),
        onChanged: widget.disabled ? null : (T val) => onChange(widget.val),
      ),
      onTap: (widget.ignoreTileTap || widget.disabled)
          ? null
          : () => onChange(widget.val),
    );
  }

  void onChange(T val) {
    final service = PrefService.of(context);
    if (val is String) {
      setState(() {
        service.setString(widget.localGroupKey, val);
      });
    } else if (val is int) {
      setState(() {
        service.setInt(widget.localGroupKey, val);
      });
    } else if (val is double) {
      setState(() {
        service.setDouble(widget.localGroupKey, val);
      });
    } else if (val is bool) {
      setState(() {
        service.setBool(widget.localGroupKey, val);
      });
    }
    service.notify(widget.localGroupKey);

    if (widget.onSelect != null) {
      widget.onSelect();
    }
  }
}