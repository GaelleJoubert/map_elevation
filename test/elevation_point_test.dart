import 'package:map_elevation/elevation_point.dart';
import 'package:test/test.dart';

void main() {
  group('ElevationPoint', () {
    test('Constructor initializes correctly', () {
      final point = ElevationPoint(45.0, 5.0, 1000.0);
      expect(point.latitude, 45.0);
      expect(point.longitude, 5.0);
      expect(point.altitude, 1000.0);
      expect(point.parameters, [{}]);
    });

    test('hasParameterType returns true if parameter type exists', () {
      final point = ElevationPoint(45.0, 5.0, 1000.0, parameters: [
        {"type": 1, "sub_type": 10}
      ]);
      expect(point.hasParameterType(1), isTrue);
    });

    test('hasParameterType returns false if parameter type does not exist', () {
      final point = ElevationPoint(45.0, 5.0, 1000.0, parameters: [
        {"type": 1, "sub_type": 10}
      ]);
      expect(point.hasParameterType(2), isFalse);
    });

    test('addOrUpgradeParameter adds new parameter if type does not exist', () {
      final point = ElevationPoint(45.0, 5.0, 1000.0);
      point.addOrUpgradeParameter(1, 10);
      bool containParameter = false;
      point.parameters.forEach((element) {
        if (element["type"] == 1 && element["sub_type"] == 10) {
          containParameter = true;
        }
      });
      expect(containParameter, isTrue);
    });

    test('addOrUpgradeParameter upgrades parameter if type exists', () {
      final point = ElevationPoint(45.0, 5.0, 1000.0, parameters: [
        {"type": 1, "sub_type": 10},
        {"type": 2, "sub_type": 40}
      ]);
      point.addOrUpgradeParameter(1, 20);

      bool containAddedParameter = false;
      point.parameters.forEach((element) {
        if (element["type"] == 1 && element["sub_type"] == 20) {
          containAddedParameter = true;
        }
      });
      expect(containAddedParameter, isTrue);

      bool containOtherParameter = false;
      point.parameters.forEach((element) {
        if (element["type"] == 2 && element["sub_type"] == 40) {
          containOtherParameter = true;
        }
      });
      expect(containOtherParameter, isTrue);
    });
  });
}
