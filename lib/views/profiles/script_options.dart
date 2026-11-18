import 'dart:async';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';

class ScriptOptionsView extends StatefulWidget {
  const ScriptOptionsView({
    super.key,
    required this.title,
    required this.loadScript,
    required this.initialValues,
    required this.onChanged,
    this.defaultsLabel,
  });

  final String title;
  final Future<String?> Function() loadScript;
  final Map<String, bool> initialValues;
  final ValueChanged<Map<String, bool>> onChanged;
  final Map<String, bool>? defaultsLabel;

  @override
  State<ScriptOptionsView> createState() => _ScriptOptionsViewState();
}

class _ScriptOptionsViewState extends State<ScriptOptionsView> {
  ExtractedScriptOptions? _extracted;
  bool _loading = true;
  late Map<String, bool> _values;

  @override
  void initState() {
    super.initState();
    _values = Map<String, bool>.from(widget.initialValues);
    unawaited(_load());
  }

  Future<void> _load() async {
    ExtractedScriptOptions result = emptyExtractedScriptOptions;
    try {
      final content = await widget.loadScript();
      if (content != null && content.isNotEmpty) {
        result = await extractScriptOptions(content);
      }
    } catch (_) {
      result = emptyExtractedScriptOptions;
    }
    if (!mounted) return;
    setState(() {
      _extracted = result;
      _loading = false;
    });
  }

  void _updateValue(String key, bool nextValue, bool fallbackDefault) {
    final next = Map<String, bool>.from(_values);
    if (nextValue == fallbackDefault && widget.defaultsLabel != null) {
      next.remove(key);
    } else {
      next[key] = nextValue;
    }
    setState(() {
      _values = next;
    });
    widget.onChanged(next);
  }

  void _resetAll() {
    setState(() {
      _values = const {};
    });
    widget.onChanged(const {});
  }

  bool _effectiveValue(String key, bool scriptDefault) {
    return _values[key] ?? widget.defaultsLabel?[key] ?? scriptDefault;
  }

  bool _fallbackDefault(String key, bool scriptDefault) {
    return widget.defaultsLabel?[key] ?? scriptDefault;
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    final extracted = _extracted;
    final options = extracted?.options ?? const <String, bool>{};
    final groups = extracted?.policyGroupOptions ?? const <String>{};
    final policyEntries = [
      for (final entry in options.entries)
        if (groups.contains(entry.key)) entry,
    ];
    final ruleEntries = [
      for (final entry in options.entries)
        if (!groups.contains(entry.key)) entry,
    ];
    return Scaffold(
      title: widget.title,
      isLoading: _loading,
      iconActions: [
        if (_values.isNotEmpty)
          IconButtonData(
            glyph: AppGlyphs.reset,
            tooltip: appLocalizations.reset,
            onPressed: _resetAll,
          ),
      ],
      body: _loading
          ? const Center(child: ActivityIndicator())
          : NullStatusSwitcher(
              isEmpty: !extracted!.compatible || options.isEmpty,
              nullStatus: NullStatus(
                label: appLocalizations.nullTip(appLocalizations.options),
                description: appLocalizations.scriptOptionsIncompatibleDesc,
                illustration: NullStatusIllustration.scripts,
              ),
              child: ScrollConfiguration(
                behavior: const ShowBarScrollBehavior(),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: SizedBox(height: context.sectionsTopPadding),
                    ),
                    if (policyEntries.isNotEmpty)
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverToBoxAdapter(
                          child: generateSection(
                            title: appLocalizations.proxyGroup,
                            items: [
                              for (final entry in policyEntries)
                                ListItem.toggle(
                                  title: Text(entry.key),
                                  value: _effectiveValue(
                                    entry.key,
                                    entry.value,
                                  ),
                                  onChanged: (value) => _updateValue(
                                    entry.key,
                                    value,
                                    _fallbackDefault(entry.key, entry.value),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    if (policyEntries.isNotEmpty && ruleEntries.isNotEmpty)
                      const SliverToBoxAdapter(child: SizedBox(height: 16)),
                    if (ruleEntries.isNotEmpty)
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverToBoxAdapter(
                          child: generateSection(
                            title: appLocalizations.rules,
                            items: [
                              for (final entry in ruleEntries)
                                ListItem.toggle(
                                  title: Text(entry.key),
                                  value: _effectiveValue(
                                    entry.key,
                                    entry.value,
                                  ),
                                  onChanged: (value) => _updateValue(
                                    entry.key,
                                    value,
                                    _fallbackDefault(entry.key, entry.value),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    SliverToBoxAdapter(
                      child: SizedBox(height: 16 + context.bottomInset),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
