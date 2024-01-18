// lib/src/openai_client.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIClient {
  final String apiKey;
  final http.Client httpClient;

  OpenAIClient({required this.apiKey}) : httpClient = http.Client();

  Future<String> translate(String text, String targetLanguage) async {
    // OpenAI doesn't offer dedicated translation endpoint as of my knowledge cut off
    // You might have to use the standard text completion endpoint for translations.
    // Make sure you abide by OpenAI's API usage policy regarding translations.

    // Implement the completion request to OpenAI here, translating the input `text`.
    // For example, you might want to prompt GPT like this:
    // "Translate the following English text to <targetLanguage>: <text>"

    var response = await httpClient.post(
      Uri.parse('https://api.openai.com/v1/engines/davinci-codex/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'prompt':
            'Translate the following English text to $targetLanguage: $text',
        'max_tokens': 60, // adjust based on expected length of translation
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      // Obtain the translated text from the `choices` in the response.
      String translatedText = data['choices'].first['text'];
      return translatedText;
    } else {
      // Handle the error cases.
      throw Exception('Failed to translate text.');
    }
  }

  void dispose() {
    httpClient.close();
  }
}
