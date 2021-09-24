import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';


import 'package:clean_architeture/domain/helpers/helpers.dart';
import 'package:clean_architeture/domain/usecases/authentication.dart';

import 'package:clean_architeture/data/http/http.dart';
import 'package:clean_architeture/data/usecases/usecases.dart';

class HttpClientSpy extends Mock implements HttpClient{}

void main(){
  RemoteAuthentication? sut;
  HttpClientSpy? httpClient;
  String? url;
  AuthenticationParams? params;
  PostExpectation mockRequest() =>   when(httpClient?.request(
      url: anyNamed('url') ,
      method: anyNamed('method'),
      body: anyNamed('body')));

  Map mockValidData() => {
    'accessToken':faker.guid.guid(),
    'name': faker.person.name()
  };

  void mockHttpData(Map data){
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error){
    mockRequest().thenThrow(error);
  }

  setUp(() {
     httpClient = HttpClientSpy();
     url = faker.internet.httpsUrl();
     sut = RemoteAuthentication(httpClient: httpClient, url: url);
     params = AuthenticationParams(email: faker.internet.email() ,
         password: faker.internet.password());
     mockHttpData(mockValidData());
  });

  test('Should call HTTClient with correct values', () async{
      await sut?.auth(params);

      verify(httpClient?.request(
          url: url,
          method:'post',
          body: {'email': params?.email, 'password' : params?.password}
      ));
  });

  test('Should throw UnexpectedError if HttpClient returns 400', () async{
    mockHttpError(HttpError.badRequest);

    final future = sut?.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async{
    mockHttpError(HttpError.notFound);

    final future = sut?.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async{
    mockHttpError(HttpError.serverError);

    final future = sut?.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw InvalidCredentialsError if HttpClient returns 401', () async{
    mockHttpError(HttpError.unauthorized);

    final future = sut?.auth(params);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('Should return an account if HttpClient returns 200', () async{
    final validData = mockValidData();
    mockHttpData(validData);

    final account = await sut?.auth(params);

    expect(account?.token, validData['accessToken']);
  });

  test('Should throw UnexpectedError if HttpClient returns 200 with invalid data', () async{
    mockHttpData( {
      'invalid_key': 'invalid_value'
    });

    final future = sut?.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}