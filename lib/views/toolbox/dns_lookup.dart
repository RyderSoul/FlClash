import 'dart:async';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/features/form/form.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'toolbox_shared.dart';

const _dnsTypes = ['A', 'AAAA', 'CNAME', 'HTTPS', 'TXT', 'MX', 'NS'];

const _dnsPresetServers = [
  '223.5.5.5',
  '119.29.29.29',
  'https://dns.alidns.com/dns-query',
  '1.1.1.1',
  '8.8.8.8',
  'https://cloudflare-dns.com/dns-query',
  'tls://dns.google',
];

class DnsLookupView extends ConsumerStatefulWidget {
  const DnsLookupView({super.key});

  @override
  ConsumerState<DnsLookupView> createState() => _DnsLookupViewState();
}

class _DnsLookupViewState extends ConsumerState<DnsLookupView> {
  late final _core = ref.read(coreHandlerProvider);
  final _domainController = TextEditingController(text: 'www.google.com');
  final _serverController = TextEditingController(text: '223.5.5.5');

  String _type = 'A';
  String _mode = 'follow';
  bool _querying = false;
  DnsQueryResult? _result;

  @override
  void dispose() {
    _domainController.dispose();
    _serverController.dispose();
    super.dispose();
  }

  Future<void> _query() async {
    final domain = _domainController.text.trim();
    if (domain.isEmpty || _querying) return;
    setState(() => _querying = true);
    try {
      final res = await _core.queryDns(
        DnsQueryParams(
          domain: domain,
          type: _type,
          mode: _mode,
          server: _mode == 'custom' ? _serverController.text.trim() : '',
        ),
      );
      if (!mounted) return;
      setState(() => _result = res);
    } catch (error) {
      if (!mounted) return;
      setState(
        () => _result = DnsQueryResult(domain: domain, error: error.toString()),
      );
    } finally {
      if (mounted) {
        setState(() => _querying = false);
      }
    }
  }

  Future<void> _pickType() async {
    final picked = await showSheet<String>(
      context: context,
      builder: (sheetContext) => SelectionSheet<String>(
        title: context.appLocalizations.type,
        sections: const [SelectionSection(items: _dnsTypes)],
        labelBuilder: (item) => item,
        selectedOf: (_) => _type,
        onSelected: (item) => Navigator.of(sheetContext).pop(item),
      ),
    );
    if (picked != null && mounted) {
      setState(() => _type = picked);
    }
  }

  Future<void> _pickPresetServer() async {
    final picked = await showSheet<String>(
      context: context,
      builder: (sheetContext) => SelectionSheet<String>(
        title: context.appLocalizations.server,
        sections: const [SelectionSection(items: _dnsPresetServers)],
        labelBuilder: (item) => item,
        selectedOf: (_) => _serverController.text.trim(),
        onSelected: (item) => Navigator.of(sheetContext).pop(item),
      ),
    );
    if (picked != null && mounted) {
      setState(() => _serverController.text = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.appLocalizations;
    final res = _result;
    return Scaffold(
      title: l10n.dnsQuery,
      body: Builder(
        builder: (context) => ToolboxScrollBody(
          children: [
            generateSection(
              items: [
                FormRow(
                  title: l10n.domain,
                  trailing: FormRowTextField(
                    controller: _domainController,
                    autocorrect: false,
                    hintText: 'example.com',
                    onFieldSubmitted: (_) => unawaited(_query()),
                  ),
                ),
                FormRow(
                  title: l10n.type,
                  onPressed: _pickType,
                  trailing: Text(_type),
                ),
                if (_mode == 'custom') ...[
                  FormRow(
                    title: l10n.server,
                    trailing: FormRowTextField(
                      controller: _serverController,
                      autocorrect: false,
                      hintText: '1.1.1.1 / https://...',
                    ),
                  ),
                  FormRow(
                    title: l10n.server,
                    onPressed: _pickPresetServer,
                    trailing: Text(l10n.search),
                  ),
                ],
              ],
            ),
            SegmentedControl<String>(
              segments: [
                ('follow', l10n.speedTestFollowRules),
                ('system', l10n.dnsQuerySystem),
                ('custom', l10n.custom),
              ],
              value: _mode,
              onChanged: (value) => setState(() => _mode = value),
            ),
            FilledButton.icon(
              onPressed: _querying ? null : _query,
              icon: const GlyphIcon(AppGlyphs.dns, fill: 1),
              label: Text(l10n.run),
            ),
            if (_querying) const LinearProgressIndicator(),
            if (res != null && res.error.isNotEmpty)
              ToolboxErrorCard(message: toolboxErrorText(context, res.error)),
            if (res != null && res.error.isEmpty) ...[
              ToolboxMetricGrid(
                items: [
                  ToolboxMetricItem(
                    label: l10n.dnsQueryRoute,
                    value: res.route.isEmpty ? '—' : res.route,
                  ),
                  ToolboxMetricItem(
                    label: 'Rcode',
                    value: res.rcode.isEmpty ? '—' : res.rcode,
                  ),
                  ToolboxMetricItem(
                    label: l10n.latency,
                    value: toolboxFormatMillis(res.elapsed),
                  ),
                  ToolboxMetricItem(
                    label: l10n.dnsQueryAnswers,
                    value: '${res.answers.length}',
                  ),
                ],
              ),
              if (res.outbound.isNotEmpty || res.fakeIpRange.isNotEmpty)
                generateSection(
                  items: [
                    if (res.outbound.isNotEmpty)
                      ListItem(
                        title: Text(l10n.routeTraceChain),
                        subtitle: Text(res.outbound),
                      ),
                    if (res.fakeIpRange.isNotEmpty)
                      ListItem(
                        title: const Text('Fake-IP'),
                        subtitle: Text(res.fakeIpRange),
                      ),
                  ],
                ),
              if (res.answers.isNotEmpty)
                generateSection(
                  title: l10n.dnsQueryAnswers,
                  items: [
                    for (final record in res.answers)
                      ListItem(
                        title: Text(record.data),
                        subtitle: Text(
                          '${record.name} · ${record.type} · TTL ${record.ttl}',
                        ),
                        onTap: () =>
                            unawaited(copyToolText(context, record.data)),
                      ),
                  ],
                ),
            ],
          ],
        ),
      ),
    );
  }
}
