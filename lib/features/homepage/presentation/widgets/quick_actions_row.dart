import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../domain/models/quick_action.dart';
import 'quick_action_button.dart';
import 'scan_action_button.dart';

class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({
    super.key,
    required this.actions,
    required this.onActionTap,
  });

  final List<QuickAction> actions;
  final ValueChanged<QuickAction> onActionTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var i = 0; i < actions.length; i++) ...[
          if (i != 0) SizedBox(width: AppSpacing.sm),
          actions[i].isPrimary
              ? ScanActionButton(
                  action: actions[i],
                  onTap: () => onActionTap(actions[i]),
                )
              : Expanded(
                  child: QuickActionButton(
                    action: actions[i],
                    onTap: () => onActionTap(actions[i]),
                  ),
                ),
        ],
      ],
    );
  }
}
