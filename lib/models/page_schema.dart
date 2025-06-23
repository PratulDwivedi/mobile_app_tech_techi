class PageSchema {
  final int id;
  final String name;
  final String? descr;
  final Map<String, dynamic>? data;
  final List<Section> sections;
  final int? pageTypeId;
  final int? bindingTypeId;
  final String? bindingNameGet;
  final String? bindingNamePost;
  final String? bindingNameDelete;
  final int? displayLocationId;
  final String? routeName;

  PageSchema({
    required this.id,
    required this.name,
    this.descr,
    this.data,
    required this.sections,
    this.pageTypeId,
    this.bindingTypeId,
    this.bindingNameGet,
    this.bindingNamePost,
    this.bindingNameDelete,
    this.displayLocationId,
    this.routeName,
  });

  factory PageSchema.fromJson(Map<String, dynamic> json) {
    return PageSchema(
      id: json['id'],
      name: json['name'],
      descr: json['descr'],
      data: json['data'],
      sections: (json['sections'] as List<dynamic>?)
              ?.map((section) => Section.fromJson(section))
              .toList() ??
          [],
      pageTypeId: json['page_type_id'],
      bindingTypeId: json['binding_type_id'],
      bindingNameGet: json['binding_name_get'],
      bindingNamePost: json['binding_name_post'],
      bindingNameDelete: json['binding_name_delete'],
      displayLocationId: json['display_location_id'],
      routeName: json['route_name'],
    );
  }
}

class Section {
  final int id;
  final String name;
  final Map<String, dynamic>? data;
  final List<Control> controls;
  final String? bindingName;
  final int? displayModeId;
  final int? childDisplayModeId;

  Section({
    required this.id,
    required this.name,
    required this.controls,
    this.data,
    this.bindingName,
    this.displayModeId,
    this.childDisplayModeId,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: json['id'],
      name: json['name'],
      data: json['data'],
      controls: (json['controls'] as List<dynamic>?)
              ?.map((control) => Control.fromJson(control))
              .toList() ??
          [],
      bindingName: json['binding_name'],
      displayModeId: json['display_mode_id'],
      childDisplayModeId: json['child_display_mode_id'],
    );
  }
}

class Control {
  final int id;
  final String name;
  final int controlTypeId;
  final String bindingName;
  final Map<String, dynamic>? data;
  final int? displayModeId;
  final int? bindingListPageId;
  final String? bindingListRouteName;

  Control({
    required this.id,
    required this.name,
    required this.controlTypeId,
    required this.bindingName,
    this.data,
    this.displayModeId,
    this.bindingListPageId,
    this.bindingListRouteName,
  });

  factory Control.fromJson(Map<String, dynamic> json) {
    return Control(
      id: json['id'],
      name: json['name'],
      controlTypeId: json['control_type_id'],
      bindingName: json['binding_name'],
      data: json['data'],
      displayModeId: json['display_mode_id'],
      bindingListPageId: json['binding_list_page_id'],
      bindingListRouteName: json['binding_list_route_name'],
    );
  }
}
