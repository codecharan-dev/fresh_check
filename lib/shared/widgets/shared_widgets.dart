// Barrel export for all shared/reusable UI widgets.
//
// Import this single file in any feature screen to access
// the entire FreshCheck design system:
//
//   import 'package:fresh_check/shared/widgets/shared_widgets.dart';
//
// Adding a new shared widget:
//   1. Create the widget file inside the appropriate sub-folder.
//   2. Add its export line to this file (keep sections alphabetical).
//   3. Never export feature-specific widgets here — only truly reusable ones.

// ── AppBar ────────────────────────────────────────────────────────────────────
export 'package:fresh_check/shared/widgets/appbar/primary_appbar.dart';

// ── Buttons ───────────────────────────────────────────────────────────────────
export 'package:fresh_check/shared/widgets/buttons/icon_button.dart';
export 'package:fresh_check/shared/widgets/buttons/primary_button.dart';
export 'package:fresh_check/shared/widgets/buttons/secondary_button.dart';

// ── Cards ─────────────────────────────────────────────────────────────────────
export 'package:fresh_check/shared/widgets/cards/app_card.dart';
export 'package:fresh_check/shared/widgets/cards/info_card.dart';

// ── Dialogs ───────────────────────────────────────────────────────────────────
export 'package:fresh_check/shared/widgets/dialogs/app_dialog.dart';
export 'package:fresh_check/shared/widgets/dialogs/bottom_sheet.dart';
export 'package:fresh_check/shared/widgets/dialogs/confirmation_dialog.dart';

// ── Images ────────────────────────────────────────────────────────────────────
export 'package:fresh_check/shared/widgets/images/network_image_view.dart';
export 'package:fresh_check/shared/widgets/images/placeholder_image.dart';
export 'package:fresh_check/shared/widgets/images/svg_view.dart';

// ── Inputs ────────────────────────────────────────────────────────────────────
export 'package:fresh_check/shared/widgets/inputs/otp_field.dart';
export 'package:fresh_check/shared/widgets/inputs/password_field.dart';
export 'package:fresh_check/shared/widgets/inputs/search_field.dart';
export 'package:fresh_check/shared/widgets/inputs/text_field.dart';

// ── Loading ───────────────────────────────────────────────────────────────────
export 'package:fresh_check/shared/widgets/loading/full_screen_loader.dart';
export 'package:fresh_check/shared/widgets/loading/loading_indicator.dart';
export 'package:fresh_check/shared/widgets/loading/shimmer_loader.dart';

// ── Spacing ───────────────────────────────────────────────────────────────────
export 'package:fresh_check/shared/widgets/spacing/app_sizedbox.dart';
export 'package:fresh_check/shared/widgets/spacing/app_spacing.dart';

// ── States ────────────────────────────────────────────────────────────────────
export 'package:fresh_check/shared/widgets/states/empty_view.dart';
export 'package:fresh_check/shared/widgets/states/error_view.dart';
export 'package:fresh_check/shared/widgets/states/retry_view.dart';
