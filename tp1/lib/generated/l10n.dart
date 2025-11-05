// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `My Application`
  String get apptitle {
    return Intl.message('My Application', name: 'apptitle', desc: '', args: []);
  }

  /// `Home`
  String get acceuil {
    return Intl.message('Home', name: 'acceuil', desc: '', args: []);
  }

  /// `Percentage of used time`
  String get tempsEcouler {
    return Intl.message(
      'Percentage of used time',
      name: 'tempsEcouler',
      desc: '',
      args: [],
    );
  }

  /// `Percentage of the task`
  String get pourcentage {
    return Intl.message(
      'Percentage of the task',
      name: 'pourcentage',
      desc: '',
      args: [],
    );
  }

  /// `Percentage of advancement`
  String get pourcetangeAvancement {
    return Intl.message(
      'Percentage of advancement',
      name: 'pourcetangeAvancement',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message('Username', name: 'username', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Password confirm`
  String get passwordConfirmation {
    return Intl.message(
      'Password confirm',
      name: 'passwordConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Connexion`
  String get connexion {
    return Intl.message('Connexion', name: 'connexion', desc: '', args: []);
  }

  /// `Sign up`
  String get inscription {
    return Intl.message('Sign up', name: 'inscription', desc: '', args: []);
  }

  /// `Consultation`
  String get consultation {
    return Intl.message(
      'Consultation',
      name: 'consultation',
      desc: '',
      args: [],
    );
  }

  /// `Limited date :`
  String get dateDechange {
    return Intl.message(
      'Limited date :',
      name: 'dateDechange',
      desc: '',
      args: [],
    );
  }

  /// `Name :`
  String get name {
    return Intl.message('Name :', name: 'name', desc: '', args: []);
  }

  /// `Percentage of advancement :`
  String get pourcentageAvancement {
    return Intl.message(
      'Percentage of advancement :',
      name: 'pourcentageAvancement',
      desc: '',
      args: [],
    );
  }

  /// `Percentage of used time :`
  String get pourcentageTempsEcoule {
    return Intl.message(
      'Percentage of used time :',
      name: 'pourcentageTempsEcoule',
      desc: '',
      args: [],
    );
  }

  /// `Pick an image`
  String get pickImage {
    return Intl.message('Pick an image', name: 'pickImage', desc: '', args: []);
  }

  /// `Modifications has been saved`
  String get modification {
    return Intl.message(
      'Modifications has been saved',
      name: 'modification',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get enregistrer {
    return Intl.message('Save', name: 'enregistrer', desc: '', args: []);
  }

  /// `Add a task`
  String get ajoutTache {
    return Intl.message('Add a task', name: 'ajoutTache', desc: '', args: []);
  }

  /// `Log out`
  String get deconnexion {
    return Intl.message('Log out', name: 'deconnexion', desc: '', args: []);
  }

  /// `Create a task`
  String get creeTache {
    return Intl.message('Create a task', name: 'creeTache', desc: '', args: []);
  }

  /// `Name of the task`
  String get nomTache {
    return Intl.message(
      'Name of the task',
      name: 'nomTache',
      desc: '',
      args: [],
    );
  }

  /// `You need to select a date`
  String get noDate {
    return Intl.message(
      'You need to select a date',
      name: 'noDate',
      desc: '',
      args: [],
    );
  }

  /// `Due date`
  String get echeance {
    return Intl.message('Due date', name: 'echeance', desc: '', args: []);
  }

  /// `Select a date`
  String get selectDate {
    return Intl.message(
      'Select a date',
      name: 'selectDate',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message('Add', name: 'add', desc: '', args: []);
  }

  /// `The username is too short`
  String get NameTooShort {
    return Intl.message(
      'The username is too short',
      name: 'NameTooShort',
      desc: '',
      args: [],
    );
  }

  /// `The password is too short`
  String get PasswordTooShort {
    return Intl.message(
      'The password is too short',
      name: 'PasswordTooShort',
      desc: '',
      args: [],
    );
  }

  /// `The passwords do not match`
  String get PasswordMismatch {
    return Intl.message(
      'The passwords do not match',
      name: 'PasswordMismatch',
      desc: '',
      args: [],
    );
  }

  /// `Invalid username or password`
  String get InvalidCredentials {
    return Intl.message(
      'Invalid username or password',
      name: 'InvalidCredentials',
      desc: '',
      args: [],
    );
  }

  /// `The password or username is incorrect`
  String get MauvaisNomOuMotDePasse {
    return Intl.message(
      'The password or username is incorrect',
      name: 'MauvaisNomOuMotDePasse',
      desc: '',
      args: [],
    );
  }

  /// `The password is too long`
  String get MotDePasseTropLong {
    return Intl.message(
      'The password is too long',
      name: 'MotDePasseTropLong',
      desc: '',
      args: [],
    );
  }

  /// `The username is too long`
  String get NomTropLong {
    return Intl.message(
      'The username is too long',
      name: 'NomTropLong',
      desc: '',
      args: [],
    );
  }

  /// `The username is too short`
  String get NomTropCourt {
    return Intl.message(
      'The username is too short',
      name: 'NomTropCourt',
      desc: '',
      args: [],
    );
  }

  /// `The username is already taken`
  String get UsernameTaken {
    return Intl.message(
      'The username is already taken',
      name: 'UsernameTaken',
      desc: '',
      args: [],
    );
  }

  /// `The task already exists`
  String get Existant {
    return Intl.message(
      'The task already exists',
      name: 'Existant',
      desc: '',
      args: [],
    );
  }

  /// `The name of the task is too short`
  String get TropCourt {
    return Intl.message(
      'The name of the task is too short',
      name: 'TropCourt',
      desc: '',
      args: [],
    );
  }

  /// `The name of the task is too long`
  String get TropLong {
    return Intl.message(
      'The name of the task is too long',
      name: 'TropLong',
      desc: '',
      args: [],
    );
  }

  /// `Some fields are empty`
  String get Vide {
    return Intl.message(
      'Some fields are empty',
      name: 'Vide',
      desc: '',
      args: [],
    );
  }

  /// `There is no internet connection`
  String get NoConnexion {
    return Intl.message(
      'There is no internet connection',
      name: 'NoConnexion',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
