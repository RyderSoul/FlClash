import 'dart:async';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'toolbox_shared.dart';

class AgeToolView extends ConsumerStatefulWidget {
  const AgeToolView({super.key});

  @override
  ConsumerState<AgeToolView> createState() => _AgeToolViewState();
}

class _AgeToolViewState extends ConsumerState<AgeToolView> {
  late final _core = ref.read(coreHandlerProvider);
  final _keysController = TextEditingController();
  final _inputController = TextEditingController();

  bool _hybrid = false;
  bool _encrypt = true;
  bool _busy = false;
  AgeKeyPair? _keyPair;
  String _output = '';
  String _error = '';

  @override
  void dispose() {
    _keysController.dispose();
    _inputController.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final pair = await _core.generateAgeKeyPair(hybrid: _hybrid);
      if (!mounted) return;
      setState(() {
        _keyPair = pair;
        _keysController.text = _encrypt ? pair.publicKey : pair.secretKey;
        _error = '';
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _run() async {
    if (_busy) return;
    final keys = _keysController.text
        .split(RegExp(r'[\n,]'))
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
    setState(() {
      _busy = true;
      _error = '';
    });
    try {
      final res = await _core.cryptAge(
        AgeCryptParams(
          mode: _encrypt ? 'encrypt' : 'decrypt',
          data: _inputController.text,
          keys: keys,
        ),
      );
      if (!mounted) return;
      setState(() {
        _output = res.data;
        _error = res.error;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.appLocalizations;
    final keyPair = _keyPair;
    return Scaffold(
      title: l10n.ageTool,
      body: Builder(
        builder: (context) => ToolboxScrollBody(
          children: [
            generateSection(
              title: l10n.ageKeygen,
              items: [
                ListItem.toggle(
                  title: Text(l10n.ageHybrid),
                  value: _hybrid,
                  onChanged: (value) => setState(() => _hybrid = value),
                ),
                if (keyPair != null) ...[
                  ListItem(
                    title: Text(l10n.publicKey),
                    subtitle: Text(
                      keyPair.publicKey,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      tooltip: l10n.copy,
                      icon: const GlyphIcon(AppGlyphs.copy),
                      onPressed: () =>
                          unawaited(copyToolText(context, keyPair.publicKey)),
                    ),
                  ),
                  ListItem(
                    title: Text(l10n.ageSecretKey),
                    subtitle: Text(
                      keyPair.secretKey,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      tooltip: l10n.copy,
                      icon: const GlyphIcon(AppGlyphs.copy),
                      onPressed: () =>
                          unawaited(copyToolText(context, keyPair.secretKey)),
                    ),
                  ),
                ],
              ],
            ),
            TonalButton(
              size: TonalButtonSize.section,
              onPressed: _busy ? null : _generate,
              label: l10n.ageKeygen,
            ),
            SegmentedControl<bool>(
              segments: [(true, l10n.ageEncrypt), (false, l10n.ageDecrypt)],
              value: _encrypt,
              onChanged: (value) => setState(() {
                _encrypt = value;
                if (keyPair != null) {
                  _keysController.text = value
                      ? keyPair.publicKey
                      : keyPair.secretKey;
                }
              }),
            ),
            FilledInputTheme(
              borderRadius: AppRadius.lg,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: TextField(
                controller: _keysController,
                minLines: 2,
                maxLines: 4,
                autocorrect: false,
                decoration: InputDecoration(hintText: l10n.ageKeysHint),
              ),
            ),
            FilledInputTheme(
              borderRadius: AppRadius.lg,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: TextField(
                controller: _inputController,
                minLines: 4,
                maxLines: 8,
                autocorrect: false,
                decoration: InputDecoration(hintText: l10n.ageInputHint),
              ),
            ),
            FilledButton.icon(
              onPressed: _busy ? null : _run,
              icon: const GlyphIcon(AppGlyphs.key, fill: 1),
              label: Text(_encrypt ? l10n.ageEncrypt : l10n.ageDecrypt),
            ),
            if (_error.isNotEmpty)
              ToolboxErrorCard(message: toolboxErrorText(context, _error)),
            if (_output.isNotEmpty)
              Card(
                radius: AppCorner.lg,
                inert: true,
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 8,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.ageOutput,
                          style: AppTextStyle.subheadline.of(
                            context,
                            emphasized: true,
                          ),
                        ),
                        IconButton(
                          tooltip: l10n.copy,
                          icon: const GlyphIcon(AppGlyphs.copy),
                          onPressed: () =>
                              unawaited(copyToolText(context, _output)),
                        ),
                      ],
                    ),
                    SelectableText(
                      _output,
                      style: AppTextStyle.footnote.of(context),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
