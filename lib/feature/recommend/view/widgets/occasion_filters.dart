import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/helpers/context_helper.dart';
import 'gender_chip.dart';

/// Sub-filtro concreto dentro de una ocasión (ej: "Cita romántica").
class OccasionOption {
  const OccasionOption(this.label, this.phrase);

  final String label;

  /// Frase que se envía al backend como `occasion`; el clasificador de
  /// zafira-core la mapea por keywords al tipo correcto (romantic, gala…).
  final String phrase;
}

/// Ocasión principal con sus sub-filtros.
class OccasionGroup {
  const OccasionGroup({
    required this.label,
    required this.icon,
    required this.phrase,
    required this.subs,
  });

  final String label;
  final IconData icon;

  /// Frase enviada si el usuario no elige sub-filtro.
  final String phrase;
  final List<OccasionOption> subs;
}

const occasionGroups = <OccasionGroup>[
  OccasionGroup(
    label: 'Cita',
    icon: Icons.favorite_rounded,
    phrase: 'cita',
    subs: [
      OccasionOption('Cita romántica', 'cita romántica'),
      OccasionOption('Cita casual', 'cita casual'),
      OccasionOption('Primera cita', 'primera cita'),
    ],
  ),
  OccasionGroup(
    label: 'Formal',
    icon: Icons.work_rounded,
    phrase: 'trabajo',
    subs: [
      OccasionOption('Oficina', 'oficina'),
      OccasionOption('Entrevista', 'entrevista'),
      OccasionOption('Presentación', 'presentación'),
    ],
  ),
  OccasionGroup(
    label: 'Fiesta',
    icon: Icons.celebration_rounded,
    phrase: 'fiesta',
    subs: [
      OccasionOption('Fiesta de noche', 'fiesta de noche'),
      OccasionOption('Cumpleaños', 'cumpleaños'),
      OccasionOption('Discoteca', 'discoteca'),
    ],
  ),
  OccasionGroup(
    label: 'Boda / Gala',
    icon: Icons.diamond_rounded,
    phrase: 'gala',
    subs: [
      OccasionOption('Boda', 'boda'),
      OccasionOption('Graduación', 'graduación'),
      OccasionOption('Evento elegante', 'evento elegante'),
    ],
  ),
  OccasionGroup(
    label: 'Deporte',
    icon: Icons.fitness_center_rounded,
    phrase: 'deporte',
    subs: [
      OccasionOption('Gym', 'gym'),
      OccasionOption('Salida deportiva', 'salida deportiva'),
      OccasionOption('Correr', 'correr'),
    ],
  ),
  OccasionGroup(
    label: 'Playa',
    icon: Icons.beach_access_rounded,
    phrase: 'playa',
    subs: [
      OccasionOption('Playa / Piscina', 'piscina'),
      OccasionOption('Vacaciones', 'vacaciones'),
    ],
  ),
  OccasionGroup(
    label: 'Casual',
    icon: Icons.checkroom_rounded,
    phrase: 'casual',
    subs: [
      OccasionOption('Look diario', 'look diario'),
      OccasionOption('Universidad', 'universidad'),
      OccasionOption('Salir con amigos', 'salir con amigos'),
    ],
  ),
];

/// Chips de ocasión en dos niveles: fila horizontal con las ocasiones
/// principales y, al elegir una, sus sub-filtros debajo.
class OccasionFilters extends StatelessWidget {
  const OccasionFilters({
    required this.selectedGroup,
    required this.selectedSub,
    required this.onGroupTap,
    required this.onSubTap,
    super.key,
  });

  final OccasionGroup? selectedGroup;
  final OccasionOption? selectedSub;
  final ValueChanged<OccasionGroup> onGroupTap;
  final ValueChanged<OccasionOption> onSubTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final group in occasionGroups) ...[
                GenderChip(
                  label: group.label,
                  icon: group.icon,
                  selected: selectedGroup == group,
                  onTap: () => onGroupTap(group),
                ),
                if (group != occasionGroups.last) const Gap(8),
              ],
            ],
          ),
        ),
        if (selectedGroup != null) ...[
          const Gap(10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final sub in selectedGroup!.subs)
                _SubChip(
                  label: sub.label,
                  selected: selectedSub == sub,
                  onTap: () => onSubTap(sub),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _SubChip extends StatelessWidget {
  const _SubChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? colors.primary.withValues(alpha: 0.18)
              : colors.nightInput,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? colors.primary : colors.nightBorder,
          ),
        ),
        child: Text(
          label,
          style: context.typography.labelSmall?.copyWith(
            color: selected ? colors.primary : colors.slate,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
