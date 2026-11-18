import 'dart:convert';

import 'package:fl_clash/common/exception.dart';
import 'package:fl_clash/common/javascript.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late List<({String script, String config})> calls;
  final engine = scriptEvaluator;

  setUp(() {
    calls = [];
  });

  tearDown(() {
    scriptEvaluator = engine;
  });

  void answerWith(String result) {
    scriptEvaluator = ({required String script, required String config}) async {
      calls.add((script: script, config: config));
      return result;
    };
  }

  test(
    'passes the profile as JSON and returns what the script produced',
    () async {
      answerWith(json.encode({'mode': 'global'}));

      final result = await handleEvaluate('main', {'mode': 'rule'});

      expect(result, {'mode': 'global'});
      expect(json.decode(calls.single.config)['mode'], 'rule');
      expect(calls.single.script, 'main');
    },
  );

  test('gives the script an empty proxy-providers map to work with', () async {
    answerWith(json.encode({'mode': 'rule'}));

    await handleEvaluate('main', {'mode': 'rule'});

    expect(json.decode(calls.single.config)['proxy-providers'], isEmpty);
  });

  test('reports what the engine threw', () async {
    scriptEvaluator = ({required String script, required String config}) async {
      throw Exception('ReferenceError: proxies is not defined');
    };

    await expectLater(
      handleEvaluate('main', {}),
      throwsA(
        isA<MessageException>().having(
          (error) => error.message,
          'message',
          contains('ReferenceError'),
        ),
      ),
    );
  });

  test('rejects a result that is not a configuration object', () async {
    answerWith(json.encode([1, 2, 3]));

    await expectLater(
      handleEvaluate('main', {}),
      throwsA(isA<MessageException>()),
    );
  });

  test('injects customOptions only when non-empty', () async {
    answerWith(json.encode({'mode': 'rule'}));

    await handleEvaluate('const ruleOptionsEnable = {};', {});
    expect(calls.single.script, 'const ruleOptionsEnable = {};');

    calls.clear();
    await handleEvaluate(
      'const ruleOptionsEnable = {};',
      {},
      customOptions: {'OpenAI': false},
    );
    expect(
      calls.single.script,
      contains('Object.assign(ruleOptionsEnable, {"OpenAI":false})'),
    );
  });

  test('extractScriptOptions inspects Bettbox compatible scripts', () async {
    answerWith(
      json.encode({
        'compatible': true,
        'options': {'OpenAI': true, 'AdBlock': false},
        'icons': {'OpenAI': 'OpenAI.svg'},
        'policyGroupOptions': ['OpenAI'],
      }),
    );

    final extracted = await extractScriptOptions(
      'const Compatible_With_Bettbox = { policyGroupOptions: ["OpenAI"] };',
    );

    expect(extracted.compatible, isTrue);
    expect(extracted.options, {'OpenAI': true, 'AdBlock': false});
    expect(extracted.icons, {'OpenAI': 'OpenAI.svg'});
    expect(extracted.policyGroupOptions, {'OpenAI'});

    final empty = await extractScriptOptions('   ');
    expect(empty.compatible, isFalse);
    expect(empty.options, isEmpty);
  });
}
