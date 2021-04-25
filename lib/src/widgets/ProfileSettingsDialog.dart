import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:veca_customer/config/ui_icons.dart';
import 'package:veca_customer/src/common/ui_helper.dart';
import 'package:veca_customer/src/models/AccountResponse.dart';

class ProfileSettingsDialog extends StatefulWidget {
  final void Function(String name, String sex, String dob, String email)
      saveUser;
  Account user;
  VoidCallback onChanged;

  ProfileSettingsDialog({Key key, this.user, this.onChanged, this.saveUser})
      : super(key: key);

  @override
  _ProfileSettingsDialogState createState() => _ProfileSettingsDialogState();
}

class _ProfileSettingsDialogState extends State<ProfileSettingsDialog>
    with UIHelper {
  GlobalKey<FormState> _profileSettingsFormKey = new GlobalKey<FormState>();
  var _userName;
  var _email;
  var _sex;
  var _dob;
  String gender = '';

  @override
  Widget build(BuildContext context) {
    if (widget.user == null) {
      gender = localizedText(context, 'Male');
    }
    return FlatButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                titlePadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                title: Row(
                  children: <Widget>[
                    Icon(UiIcons.user_1),
                    SizedBox(width: 10),
                    Text(
                      localizedText(context, 'profile_settings'),
                      style: Theme.of(context).textTheme.headline4,
                    )
                  ],
                ),
                children: <Widget>[
                  Form(
                    key: _profileSettingsFormKey,
                    child: Column(
                      children: <Widget>[
                        new TextFormField(
                          style: Theme.of(context).textTheme.bodyText2,
                          keyboardType: TextInputType.text,
                          enabled: false,
                          decoration: getInputDecoration(
                              hintText: '',
                              labelText:
                                  localizedText(context, 'phone_number')),
                          validator: (input) => input.trim().length < 3
                              ? localizedText(context, 'not_a_valid_full_name')
                              : null,
                          initialValue: widget.user == null
                              ? "+84972279843"
                              : widget.user.phoneCountryCode +
                                  widget.user.phoneNumber,
                          onSaved: (input) => _userName = input,
                        ),
                        new TextFormField(
                          style: Theme.of(context).textTheme.bodyText2,
                          keyboardType: TextInputType.text,
                          decoration: getInputDecoration(
                              hintText: '',
                              labelText: localizedText(context, 'full_name')),
                          validator: (input) => input.trim().length < 3
                              ? localizedText(context, 'not_a_valid_full_name')
                              : null,
                          initialValue:
                              widget.user == null ? "" : widget.user.name,
                          onSaved: (input) => _userName = input,
                        ),
                        new TextFormField(
                          style: Theme.of(context).textTheme.bodyText2,
                          keyboardType: TextInputType.emailAddress,
                          decoration: getInputDecoration(
                              hintText: '',
                              labelText:
                                  localizedText(context, 'email_address')),
                          initialValue:
                              widget.user == null ? "" : widget.user.email,
                          validator: (input) => !input.contains('@')
                              ? localizedText(context, 'not_a_valid_email')
                              : null,
                          onSaved: (input) => _email = input,
                        ),
                        FormField<String>(
                          builder: (FormFieldState<String> state) {
                            return DropdownButtonFormField<String>(
                              decoration: getInputDecoration(
                                  hintText: localizedText(context, 'female'),
                                  labelText: localizedText(context, 'gender')),
                              hint: Text(
                                  localizedText(context, 'select_device'),
                                  style: Theme.of(context).textTheme.bodyText2),
                              value: widget.user == null
                                  ? gender
                                  : widget.user.sex,
                              onSaved: (input) => _sex = input,
                              onChanged: (value) {
                                setState(() => widget.user.sex = value);
                              },
                              items: [
                                new DropdownMenuItem(
                                    value: 'Male',
                                    child: Text(
                                      localizedText(
                                        context,
                                        'male',
                                      ),
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    )),
                                new DropdownMenuItem(
                                    value: 'Female',
                                    child: Text(
                                      localizedText(context, 'female'),
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    )),
                              ],
                            );
                          },
                        ),
                        FormField<String>(
                          builder: (FormFieldState<String> state) {
                            return DateTimeField(
                              decoration: getInputDecoration(
                                  hintText: (widget.user == null ||
                                          widget.user.dob == "")
                                      ? ""
                                      : widget.user.dob,
                                  labelText:
                                      localizedText(context, 'birth_date')),
                              format: new DateFormat('yyyy-MM-dd'),
                              initialValue: (widget.user == null ||
                                      widget.user.dob == "" ||
                                      widget.user.dob == null)
                                  ? null
                                  : new DateFormat('MMMM dd, yyyy')
                                      .parse(widget.user.dob),
                              validator: (input) => input == null
                                  ? localizedText(context, 'time_is_empty')
                                  : null,
                              onShowPicker: (context, currentValue) {
                                return showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1900),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: DateTime(2100));
                              },
                              onSaved: (input) => setState(() {
                                _dob = input;
                              }),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(localizedText(context, 'cancel'),
                            style: Theme.of(context).textTheme.headline4),
                      ),
                      MaterialButton(
                        onPressed: _submit,
                        child: Text(
                          localizedText(context, 'save'),
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.end,
                  ),
                  SizedBox(height: 10),
                ],
              );
            });
      },
      child: Text(
        localizedText(context, 'edit'),
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }

  InputDecoration getInputDecoration({String hintText, String labelText}) {
    return new InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: Theme.of(context).textTheme.subtitle2.merge(
            TextStyle(color: Theme.of(context).accentColor),
          ),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).accentColor.withOpacity(0.2))),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).accentColor)),
      hasFloatingPlaceholder: true,
      labelStyle: Theme.of(context).textTheme.bodyText2.merge(
            TextStyle(color: Theme.of(context).accentColor),
          ),
    );
  }

  void _submit() {
    if (_profileSettingsFormKey.currentState.validate()) {
      _profileSettingsFormKey.currentState.save();
      widget.saveUser(
          _userName, _sex, DateFormat('yyyy-MM-dd').format(_dob), _email);
      Navigator.pop(context);
    }
  }
}
