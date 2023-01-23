
// ignore_for_file: cascade_invocations

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'service/generate_pdf_service.dart';
import 'service/io_scanned_document_repository.dart';
import 'service/scanned_document_repository.dart';

final getIt = GetIt.I;

@InjectableInit()
void configureDependencies() => $initGetIt(getIt);

GetIt $initGetIt(
  GetIt get, {
  String environment,
  EnvironmentFilter environmentFilter,
}) {
  final gh = GetItHelper(get, environment, environmentFilter);
  gh.lazySingleton<ScannedDocumentRepository>(
      () => IoScannedDocumentRepository());
  gh.lazySingleton<GeneratePdfService>(
      () => GeneratePdfService(get<ScannedDocumentRepository>()));
  return get;
}
