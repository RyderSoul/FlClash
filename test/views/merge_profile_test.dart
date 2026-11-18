import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/views/profiles/merge_profile.dart';
import 'package:fl_clash/views/profiles/profiles.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/host_scaffold.dart';
import '../helpers/test_app.dart';
import '../helpers/test_profiles.dart';

class _RecordingProfilesAction extends ProfilesAction {
  final saved =
      <({int? profileId, String label, List<BundleMember> members})>[];

  @override
  Future<Profile> saveBundleProfile({
    int? profileId,
    required String label,
    required List<BundleMember> members,
    bool refresh = true,
  }) async {
    saved.add((profileId: profileId, label: label, members: members));
    return Profile.normal(label: label).copyWith(
      id: profileId ?? 99,
      overrides: ProfileOverrides(bundle: BundleConfig(members: members)),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await AppLocalizations.load(const Locale('en'));
  });

  ProviderContainer containerFor(
    WidgetTester tester, {
    required List<Profile> profiles,
    _RecordingProfilesAction? action,
  }) {
    const size = Size(1100, 1200);
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer(
      overrides: [
        profilesProvider.overrideWith(() => TestProfiles(profiles)),
        currentProfileIdProvider.overrideWithBuild((_, _) => profiles.first.id),
        if (action != null) profilesActionProvider.overrideWith(() => action),
      ],
    );
    addTearDown(container.dispose);
    globalState.container = container;
    container.read(viewSizeProvider.notifier).update((_) => size);
    return container;
  }

  testWidgets('MergeProfileView saves bundle and warns below 2 enabled', (
    tester,
  ) async {
    final first = Profile.normal(label: 'Airport A').copyWith(id: 1);
    final second = Profile.normal(label: 'Airport B').copyWith(id: 2);
    final bundle = Profile.normal(label: 'Merged').copyWith(
      id: 3,
      overrides: const ProfileOverrides(
        bundle: BundleConfig(
          members: [BundleMember(profileId: 1), BundleMember(profileId: 2)],
          report: MergeReport(proxies: 12, duplicates: 1, groups: 3),
        ),
      ),
    );
    final action = _RecordingProfilesAction();
    final container = containerFor(
      tester,
      profiles: [first, second, bundle],
      action: action,
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: TestApp(
          child: HostScaffold(body: MergeProfileView(profileId: bundle.id)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Airport A'), findsOneWidget);
    expect(find.text('Airport B'), findsOneWidget);
    expect(find.text('12'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);

    await tester.tap(find.text(currentAppLocalizations.save));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 2));

    expect(action.saved.length, 1);
    expect(action.saved.single.label, 'Merged');
    expect(action.saved.single.members.map((e) => e.profileId), [1, 2]);
    expect(tester.takeException(), isNull);
  });

  testWidgets('ProfilesView displays collapsible bundle members', (
    tester,
  ) async {
    final first = Profile.normal(label: 'Alpha Node').copyWith(id: 11);
    final second = Profile.normal(label: 'Beta Node').copyWith(id: 12);
    final bundle = Profile.normal(label: 'Combined').copyWith(
      id: 13,
      overrides: const ProfileOverrides(
        bundle: BundleConfig(
          members: [BundleMember(profileId: 11), BundleMember(profileId: 12)],
          report: MergeReport(proxies: 20, duplicates: 2, groups: 4),
        ),
      ),
    );
    final container = containerFor(tester, profiles: [first, second, bundle]);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const TestApp(child: HostScaffold(body: ProfilesView())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Combined'), findsOneWidget);
    expect(find.text(currentAppLocalizations.bundleSummary(2, 20)), findsOne);
    expect(tester.takeException(), isNull);
  });
}
