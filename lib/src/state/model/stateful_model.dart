import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class StatefulModel extends ChangeNotifier {
  void setState([VoidCallback? action]) {
    action?.call();
    notifyListeners();
  }

  static T watch<T>(BuildContext context, [bool listen = false]) => Provider.of<T>(context, listen: true);
  static T read<T>(BuildContext context, [bool listen = false]) => Provider.of<T>(context, listen: false);
}

/** 

class _TemplateModel extends StatefulModel {
  static _TemplateModel read(BuildContext context) => StatefulModel.read(context);
  static _TemplateModel watch(BuildContext context) => StatefulModel.watch(context);

  // -----------------------------------------------------------
  // State -----------------------------------------------------

  // -----------------------------------------------------------
  // Getters ---------------------------------------------------

  // -----------------------------------------------------------
  // Utility ---------------------------------------------------

  // -----------------------------------------------------------
  // Manipulation ----------------------------------------------

  // -----------------------------------------------------------
  // Internal Helpers ------------------------------------------

}

*/
