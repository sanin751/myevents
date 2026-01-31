import 'package:flutter_test/flutter_test.dart';
import 'package:myevents/features/auth/data/models/auth_api_model.dart';
import 'package:myevents/features/auth/domain/entities/auth_entity.dart';

void main() {
 test("convert to auth entity from Api model", () {
    final apiModel = AuthApiModel(
      authId: "id104",
      firstName: "firstName",
      email: "email@email.com",
      lastName: "lastName",
    );

    AuthEntity expectedEntity = AuthEntity(
      authId: "id104",
      firstName: "firstName",
      lastName: "lastName",
      email: "email@email.com",
    );

    AuthEntity actualEntity = apiModel.toEntity();

    expect(actualEntity, expectedEntity);
  });

test("convert from Json to Api model", () {
      Map<String, dynamic> json = {
        "_id": "id103",
        "firstName": "firstName",
        "lastName": "lastName",
        "email": "email@email.com",
      };

      final expectedModel = AuthApiModel(
        authId: "id103",
        firstName: "firstName",
        email: "email@email.com",
        lastName: "lastName",
      );

      AuthApiModel actualModel = AuthApiModel.fromJson(json);

      expect(actualModel.authId, expectedModel.authId);
      expect(actualModel.firstName, expectedModel.firstName);
      expect(actualModel.lastName, expectedModel.lastName);
      expect(actualModel.email, expectedModel.email);
    });

    test("convert to json from Api model", () {
      final apiModel = AuthApiModel(
        firstName: "firstName",
        email: "email@email.com",
        lastName: "lastName",
      );

      Map<String, dynamic> expectedJson = {
        "firstName": "firstName",
        "lastName": "lastName",
        "email": "email@email.com",
      };

      Map<String, dynamic> actualJson = apiModel.toJson();
      // expect(actualJson, expectedJson);
      expect(actualJson["firstName"], expectedJson["firstName"]);
      expect(actualJson["lastName"], expectedJson["lastName"]);
      expect(actualJson["email"], expectedJson["email"]);
    });
}