/// Dynamic fare calculation service
class PricingService {
  static final PricingService _instance = PricingService._internal();

  factory PricingService() {
    return _instance;
  }

  PricingService._internal();

  /// Base fare configuration
  static const double basePrice = 10.0;
  static const double pricePerKm = 2.5;
  static const double fuelSurcharge = 1.2;
  static const double peakHourMultiplier = 1.5;

  /// Calculate fare based on distance and time
  double calculateFare({
    required double distanceKm,
    required DateTime pickupTime,
    double baseFare = basePrice,
    double perKmRate = pricePerKm,
  }) {
    // Base fare
    double fare = baseFare;

    // Distance charge
    fare += distanceKm * perKmRate;

    // Peak hour surcharge (9-11 AM, 4-7 PM)
    if (_isPeakHour(pickupTime)) {
      fare *= peakHourMultiplier;
    }

    // Apply fuel surcharge
    fare *= fuelSurcharge;

    return _roundToNearest5(fare);
  }

  /// Check if time is peak hour
  bool _isPeakHour(DateTime time) {
    final hour = time.hour;
    return (hour >= 9 && hour < 11) || (hour >= 16 && hour < 19);
  }

  /// Round fare to nearest 5
  double _roundToNearest5(double value) {
    return (value / 5).ceil() * 5;
  }

  /// Get dynamic fare based on demand
  double getDynamicFare({
    required double baseFare,
    required double demandMultiplier,
  }) {
    return baseFare * demandMultiplier;
  }

  /// Calculate total fare with additional charges
  double calculateTotalFare({
    required double baseFare,
    double serviceCharge = 0.0,
    double discount = 0.0,
  }) {
    double total = baseFare + serviceCharge - discount;
    return total > 0 ? total : baseFare;
  }

  /// Apply coupon discount
  double applyCoupon({required double fare, required double discountPercent}) {
    if (discountPercent < 0 || discountPercent > 100) {
      return fare;
    }
    return fare * (1 - discountPercent / 100);
  }

  /// Check if fare is within acceptable range
  bool isFareAcceptable(double fare) {
    return fare >= basePrice && fare <= 10000;
  }
}
