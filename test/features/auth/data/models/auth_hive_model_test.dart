import 'package:flutter_test/flutter_test.dart';
import 'package:myevents/features/auth/data/models/auth_hive_model.dart';
import 'package:myevents/features/auth/domain/entities/auth_entity.dart' show AuthEntity;

void main() {
   test('convert to entity from hive model', () {
      final authModel = AuthHiveModel(
        authId: "id101",
        firstName: "test",
        email: "test@gmail.com",
        lastName: "lastName",
      );

      AuthEntity expectedEntity = AuthEntity(
        authId: "id101",
        firstName: "test",
        lastName: "lastName",
        email: "test@gmail.com",
      );
      AuthEntity actualEntity = authModel.toEntity();

      expect(expectedEntity, actualEntity);
    });

    test("convert to hive model from entity", () {
      final authEntity = AuthEntity(
        authId: "id102",
        firstName: "firstName",
        lastName: "lastName",
        email: "email@email.com",
      );

      AuthHiveModel expectedModel = AuthHiveModel(
        authId: "id102",
        firstName: "firstName",
        lastName: "lastName",
        email: "email@email.com",
      );
      AuthHiveModel actualModel = AuthHiveModel.fromEntity(authEntity);

      expect(actualModel.authId, expectedModel.authId);
      expect(actualModel.firstName, expectedModel.firstName);
      expect(actualModel.lastName, expectedModel.lastName);
      expect(actualModel.email, expectedModel.email);
    });
}