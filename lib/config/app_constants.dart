class TenantAuthTypes {
  static const int form = 1;
  static const int saml = 2;
  static const int ldap = 3;
}

class Platforms {
  static const int both = 20;
  static const int web = 21;
  static const int mobile = 22;
}

class PageDisplayLocations {
  static const int sidebar = 17;
  static const int quicklist = 18;
  static const int none = 19;
}

class PageTypes {
  static const int form = 23;
  static const int report = 24;
  static const int schedule = 38;
}

class PageBindingTypes {
  static const int function = 25;
}

class SectionDisplayModes {
  static const int expand = 28;
  static const int collapse = 29;
  static const int none = 30;
}

class ControlDisplayModes {
  static const int visible = 33;
  static const int require = 34;
  static const int disabled = 35;
  static const int displayReadOnly = 36;
  static const int noneHidden = 37;
}

class ChildDiaplayModes {
  static const int form = 31;
  static const int dataTable = 32;
  static const int dataTableReport = 39;
  static const int dataTableReportAdvance = 40;
  static const int googleMap = 41;
  static const int cardItem = 259;
}

class ControlTypes {
  static const int alphaNumeric = 1;
  static const int alphaOnly = 2;
  static const int email = 3;
  static const int date = 4;
  static const int dateAndTime = 5;
  static const int password = 6;
  static const int phoneNumber = 7;
  static const int integer = 8;
  static const int decimal = 9;
  static const int checkbox = 10;
  static const int dropdownMultiselect = 11;
  static const int dropdown = 12;
  static const int textArea = 13;
  static const int fileUpload = 14;
  static const int hyperlink = 15;
  static const int submit = 16;
  static const int treeViewSingle = 17;
  static const int treeViewMulti = 18;
  static const int barChart = 19;
  static const int lineChart = 20;
  static const int pieChart = 21;
  static const int geoLocation = 22;
  static const int htmlEditor = 23;
  static const int htmlParser = 24;
  static const int currency = 25;
  static const int image = 26;
  static const int month = 27;
  static const int time = 28;
  static const int reorderList = 29;
  static const int toggleSwitch = 30;
  static const int list = 31;
  static const int url = 32;
  static const int hyperlinkRow = 33;
  static const int addTableRow = 34;
  static const int deleteTableRow = 35;
  static const int markdownParser = 36;
  static const int colorPicker = 37;
}

class ApiRoutes {
  static const String profile = 'fn_get_profile';
  static const String logoUrl = 'fn_get_tenant_logo_url';
  static const String userPages = 'fn_get_user_pages';
  static const String pageSchema = 'fn_get_page_schema';
  static const String userDevice = 'fn_save_user_device';
  // Add more routes as needed
}
