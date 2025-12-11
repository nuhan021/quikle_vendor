// Model for GET /earning/vendor/vendor_account

class EarningsModel {
  final int? vendorId;
  final double? totalEarnings;
  final double? averageEarnings;
  final int? totalOrders;
  final double? totalWithdraw;
  final double? totalPending;
  final double? pendingBalance;
  final double? commissionEarned;
  final double? platformCost;
  final DateTime? updatedAt;

  EarningsModel({
    this.vendorId,
    this.totalEarnings,
    this.averageEarnings,
    this.totalOrders,
    this.totalWithdraw,
    this.totalPending,
    this.pendingBalance,
    this.commissionEarned,
    this.platformCost,
    this.updatedAt,
  });

  factory EarningsModel.fromJson(Map<String, dynamic> json) {
    double? _toDouble(dynamic v) {
      if (v == null) return null;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      if (v is String) return double.tryParse(v);
      return null;
    }

    int? _toInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is String) return int.tryParse(v);
      if (v is double) return v.toInt();
      return null;
    }

    DateTime? _toDate(String? s) {
      if (s == null) return null;
      try {
        return DateTime.parse(s);
      } catch (_) {
        return null;
      }
    }

    return EarningsModel(
      vendorId: _toInt(json['vendor_id']),
      totalEarnings: _toDouble(json['total_earnings']),
      averageEarnings: _toDouble(json['average_earnings']),
      totalOrders: _toInt(json['total_orders']),
      totalWithdraw: _toDouble(json['total_withdraw']),
      totalPending: _toDouble(json['total_pending']),
      pendingBalance: _toDouble(json['pending_balance']),
      commissionEarned: _toDouble(json['commission_earned']),
      platformCost: _toDouble(json['platform_cost']),
      updatedAt: _toDate(json['updated_at'] as String?),
    );
  }

  Map<String, dynamic> toJson() => {
    'vendor_id': vendorId,
    'total_earnings': totalEarnings,
    'average_earnings': averageEarnings,
    'total_orders': totalOrders,
    'total_withdraw': totalWithdraw,
    'total_pending': totalPending,
    'pending_balance': pendingBalance,
    'commission_earned': commissionEarned,
    'platform_cost': platformCost,
    'updated_at': updatedAt?.toIso8601String(),
  };
}
