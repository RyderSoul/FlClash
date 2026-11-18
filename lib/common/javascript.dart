import 'dart:convert';

import 'package:fl_clash/common/exception.dart';
import 'package:flutter/foundation.dart';
import 'package:rust_api/rust_api.dart';

typedef ScriptEvaluator =
    Future<String> Function({required String script, required String config});

typedef ExtractedScriptOptions = ({
  bool compatible,
  Map<String, bool> options,
  Map<String, String> icons,
  Set<String> policyGroupOptions,
});

const emptyExtractedScriptOptions = (
  compatible: false,
  options: <String, bool>{},
  icons: <String, String>{},
  policyGroupOptions: <String>{},
);

@visibleForTesting
ScriptEvaluator scriptEvaluator = evaluateScript;

Future<Map<String, dynamic>> handleEvaluate(
  String scriptContent,
  Map<String, dynamic> config, {
  Map<String, bool>? customOptions,
}) async {
  if (config['proxy-providers'] == null) {
    config['proxy-providers'] = {};
  }
  final effectiveScript = customOptions == null || customOptions.isEmpty
      ? scriptContent
      : '$scriptContent\n;if (typeof ruleOptionsEnable === \'object\' && '
            'ruleOptionsEnable !== null) { '
            'Object.assign(ruleOptionsEnable, ${json.encode(customOptions)}); }\n';
  final String result;
  try {
    result = await scriptEvaluator(
      script: effectiveScript,
      config: json.encode(config),
    );
  } catch (e) {
    throw MessageException(e.toString());
  }
  final decoded = json.decode(result);
  if (decoded is! Map<String, dynamic>) {
    throw const MessageException(
      'script did not return a configuration object',
    );
  }
  return decoded;
}

Future<ExtractedScriptOptions> extractScriptOptions(
  String scriptContent,
) async {
  if (scriptContent.trim().isEmpty) return emptyExtractedScriptOptions;
  final probeScript =
      '''
(function() {
$scriptContent
const __compat = typeof Compatible_With_Bettbox !== 'undefined' && Boolean(Compatible_With_Bettbox);
const __options = {};
if (__compat && typeof ruleOptionsEnable === 'object' && ruleOptionsEnable !== null) {
  for (const [k, v] of Object.entries(ruleOptionsEnable)) {
    if (typeof v === 'boolean') __options[k] = v;
  }
}
const __icons = {};
if (__compat && typeof serviceConfigs !== 'undefined' && Array.isArray(serviceConfigs)) {
  for (const svc of serviceConfigs) {
    if (svc && typeof svc.name === 'string' && typeof svc.icon === 'string') {
      __icons[svc.name] = svc.icon;
    }
  }
}
if (__compat && typeof icons === 'object' && icons !== null) {
  for (const [k, v] of Object.entries(icons)) {
    if (typeof v === 'string') __icons[k] = v;
  }
}
const __groups = [];
if (__compat && typeof Compatible_With_Bettbox === 'object' && Array.isArray(Compatible_With_Bettbox.policyGroupOptions)) {
  for (const name of Compatible_With_Bettbox.policyGroupOptions) {
    if (typeof name === 'string') __groups.push(name);
  }
}
if (__compat && typeof policyGroupOptions !== 'undefined' && Array.isArray(policyGroupOptions)) {
  for (const name of policyGroupOptions) {
    if (typeof name === 'string') __groups.push(name);
  }
}
globalThis.__flsmartExtracted = {
  compatible: __compat,
  options: __options,
  icons: __icons,
  policyGroupOptions: __groups,
};
})();
function main() {
  return globalThis.__flsmartExtracted;
}
''';
  try {
    final raw = await scriptEvaluator(script: probeScript, config: '{}');
    final decoded = json.decode(raw);
    if (decoded is! Map<String, dynamic>) return emptyExtractedScriptOptions;
    final compatible = decoded['compatible'] == true;
    if (!compatible) return emptyExtractedScriptOptions;
    final options = <String, bool>{
      for (final entry in (decoded['options'] as Map? ?? const {}).entries)
        if (entry.value is bool) entry.key.toString(): entry.value as bool,
    };
    final icons = <String, String>{
      for (final entry in (decoded['icons'] as Map? ?? const {}).entries)
        if (entry.value is String) entry.key.toString(): entry.value as String,
    };
    final policyGroupOptions = <String>{
      for (final item in decoded['policyGroupOptions'] as List? ?? const [])
        if (item is String) item,
    };
    return (
      compatible: true,
      options: options,
      icons: icons,
      policyGroupOptions: policyGroupOptions,
    );
  } catch (_) {
    return emptyExtractedScriptOptions;
  }
}
