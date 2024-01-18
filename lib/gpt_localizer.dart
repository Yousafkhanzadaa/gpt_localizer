// bin/main.dart

import 'dart:io';

import 'package:args/args.dart';
import 'package:gpt_localizer/src/arb_processor.dart';
import 'package:gpt_localizer/src/openai_client.dart';

Future<void> main(List<String> arguments) async {
  var parser = ArgParser()
    ..addOption('api-key', abbr: 'k', help: 'OpenAI API key.')
    ..addOption('source', abbr: 's', help: 'The source arb file path.')
    ..addOption('target-langs',
        abbr: 't', help: 'Target languages separated by comma.');

  ArgResults argResults = parser.parse(arguments);

  final apiKey = argResults['api-key'];
  final sourceArbPath = argResults['source'];
  final targetLangs = argResults['target-langs']?.split(',') ?? [];

  if (apiKey == null || sourceArbPath == null || targetLangs.isEmpty) {
    print(parser.usage);
    exit(2);
  }

  try {
    var client = OpenAIClient(apiKey: apiKey);
    var processor = ArbProcessor();

    Map<String, dynamic> sourceContent =
        await processor.readArbFile(sourceArbPath);

    for (var language in targetLangs) {
      Map<String, dynamic> translatedContent = {};

      for (var key in sourceContent.keys) {
        if (sourceContent[key] is String) {
          var translation =
              await client.translate(sourceContent[key], language);
          translatedContent[key] = translation;
        } else {
          translatedContent[key] = sourceContent[key];
        }
      }

      String targetArbPath = 'l10n/app_$language.arb';
      await processor.writeArbFile(targetArbPath, translatedContent);
    }

    client.dispose();
  } catch (e) {
    print('Error: $e');
    exit(1);
  }
}
