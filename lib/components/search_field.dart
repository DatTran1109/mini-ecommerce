import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final void Function()? onFilterPressed;
  final void Function()? onSearchPressed;
  final TextEditingController textController;

  const SearchField(
      {super.key,
      required this.onFilterPressed,
      required this.onSearchPressed,
      required this.textController});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: const Color(0xff1D1617).withOpacity(0.11),
            blurRadius: 40,
            spreadRadius: 0.0)
      ]),
      child: TextField(
        controller: textController,
        decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).colorScheme.secondary,
            contentPadding: const EdgeInsets.all(15),
            hintText: 'Search products',
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(5),
              child: IconButton(
                icon: const Icon(Icons.search),
                onPressed: onSearchPressed,
              ),
            ),
            suffixIcon: SizedBox(
              width: 100,
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const VerticalDivider(
                      color: Colors.black,
                      indent: 10,
                      endIndent: 10,
                      thickness: 0.1,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: IconButton(
                          onPressed: onFilterPressed,
                          icon: const Icon(Icons.filter_alt_outlined)),
                    ),
                  ],
                ),
              ),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none)),
      ),
    );
  }
}
