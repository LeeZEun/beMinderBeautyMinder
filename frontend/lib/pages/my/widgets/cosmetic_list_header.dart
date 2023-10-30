import 'package:beautyminder/bloc/cosmetic/cosmetic_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/cosmetic/cosmetic_bloc.dart';

const List<String> list = <String>['이름순', '유통기한순'];

class CosmeticListHeader extends StatelessWidget {
  final String itemNum;

  const CosmeticListHeader({super.key, required this.itemNum});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const CosmeticDropDownButton(),
                Text(
                  itemNum,
                  style:
                      const TextStyle(fontSize: 15, color: Color(0xFF868383)),
                  textAlign: TextAlign.left,
                )
              ]),
        ),
        const Divider(height: 1, thickness: 1, color: Color(0xFFADABAB)),
      ],
    );
  }
}

class CosmeticDropDownButton extends StatefulWidget {
  const CosmeticDropDownButton({super.key});

  @override
  State<CosmeticDropDownButton> createState() => _CosmeticDropDownButtonState();
}

class _CosmeticDropDownButtonState extends State<CosmeticDropDownButton> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      initialSelection: list.first,
      onSelected: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          if (dropdownValue != value) {
            BlocProvider.of<CosmeticBloc>(context).add(ChangeSortCosmetics(value!));
          }
          dropdownValue = value!;
        });
      },
      dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }
}
