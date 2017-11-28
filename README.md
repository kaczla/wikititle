**wikititle** - script for printing list all Wikipedia title in few language (if one of them/translation do not exist, line/title is ignored) from Wikipedia dump (dump are downloaded automatically - will be downloaded 2-3 files)

**WARNING** - Wikipedia dump may require some space on disc (from ~50MB to ~2GB per file) and RAM

*Example:*
- for English and German (wikititle en de) require ~2GB space and ~5GB RAM
- for Polish, English and German (wikititle pl en de) require ~700MB and ~1GB RAM
- Depends on the number of article in soruce Wikipedia

*Little note:* - All log or error info are output into stderr

**Usage:**
`wikititle [options] <source langauge> <translate languange list>`

**Available option:**
`-h, --help` - Print help message (this message)
`--cache` - Reload caches (list language) and exit
`-c, --clean` -	Remove all unnecessary files (cache + Wikipedia dump) and exit
`-f, --force` - Print title if do not have translation
`--head, --header` - Print language name in first row
`--id` - Get article id (as first column) - it is id defined in specific language, not global id (Wikidata ID). Id can be used to create article link, e.g. `http://en.wikipedia.org/?curid={ID}` where `{ID}` is id article for source language Wikipedia
`--ignore` - Ignore checking program and libs
`-l, --lang` - Print all available langauge
`-o, --override` - Override downloaded Wikipedia dump
`-s SEP, --sep SEP, --separator SEP` - Set separator between translation (default: ';')
`-w FILE_NAME, --write FILE_NAME, --file FILE_NAME` - Write output into FILE_NAME file (default is out.txt file) or redirect stdout to file
`--wikitag WIKITAG` - Wiki tag for searching specific article, it will download hude Wikipedia dump (from 10GB to 50GB after decompres) e.g. `{{Imiona}}` for Polish Wikipedia or `[[Category:English masculine given names]]` for English Wikipedia

**Example:**
`wikititle pl en` - run script for Polish language and English translation, print titles into STDIO
*Example output:*
...
Polska;Poland
Europa;Europe
...

`wikititle pl en -f` - run script for Polish language and English, French translation, print titles into STDIO, print all title - if transtaltion does not exist then is empty
*Example output:*
...
Polska;Poland;Pologne
Europa;Europe;Europe
KT-90;;
...

`wikititle en de pl -w out.tsv -s '\t'` - run script for English language and German, Polish translation, save titles into out.tsv, separator title is tabulation
*Example output in out.tsv file:*
...
Poland	Polen	Polska
Europe	Europa	Europa
...

`wikititle pl en de ja fr --header -f --id` - run script for Polish language and English, German, Japanese, French translation, print titles into STDIO, print langauage list, print all title - if transtaltion does not exist then is empty, print id article for Polish Wikipedia
*Example output:*
id;Polish;English;German;Japanese;French
...
44854;Europa;Europe;Europa;ヨーロッパ;Europe
44895;Polska;Poland;Polen;ポーランド;Pologne
40981;Klucz (architektura);;;;
...

`wikititle -f --wikitag '[[Kategoria:Informatyka]]' pl en de` - run script for Polish language and English, German translation, print titles into STDIO, print all title - if transtaltion does not exist then is empty, search with Wikitag [[Kategoria:Informatyka]] - it will be download extra ~5GB Wikipedia dump for searching tag

*Example output:*
...
Teleinformatyka;Information and communications technology;Informations- und Kommunikationstechnik
Argumentowość;Arity;Stelligkeit
Teoria systemów;Systems theory;Systemtheorie
Moc obliczeniowa;Computer performance;Rechenleistung
...
