import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:music_room_app/models/HasNameObject.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    required Future<List<HasNameObject>> Function(dynamic pattern) getItemList,
    Key? key,
  })  : getItemList = getItemList,
        super(key: key);

  final getItemList;
  @override
  Widget build(BuildContext context) {
    final TextEditingController _typeAheadController = TextEditingController();

    return Row(
      children: [
        Expanded(
            child: Container(
          padding: EdgeInsets.only(left: 5),
          height: 50,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).shadowColor,
                    offset: Offset(0, 3.0),
                    blurRadius: 4.0),
              ]),
          child: TypeAheadField(
            debounceDuration: Duration(microseconds: 500),
            textFieldConfiguration: TextFieldConfiguration(
                controller: _typeAheadController,
                autofocus: false,
                style: DefaultTextStyle.of(context)
                    .style
                    .copyWith(fontStyle: FontStyle.italic),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search Name',
                  contentPadding: EdgeInsets.all(10),
                )),
            suggestionsCallback: getItemList,
            itemBuilder: (context, HasNameObject suggestion) {
              return ListTile(
                title: Text(suggestion.name),
              );
            },
            onSuggestionSelected: (HasNameObject suggestion) {
              _typeAheadController.text = suggestion.name;
            },
          ),
        )),
        SizedBox(width: 10),
        Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Theme.of(context).shadowColor,
                  offset: Offset(0, 3.0),
                  blurRadius: 4.0),
            ], borderRadius: BorderRadius.all(Radius.circular(25))),
            child: ElevatedButton(
              onPressed: () {},
              child: Icon(Icons.search),
            )),
      ],
    );
  }
}
