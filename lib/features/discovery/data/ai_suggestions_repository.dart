// lib/features/discovery/data/ai_suggestions_repository.dart

// ignore_for_file: document_ignores

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tropicaguide/core/utils/logger.dart';


const String _geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');

/// A single activity suggestion returned by the Gemini AI.
class SuggestedActivity {
  /// Creates a [SuggestedActivity].
  const SuggestedActivity({
    required this.title,
    required this.category,
    required this.locationName,
    required this.estimatedCostUSD,
    required this.durationMinutes,
    required this.description,
  });

  /// Parses a [SuggestedActivity] from a JSON map.
  factory SuggestedActivity.fromJson(Map<String, dynamic> json) =>
      SuggestedActivity(
        title: json['title'] as String? ?? '',
        category: _validCategory(json['category'] as String? ?? 'sightseeing'),
        locationName: json['locationName'] as String? ?? '',
        estimatedCostUSD: (json['estimatedCostUSD'] as num?)?.toInt() ?? 0,
        durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 60,
        description: json['description'] as String? ?? '',
      );

  /// Activity title.
  final String title;

  /// Category (sightseeing | food | adventure | rest | transport).
  final String category;

  /// Venue or place name.
  final String locationName;

  /// Estimated cost in whole US dollars.
  final int estimatedCostUSD;

  /// Duration in minutes.
  final int durationMinutes;

  /// Short description (max 100 chars).
  final String description;

  /// Formatted cost string.
  String get formattedCost => '\$$estimatedCostUSD';

  /// Formatted duration string.
  String get formattedDuration {
    final h = durationMinutes ~/ 60;
    final m = durationMinutes % 60;
    if (h == 0) return '${m}m';
    if (m == 0) return '${h}h';
    return '${h}h ${m}m';
  }

  static const _validCategories = {
    'sightseeing',
    'food',
    'adventure',
    'rest',
    'transport',
  };

  static String _validCategory(String raw) =>
      _validCategories.contains(raw) ? raw : 'sightseeing';
}

/// Fetches AI-powered activity suggestions using the Google Gemini API.
///
/// Free tier: 15 requests/minute, no credit card required.
class AiSuggestionsRepository {
  /// Creates an [AiSuggestionsRepository].
  const AiSuggestionsRepository();

   static const _model = 'gemini-2.5-flash';

  String get _endpoint =>
      'https://generativelanguage.googleapis.com/v1beta/models/'
      '$_model:generateContent?key=$_geminiApiKey';

  /// Returns 6 suggested activities for [destination].
  Future<List<SuggestedActivity>> fetchSuggestions(
    String destination,
  ) async {
    appLogger.i('AiSuggestionsRepository: fetching for "$destination"');

    final prompt =
        'Return a JSON array of exactly 15 travel activities for $destination. '
        'Output raw JSON only. No markdown. No explanation. No code fences. '
        // ignore: missing_whitespace_between_adjacent_strings
        'Each item: {"title":"...","category":"sightseeing|food|adventure|rest|transport",'
        '"locationName":"...","estimatedCostUSD":0,"durationMinutes":0,'
        '"description":"max 80 chars"}';

    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt},
            ],
          },
        ],
        'generationConfig': {
          'temperature': 0.4,
          'maxOutputTokens': 8192,
          'responseMimeType': 'application/json',
        },
      }),
    );

    if (response.statusCode != 200) {
      appLogger.e(
        'AiSuggestionsRepository: API error ${response.statusCode} '
        '— ${response.body}',
      );
      throw Exception(
        'Failed to fetch suggestions (${response.statusCode}). '
        'Check your API key.',
      );
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final candidates = body['candidates'] as List<dynamic>;
    final content =
        (candidates.first as Map<String, dynamic>)['content']
            as Map<String, dynamic>;
    final parts = content['parts'] as List<dynamic>;
    var text = (parts.first as Map<String, dynamic>)['text'] as String;

    // Strip any accidental markdown fences
    text = text
        .replaceAll('```json', '')
        .replaceAll('```', '')
        .trim();

    final parsed = jsonDecode(text) as List<dynamic>;
    final suggestions = parsed
        .map((e) => SuggestedActivity.fromJson(e as Map<String, dynamic>))
        .toList();

    appLogger.i(
      'AiSuggestionsRepository: received ${suggestions.length} suggestions',
    );
    return suggestions;
  }
}
