import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/plateform/network_info.dart';

import 'network_info_test.mocks.dart';

@GenerateMocks([InternetConnection])
void main() {
  late NetworkInfoImpl networkInfoImpl;
  late MockInternetConnection mockNetworkInfo;

  setUp(() {
    mockNetworkInfo = MockInternetConnection();
    networkInfoImpl = NetworkInfoImpl(connectChecker: mockNetworkInfo);
  });

  group('isConnected', () {
    test(
      'should forward the call to InternetConnection.hasInternetAccess',
      () async {

        // arrange
        when(mockNetworkInfo.hasInternetAccess).thenAnswer((_) async => true);
        //act
        final result = await networkInfoImpl.isConnectivity;

        //assert
        verify(mockNetworkInfo.hasInternetAccess);
        expect(result, true);
      },
    );
  });
}
