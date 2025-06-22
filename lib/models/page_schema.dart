class PageSchema {
  final int id;
  final String name;
  final String? descr;
  final Map<String, dynamic>? data;
  final List<Section> sections;

  // Optional metadata fields
  final bool? isActive;
  final int? moduleId;
  final int? tenantId;
  final DateTime? createdAt;
  final int? createdBy;
  final DateTime? updatedAt;
  final int? updatedBy;
  final int? platformId;
  final int? pageTypeId;
  final int? displayOrder;
  final int? parentPageId;
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
    this.isActive,
    this.moduleId,
    this.tenantId,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.platformId,
    this.pageTypeId,
    this.displayOrder,
    this.parentPageId,
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
      sections: (json['sections'] as List<dynamic>)
          .map((section) => Section.fromJson(section))
          .toList(),
      isActive: json['is_active'],
      moduleId: json['module_id'],
      tenantId: json['tenant_id'],
      createdAt: DateTime.tryParse(json['created_at'] ?? ''),
      createdBy: json['created_by'],
      updatedAt: DateTime.tryParse(json['updated_at'] ?? ''),
      updatedBy: json['updated_by'],
      platformId: json['platform_id'],
      pageTypeId: json['page_type_id'],
      displayOrder: json['display_order'],
      parentPageId: json['parent_page_id'],
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

  // Optional metadata fields
  final bool? isActive;
  final int? tenantId;
  final DateTime? createdAt;
  final int? createdBy;
  final DateTime? updatedAt;
  final int? updatedBy;
  final int? platformId;
  final String? bindingName;
  final int? displayOrder;
  final int? displayModeId;
  final int? childDisplayModeId;

  Section({
    required this.id,
    required this.name,
    required this.controls,
    this.data,
    this.isActive,
    this.tenantId,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.platformId,
    this.bindingName,
    this.displayOrder,
    this.displayModeId,
    this.childDisplayModeId,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: json['id'],
      name: json['name'],
      data: json['data'],
      controls: (json['controls'] as List<dynamic>)
          .map((control) => Control.fromJson(control))
          .toList(),
      isActive: json['is_active'],
      tenantId: json['tenant_id'],
      createdAt: DateTime.tryParse(json['created_at'] ?? ''),
      createdBy: json['created_by'],
      updatedAt: DateTime.tryParse(json['updated_at'] ?? ''),
      updatedBy: json['updated_by'],
      platformId: json['platform_id'],
      bindingName: json['binding_name'],
      displayOrder: json['display_order'],
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

  // Optional metadata fields
  final bool? isActive;
  final int? tenantId;
  final DateTime? createdAt;
  final int? createdBy;
  final DateTime? updatedAt;
  final int? updatedBy;
  final int? platformId;
  final int? displayOrder;
  final int? displayModeId;
  final int? bindingListPageId;
  final String? bindingListRouteName;

  Control({
    required this.id,
    required this.name,
    required this.controlTypeId,
    required this.bindingName,
    this.data,
    this.isActive,
    this.tenantId,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.platformId,
    this.displayOrder,
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
      isActive: json['is_active'],
      tenantId: json['tenant_id'],
      createdAt: DateTime.tryParse(json['created_at'] ?? ''),
      createdBy: json['created_by'],
      updatedAt: DateTime.tryParse(json['updated_at'] ?? ''),
      updatedBy: json['updated_by'],
      platformId: json['platform_id'],
      displayOrder: json['display_order'],
      displayModeId: json['display_mode_id'],
      bindingListPageId: json['binding_list_page_id'],
      bindingListRouteName: json['binding_list_route_name'],
    );
  }
}
