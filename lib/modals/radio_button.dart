import 'package:flutter/material.dart';

class RadioButtonGroup<T> extends StatefulWidget {
  final List<T> options;
  final T? selectedOption;
  final void Function(T)? onChanged;

  const RadioButtonGroup({
    required this.options,
    this.selectedOption,
    this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  _RadioButtonGroupState<T> createState() => _RadioButtonGroupState<T>();
}

class _RadioButtonGroupState<T> extends State<RadioButtonGroup<T>> {
  late T? _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.selectedOption;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.options.map((option) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Radio<T>(
                  value: option,
                  groupValue: _selectedOption,
                  onChanged: (value) {
                    setState(() {
                      _selectedOption = value;
                    });
                    if (widget.onChanged != null) {
                      widget.onChanged!(value as T);
                    }
                  },
                ),
                SizedBox(width: 5),
                Text(option.toString()),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }


}
