class ProcessDetail {
  final int processId;
  final String ImagePath;
  final String enhancedImagePath;
  final String segmentedImagePath;
  final String asymmetry;
  final String border;
  final String colour;
  final String diameter;

  ProcessDetail({
    required this.processId,
    required this.ImagePath,
    required this.enhancedImagePath,
    required this.segmentedImagePath,
    required this.asymmetry,
    required this.border,
    required this.colour,
    required this.diameter,
  });

  factory ProcessDetail.fromJson(Map<String, dynamic> json) {
    return ProcessDetail(
      processId: int.parse(json['process_id'].toString()),
      ImagePath: json['image_path'],
      enhancedImagePath: json['enhanced_image_path'],
      segmentedImagePath: json['segmented_image_path'],
      asymmetry: json['asymmetry'],
      border: json['border'],
      colour: json['colour'],
      diameter: json['diameter'],
    );
  }
}
