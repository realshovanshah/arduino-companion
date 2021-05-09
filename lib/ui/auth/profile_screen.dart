import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:task_weplay/utilities/enums.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  Map<String, dynamic> formData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: FormBuilder(
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    "Upload to cloud.",
                    style: TextStyle(color: Colors.black87, fontSize: 30),
                  ),
                ),
                SizedBox(height: 20),
                FormBuilderTextField(
                  initialValue: 'title',
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    labelText: 'Title',
                  ),
                  validators: [
                    FormBuilderValidators.required(),
                    FormBuilderValidators.max(20),
                  ],
                  keyboardType: TextInputType.name,
                  attribute: '',
                ),
                SizedBox(height: 20),
                FormBuilderDropdown(
                  initialValue: null,
                  attribute: 'screenType',
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    labelText: 'Screen Type',
                  ),
                  allowClear: true,
                  hint: Text('Screen Type'),
                  validators: [FormBuilderValidators.required()],
                  items: (ScreenType.values)
                      .map((screenOption) => DropdownMenuItem(
                            value: screenOption.index,
                            child: Text('${screenOption.getEnumValue()}'),
                          ))
                      .toList(),
                ),
                SizedBox(height: 20),
                FormBuilderDropdown(
                  initialValue: null,
                  attribute: 'category',
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    labelText: 'Category',
                  ),
                  allowClear: true,
                  hint: Text('Category'),
                  validators: [FormBuilderValidators.required()],
                  items: (CategoryType.values)
                      .map((formOption) => DropdownMenuItem(
                            value: formOption.index,
                            child: Text('${formOption.getEnumValue()}'),
                          ))
                      .toList(),
                ),
                FormBuilderChoiceChip(
                  initialValue: null,
                  attribute: 'status',
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Status',
                  ),
                  options: [
                    FormBuilderFieldOption(
                      value: false,
                      child: Text('True'),
                    ),
                    FormBuilderFieldOption(
                      value: true,
                      child: Container(
                        child: Text('False'),
                      ),
                    ),
                  ],
                  spacing: 8,
                  onChanged: (value) => {print(value)},
                ),
                SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: CupertinoButton(
                        color: Theme.of(context).accentColor,
                        child: Text(
                          "Reset",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          _formKey.currentState?.reset();
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'This is the initial data of your form.')));
                        },
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: CupertinoButton(
                        color: Theme.of(context).accentColor,
                        child: Text(
                          "Done",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          var currentState = _formKey.currentState;
                          currentState?.save();
                          formData = Map.from(currentState.value);
                          if (currentState.validate() == true) {
                            print(currentState.value);
                          } else {
                            print(currentState.value);
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Select a file!')));
                          }
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
