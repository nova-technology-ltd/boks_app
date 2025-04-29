import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'custom_number_button.dart';

class PinEntryBottomSheet extends StatefulWidget {
  final String title;
  final String correctPin;
  final VoidCallback onSuccess;
  final Widget? headerWidget;
  final String? successMessage;
  final String? errorMessage;

  const PinEntryBottomSheet({
    Key? key,
    required this.correctPin,
    required this.onSuccess,
    this.title = "Account PIN Required",
    this.headerWidget,
    this.successMessage = "Secure your transaction with your PIN",
    this.errorMessage,
  }) : super(key: key);

  @override
  State<PinEntryBottomSheet> createState() => _PinEntryBottomSheetState();
}

class _PinEntryBottomSheetState extends State<PinEntryBottomSheet> {
  String enteredPin = "";
  bool isPinVisible = true;
  bool hasError = false;

  void addPinDigit(int number) {
    if (enteredPin.length < 4) {
      setState(() {
        enteredPin += number.toString();
        hasError = false;
      });

      if (enteredPin.length == 4) {
        if (enteredPin == widget.correctPin) {
          Navigator.pop(context);
          widget.onSuccess();
        } else {
          setState(() {
            hasError = true;
            enteredPin = "";
          });
        }
      }
    }
  }

  void removeLastPinDigit() {
    if (enteredPin.isNotEmpty) {
      setState(() {
        enteredPin = enteredPin.substring(0, enteredPin.length - 1);
        hasError = false;
      });
    }
  }

  Widget _buildNumberButton(int number) {
    return CustomNumberButton(
      onClick: () => addPinDigit(number),
      numbers: number,
    );
  }

  Widget _buildPinIndicator(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0),
      child: Container(
        height: 61,
        width: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            width: 1,
            color: hasError
                ? Colors.red.withOpacity(0.5)
                : Colors.grey.withOpacity(0.3),
          ),
        ),
        child: Center(
          child: isPinVisible
              ? Text(
            index < enteredPin.length ? enteredPin[index] : "",
            style: TextStyle(
              fontSize: 25,
              color: hasError ? Colors.red : Colors.black,
              fontWeight: FontWeight.w400,
            ),
          )
              : Container(
            height: 15,
            width: 15,
            decoration: BoxDecoration(
              color: index < enteredPin.length
                  ? Colors.black
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: 400,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            topLeft: Radius.circular(15),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10, bottom: 3),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: Colors.grey),
                  ),
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.black.withOpacity(0.4),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => isPinVisible = !isPinVisible),
                    child: Icon(
                      isPinVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              if (widget.headerWidget != null) widget.headerWidget!,
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) => _buildPinIndicator(index)),
                  ),
                ),
              ),
              if (hasError && widget.errorMessage != null)
                Container(
                  height: 34,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, color: Colors.red),
                        const SizedBox(width: 5),
                        Text(
                          widget.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        )
                      ],
                    ),
                  ),
                ),
              if (widget.successMessage != null && !hasError)
                Container(
                  height: 34,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.shield, color: Colors.green, size: 20,),
                        const SizedBox(width: 5),
                        Text(
                          widget.successMessage!,
                          style: const TextStyle(color: Colors.green, fontSize: 13),
                        )
                      ],
                    ),
                  ),
                ),
              const Spacer(),
              for (int i = 0; i < 3; i++)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(3, (index) => _buildNumberButton(1 + 3 * i + index)),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(width: 100), // Spacer
                  _buildNumberButton(0),
                  Padding(
                    padding: const EdgeInsets.all(3),
                    child: SizedBox(
                      height: 50,
                      width: 100,
                      child: GestureDetector(
                        onTap: removeLastPinDigit,
                        child: Container(
                          decoration: const BoxDecoration(color: Colors.transparent),
                          child: const Center(
                            child: Icon(
                              Icons.backspace,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}