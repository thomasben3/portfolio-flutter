import 'dart:html' as html;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:thbensem_portfolio/extensions/colors.dart';
import 'package:thbensem_portfolio/models/providers/l10n.dart';
import 'package:thbensem_portfolio/models/providers/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:thbensem_portfolio/utils/url_launcher.dart';

class ExpandingMenu extends StatefulWidget {

  const ExpandingMenu({
    super.key,
    required this.refreshState
  });

  final Function refreshState;

  @override
  State<ExpandingMenu> createState() => _ExpandingMenuState();
}

class _ExpandingMenuState extends State<ExpandingMenu> with SingleTickerProviderStateMixin {

  static const Duration _transitionDuration = Duration(milliseconds: 300);
  static const int      _languageIndex = 0;
  static const int      _themeIndex = 1;
  static const int      _resumeIndex = 2;

  late final AnimationController _animationController = AnimationController(vsync: this, duration: _transitionDuration);

  bool  _isExpanded = false;
  int   _selectedIndex = 0;

  double get _expandedWidth => min(300, MediaQuery.of(context).size.width);
  double get _expandedHeight => min(300, MediaQuery.of(context).size.height);
  double get _closedSize => 56;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggle() {
    if (_isExpanded == false) {
      _animationController.forward();
      setState(() => _isExpanded = true);
    } else {
      _animationController.reverse();
      setState(() => _isExpanded = false);
    }
  }

  Widget get _menu {
    switch (_selectedIndex) {
      case _themeIndex:
        return _ThemeMenu(refreshState: () {
          setState(() {});
          widget.refreshState();
        });
      case _resumeIndex:
        return const _ResumeMenu();
      default:
        return const _LanguageMenu();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: _transitionDuration,
      width: _isExpanded ? _expandedWidth : _closedSize,
      height: _isExpanded ? _expandedHeight : _closedSize,
      child: SingleChildScrollView(
        child: Material(
          borderRadius: BorderRadius.circular(_isExpanded ? 16 : 28),
          color: context.read<AppTheme>().color0,
          elevation: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 56,
                width: 56,
                child: InkWell(
                  borderRadius: BorderRadius.circular(_isExpanded ? 16 : 28),
                  onTap: _toggle,
                  child: Center(
                    child: AnimatedIcon(
                      size: 25,
                      icon: AnimatedIcons.menu_close,
                      progress: _animationController,
                      color: context.read<AppTheme>().textColor0
                    ),
                  )
                ),
              ),
              if (_isExpanded) ...[
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: _expandedWidth,
                    child: Row(
                      children: [
                        IntrinsicWidth(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _CustomListTile(
                                isSelected: _selectedIndex == _languageIndex,
                                leading: Image.asset('assets/images/flags/${context.read<L10n>().currentLocale.languageCode.split('_').first}.png', height: 20),
                                title: Text(AppLocalizations.of(context)!.languageSetting, style: TextStyle(color: context.read<AppTheme>().textColor0)),
                                onTap: () => setState(() => _selectedIndex = _languageIndex)
                              ),
                              _CustomListTile(
                                isSelected: _selectedIndex == _themeIndex,
                                leading: Material(child: _ThemeMiniature(height: 15, width: 20, theme: context.read<AppTheme>().currentTheme)),
                                title: Text(AppLocalizations.of(context)!.theme, style: TextStyle(color: context.read<AppTheme>().textColor0)),
                                onTap: () => setState(() => _selectedIndex = _themeIndex)
                              ),
                              _CustomListTile(
                                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16)),
                                isSelected: _selectedIndex == _resumeIndex,
                                leading: Icon(MdiIcons.fileDocument, color: context.read<AppTheme>().textColor1),
                                title: Text(AppLocalizations.of(context)!.cv, style: TextStyle(color: context.read<AppTheme>().textColor0)),
                                onTap: () => setState(() => _selectedIndex = _resumeIndex)
                              ),
                            ]
                          ),
                        ),
                        Ink(height: 80, width: 1, color: context.read<AppTheme>().color0.lighten()),
                        Expanded(child: _menu)
                      ]
                    ),
                  ),
                )
              ]
            ],
          )
        ),
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  const _CustomListTile({
    required this.leading,
    required this.title,
    required this.onTap,
    this.isSelected = false,
    this.borderRadius
  });

  final Widget          leading;
  final Widget          title;
  final void Function() onTap;
  final bool            isSelected;
  final BorderRadius?   borderRadius;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: borderRadius,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: isSelected ? context.read<AppTheme>().color0.darken() : null, // same color as parent background
        ),
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            leading,
            const SizedBox(width: 15),
            title,
          ],
        ),
      ),
    );
  }
}

class _LanguageMenu extends StatelessWidget {
  const _LanguageMenu();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InkWell(
          hoverColor: context.read<AppTheme>().color0.darken(),
          onTap: () => context.read<L10n>().setLocale('en'),
          borderRadius: BorderRadius.circular(100),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Image.asset('assets/images/flags/en.png', width: min(300, MediaQuery.of(context).size.width) / 4), // == ExpandingMenuState._expandedWidth / 4
          )
        ),
        InkWell(
          hoverColor: context.read<AppTheme>().color0.darken(),
          onTap: () => context.read<L10n>().setLocale('fr'),
          borderRadius: BorderRadius.circular(100),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Image.asset('assets/images/flags/fr.png', width: min(300, MediaQuery.of(context).size.width) / 4),
          )
        ),
      ],
    );
  }
}

class _ThemeMenu extends StatelessWidget {
  const _ThemeMenu({
    required this.refreshState
  });

  static const double _miniatureHeight = 30;
  static const double _miniatureWidth = 70;

  final Function refreshState;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceAround,
      runSpacing: 15,
      children: List.generate(AppTheme.themeColors.length, (index) => InkWell(
        onTap: () async {
          context.read<AppTheme>().setTheme(index);
          refreshState();
        },
        child: _ThemeMiniature(height: _miniatureHeight, width: _miniatureWidth, theme: AppTheme.themeColors[index]),
      )),
    );
  }
}

class _ThemeMiniature extends StatelessWidget {
  const _ThemeMiniature({
    required this.height,
    required this.width,
    required this.theme
  });

  final double      height;
  final double      width;
  final List<Color> theme;

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 0.5, strokeAlign: BorderSide.strokeAlignOutside)),
      height: height,
      width: width,
      child: Row(
        children: List.generate(max(0, theme.length - 2), (index) => Ink(height: height, width: width / (theme.length - 2), color: theme[index]))
      ),
    );
  }
}

class _ResumeMenu extends StatelessWidget {
  const _ResumeMenu();

  static const double _imageWidth = 70;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => launch("assets/assets/pdf/cv_${context.read<L10n>().currentLocale.languageCode.split('_').first}.pdf"),
            child: Tooltip(
              enableTapToDismiss: false,
              textStyle: const TextStyle(color: Color.fromARGB(255, 114, 114, 114)),
              decoration: const BoxDecoration(color: Colors.transparent),
              message: AppLocalizations.of(context)!.showCv,
              child: Image.asset('assets/images/cv_sample.png', width: _imageWidth)
            )
          )
        ),
        IconButton(
          onPressed: () {
            final anchorElement = html.AnchorElement(href: "assets/assets/pdf/cv_${context.read<L10n>().currentLocale.languageCode.split('_').first}.pdf");
            anchorElement.download = "Thomas Bensemhoun - CV";
            anchorElement.click();
          },
          icon: Icon(MdiIcons.download, color: context.read<AppTheme>().textColor0)
        )
      ],
    );
  }
}