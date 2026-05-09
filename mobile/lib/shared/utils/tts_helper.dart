import 'package:markdown/markdown.dart' as md;

class TtsHelper {
  static String stripMarkdownForTts(String markdown) {
    String html = md.markdownToHtml(markdown);
    // Add pauses after headings
    html = html.replaceAll('</h1>', '.</h1>');
    html = html.replaceAll('</h2>', '.</h2>');
    html = html.replaceAll('</h3>', '.</h3>');
    html = html.replaceAll('</h4>', '.</h4>');
    // Add pauses after list items
    html = html.replaceAll('</li>', ',</li>');
    // Remove code blocks from speech
    html = html.replaceAll(RegExp('<code>[^<]*</code>'), '');
    html = html.replaceAll(RegExp('<pre>[^<]*</pre>'), '');
    // Strip all HTML tags
    final plainText = html.replaceAll(RegExp('<[^>]*>'), ' ');
    return plainText.split(RegExp('[ \t\n\r]+')).join(' ').trim();
  }
}
