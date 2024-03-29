import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:upoint/models/option_model.dart';

import '../../globals/colors.dart';
import '../../globals/custom_messengers.dart';
import '../../globals/date_time_transfer.dart';

class LongField extends StatefulWidget {
  final String initText;
  final OptionModel option;
  final Function(String) onChanged;
  const LongField({
    super.key,
    required this.option,
    required this.initText,
    required this.onChanged,
  });

  @override
  State<LongField> createState() => _LongFieldState();
}

class _LongFieldState extends State<LongField> {
  late bool isDetail = widget.option.type == "detail";
  late TextEditingController _controller;
  List iconList = ["date", "date2002", "date91", "time"];
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initText);
  }

  Widget choseIcon() {
    if (widget.option.type == "time") {
      return Container(
        height: Dimensions.height2 * 12,
        width: Dimensions.height2 * 12,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/edit_clock.png"),
          ),
        ),
      );
    } else if (widget.option.type == "drop_down") {
      return Icon(
        Icons.keyboard_arrow_down,
        color: cColor.grey300,
        size: Dimensions.height2 * 12,
      );
    } else {
      return Icon(
        Icons.calendar_month,
        color: cColor.grey300,
        size: Dimensions.height2 * 12,
      );
    }
  }

  late CColor cColor;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cColor = CColor.of(context);
  }

  onTap(String? text) async {
    if (widget.option.type == "time") {
      await _selectTime(context);
    } else if (widget.option.type == "drop_down") {
      setState(() {
        _controller.text = text ?? "";
      });
      widget.onChanged(_controller.text);
    } else {
      await _selectDate(context);
    }
  }

  DateTime? selectedDate;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await Messenger.selectDate(context, selectedDate);
    String _text = "";
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        if (widget.option.type == "date2002") {
          _text = DateFormat('yyyy-MM-dd').format(selectedDate!);
        } else {
          _text = TimeTransfer.convertToROC(selectedDate!);
        }
        _controller = TextEditingController(text: _text);
      });
      widget.onChanged(_controller.text);
    }
  }

  //選時間
  TimeOfDay? selectedTime;
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await Messenger.selectTime(context, selectedTime);
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        String _text = TimeTransfer.timeTrans04(context, selectedTime!);
        _controller = TextEditingController(text: _text);
      });
      widget.onChanged(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height:
                isDetail ? Dimensions.height5 * 24 : Dimensions.height5 * 10,
            padding: const EdgeInsets.only(left: 17, right: 11),
            decoration: BoxDecoration(
              border: Border.all(color: cColor.grey300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: widget.option.type == "detail"
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.option.type == "drop_down"
                    ? Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            customButton: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MediumText(
                                  color: cColor.grey500,
                                  size: Dimensions.height2 * 8,
                                  text: _controller.text,
                                ),
                                choseIcon(),
                              ],
                            ),
                            hint: Text(
                              '請擇一',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            value: _controller.text == ""
                                ? null
                                : _controller.text,
                            isExpanded: true,
                            onChanged: (value) => onTap(value),
                            items: widget.option.body
                                .map(
                                  (e) => DropdownMenuItem<String>(
                                    value: e,
                                    child: MediumText(
                                      color: cColor.grey500,
                                      size: Dimensions.height2 * 7,
                                      text: e,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      )
                    : Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                enabled: !iconList.contains(widget.option.type),
                                maxLines: isDetail ? 20 : 1,
                                keyboardType:
                                    isDetail ? TextInputType.multiline : null,
                                style: TextStyle(
                                  color: cColor.grey500,
                                  fontSize: Dimensions.height2 * 8,
                                  fontFamily: "NotoSansRegular",
                                ),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: Dimensions.height5),
                                  enabledBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                                onChanged: (e) => widget.onChanged(e),
                              ),
                            ),
                            if (iconList.contains(widget.option.type))
                              Row(
                                children: [
                                  MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () => onTap(null),
                                      child: choseIcon(),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
