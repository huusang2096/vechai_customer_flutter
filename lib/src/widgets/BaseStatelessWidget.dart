import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

abstract class BaseStatelessWidget extends StatelessWidget {
  String localizedText(BuildContext context, String key) {
    return AppLocalizations.of(context).tr(key);
  }
}