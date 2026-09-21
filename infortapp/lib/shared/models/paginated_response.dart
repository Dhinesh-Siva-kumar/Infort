class PaginatedResponse<T> {
  const PaginatedResponse({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final data = (json['data'] as List<dynamic>? ?? const [])
        .map((item) => fromJsonT(item as Map<String, dynamic>))
        .toList();
    final meta = json['meta'] as Map<String, dynamic>? ?? const {};

    return PaginatedResponse<T>(
      items: data,
      page: (meta['page'] as num?)?.toInt() ?? 1,
      limit: (meta['limit'] as num?)?.toInt() ?? data.length,
      total: (meta['total'] as num?)?.toInt() ?? data.length,
    );
  }

  final List<T> items;
  final int page;
  final int limit;
  final int total;

  bool get hasMore => page * limit < total;
}
